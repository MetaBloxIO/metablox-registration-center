require('dotenv').config()
const { TruffleProvider } = require('@harmony-js/core')
const account_1_mnemonic = process.env.MNEMONIC
const account_1_private_key = process.env.PRIVATE_KEY
const mainnet_private_key = process.env.MAINNET_PRIVATE_KEY
const testnet_0_url = process.env.TESTNET_0_URL
const mainnet_0_url = process.env.MAINNET_0_URL

gasLimit = process.env.GAS_LIMIT
gasPrice = process.env.GAS_PRICE

module.exports = {
  networks: {
    testnet: {
      network_id: '2', // Any network (default: none)
      provider: () => {
        const truffleProvider = new TruffleProvider(
          testnet_0_url,
          { memonic: account_1_mnemonic },
          { shardID: 0, chainId: 2 },
          { gasLimit: gasLimit, gasPrice: gasPrice }
        );
        const newAcc = truffleProvider.addByPrivateKey(account_1_private_key);
        truffleProvider.setSigner(newAcc);
        return truffleProvider;
      },
      skipDryRun: true,
    },

    mainnet: {
      network_id: '1', // Any network (default: none)
      provider: () => {
        const truffleProvider = new TruffleProvider(
          mainnet_0_url,
          { memonic: account_1_mnemonic },
          { shardID: 0, chainId: 1 },
          { gasLimit: gasLimit, gasPrice: gasPrice },
        );
        const newAcc = truffleProvider.addByPrivateKey(mainnet_private_key);
        truffleProvider.setSigner(newAcc);
        return truffleProvider;
      },
      skipDryRun: true,
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
    }
  }
}