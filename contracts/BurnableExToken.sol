pragma solidity ^0.4.24;

import './access/Manageable.sol';
import './base/BurnableToken.sol';


/**
 * @title BurnableExToken.
 * @dev Extension for the BurnableToken contract, to support
 * some manager to enforce burning all tokens of all holders.
 **/
contract BurnableExToken is Manageable, BurnableToken {

  /**
   * @dev Burns all remaining tokens of all holders.
   * @param note a note that the manager can attach.
   */
  function burnAll(string note) external onlyManager {
    uint256 holdersCount = getTheNumberOfHolders();
    for (uint256 i = 0; i < holdersCount; ++i) {
      address holder = getHolder(i);
      uint256 balance = balanceOf(holder);
      if (balance == 0) continue;

      _burn(holder, balance, note);
    }
  }
}
