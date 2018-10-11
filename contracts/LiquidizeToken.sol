pragma solidity ^0.4.24;

import './openzeppelin/contracts/ownership/Contactable.sol';

import './base/DetailedToken.sol';
import './base/PausableToken.sol';
import './delegate/CanDelegateToken.sol';
import './delegate/DelegateToken.sol';
import './AssetInfo.sol';
import './BurnableExToken.sol';
import './CompliantToken.sol';
import './TokenWithFees.sol';
import './WithdrawalToken.sol';


/**
 * @title Liquidize token.
 * @dev Liquidize is a ERC20 token that:
 *  - caps total number at 1 million tokens.
 *  - can pause and unpause token transfer (and authorization) actions.
 *  - mints new tokens when purchased.
 *  - token holders can be distributed profit from asset manager.
 *  - contains real asset information.
 *  - can change token name and symbol as needed.
 *  - can delegate to a new contract.
 *  - can enforce burning all tokens.
 *  - can run a loop through its all holders.
 *  - transferring tokens to 0x0 address is treated as burning.
 *  - transferring tokens with fees are sent to the system wallet.
 *  - attempts to check KYC/AML and Blacklist using Registry.
 *  - attempts to reject ERC20 token transfers to itself and allows token transfer out.
 *  - attempts to reject ether sent and allows any ether held to be transferred out.
 *  - allows the new owner to accept the ownership transfer, the owner can cancel the transfer if needed.
 **/
contract LiquidizeToken is Contactable, AssetInfo, DetailedToken, BurnableExToken, CanDelegateToken, DelegateToken, TokenWithFees, CompliantToken, WithdrawalToken, PausableToken {
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
    address wallet
  )
    public
    AssetInfo(fixedDocsLink, varDocsLink)
    DetailedToken(name, symbol)
    TokenWithFees(wallet)
  {
    contactInformation = 'https://liquidize.io/';
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
