pragma solidity ^0.4.24;

import "../openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "../openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "../LiquidizeToken.sol";
import "./RefundableCrowdsale.sol";


/**
 * @title LQDCrowdsale
 * @dev LQD token sale.
 **/
contract LQDCrowdsale is RefundableCrowdsale {

  constructor(
    uint256 openingTime,
    uint256 closingTime,
    uint256 rate,
    address wallet,
    LiquidizeToken token
  )
    public
    Crowdsale(rate, wallet, token)
    TimedCrowdsale(openingTime, closingTime)
    RefundableCrowdsale()
  {
  }
}
