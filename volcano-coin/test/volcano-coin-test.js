const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VolcanoCoin", function () {
  it("Should mint 10000 coins", async function () {
    const VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
    const volcanoCoin = await VolcanoCoin.deploy();
    await volcanoCoin.deployed();

    expect(await volcanoCoin.totalSupply()).to.equal(10000);
  })
});
