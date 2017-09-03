var SSayePresale = artifacts.require("./SSayePresale.sol");
var startBlock = 0;
var endBlock = 100;
var ssayeMultiSig = 0xcb6ed90bb51e03eaf233e7fc1d300c43176c0433;
module.exports = function(deployer) {
  deployer.deploy(SSayePresale,ssayeMultiSig,startBlock,endBlock);
};
