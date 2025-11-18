# Development Guide

## Setting Up Development Environment

```bash
# Clone and install
git clone https://github.com/yourusername/minionteechs-web-dao.git
cd minionteechs-web-dao

# Install Foundry dependencies
forge install

# Build project
forge build
```

## Project Layout

```
src/
├── GovernanceToken.sol   - ERC20 token with voting
├── DAOGovernor.sol       - Governance logic
├── Timelock.sol          - Execution delays
├── Treasury.sol          - Fund management
└── DAOStorage.sol        - Member tracking

test/
├── GovernanceToken.t.sol - Token tests
├── DAOGovernor.t.sol     - Governor tests
├── Timelock.t.sol        - Timelock tests
├── Treasury.t.sol        - Treasury tests
└── DAOStorage.t.sol      - Storage tests

script/
├── Deploy.s.sol          - Deploy all contracts
└── Initialize.s.sol      - Initialize DAO
```

## Code Style

### Solidity Standards

1. **Naming Conventions**
   - Contracts: PascalCase (e.g., `GovernanceToken`)
   - Functions: camelCase (e.g., `castVote`)
   - Constants: UPPER_CASE (e.g., `MAX_SUPPLY`)
   - Private/Internal: Leading underscore (e.g., `_execute`)

2. **Ordering**
   - License and pragma
   - Imports
   - Errors
   - Events
   - State variables
   - Constructor
   - Modifiers
   - Public functions
   - Internal functions
   - Private functions

3. **Documentation**
   - Use NatSpec format
   - Document all public functions
   - Include `@notice`, `@dev`, `@param`, `@return`

### Example:

```solidity
/**
 * @notice Casts a vote on a proposal
 * @dev Only token holders can vote
 * @param proposalId The proposal ID
 * @param support Vote type (0=Against, 1=For, 2=Abstain)
 * @return weight The voting weight applied
 */
function castVote(uint256 proposalId, uint8 support) 
    public 
    returns (uint128 weight) 
{
    // Implementation
}
```

## Testing

### Writing Tests

```solidity
import "forge-std/Test.sol";

contract MyContractTest is Test {
    MyContract contract;
    
    function setUp() public {
        contract = new MyContract();
    }
    
    function testExample() public {
        // Arrange
        uint256 expected = 42;
        
        // Act
        uint256 result = contract.getValue();
        
        // Assert
        assertEq(result, expected);
    }
    
    function testFailure() public {
        vm.expectRevert("Error message");
        contract.revertingFunction();
    }
}
```

### Running Tests

```bash
# All tests
forge test

# Verbose output
forge test -v

# Match pattern
forge test --match-path "test/GovernanceToken.t.sol"

# Single test function
forge test --match "testMint"

# With gas report
forge test --gas-report

# Coverage
forge coverage
```

## Common Tasks

### Add New Contract

1. Create `src/NewContract.sol`
2. Create `test/NewContract.t.sol`
3. Write tests first (TDD)
4. Implement contract
5. Run tests: `forge test`

### Add New Test

```solidity
function testNewFeature() public {
    // Your test
}
```

### Update Dependencies

```bash
forge update
```

### Clean Build Artifacts

```bash
forge clean
```

## Debugging

### Using Cast

```bash
# Query contract state
cast call $CONTRACT_ADDRESS "functionName()" --rpc-url $RPC_URL

# Simulate transaction
cast call $CONTRACT_ADDRESS "functionName(args)" --from $YOUR_ADDRESS --rpc-url $RPC_URL

# Decode output
cast decode "result" "uint256"
```

### Using Anvil

```bash
# Start local blockchain
anvil

# Deploy locally
forge script script/Deploy.s.sol \
    --rpc-url http://localhost:8545 \
    --broadcast

# Interact with local contracts
cast call $ADDRESS "balanceOf(address)" $ACCOUNT --rpc-url http://localhost:8545
```

### Adding Logs

```solidity
import "forge-std/console.sol";

function myFunction() public {
    console.log("Value:", someValue);
    console.log("Address:", someAddress);
}
```

## Performance Optimization

### Gas Optimization Tips

1. Use storage efficiently
2. Batch operations where possible
3. Use events instead of storage for logs
4. Optimize loop conditions
5. Cache storage reads

### Measuring Gas

```bash
forge test --gas-report

# Output shows gas usage by function
```

## Pre-Commit Checks

```bash
# Format code
forge fmt

# Check code style
solhint 'src/**/*.sol'

# Run all tests
forge test

# Generate coverage
forge coverage
```

## Deployment Checklist

- [ ] All tests passing
- [ ] Code formatted: `forge fmt`
- [ ] Linting passed: `solhint 'src/**/*.sol'`
- [ ] Coverage adequate: `forge coverage`
- [ ] Gas optimization reviewed
- [ ] Security checklist completed
- [ ] Deployment parameters verified
- [ ] Private key secured
- [ ] RPC endpoint tested

## Useful Commands Reference

```bash
# Build
forge build
forge build --optimize

# Test
forge test
forge test -v
forge test --gas-report

# Deploy
forge script script/Deploy.s.sol --broadcast

# Verify
forge verify-contract <address> <contract-name>

# Clean
forge clean

# Format
forge fmt

# Documentation
forge doc --out docs
```

## Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/4.x/)
- [Solhint Linter](https://github.com/protofire/solhint)
