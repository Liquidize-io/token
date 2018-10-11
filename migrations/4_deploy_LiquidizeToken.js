const LiquidizeToken = artifacts.require("./LiquidizeToken.sol");
const SafeMath = artifacts.require("./openzeppelin/contracts/math/SafeMath.sol");

module.exports = function(deployer, network, accounts) {
  let overwrite = true;
  var systemWallet = accounts[7]
  let tokenName = "Liquidize";
  let tokenSymbol = "LQD";
  let varLinkDoc = 'https://drive.google.com/file/d/1Zbstii6UmnNEEDyAHU59L3W6xonrDS_-/view?usp=sharing';
  let fixedLinkDoc = 'https://drive.google.com/file/d/1CQOKzCf3qKXQQLDpZumGMXCUt3Wtx9uf/view?usp=sharing';

  switch (network) {
    case 'development':
      overwrite = true;
      break;
    default:
      throw new Error ("Unsupported network");
  }

  deployer.then (async () => {
    await deployer.link(SafeMath, LiquidizeToken);
    return deployer.deploy(LiquidizeToken, tokenName, tokenSymbol, fixedLinkDoc, varLinkDoc, systemWallet, {overwrite: overwrite});
  }).then(() => {
    return LiquidizeToken.deployed();
  }).catch((err) => {
    console.error(err);
    process.exit(1);
  });
};
