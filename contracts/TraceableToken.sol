pragma solidity ^0.4.24;

import './access/Manageable.sol';
import './base/MintableToken.sol';
import './utils/AddressSet.sol';


/**
 * @title Traceable token.
 * @dev This contract allows a sub-class token contract to run a loop through its all holders.
 **/
contract TraceableToken is Manageable, MintableToken {
  AddressSet private _holderSet;

  constructor() public {
    _holderSet = new AddressSet();
  }

  /**
   * @dev Throws if called by any account that is neither a manager nor the owner.
   */
  modifier canTrace() {
    require(isManager(msg.sender) || msg.sender == owner);
    _;
  }

  /**
   * @dev Mints tokens to a beneficiary address. The target address should be
   * added to the token holders list if needed.
   * @param to Who got the tokens.
   * @param amount Amount of tokens.
   */
  function mint(
    address to,
    uint256 amount
  )
    public
    hasMintPermission
    canMint
    returns (bool)
  {
    bool suc = super.mint(to, amount);
    if (suc) _holderSet.add(to);

    return suc;
  }

  function transfer(address to, uint256 value) public returns (bool) {
    _checkTransferTarget(to);

    super.transfer(to, value);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    _checkTransferTarget(to);

    super.transferFrom(from, to, value);
    return true;
  }

  function getTheNumberOfHolders() public canTrace view returns (uint256) {
    return _holderSet.getTheNumberOfElements();
  }

  function getHolder(uint256 index) public canTrace view returns (address) {
    return _holderSet.elementAt(index);
  }

  function _checkTransferTarget(address to) internal {
    if (!_holderSet.contains(to)) {
      _holderSet.add(to);
    }
  }
}
