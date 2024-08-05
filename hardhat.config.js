require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: "0.8.20", //replace your own solidity compiler version
  networks: {
    opbnb: {
      url: "https://opbnb-mainnet-rpc.bnbchain.org/",
      chainId: 5611, // Replace with the correct chainId for the "opbnb" network
      accounts: ["{{YOUR-PRIVATE-KEY}}"], // Add private keys or mnemonics of accounts to use
      gasPrice: 20000000000,
    },
  },
  etherscan: {
    apiKey: {
      opbnb: "{{YOUR-NODEREAL-API-KEY}}", //replace your nodereal API key
    },

    customChains: [
      {
        network: "opbnb",
        chainId: 5611, // Replace with the correct chainId for the "opbnb" network
        urls: {
          apiURL:
            "https://open-platform.nodereal.io/{{YOUR-NODEREAL-API-KEY}}/op-bnb-mainnet/contract/",
          browserURL: "https://opbnbscan.com/",
        },
      },
    ],
  },
};