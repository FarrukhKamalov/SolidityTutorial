const { expect } = require("chai");
const {ethers} = require("ethers");
const { beforeEach } = require("node:test");
describe("AucEngine", function () {
  let owner
  let buyer
  let auct

  beforeEach
  (async function (params) {
      [owner, buyer] = await ethers.getSigners();
      const AucEngine = await ethers.getContractFactory("AucEngine", owner);
      auct = await AucEngine.deploy()
      await auct.deployed()
  })
});
