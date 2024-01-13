// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Token is ERC20, ERC20Burnable, ERC20Pausable, AccessControl, ReentrancyGuard {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint public maxSupply;

    constructor(uint _maxSupply) ERC20("Luminar", "LUM") {
      maxSupply = _maxSupply;
      _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
      _grantRole(PAUSER_ROLE, msg.sender);
      _grantRole(MINTER_ROLE, msg.sender);
    }

    event Mint (address indexed guy, uint256 wad);
    event Burn (address indexed guy, uint256 wad);
    event Approval (address indexed owner, address indexed guy, uint256 wad);
    event Stop ();
    event Start ();

    function stop() public onlyRole(PAUSER_ROLE) {
      _pause();
      emit Stop();
    }

    function start() public onlyRole(PAUSER_ROLE) {
        _unpause();
        emit Start();
    }

    function approve(address guy, uint wad) public virtual override returns (bool) {
        address ownwer = _msgSender();
        _approve(ownwer, guy, wad);
        emit Approval(ownwer, guy, wad);
        return true;
    } 

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        uint256 newTotalSupply = totalSupply() + amount;
        require(newTotalSupply <= maxSupply, "Max supply exceeded");
        emit Mint(to, amount);
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 ammount) internal whenNotPaused nonReentrant override {
        super._beforeTokenTransfer(from, to, ammount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}
