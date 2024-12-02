# Plinko-GNFT 🎲🎨

A blockchain-based Plinko game that integrates NFTs and rewards players with USDC. This project combines a Svelte-powered frontend with a Solidity backend for a fun, free-to-play experience inspired by [Stake.com's Plinko game](https://stake.com/casino/games/plinko).

## About

Plinko is a classic game where the player drops a ball in a multi-row pin pyramid, bouncing randomly until it reaches payout bins at the bottom.  
In **Plinko-GNFT**, players use NFTs to play, earn rewards in USDC, and interact with blockchain technology seamlessly.

This project is **not affiliated with Stake.com** and is designed to promote learning about Svelte, Solidity, and NFTs.

---

## Features

### Frontend (Plinko)

- 🤖 Manual and auto-bet modes
- 📊 Real-time live stats
- 📱 Responsive design for all devices

### Backend (GameNFT)

- 🛒 **Buy NFTs**: Purchase NFTs using USDC (1 USDC = 1 NFT).
- 🔥 **Play the Game**: Burn an NFT to play Plinko.
- 🏆 **Earn Rewards**: Receive USDC rewards based on performance:
   - Reward 1: 0.1 USDC per NFT.
   - Reward 2: 0.5 USDC per NFT.
   - Reward 3: 2 USDC per NFT.
- 💰 **Funds Management**:
   - Deposit USDC into the contract.
   - Withdraw USDC (owner-only).
- 🔒 **Access Control**:
   - Authorized agents can manage rewards.
   - Only the contract owner can add/remove agents.
## Contract Details

- **Network:** Base
- **USDC Address:** `0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359`

---

## Development

### Frontend

#### Getting Started

> **Note**: Requires Node.js 20 or later.

1. Install [pnpm](https://pnpm.io/installation) version 9 or later.
2. Clone this repository.
3. Install dependencies:

   ```bash
   pnpm install
```

4. Start the development server

   ```bash
   pnpm dev
   ```

### Building for Production

The entire site is statically generated using [@sveltejs/adapter-static](https://github.com/sveltejs/kit/tree/main/packages/adapter-static).

1. Generate a static build

   ```bash
   pnpm build
   ```

2. Preview the build site

   ```bash
   pnpm preview
   ```

### Testing

For unit tests, run:

```bash
pnpm test:unit
```