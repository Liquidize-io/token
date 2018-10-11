pragma solidity ^0.4.24;

import "../openzeppelin/contracts/lifecycle/Pausable.sol";

import "./StandardToken.sol";


/**
 * @title Pausable token
 * @dev StandardToken modified with pausable transfers.
 **/
contract PausableToken is StandardToken, Pausable {

  function _transfer(
    address from,
    address to,
    uint256 value
  )
    internal
    whenNotPaused
  {
    super._transfer(from, to, value);
  }

  function _transferFrom(
    address from,
    address to,
    uint256 value,
    address spender
  )
    internal
    whenNotPaused
  {
    super._transferFrom(from, to, value, spender);
  }

  function _approve(
    address spender,
    uint256 value,
    address holder
  )
    internal
    whenNotPaused
  {
    super._approve(spender, value, holder);
  }

  function _increaseAllowance(
    address spender,
    uint256 addedValue,
    address holder
  )
    internal
    whenNotPaused
  {
    super._increaseAllowance(spender, addedValue, holder);
  }

  function _decreaseAllowance(
    address spender,
    uint256 subtractedValue,
    address holder
  )
    internal
    whenNotPaused
  {
    super._decreaseAllowance(spender, subtractedValue, holder);
  }

  function _burn(
    address burner,
    uint256 value
  )
    internal
    whenNotPaused
  {
    super._burn(burner, value);
  }
}
