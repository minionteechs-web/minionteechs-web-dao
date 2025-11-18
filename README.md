# MinionTechs Web DAO

A Solidity-based governance contract for the MinionTechs Web DAO.

## Project Structure

```
minionteechs-web-dao/
├── src/
│   └── Governance.sol
├── test/
│   └── Governance.t.sol
├── script/
│   └── Deploy.s.sol
├── foundry.toml
└── README.md
```

## Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

### Installation
```bash
git clone <repository-url>
cd minionteechs-web-dao
```

### Building
```bash
forge build
```

### Testing
```bash
forge test
```

### Deployment
```bash
forge script script/Deploy.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

## License

MIT
