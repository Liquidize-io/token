pragma solidity ^0.4.24;


import "../openzeppelin/contracts/math/SafeMath.sol";
import "../openzeppelin/contracts/crowdsale/distribution/FinalizableCrowdsale.sol";
import "../openzeppelin/contracts/payment/RefundEscrow.sol";


/**
 * @title RefundableCrowdsale
 * @dev Extension of Crowdsale contract that allows owner to enforce enabling
 * refunds, and the possibility of users getting a refund if goal is not met.
 **/
contract RefundableCrowdsale is FinalizableCrowdsale {
  using SafeMath for uint256;

  // refund escrow used to hold funds while crowdsale is running
  RefundEscrow private _escrow;

  bool private _goalReached;

  /**
   * @dev Constructor, creates RefundEscrow.
   */
  constructor() public {
    _escrow = new RefundEscrow(wallet);

    _goalReached = true;
  }

  function finalizeAndEnableRefunds() public onlyOwner {
    _goalReached = false;

    finalize();
  }

  /**
   * @dev Investors can claim refunds here if crowdsale is unsuccessful
   */
  function claimRefund() public {
    require(isFinalized);
    require(!goalReached());

    _escrow.withdraw(msg.sender);
  }

  /**
   * @dev Checks whether funding goal was reached.
   * @return Whether funding goal was reached
   */
  function goalReached() public view returns (bool) {
    return _goalReached;
  }

  /**
   * @dev escrow finalization task, called when owner calls finalize()
   */
  function finalization() internal {
    if (goalReached()) {
      _escrow.close();
      _escrow.beneficiaryWithdraw();
    } else {
      _escrow.enableRefunds();
    }

    super.finalization();
  }

  /**
   * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
   */
  function _forwardFunds() internal {
    _escrow.deposit.value(msg.value)(msg.sender);
  }
}
