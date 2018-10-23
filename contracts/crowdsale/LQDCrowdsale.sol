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

  /**
   * Event for changing rate logging
   * @param newRate a new rate value
   */
  event ChangeRate(
    uint256 newRate
  );

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

  /**
   * @dev Change rate value.
   * The rate is the conversion between wei and the smallest and indivisible token unit.
   * @param _rate a new rate value
   */
  function changeRate(uint256 _rate) {
    require(_rate > 0);
    
    rate = _rate;

    emit ChangeRate(rate);
  }
}
