const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VolcanoCoin", function () {
  it("Should mint 10000 coins", async function () {
    const VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
    const volcanoCoin = await VolcanoCoin.deploy();
    await volcanoCoin.deployed();

    expect(await volcanoCoin.totalSupply()).to.equal(10000);
  });

  // TODO: addresses
});

describe("VolcanoToken", function () {
  it("", async function () {
    const VolcanoToken = await ethers.getContractFactory("VolcanoToken");
    const volcanoToken = await VolcanoToken.deploy();
    await volcanoToken.deployed();

  });
});
