# 🐱 NEKOPUNKS (NKPK)

Cat-themed ERC-20 token on Base network. Mint via Claude AI.

## Token Info

| Property | Value |
|----------|-------|
| **Name** | NEKOPUNKS |
| **Symbol** | NKPK |
| **Decimals** | 18 |
| **Network** | Base (Chain ID: 8453) |
| **Contract** | `0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934` |
| **Max Supply** | 100,000,000,000 NKPK |

## Mint Parameters

| Parameter | Value |
|-----------|-------|
| **Mint Price** | 0.001 ETH |
| **Per Mint** | 20,000 NKPK |
| **Max Per Wallet** | 200,000 NKPK |
| **Max Mint TXs** | 10 per wallet |
| **Public Mint Cap** | 510,000,000 NKPK |

## How to Mint

### Option 1: Via Claude.ai (Skill)
1. Open [claude.ai](https://claude.ai)
2. Copy the [SKILL.md](SKILL.md) content
3. Paste into chat and ask to mint

### Option 2: Via MCP Server
1. Go to [nekopunks-web.vercel.app](https://nekopunks-web.vercel.app)
2. Copy the MCP endpoint URL
3. Add it in Claude Desktop or claude.ai integrations
4. Ask Claude to mint NEKOPUNKS

### Option 3: Via CLI (Cast)
```bash
cast send 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934 "mint()" \
  --value 0.001ether \
  --rpc-url https://mainnet.base.org \
  --private-key <PRIVATE_KEY>
```

## Contract Functions

- `mint()` — Payable, mint 20,000 NKPK for 0.001 ETH
- `toggleMint()` — Owner only, toggle mint on/off
- `withdraw()` — Owner only, withdraw all ETH
- `totalSupply()` — Returns total NKPK supply
- `totalPublicMinted()` — Returns total NKPK minted
- `mintCount(address)` — Returns mint count for wallet
- `mintActive()` — Returns whether mint is active
- `remainingPublicMint()` — Returns remaining public mint allocation

## Links

- **BaseScan:** https://basescan.org/address/0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934
- **Web:** https://nekopunks-web.vercel.app
- **MCP Server:** https://nekopunks-mcp.vercel.app
- **GitHub:** https://github.com/punksneko/nekopunks-mint

## Project Structure

```
├── SKILL.md          # Claude.ai skill for minting
├── README.md         # This file
├── contract/
│   └── NEKOPUNKS.sol # Solidity contract source
└── web/
    ├── index.html    # Landing page
    └── vercel.json   # Vercel config
```

## License

MIT
