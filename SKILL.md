SKILL.md:
---
name: nekopunks
description: Mint NEKOPUNKS (NKPK) token on Base network
---

# NEKOPUNKS Mint Skill

Mint NEKOPUNKS (NKPK) token on Base network via Claude.

## Contract Info
- **Network:** Base (Chain ID: 8453)
- **Contract:** 0x664Cb6D5BdCFBE3556E002BD70151205201A11C7
- **Token:** NEKOPUNKS (NKPK)
- **Decimals:** 18
- **Owner:** 0xa24613C7DE8D3c357c75cF68133E2eCe7C4eE4a0

## Mint Parameters
- **Mint Price:** 0.001 ETH
- **Per Mint:** 20,000 NKPK
- **Max Per Wallet:** 200,000 NKPK
- **Max Mints Per Wallet:** 10
- **Public Mint Cap:** 510,000,000 NKPK

## How to Mint

### Step 1: Check Mint Status
Run this command to check total minted:
bash
cast call 0x664Cb6D5BdCFBE3556E002BD70151205201A11C7 "totalMinted()" --rpc-url https://mainnet.base.org

### Step 2: Check User's Mint Count
Check how many times a wallet has minted:
bash
cast call 0x664Cb6D5BdCFBE3556E002BD70151205201A11C7 "mintCounts(address)" --args <WALLET_ADDRESS> --rpc-url https://mainnet.base.org

### Step 3: Generate Mint Transaction
Tell the user to send this transaction:
- **To:** 0x664Cb6D5BdCFBE3556E002BD70151205201A11C7
- **Value:** 0.001 ETH
- **Data:** 0x1249c58b (mint() function selector)

Or use cast:
bash
cast send 0x664Cb6D5BdCFBE3556E002BD70151205201A11C7 "mint()" --value 0.001ether --rpc-url https://mainnet.base.org --private-key <PRIVATE_KEY>

## Contract Functions
- `mint()` — Payable, mint 20,000 NKPK for 0.001 ETH
- `withdraw()` — Owner only, withdraw all ETH
- `totalMinted()` — Returns total NKPK minted
- `mintCounts(address)` — Returns mint count for wallet
- `owner()` — Returns owner address

## Important Rules
- Each wallet can mint max 10 times
- Each mint gives 20,000 NKPK
- Max per wallet: 200,000 NKPK
- Public mint cap: 510,000,000 NKPK
- Price: 0.001 ETH per mint

## Links
- **BaseScan:** https://basescan.org/address/0x664Cb6D5BdCFBE3556E002BD70151205201A11C7
- **GitHub:** https://github.com/nekopunks/nekopunks-mint


