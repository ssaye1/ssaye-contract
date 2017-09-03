var SSayePresale = artifacts.require("./SSayePresale.sol");
var startBlock = 0;
var endBlock = 100;
var ssayeMultiSig = 0xd81cf1067156bc1f74d95c62e50dd3c69317eb80;
module.exports = function(deployer) {
  deployer.deploy(SSayePresale,ssayeMultiSig,startBlock,endBlock);
};
