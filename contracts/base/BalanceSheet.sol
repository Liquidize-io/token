pragma solidity ^0.4.24;

import "../openzeppelin/contracts/math/SafeMath.sol";

import "../ownership/ClaimableEx.sol";
import '../utils/AddressSet.sol';


// A wrapper around the balances mapping.
contract BalanceSheet is ClaimableEx {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  AddressSet private holderSet;

  constructor() public {
    holderSet = new AddressSet();
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  function addBalance(address addr, uint256 value) public onlyOwner {
    _balances[addr] = _balances[addr].add(value);

    _checkHolderSet(addr);
  }

  function subBalance(address addr, uint256 value) public onlyOwner {
    _balances[addr] = _balances[addr].sub(value);
  }

  function setBalance(address addr, uint256 value) public onlyOwner {
    _balances[addr] = value;

    _checkHolderSet(addr);
  }

  function setBalanceBatch(
    address[] _addrs,
    uint256[] _values
  )
    public
    onlyOwner
  {
    uint256 _count = _addrs.length;
    require(_count == _values.length);

    for(uint256 _i = 0; _i < _count; _i++) {
      setBalance(_addrs[_i], _values[_i]);
    }
  }

  function getTheNumberOfHolders() public view returns (uint256) {
    return holderSet.getTheNumberOfElements();
  }

  function getHolder(uint256 _index) public view returns (address) {
    return holderSet.elementAt(_index);
  }

  function _checkHolderSet(address _addr) internal {
    if (!holderSet.contains(_addr)) {
      holderSet.add(_addr);
    }
  }
}
