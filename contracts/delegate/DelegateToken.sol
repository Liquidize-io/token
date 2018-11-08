pragma solidity ^0.4.24;

import "../base/BurnableToken.sol";
import "./DelegateBurnable.sol";


// Treats all delegate functions exactly like the corresponding normal functions,
// e.g. delegateTransfer is just like transfer. See DelegateBurnable.sol for more on
// the delegation system.
contract DelegateToken is DelegateBurnable, BurnableToken {
  address private _delegatedFrom;

  event DelegatedFromSet(address addr);

  // Only calls from appointed address will be processed
  modifier onlyMandator() {
    require(msg.sender == _delegatedFrom);
    _;
  }

  function delegatedFrom() public view returns (address) {
    return _delegatedFrom;
  }

  function setDelegatedFrom(address addr) public onlyOwner {
    _delegatedFrom = addr;
    emit DelegatedFromSet(addr);
  }

  function delegateBalanceOf(
    address who
  )
    public
    onlyMandator
    view
    returns (uint256)
  {
    return balanceOf(who);
  }

  // each function delegateX is simply forwarded to function X
  function delegateTotalSupply(
  )
    public
    onlyMandator
    view
    returns (uint256)
  {
    return totalSupply();
  }

  function delegateTransfer(
    address to,
    uint256 value,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _transfer(origSender, to, value);
    return true;
  }

  function delegateTransferFrom(
    address from,
    address to,
    uint256 value,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _transferFrom(from, to, value, origSender);
    return true;
  }

  function delegateAllowance(
    address owner,
    address spender
  )
    public
    onlyMandator
    view
    returns (uint256)
  {
    return allowance(owner, spender);
  }

  function delegateApprove(
    address spender,
    uint256 value,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _approve(spender, value, origSender);
    return true;
  }

  function delegateDecreaseAllowance(
    address spender,
    uint256 subtractedValue,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _decreaseAllowance(spender, subtractedValue, origSender);
    return true;
  }

  function delegateIncreaseAllowance(
    address spender,
    uint256 addedValue,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _increaseAllowance(spender, addedValue, origSender);
    return true;
  }

  function delegateBurn(
    address origSender,
    uint256 value,
    string note
  )
    public
    onlyMandator
  {
    _burn(origSender, value , note);
  }

  function delegateGetTheNumberOfHolders() public view returns (uint256) {
    return getTheNumberOfHolders();
  }

  function delegateGetHolder(uint256 _index) public view returns (address) {
    return getHolder(_index);
  }
}
