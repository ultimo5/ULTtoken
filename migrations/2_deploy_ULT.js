const ULT = artifacts.require("Ultimo5Token")

module.exports = async (deployer, network, accounts) => {
    deployer.deploy(ULT)
      .then(() => console.log("[MIGRATION] [" + parseInt(require("path").basename(__filename)) + "] ULT deploy: #done"))
}