const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("ERC20Token", function () {
  let token;

  beforeEach(async () => {
    token = await ethers.deployContract("ERC20Token", ["DevToken", "DToken"]);
  });

  it("Total supply should be 10000000", async function () {
    expect(await token.totalSupply()).to.equal("10000000000000000000000000");
  });

  it("Owner's balance should be 10000000", async function () {
    const [owner] = await ethers.getSigners();
    expect(await token.balanceOf(owner)).to.equal("10000000000000000000000000");
  });

  it("Sending token should be success", async function () {
    const [owner, address1] = await ethers.getSigners();

    await token.transfer(address1, 50);

    expect(await token.balanceOf(address1)).to.equal(50);
  });

  it("Mint from owner address should be success", async function () {
    const [owner] = await ethers.getSigners();

    await token.mint(50);

    expect(await token.balanceOf(owner)).to.equal("10000000000000000000000050");
  });

  it("Mint from general address should be failed", async function () {
    const [_, address1] = await ethers.getSigners();

    await expect(token.connect(address1).mint(50)).to.be.revertedWith(
      "Ownable: caller is not the owner"
    );
  });

  it("Burn from owner address should be success", async function () {
    const [owner] = await ethers.getSigners();

    await token.burn(50);

    expect(await token.balanceOf(owner)).to.equal("9999999999999999999999950");
  });

  it("Burn from general address should be failed", async function () {
    const [_, address1] = await ethers.getSigners();

    await expect(token.connect(address1).burn(50)).to.be.revertedWith(
      "Ownable: caller is not the owner"
    );
  });

  it("Pause from owner should be success", async function () {
    const [owner] = await ethers.getSigners();

    await token.pause();

    await token.mint(50);

    expect(await token.balanceOf(owner)).to.equal("10000000000000000000000050");
  });

  it("Pause from general address should be failed", async function () {
    const [_, address1] = await ethers.getSigners();

    await expect(token.connect(address1).pause()).to.be.revertedWith(
      "Ownable: caller is not the owner"
    );
  });
});
