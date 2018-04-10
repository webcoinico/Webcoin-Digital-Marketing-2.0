var Vault = artifacts.require("./Vault.sol");
var WebcoinToken = artifacts.require("./WebcoinToken.sol");
var WebcoinCrowdsale = artifacts.require("./WebcoinCrowdsale.sol");
const totalSupplyCap = "70000000000000000000000000"; // 70M * 10**18 wei
const crowdsaleCap = "25000000000000000000000000"; // 25M * 10**18 wei
const softCap = "600000000000000000000"; // 600 * 10**18 wei

module.exports = function(deployer, helper, accounts) {
    const openingTime = 1523232000;
    const closingTime = 1546297200;
    return deployer.deploy(WebcoinCrowdsale, openingTime, closingTime, [2200,1900,1700,1500,1300,1100,1000,850], softCap, crowdsaleCap, Vault.address, accounts, WebcoinToken.address);
}