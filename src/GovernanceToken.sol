// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title GovernanceToken
 * @dev ERC20 token with voting rights for DAO governance
 */
contract GovernanceToken is ERC20, ERC20Votes, ERC20Permit, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000e18;

    constructor()
        ERC20("MinionTechs DAO Token", "MTD")
        ERC20Permit("MinionTechs DAO Token")
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function _update(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, amount);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}
