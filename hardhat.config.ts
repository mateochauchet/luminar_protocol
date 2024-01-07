import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'dotenv/config';

const config: HardhatUserConfig = {
  solidity: "0.8.9",

  networks: {
    sepolia: {
      url: process.env.ETHEREUM_SEPOLIA_TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY || '']
    }
  },

  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },

  paths: {
    artifacts: './artifacts',
    cache: './cache',
    sources: './contracts',
    tests: './test'
  }
};

export default config;
