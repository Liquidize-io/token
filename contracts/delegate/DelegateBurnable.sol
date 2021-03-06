pragma solidity ^0.4.24;


// Interface implemented by tokens that are the *target* of a BurnableToken's
// delegation. That is, if we want to replace BurnableToken X by
// Y but for convenience we'd like users of X
// to be able to keep using it and it will just forward calls to Y,
// then X should extend CanDelegate and Y should extend DelegateBurnable.
// Most ERC20 calls use the value of msg.sender to figure out e.g. whose
// balance to update; since X becomes the msg.sender of all such calls
// that it forwards to Y, we add the origSender parameter to those calls.
// Delegation is intended as a convenience for legacy users of X since
// we do not expect all regular users to learn about Y and change accordingly,
// but we do require the *owner* of X to now use Y instead so ownerOnly
// functions are not delegated and should be disabled instead.
// This delegation system is intended to work with the modified versions of
// the standard ERC20 token contracts, allowing the balances
// to be moved over to a new contract.
// NOTE: To maintain backwards compatibility, these function signatures
// cannot be changed
contract DelegateBurnable {

  function delegateBalanceOf(address who) public view returns (uint256);

  function delegateTotalSupply() public view returns (uint256);

  function delegateTransfer(address to, uint256 value, address origSender)
    public returns (bool);

  function delegateTransferFrom(
    address from,
    address to,
    uint256 value,
    address origSender
  )
    public returns (bool);

  function delegateAllowance(address owner, address spender)
    public view returns (uint256);

  function delegateApprove(
    address spender,
    uint256 value,
    address origSender
  )
    public returns (bool);

  function delegateDecreaseAllowance(
    address spender,
    uint256 subtractedValue,
    address origSender
  )
    public returns (bool);

  function delegateIncreaseAllowance(
    address spender,
    uint256 addedValue,
    address origSender
  )
    public returns (bool);

  function delegateBurn(
    address origSender,
    uint256 value,
    string note
  )
    public;

  function delegateGetTheNumberOfHolders() public view returns (uint256);

  function delegateGetHolder(uint256 _index) public view returns (address);
}
