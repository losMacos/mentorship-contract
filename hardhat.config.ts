import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const fs = require('fs');
const privateKey = fs.readFileSync(".secret").toString().trim() || "01234567890123456789"

const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";


const config: HardhatUserConfig = {
  solidity: "0.8.11",
  networks: {
    hardhat: {
      gas: 2100000,
      gasPrice: 8000000000
    },
  
    goerli: {
      url: `https://goerli.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    },
    matic: {
      url: `https://polygon-mainnet.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey:'2D134SPWU6WE6M7VXZUX4PWSSSUI9EKFUE'
  },
};

export default config;
