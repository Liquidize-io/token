pragma solidity ^0.4.24;

import "../openzeppelin/contracts/math/SafeMath.sol";

import "../ownership/ClaimableEx.sol";


// A wrapper around the balances mapping.
contract BalanceSheet is ClaimableEx {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  function addBalance(address addr, uint256 value) public onlyOwner {
    _balances[addr] = _balances[addr].add(value);
  }

  function subBalance(address addr, uint256 value) public onlyOwner {
    _balances[addr] = _balances[addr].sub(value);
  }

  function setBalance(address addr, uint256 value) public onlyOwner {
    _balances[addr] = value;
  }
}
