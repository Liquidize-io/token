pragma solidity ^0.4.24;

import '../openzeppelin/contracts/ownership/Contactable.sol';

import '../base/DetailedToken.sol';
import '../base/PausableToken.sol';
import '../delegate/CanDelegateToken.sol';
import '../delegate/DelegateToken.sol';
import '../AssetInfo.sol';
import '../BurnableExToken.sol';
import '../CompliantToken.sol';
import '../TokenWithFees.sol';
import '../WithdrawalToken.sol';


/**
 * @title LiquidizeTokenMock.
 * @dev LiquidizeTokenMock is a ERC20 token that is used for test purpose only.
 **/
contract LiquidizeTokenMock is Contactable, AssetInfo, DetailedToken, BurnableExToken, CanDelegateToken, DelegateToken, TokenWithFees, CompliantToken, WithdrawalToken, PausableToken {
  uint8 public constant decimals = 18;
  uint256 public constant TOTAL_TOKENS = 1 * (10**6) * (10 ** uint256(decimals));

  /**
   * @param name Name of this token.
   * @param symbol Symbol of this token.
   */
  constructor(
    string name,
    string symbol,
    string fixedDocsLink,
    string varDocsLink,
    address wallet,
    uint256 totalSupply
  )
    public
    AssetInfo(fixedDocsLink, varDocsLink)
    DetailedToken(name, symbol)
    TokenWithFees(wallet)
  {
    contactInformation = 'https://liquidize.io/';

    _setTotalSupply(totalSupply);
  }

  /**
   * @dev Mints tokens to a beneficiary address.
   * Cap minting so that totalSupply <= TOTAL_TOKENS.
   * @param to Who got the tokens.
   * @param value Amount of tokens.
   */
  function mint(
    address to,
    uint256 value
  )
    public
    hasMintPermission
    canMint
    returns (bool)
  {
    require(totalSupply().add(value) <= TOTAL_TOKENS);

    return super.mint(to, value);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a new owner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    // do not allow self ownership
    require(newOwner != address(this));

    super.transferOwnership(newOwner);
  }
}
