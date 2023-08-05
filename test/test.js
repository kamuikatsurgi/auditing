const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Exploits", function () {
  it("Struct exploit", async function () {
    const structbug = await ethers.getContractFactory("StructBug");
    const contract = await structbug.deploy();
    await contract.setObject(1, 1, 1);
    await contract.deleteObejct(1);
    expect(await contract.readObject(1, 1)).to.equal(1);
  });

  it("Delegate call", async function () {
    const testcontract = await ethers.getContractFactory("TestDelegateCall");
    const test = await testcontract.deploy();
    const maincontract = await ethers.getContractFactory("DelegateCall");
    const main = await maincontract.deploy();
    await main.setVariables(test.target, 100);

    expect(await main.num()).to.equal(200);
  });

  it("Unsafe Delegate call", async function () {
    const libraryContract = await ethers.getContractFactory("Library");
    const lib = await libraryContract.deploy();
    const hackme = await ethers.getContractFactory("HackMe");
    const HackMe = await hackme.deploy(lib.target);
    const attackContract = await ethers.getContractFactory("AttackContract");
    const Attack = await attackContract.deploy(HackMe.target);
    await Attack.attack();

    expect(await HackMe.owner()).to.equal(Attack.target);
  });

  it("Denial of Service", async function () {
    const [acc1, acc2] = await ethers.getSigners();
    const BecomeKing = await ethers.getContractFactory("BecomeKing");
    const DOS = await BecomeKing.deploy();
    const DOSAttack = await ethers.getContractFactory("DOSAttack");
    const attack = await DOSAttack.deploy();
    await attack.attack(DOS.target, { from: acc1, value: 100000000 });
    try {
      await attack.attack(DOS.target, { from: acc1, value: 2000000000 });
    } catch (error) {}
  });
});
