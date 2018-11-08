pragma solidity ^0.4.24;

import "../openzeppelin/contracts/math/SafeMath.sol";
import "../openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../ownership/ClaimableEx.sol";
import "../ownership/NoOwnerEx.sol";
import "./BalanceSheet.sol";


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * A version of OpenZeppelin's StandardToken whose balances mapping has been replaced
 * with a separate BalanceSheet contract. Most useful in combination with e.g.
 * HasNoContracts because then it can relinquish its balance sheet to a new
 * version of the token, removing the need to copy over balances.
 **/
contract StandardToken is ClaimableEx, NoOwnerEx, ERC20 {
  using SafeMath for uint256;

  uint256 private _totalSupply;

  BalanceSheet private _balances;
  event BalanceSheetSet(address indexed sheet);

  mapping (address => mapping (address => uint256)) private _allowed;

  constructor() public {
    _totalSupply = 0;
  }

  /**
   * @dev Total number of tokens in existence
   */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev Gets the balance of the specified address.
   * @param owner The address to query the the balance of.
   * @return An uint256 representing the amount owned by the passed address.
   */
  function balanceOf(address owner) public view returns (uint256 balance) {
    return _balances.balanceOf(owner);
  }

  /**
   * @dev Claim ownership of the BalanceSheet contract
   * @param sheet The address of the BalanceSheet to claim.
   */
  function setBalanceSheet(address sheet) public onlyOwner returns (bool) {
    _balances = BalanceSheet(sheet);
    _balances.claimOwnership();
    emit BalanceSheetSet(sheet);
    return true;
  }

  function getTheNumberOfHolders() public view returns (uint256) {
    return _balances.getTheNumberOfHolders();
  }

  function getHolder(uint256 _index) public view returns (address) {
    return _balances.getHolder(_index);
  }

  /**
   * @dev Transfer token for a specified address
   * @param to The address to transfer to.
   * @param value The amount to be transferred.
   */
  function transfer(address to, uint256 value) public returns (bool) {
    _transfer(msg.sender, to, value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param from The address which you want to send tokens from
   * @param to The address which you want to transfer to
   * @param value The amount of tokens to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    _transferFrom(from, to, value, msg.sender);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param spender The address which will spend the funds.
   * @param value The amount of tokens to be spent.
   */
  function approve(address spender, uint256 value) public returns (bool) {
    _approve(spender, value, msg.sender);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param owner address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address owner,
    address spender
  )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when _allowed[spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of tokens to increase the allowance by.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _increaseAllowance(spender, addedValue, msg.sender);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when _allowed[spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _decreaseAllowance(spender, subtractedValue, msg.sender);
    return true;
  }

  function _approve(
    address spender,
    uint256 value,
    address holder
  )
    internal
  {
    _allowed[holder][spender] = value;

    emit Approval(holder, spender, value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param burner The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burn(address burner, uint256 value) internal {
    require(burner != 0);
    require(value <= balanceOf(burner), "not enough balance to burn");

    // no need to require value <= _totalSupply, since that would imply the
    // sender's balance is greater than the _totalSupply, which *should* be an assertion failure
    _balances.subBalance(burner, value);
    _totalSupply = _totalSupply.sub(value);

    emit Transfer(burner, address(0), value);
  }

  function _decreaseAllowance(
    address spender,
    uint256 subtractedValue,
    address holder
  )
    internal
  {
    _allowed[holder][spender] = _allowed[holder][spender].sub(subtractedValue);

    emit Approval(holder, spender, _allowed[holder][spender]);
  }

  function _increaseAllowance(
    address spender,
    uint256 addedValue,
    address holder
  )
    internal
  {
    _allowed[holder][spender] = _allowed[holder][spender].add(addedValue);

    emit Approval(holder, spender, _allowed[holder][spender]);
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created tokens.
   * @param value The amount that will be created.
   */
  function _mint(address account, uint256 value) internal {
    require(account != address(0));

    _totalSupply = _totalSupply.add(value);
    _balances.addBalance(account, value);

    emit Transfer(address(0), account, value);
  }

  function _setTotalSupply(uint256 value) internal {
    _totalSupply = value;
  }

  function _transfer(address from, address to, uint256 value) internal {
    require(to != address(0), "to address cannot be 0x0");
    require(from != address(0),"from address cannot be 0x0");
    require(value <= balanceOf(from), "not enough balance to transfer");

    // SafeMath.sub will throw if there is not enough balance.
    _balances.subBalance(from, value);
    _balances.addBalance(to, value);

    emit Transfer(from, to, value);
  }

  function _transferFrom(
    address from,
    address to,
    uint256 value,
    address spender
  )
    internal
  {
    require(value <= _allowed[from][spender], "not enough allowance to transfer");

    _allowed[from][spender] = _allowed[from][spender].sub(value);
    _transfer(from, to, value);
  }
}
