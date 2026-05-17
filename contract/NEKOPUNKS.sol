// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

interface IERC20Errors {
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) { return msg.sender; }
    function _msgData() internal view virtual returns (bytes calldata) { return msg.data; }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;
    mapping(address account => mapping(address spender => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) { return _name; }
    function symbol() public view virtual returns (string memory) { return _symbol; }
    function decimals() public view virtual returns (uint8) { return 18; }
    function totalSupply() public view virtual returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view virtual returns (uint256) { return _balances[account]; }

    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) { revert ERC20InvalidSender(address(0)); }
        if (to == address(0)) { revert ERC20InvalidReceiver(address(0)); }
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) { _totalSupply += value; }
        else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) { revert ERC20InsufficientBalance(from, fromBalance, value); }
            unchecked { _balances[from] = fromBalance - value; }
        }
        if (to == address(0)) { unchecked { _totalSupply -= value; } }
        else { unchecked { _balances[to] += value; } }
        emit Transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal {
        if (account == address(0)) { revert ERC20InvalidReceiver(address(0)); }
        _update(address(0), account, value);
    }

    function _burn(address account, uint256 value) internal {
        if (account == address(0)) { revert ERC20InvalidSender(address(0)); }
        _update(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) { revert ERC20InvalidApprover(address(0)); }
        if (spender == address(0)) { revert ERC20InvalidSpender(address(0)); }
        _allowances[owner][spender] = value;
        if (emitEvent) { emit Approval(owner, spender, value); }
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < type(uint256).max) {
            if (currentAllowance < value) { revert ERC20InsufficientAllowance(spender, currentAllowance, value); }
            unchecked { _approve(owner, spender, currentAllowance - value, false); }
        }
    }
}

abstract contract Ownable is Context {
    address private _owner;
    error OwnableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) { revert OwnableInvalidOwner(address(0)); }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() { _checkOwner(); _; }

    function owner() public view virtual returns (address) { return _owner; }

    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) { revert OwnableUnauthorizedAccount(_msgSender()); }
    }

    function renounceOwnership() public virtual onlyOwner { _transferOwnership(address(0)); }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) { revert OwnableInvalidOwner(newOwner); }
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/// @title NEKOPUNKS Token with EIP-7702 Support
/// @notice ERC-20 token with EIP-7702 delegation and minting via Claude/MCP only
/// @dev Mint is disabled by default (mintActive = false). Only MCP server can activate per-session.
contract NEKOPUNKS is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000_000 * 10**18;
    uint256 public constant MINT_PRICE = 0.001 ether;
    uint256 public constant MAX_PER_WALLET = 200_000 * 10**18;
    uint256 public constant MINT_AMOUNT = 20_000 * 10**18;
    uint256 public constant MAX_MINT_TXS = 10;
    uint256 public constant PUBLIC_MINT_MAX = 510_000_000 * 10**18;

    uint256 public totalPublicMinted;
    bool public mintActive;
    mapping(address => uint256) public mintCount;

    event Mint(address indexed user, uint256 amount);
    event Withdraw(uint256 amount);

    constructor() ERC20("NEKOPUNKS", "NKPK") Ownable(msg.sender) {
        mintActive = false; // Only MCP/Claude can mint
    }

    /// @notice Mint NKPK tokens
    /// @dev Works for both normal transactions and EIP-7702 delegated transactions
    function mint() external payable {
        require(mintActive, "Mint not active");
        require(totalSupply() + MINT_AMOUNT <= MAX_SUPPLY, "Max supply reached");
        require(totalPublicMinted + MINT_AMOUNT <= PUBLIC_MINT_MAX, "Public mint cap reached");
        require(mintCount[msg.sender] < MAX_MINT_TXS, "Max mints reached");
        require(balanceOf(msg.sender) + MINT_AMOUNT <= MAX_PER_WALLET, "Max per wallet reached");
        require(msg.value >= MINT_PRICE, "Not enough ETH");

        mintCount[msg.sender]++;
        totalPublicMinted += MINT_AMOUNT;
        _mint(msg.sender, MINT_AMOUNT);

        emit Mint(msg.sender, MINT_AMOUNT);
    }

    /// @notice Owner can mint to any address (for airdrops, etc.)
    function ownerMint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply reached");
        _mint(to, amount);
    }

    /// @notice Toggle mint active status (owner only)
    function toggleMint() external onlyOwner {
        mintActive = !mintActive;
    }

    /// @notice Withdraw ETH from contract to owner
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdraw failed");
        emit Withdraw(balance);
    }

    /// @notice Get remaining public mint supply
    function remainingPublicMint() external view returns (uint256) {
        return PUBLIC_MINT_MAX - totalPublicMinted;
    }
}
