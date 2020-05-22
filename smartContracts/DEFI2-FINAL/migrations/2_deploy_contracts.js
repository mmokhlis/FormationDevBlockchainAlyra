//var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var MarketPlace = artifacts.require("./MarketPlace.sol");

module.exports = function(deployer) {
  deployer.deploy(MarketPlace);
};
