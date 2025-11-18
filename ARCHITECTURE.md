# Architecture Documentation

## System Overview

The MinionTechs DAO is a modular governance system consisting of five interconnected smart contracts:

```
┌─────────────────────────────────────────────────────────────┐
│                    Governance Layer                          │
│  ┌──────────────────┐         ┌──────────────────────────┐  │
│  │  DAOGovernor     │ ◄────── │  GovernanceToken        │  │
│  │  (Voting Logic)  │         │  (Vote Delegation)      │  │
│  └────────┬─────────┘         └──────────────────────────┘  │
│           │                                                  │
│           ▼                                                  │
│  ┌──────────────────┐                                       │
│  │  Timelock        │                                       │
│  │  (Delays)        │                                       │
│  └────────┬─────────┘                                       │
│           │                                                 │
└───────────┼────────────────────────────────────────────────┘
            │
   ┌────────┼────────┐
   │        │        │
   ▼        ▼        ▼
┌─────┐ ┌──────────┐ ┌──────────────┐
│Treas│ │ Storage  │ │  Other Apps  │
│ury  │ │          │ │              │
└─────┘ └──────────┘ └──────────────┘

Execution Layer
```

## Contract Dependencies

### GovernanceToken
- **Depends on**: OpenZeppelin ERC20, ERC20Votes, Ownable
- **Used by**: DAOGovernor
- **Purpose**: Voting power representation

### DAOGovernor  
- **Depends on**: GovernanceToken, Timelock, OpenZeppelin Governor
- **Used by**: External proposal systems
- **Purpose**: Proposal creation and voting

### Timelock
- **Depends on**: None
- **Used by**: DAOGovernor
- **Purpose**: Time-delayed execution

### Treasury
- **Depends on**: OpenZeppelin Ownable, ReentrancyGuard
- **Used by**: Governance via proposals
- **Purpose**: Fund management

### DAOStorage
- **Depends on**: OpenZeppelin Ownable
- **Used by**: DAO managers
- **Purpose**: Member tracking

## State Transitions

### Proposal Lifecycle

```
┌─────────────┐
│   Created   │
└──────┬──────┘
       │ (voting_delay blocks)
       ▼
┌──────────────┐
│   Voting     │ ◄────── Users can castVote
└──────┬───────┘
       │ (voting_period blocks)
       ▼
┌──────────────┐
│    Ended     │ ◄────── Check if Succeeded/Defeated
└──────┬───────┘
       │ (if succeeded)
       ▼
┌──────────────┐
│   Queued     │ ◄────── (optional, via queue())
└──────┬───────┘
       │ (min_delay)
       ▼
┌──────────────┐
│  Executable  │ ◄────── Call execute()
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Executed   │
└──────────────┘
```

## Data Flow

### Token Voting Flow

```
User owns tokens
      │
      ▼
User delegates to self/other
      │
      ▼
Delegation tracked in GovernanceToken
      │
      ▼
User can vote on proposals
      │
      ▼
Votes counted by DAOGovernor
      │
      ▼
Proposal passes if quorum + majority
```

### Treasury Flow

```
User deposits ETH
      │
      ▼
Tracked in Treasury contract
      │
      ▼
Governance votes on withdrawal
      │
      ▼
Proposal queued in Timelock
      │
      ▼
After delay, proposal executed
      │
      ▼
Funds transferred
```

## Security Model

### Access Control Levels

```
Public (Anyone)
├── castVote() - Cast vote on proposal
├── propose() - Create proposal (need threshold)
├── deposit() - Deposit to treasury
└── delegate() - Delegate voting power

OnlyOwner (DAO/Governance)
├── mint() - Mint governance tokens
├── withdraw() - Withdraw from treasury
├── addMember() - Add DAO member
└── updateShares() - Update member shares

Admin Only (Timelock Admins)
├── schedule() - Schedule operation
├── execute() - Execute operation
└── cancel() - Cancel operation
```

### Threat Mitigations

1. **Reentrancy**: Protected by ReentrancyGuard in Treasury
2. **Double Spending**: ERC20 standard handles via balance tracking
3. **Governance Hijacking**: Voting power needs quorum + majority
4. **Flash Loans**: Voting power based on delegation, not balance
5. **Time Attacks**: Timelock enforces delays before execution
6. **Access Control**: Multi-level permission checks

## Gas Optimization

### Key Optimizations

1. **Storage Packing**: Related data stored together
2. **Event Logging**: Used instead of unnecessary storage
3. **Delegation**: Checkpoints only at changes
4. **Batching**: Operations grouped where possible

### Gas Costs (Typical)

- Token Mint: ~50,000 gas
- Propose: ~200,000 gas
- Vote: ~70,000 gas
- Queue: ~100,000 gas
- Execute: ~150,000 gas

## Extensibility Points

### Adding New Functionality

1. **Custom Voting Logic**: Extend DAOGovernor
2. **Treasury Strategies**: Add to Treasury contract
3. **Member Roles**: Extend DAOStorage
4. **Token Mechanics**: Extend GovernanceToken

### Integration Points

- Calls any external contract from Treasury
- Proposals can interact with any address
- Token is standard ERC20 compatible

## Upgrade Considerations

Current contracts use:
- No proxies (immutable core logic)
- OpenZeppelin Governor pattern
- Governor parameters can be updated via governance

To upgrade:
1. Deploy new implementation
2. Propose governance update
3. Vote and execute through governance
4. Can point to new contract addresses

## Monitoring & Alerting

### Key Events to Monitor

```
GovernanceToken:
- TokensMinted(address indexed to, uint256 amount)
- TokensBurned(address indexed from, uint256 amount)
- DelegateChanged(...)

DAOGovernor:
- ProposalCreated(...)
- VoteCast(...)
- ProposalQueued(...)

Timelock:
- OperationScheduled(bytes32 indexed id, uint256 delay)
- OperationExecuted(bytes32 indexed id)

Treasury:
- FundsDeposited(address indexed from, uint256 amount)
- FundsWithdrawn(address indexed to, uint256 amount)
```

### Health Checks

- Token total supply matches minted tokens
- Voting power consistent with delegations
- Timelock operations executing properly
- Treasury balance accurate
