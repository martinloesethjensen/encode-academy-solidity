const { expect } = require("chai");
const { ethers } = require("hardhat");

let VolcanoCoin;
let volcanoCoin;
let owner;
let addr1;
let addr2;
let addrs;

beforeEach(async function () {
  VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
  [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

  volcanoCoin = await VolcanoCoin.deploy();
});

describe("VolcanoCoin", function () {
  it("Should mint 10000 coins", async function () {
    expect(await volcanoCoin.totalSupply()).to.equal(10000);
  });

  it("Should have 0 coins", async function () {
    expect(await volcanoCoin.balanceOf("0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2")).to.equal(0);
  });

  it("Onwer has a balance of 10000", async function () {
    const ownerBalance = await volcanoCoin.balanceOf(owner.address);
    expect(ownerBalance, 10000);
  });
});
