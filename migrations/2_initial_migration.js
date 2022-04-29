const Timelock = artifacts.require("Timelock")

module.exports = function(deployer){
    deployer.deploy(Timelock);
}