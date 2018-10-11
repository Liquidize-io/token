pragma solidity ^0.4.24;

import "./access/Manageable.sol";
import "./base/StandardToken.sol";


/**
 * @title TokenWithFees.
 * @dev This contract allows for transaction fees to be assessed on transfer.
 **/
contract TokenWithFees is Manageable, StandardToken {
  uint256 private _feeNumerator = 0;
  uint256 private _feeDenominator = 10000;
  // All transaction fees are paid to this address.
  address private _beneficiary;

  event ChangeWallet(address indexed newBeneficiary);
  event ChangeFees(uint256 newFeeNumerator,
                   uint256 newFeeDenominator);

  constructor(address wallet) public {
    _beneficiary = wallet;
  }

  function beneficiary() public view returns (address) {
    return _beneficiary;
  }

  function feeNumerator() public view returns (uint256) {
    return _feeNumerator;
  }

  function feeDenominator() public view returns (uint256) {
    return _feeDenominator;
  }

  // transfer and transferFrom both call this function, so pay fee here.
  // E.g. if A transfers 1000 tokens to B, B will receive 999 tokens,
  // and the system wallet will receive 1 token.
  function _transfer(address from, address to, uint256 value) internal {
    uint256 fee = _payFee(from, value, to);
    uint256 remaining = value.sub(fee);
    super._transfer(from, to, remaining);
  }

  function _payFee(
    address payer,
    uint256 value,
    address otherParticipant
  )
    internal
    returns (uint256)
  {
    // This check allows accounts to be whitelisted and not have to pay transaction fees.
    bool shouldBeFree = (
      registry().hasAttribute(payer, Attribute.AttributeType.NO_FEES) ||
      registry().hasAttribute(otherParticipant, Attribute.AttributeType.NO_FEES)
    );
    if (shouldBeFree) {
      return 0;
    }

    uint256 fee = value.mul(_feeNumerator).div(_feeDenominator);
    if (fee > 0) {
      super._transfer(payer, _beneficiary, fee);
    }
    return fee;
  }

  function checkTransferFee(uint256 value) public view returns (uint256) {
    return value.mul(_feeNumerator).div(_feeDenominator);
  }

  function changeFees(
    uint256 newFeeNumerator,
    uint256 newFeeDenominator
  )
    public
    onlyManager
  {
    require(newFeeNumerator < newFeeDenominator);
    _feeNumerator = newFeeNumerator;
    _feeDenominator = newFeeDenominator;

    emit ChangeFees(_feeNumerator, _feeDenominator);
  }

  /**
   * @dev Change address of the wallet where the fees will be sent to.
   * @param newBeneficiary The new wallet address.
   */
  function changeWallet(address newBeneficiary) public onlyManager {
    require(newBeneficiary != address(0), "new wallet cannot be 0x0");
    _beneficiary = newBeneficiary;

    emit ChangeWallet(_beneficiary);
  }
}
