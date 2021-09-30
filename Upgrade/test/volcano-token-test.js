const { expect } = require("chai");
const { ethers } = require("hardhat");

let VolcanoToken;
let volcanoToken;
let owner;
let addr1;
let addr2;
let addrs;

beforeEach(async function () {
  VolcanoToken = await ethers.getContractFactory("VolcanoToken");
  [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

  volcanoToken = await VolcanoToken.deploy();
});

describe("VolcanoToken", function () {
  it("Should mint", async function () {
    let oldBalance = await volcanoToken.balanceOf(addr1.address);

    console.log(await volcanoToken.getCurrentTokenId());

    expect(await volcanoToken.getCurrentTokenId()).to.equal(0);
    
    await volcanoToken.connect(addr1).mint("TOKEN");
    
    expect(await volcanoToken.balanceOf(addr1.address)).to.not.equal(oldBalance)
    expect(await volcanoToken.getCurrentTokenId()).to.equal(1);
  });

});
