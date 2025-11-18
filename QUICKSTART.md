# Quick Start Guide

## 5-Minute Setup

### 1. Prerequisites
```bash
# Install Foundry (if not already installed)
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Clone & Setup
```bash
git clone https://github.com/yourusername/minionteechs-web-dao.git
cd minionteechs-web-dao
forge install
```

### 3. Build & Test
```bash
# Build contracts
forge build

# Run tests
forge test

# View gas report
forge test --gas-report
```

### 4. Deploy Locally (Anvil)
```bash
# Terminal 1: Start local blockchain
anvil

# Terminal 2: Deploy
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb476c55263f4899f48243edf0625
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

## Deployment Commands

### Testnet (Sepolia)
```bash
export PRIVATE_KEY=your_private_key
export SEPOLIA_RPC_URL=your_rpc_url
export ETHERSCAN_API_KEY=your_etherscan_key

forge script script/Deploy.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    -vvv
```

### Mainnet
```bash
# SAME as above but with MAINNET_RPC_URL
# ⚠️ VERIFY EVERYTHING BEFORE PRESSING ENTER ⚠️
```

## What's Included

✅ **5 Production-Ready Contracts**
- GovernanceToken (ERC20 with voting)
- DAOGovernor (Voting mechanism)
- Timelock (Execution delays)
- Treasury (Fund management)
- DAOStorage (Member tracking)

✅ **Comprehensive Testing**
- 6 test files with 50+ test cases
- Gas reports for optimization
- Coverage analysis

✅ **Deployment Automation**
- Deploy.s.sol - Deploy all contracts
- Initialize.s.sol - Initialize members

✅ **Professional Documentation**
- README.md - Full documentation
- ARCHITECTURE.md - System design
- DEVELOPMENT.md - Development guide
- OPERATIONS.md - How to use DAO
- SECURITY.md - Security checklist

✅ **DevOps Ready**
- .github/workflows - CI/CD pipeline
- foundry.toml - Optimized config
- package.json - npm integration

## File Structure

```
minionteechs-web-dao/
├── src/                    # Smart contracts
│   ├── GovernanceToken.sol
│   ├── DAOGovernor.sol
│   ├── Timelock.sol
│   ├── Treasury.sol
│   └── DAOStorage.sol
├── test/                   # Tests
│   ├── GovernanceToken.t.sol
│   ├── DAOGovernor.t.sol
│   ├── Timelock.t.sol
│   ├── Treasury.t.sol
│   └── DAOStorage.t.sol
├── script/                 # Deployment scripts
│   ├── Deploy.s.sol
│   └── Initialize.s.sol
├── .github/workflows/      # CI/CD
├── README.md              # Full docs
├── ARCHITECTURE.md        # System design
├── DEVELOPMENT.md         # Dev guide
├── OPERATIONS.md          # Usage guide
├── SECURITY.md            # Security info
├── foundry.toml           # Config
├── package.json           # NPM config
├── .env.example           # Env template
├── .gitignore             # Git rules
└── LICENSE                # MIT License
```

## Common Tasks

### Run All Tests
```bash
forge test -v
```

### Generate Gas Report
```bash
forge test --gas-report
```

### Check Code Coverage
```bash
forge coverage
```

### Format Code
```bash
forge fmt
```

### Get Contract Info
```bash
cast call 0x... "balanceOf(address)" 0x...
```

## Key Concepts

### Governance Token
- ERC20 token with voting rights
- Vote power through delegation
- Mintable by owner/governance
- Burnable by holder

### Governor
- Manages proposals and voting
- Integrates with Timelock
- Configurable delays and thresholds
- Transparent execution

### Timelock
- 2-30 day delays on execution
- Prevents rug pulls
- Allows community to exit
- Cancellable by admins

### Treasury
- Secure ETH management
- Reentrancy protected
- Governance controlled
- User deposit tracking

### Storage
- Member management
- Share tracking
- Role assignment
- Query functions

## Next Steps

1. **Understand Contracts**: Read ARCHITECTURE.md
2. **Set Up Dev**: Follow DEVELOPMENT.md
3. **Run Tests**: `forge test`
4. **Deploy Testnet**: Use Deploy.s.sol
5. **Verify**: Check on Etherscan
6. **Go Live**: Deploy to mainnet

## Resources

- [Foundry Docs](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [OpenZeppelin](https://docs.openzeppelin.com/contracts/)

## Support

- 📖 Read the full README.md
- 🔍 Check ARCHITECTURE.md for design details
- 🛠️ See DEVELOPMENT.md for coding help
- ⚠️ Review SECURITY.md before deployment

## License

MIT - See LICENSE file

---

**Ready to build? Start with:**
```bash
forge build && forge test
```
