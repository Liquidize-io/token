pragma solidity ^0.4.24;

import "../base/BurnableToken.sol";
import "./DelegateBurnable.sol";


// See DelegateBurnable.sol for more on the delegation system.
contract CanDelegateToken is BurnableToken {
  // If this contract needs to be upgraded, the new contract will be stored
  // in 'delegate' and any BurnableToken calls to this contract will be delegated to that one.
  DelegateBurnable private _delegate;

  event DelegateToNewContract(address indexed newContract);

  function balanceOf(address who) public view returns (uint256) {
    if (!_hasDelegate()) {
      return super.balanceOf(who);
    } else {
      return _delegate.delegateBalanceOf(who);
    }
  }

  function getTheNumberOfHolders() public view returns (uint256) {
    if (!_hasDelegate()) {
      return super.getTheNumberOfHolders();
    } else {
      return _delegate.delegateGetTheNumberOfHolders();
    }
  }

  function getHolder(uint256 _index) public view returns (address) {
    if (!_hasDelegate()) {
      return super.getHolder(_index);
    } else {
      return _delegate.delegateGetHolder(_index);
    }
  }

  function delegate() public view returns (address) {
    return _delegate;
  }

  // Can undelegate by passing in newContract = address(0)
  function delegateToNewContract(
    DelegateBurnable newContract
  )
    public
    onlyOwner
  {
    _delegate = newContract;
    emit DelegateToNewContract(_delegate);
  }

  function totalSupply() public view returns (uint256) {
    if (!_hasDelegate()) {
      return super.totalSupply();
    } else {
      return _delegate.delegateTotalSupply();
    }
  }

  function allowance(
    address owner,
    address spender
  )
    public
    view
    returns (uint256)
  {
    if (!_hasDelegate()) {
      return super.allowance(owner, spender);
    } else {
      return _delegate.delegateAllowance(owner, spender);
    }
  }

  function _approve(
    address spender,
    uint256 value,
    address holder
  )
    internal
  {
    if (!_hasDelegate()) {
      super._approve(spender, value, holder);
    } else {
      require(_delegate.delegateApprove(spender, value, holder));
    }
  }

  function _decreaseAllowance(
    address spender,
    uint256 subtractedValue,
    address holder
  )
    internal
  {
    if (!_hasDelegate()) {
      super._decreaseAllowance(spender, subtractedValue, holder);
    } else {
      require(
        _delegate.delegateDecreaseAllowance(
          spender,
          subtractedValue,
          holder)
      );
    }
  }

  function _increaseAllowance(
    address spender,
    uint256 addedValue,
    address holder
  )
    internal
  {
    if (!_hasDelegate()) {
      super._increaseAllowance(spender, addedValue, holder);
    } else {
      require(
        _delegate.delegateIncreaseAllowance(spender, addedValue, holder)
      );
    }
  }

  // If a delegate has been designated, all ERC20 calls are forwarded to it
  function _transfer(address from, address to, uint256 value) internal {
    if (!_hasDelegate()) {
      super._transfer(from, to, value);
    } else {
      require(_delegate.delegateTransfer(to, value, from));
    }
  }

  function _transferFrom(
    address from,
    address to,
    uint256 value,
    address spender
  )
    internal
  {
    if (!_hasDelegate()) {
      super._transferFrom(from, to, value, spender);
    } else {
      require(_delegate.delegateTransferFrom(from, to, value, spender));
    }
  }

  function _burn(address burner, uint256 value, string note) internal {
    if (!_hasDelegate()) {
      super._burn(burner, value, note);
    } else {
      _delegate.delegateBurn(burner, value , note);
    }
  }

  function _hasDelegate() internal view returns (bool) {
    return !(_delegate == address(0));
  }
}
