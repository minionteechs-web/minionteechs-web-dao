# DAO Operations Guide

## Creating and Voting on Proposals

### Step 1: Prepare Proposal

The proposal must include:
- `targets` - array of contract addresses to call
- `values` - array of ETH values to send
- `calldatas` - array of function call data
- `description` - human-readable description

### Step 2: Submit Proposal

```solidity
governor.propose(
    targets,
    values,
    calldatas,
    "Proposal #1: Deploy new feature"
);
```

### Step 3: Wait for Voting Delay

Default: 1 block

### Step 4: Vote

```solidity
// 0 = Against, 1 = For, 2 = Abstain
governor.castVote(proposalId, 1);
```

### Step 5: Wait for Voting Period to End

Default: 50,400 blocks (~1 week)

### Step 6: Queue Proposal (if passed)

```solidity
governor.queue(
    targets,
    values,
    calldatas,
    descriptionHash
);
```

### Step 7: Wait for Timelock

Default: 2 days minimum

### Step 8: Execute Proposal

```solidity
governor.execute(
    targets,
    values,
    calldatas,
    descriptionHash
);
```

## Treasury Operations

### Deposit Funds

```solidity
// Direct transfer
treasury.deposit{value: 1 ether}();

// Or send ETH directly
(bool success, ) = address(treasury).call{value: 1 ether}("");
require(success);
```

### Withdraw Funds

Only DAO governance can withdraw:

1. Create proposal to call `treasury.withdraw(recipient, amount)`
2. Follow proposal process above
3. After execution, recipient receives funds

### Check Treasury Balance

```solidity
uint256 balance = treasury.getTreasuryBalance();
uint256 userBalance = treasury.getUserBalance(userAddress);
```

## Member Management

### Add Member

```solidity
daoStorage.addMember(memberAddress, sharesAmount);
```

### Remove Member

```solidity
daoStorage.removeMember(memberAddress);
```

### Update Member Shares

```solidity
daoStorage.updateShares(memberAddress, newShareAmount);
```

### Query Members

```solidity
address[] memory members = daoStorage.getMembers();
DAOStorage.Member memory member = daoStorage.getMember(memberAddress);
bool isMember = daoStorage.isMember(memberAddress);
```

## Common Tasks

### Token Distribution

```bash
# Mint tokens to members
forge script script/Initialize.s.sol \
    --rpc-url $RPC_URL \
    --broadcast \
    --private-key $PRIVATE_KEY
```

### Query Governance State

```bash
# Check proposal state
cast call $GOVERNOR "state(uint256)" proposalId

# Get proposal details
cast call $GOVERNOR "proposalDetails(uint256)" proposalId

# Check voting weight
cast call $TOKEN "getVotes(address)" 0xYourAddress
```

### Emergency Operations

If governance becomes stuck:

1. Timelock admin can cancel pending operations
2. Token owner can mint emergency tokens
3. Treasury owner can withdraw funds

## Governance Parameters

Current defaults:
- **Voting Delay**: 1 block
- **Voting Period**: 50,400 blocks
- **Proposal Threshold**: 100 tokens
- **Quorum**: 4%
- **Timelock Delay**: 2-30 days

To modify parameters (requires governance vote):
1. Create proposal to call `governor.updateGovernanceSettings(...)`
2. Follow standard proposal process

## Troubleshooting

### Proposal Not Passing
- Check quorum (need 4% of total votes)
- Ensure voting period hasn't ended
- Verify enough FOR votes vs AGAINST

### Execution Failed
- Check timelock delay has passed
- Verify caller has permission
- Check call data is correct
- Ensure contract has sufficient gas/funds

### Token Transfer Issues
- Verify token balance before transfer
- Check for delegation requirements
- Ensure no token locks in place

## Emergency Contacts

Document key contacts:
- Team Lead: [contact]
- Security Lead: [contact]
- DevOps: [contact]
- Treasury Manager: [contact]
