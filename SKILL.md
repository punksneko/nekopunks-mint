---
name: nekopunks
description: Mint NEKOPUNKS (NKPK) token on Base network
---

# NEKOPUNKS Mint Skill

Mint NEKOPUNKS (NKPK) token on Base network via Claude.

## Contract Info
- **Network:** Base (Chain ID: 8453)
- **Contract:** 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934
- **Token:** NEKOPUNKS (NKPK)
- **Decimals:** 18
- **Owner:** 0xed135651Fec4e2BCeBD1eAB9f7e7d9e4aeaf5fC1

## Mint Parameters
- **Mint Price:** 0.001 ETH
- **Per Mint:** 20,000 NKPK
- **Max Per Wallet:** 200,000 NKPK
- **Max Mints Per Wallet:** 10
- **Public Mint Cap:** 510,000,000 NKPK
- **Max Supply:** 100,000,000,000 NKPK

## How to Mint

### Via MCP Server (Recommended)
1. Go to https://nekopunks-web.vercel.app
2. Copy the MCP endpoint URL
3. Add it in Claude Desktop or claude.ai integrations
4. Ask Claude to mint NEKOPUNKS

### Via Skill (Claude.ai)
1. Copy this SKILL.md content
2. Paste into claude.ai chat
3. Ask Claude to mint NEKOPUNKS

### Via Cast (CLI)

#### Check Mint Status
```bash
cast call 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934 "totalSupply()" --rpc-url https://mainnet.base.org
cast call 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934 "totalPublicMinted()" --rpc-url https://mainnet.base.org
cast call 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934 "mintCount(address)" --args <WALLET_ADDRESS> --rpc-url https://mainnet.base.org
```

#### Check Mint Active
```bash
cast call 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934 "mintActive()" --rpc-url https://mainnet.base.org
```

#### Mint (requires owner PK to toggle mint on first)
```bash
cast send 0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934 "mint()" --value 0.001ether --rpc-url https://mainnet.base.org --private-key <PRIVATE_KEY>
```

## Contract Functions
- `mint()` — Payable, mint 20,000 NKPK for 0.001 ETH
- `toggleMint()` — Owner only, toggle mint on/off
- `withdraw()` — Owner only, withdraw all ETH
- `totalSupply()` — Returns total NKPK supply
- `totalPublicMinted()` — Returns total NKPK minted via public mint
- `mintCount(address)` — Returns mint count for wallet
- `mintActive()` — Returns whether mint is currently active
- `owner()` — Returns owner address
- `remainingPublicMint()` — Returns remaining public mint allocation

## Important Rules
- Each wallet can mint max 10 times
- Each mint gives 20,000 NKPK
- Max per wallet: 200,000 NKPK
- Public mint cap: 510,000,000 NKPK
- Max supply: 100,000,000,000 NKPK
- Price: 0.001 ETH per mint
- Mint is ONLY available via Claude/MCP (mintActive = false by default)

## Links
- **BaseScan:** https://basescan.org/address/0x25b5fB7602f542D482Ca1fCe2b0c7016e193A934
- **GitHub:** https://github.com/punksneko/nekopunks-mint
- **MCP Server:** https://nekopunks-mcp.vercel.app
- **Web:** https://nekopunks-web.vercel.app
