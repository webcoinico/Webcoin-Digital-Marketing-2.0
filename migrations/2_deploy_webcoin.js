var WebcoinToken = artifacts.require("./WebcoinToken.sol");
const totalSupplyCap = "70000000000000000000000000"; // 70M * 10**18 wei

module.exports = function(deployer, helper, accounts) {
  return deployer.deploy(WebcoinToken, totalSupplyCap, accounts);
}
