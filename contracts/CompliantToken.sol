pragma solidity ^0.4.24;

import "./base/StandardToken.sol";
import "./registry/HasRegistry.sol";


contract CompliantToken is HasRegistry, StandardToken {
  // Addresses can also be blacklisted, preventing them from sending or receiving
  // Liquidize tokens. This can be used to prevent the use of LQD by bad actors in
  // accordance with law enforcement.

  modifier onlyIfNotBlacklisted(address addr) {
    require(
      !registry().hasAttribute(
        addr,
        Attribute.AttributeType.IS_BLACKLISTED
      )
    );
    _;
  }

  modifier onlyIfBlacklisted(address addr) {
    require(
      registry().hasAttribute(
        addr,
        Attribute.AttributeType.IS_BLACKLISTED
      )
    );
    _;
  }

  function _mint(
    address to,
    uint256 value
  )
    internal
    onlyIfNotBlacklisted(to)
  {
    super._mint(to, value);
  }

  // transfer and transferFrom both call this function, so check blacklist here.
  function _transfer(
    address from,
    address to,
    uint256 value
  )
    internal
    onlyIfNotBlacklisted(from)
    onlyIfNotBlacklisted(to)
  {
    super._transfer(from, to, value);
  }
}
