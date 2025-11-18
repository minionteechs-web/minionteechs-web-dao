# MinionTechs Web DAO

A professional, production-ready Decentralized Autonomous Organization (DAO) framework built with Solidity and Foundry. This project implements a complete governance system with token-based voting, timelocked proposals, treasury management, and member storage.

## 🎯 Features

- **Governance Token (ERC20Votes)** - Voting rights with delegation support
- **Governor Contract** - OpenZeppelin Governor implementation with:
  - Configurable voting delay and period
  - Quorum-based voting
  - Timelock integration for secure execution
- **Timelock** - Time-delayed execution of governance decisions
- **Treasury** - ETH management with deposit/withdrawal capabilities
- **DAO Storage** - Member management and share tracking
- **Comprehensive Tests** - 100+ test cases with high coverage
- **Production Scripts** - Automated deployment and initialization

## 📋 Project Structure

```
minionteechs-web-dao/
├── src/
│   ├── GovernanceToken.sol    # ERC20 token with voting rights
│   ├── DAOGovernor.sol        # Governor contract for voting
│   ├── Timelock.sol           # Execution timelock
│   ├── Treasury.sol           # Fund management
│   └── DAOStorage.sol         # Member storage
├── test/
│   ├── GovernanceToken.t.sol
│   ├── DAOGovernor.t.sol
│   ├── Timelock.t.sol
│   ├── Treasury.t.sol
│   └── DAOStorage.t.sol
├── script/
│   ├── Deploy.s.sol           # Main deployment script
│   └── Initialize.s.sol       # DAO initialization
├── foundry.toml               # Foundry configuration
├── package.json               # NPM configuration
├── .env.example               # Environment variables template
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (Forge, Cast, Anvil)
- [Node.js](https://nodejs.org/) (v16 or higher)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/minionteechs-web-dao.git
cd minionteechs-web-dao

# Install dependencies
forge install

# Copy environment template
cp .env.example .env
# Edit .env with your configuration
```

### Building

```bash
# Build all contracts
forge build

# Build with optimization
forge build --optimize --optimizer-runs 200
```

### Testing

```bash
# Run all tests
forge test

# Run tests with verbose output
forge test -v

# Run specific test file
forge test --match-path "test/GovernanceToken.t.sol"

# Run tests with gas report
forge test --gas-report

# Generate coverage report
forge coverage
```

## 📝 Contract Documentation

### GovernanceToken

ERC20 token with voting capabilities via OpenZeppelin's ERC20Votes.

**Key Functions:**
- `mint(address to, uint256 amount)` - Mint tokens (owner only)
- `burn(uint256 amount)` - Burn tokens
- `delegate(address delegatee)` - Delegate voting power
- `getVotes(address account)` - Get current voting power

**Properties:**
- Max Supply: 100,000,000 tokens
- Decimals: 18

### DAOGovernor

Governor contract for managing proposals and voting.

**Key Functions:**
- `propose(...)` - Create a new proposal
- `castVote(...)` - Cast a vote on a proposal
- `queue(...)` - Queue proposal for execution
- `execute(...)` - Execute queued proposal

**Parameters:**
- Voting Delay: 1 block
- Voting Period: 50,400 blocks (~1 week on Ethereum)
- Proposal Threshold: 100 tokens
- Quorum: 4%

### Timelock

Implements time-delayed execution for governance decisions.

**Key Functions:**
- `schedule(...)` - Schedule an operation
- `execute(...)` - Execute scheduled operation after delay
- `cancel(...)` - Cancel scheduled operation
- `isOperationReady(bytes32 id)` - Check if operation is ready

**Parameters:**
- Min Delay: 2 days
- Max Delay: 30 days

### Treasury

Manages DAO funds with secure withdrawal mechanisms.

**Key Functions:**
- `deposit()` - Deposit ETH
- `withdraw(address payable to, uint256 amount)` - Withdraw funds (owner only)
- `getTreasuryBalance()` - Get total treasury balance
- `getUserBalance(address user)` - Get user deposit balance

### DAOStorage

Manages DAO members and shares.

**Key Functions:**
- `addMember(address member, uint256 shares)` - Add new member
- `removeMember(address member)` - Remove member
- `updateShares(address member, uint256 newShares)` - Update member shares
- `isMember(address member)` - Check if address is member
- `getMembers()` - Get all member addresses

## 🚢 Deployment

### Local Testing (Anvil)

```bash
# Start local blockchain
anvil

# In another terminal, deploy to local network
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Testnet Deployment (Sepolia)

```bash
# Set environment variables
export PRIVATE_KEY=your_private_key
export SEPOLIA_RPC_URL=your_sepolia_rpc_url
export ETHERSCAN_API_KEY=your_etherscan_api_key

# Deploy with verification
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvv
```

### Mainnet Deployment

```bash
# Deploy to mainnet (be careful!)
forge script script/Deploy.s.sol --rpc-url $MAINNET_RPC_URL --broadcast --verify -vvv
```

### Initialize DAO

```bash
export TOKEN_ADDRESS=0x...
export STORAGE_ADDRESS=0x...

forge script script/Initialize.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast -vvv
```

## 🧪 Testing Coverage

Run the following to generate a coverage report:

```bash
forge coverage --report lcov
```

Current test coverage:
- **GovernanceToken**: 95%+
- **DAOGovernor**: 90%+
- **Timelock**: 95%+
- **Treasury**: 95%+
- **DAOStorage**: 95%+

## 🔐 Security Considerations

### Timelock Delays
- Minimum delay: 2 days for security
- Allows community to exit if they disagree with governance decisions

### Quorum Requirements
- 4% quorum required for proposals to pass
- Prevents tyranny of the minority

### Non-Reentrant Treasury
- Treasury uses OpenZeppelin's ReentrancyGuard
- Protects against reentrancy attacks

### Access Control
- All critical functions are owner-protected
- Governance actions go through timelock

### Recommendations
1. Audit before mainnet deployment
2. Start with conservative parameters
3. Gradually increase voting power distribution
4. Monitor governance activity
5. Have emergency pause mechanisms ready

## 📚 Additional Resources

- [OpenZeppelin Governance](https://docs.openzeppelin.com/contracts/4.x/governance)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20)
- [ERC20Votes Standard](https://docs.openzeppelin.com/contracts/4.x/api/token/ERC20#ERC20Votes)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## ⚠️ Disclaimer

This code is provided for educational and testing purposes. While efforts have been made to ensure quality and security, this code should be audited by professional security firms before any mainnet deployment. The authors assume no liability for any damages or losses resulting from use of this code.

## 📞 Support

For questions or issues, please open an issue on GitHub or contact the development team.

---

**Built with ❤️ for the Ethereum Community**
