const { NomicLabsHardhatPluginError } = require("hardhat/plugins");

async function main() {}

async function validateEnvironment(hreModule, ethers) {
  const signers = await ethers.getSigners();
  // Find deployer signer in signers.
  let deployer;
  signers.forEach((a) => {
    if (a.address === process.env.DEPLOY_ADDRESS) {
      deployer = a;
    }
  });
  if (!deployer) {
    console.log("error");
    throw new Error(`${process.env.DEPLOY_ADDRESS} not found in signers!`);
  }

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Network:", hreModule.network.name);
}

async function deployContract(contractName, params, hreModule, ethers) {
  await validateEnvironment(hreModule, ethers);
  console.log("-------------------------");
  if (
    hreModule.network.name === "testnet" ||
    hreModule.network.name === "mainnet"
  ) {
    console.log(`-------Deploying ${contractName}-----------`);
    const nftContract = await ethers.getContractFactory(contractName);
    const nftContractImplementation = await nftContract.deploy(...params);

    await nftContractImplementation.waitForDeployment();
    console.log(
      `Deployed ${contractName} Address: ` +
        (await nftContractImplementation.getAddress())
    );
    console.log("-------------------------");
  }
}

module.exports = {
  deployContract,
};
