pragma solidity ^0.4.24;


contract Migrations {
  address private _owner;
  uint256 private _last_completed_migration;

  modifier restricted() {
    if (msg.sender == _owner) _;
  }

  constructor() public {
    _owner = msg.sender;
  }

  function setCompleted(uint256 completed) public restricted {
    _last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(_last_completed_migration);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  function last_completed_migration() public view returns (uint256) {
    return _last_completed_migration;
  }
}
