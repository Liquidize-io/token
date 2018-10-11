pragma solidity ^0.4.24;

import "./StandardToken.sol";


/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 **/
contract BurnableToken is StandardToken {
  event Burn(address indexed burner, uint256 value, string note);

  /**
   * @dev Burns a specific amount of tokens.
   * @param value The amount of token to be burned.
   * @param note a note that burner can attach.
   */
  function burn(uint256 value, string note) public returns (bool) {
    _burn(msg.sender, value, note);

    return true;
  }

  /**
   * @dev Burns a specific amount of tokens of an user.
   * @param burner Who has tokens to be burned.
   * @param value The amount of tokens to be burned.
   * @param note a note that the manager can attach.
   */
  function _burn(
    address burner,
    uint256 value,
    string note
  )
    internal
  {
    _burn(burner, value);

    emit Burn(burner, value, note);
  }
}
