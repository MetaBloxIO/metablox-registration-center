const Migrations = artifacts.require("HarmonyDIDRegistry");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};