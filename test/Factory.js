const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers")
const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Factory", function () {
    it("check the name",async function(){
        //hardhat tests are blank by default, so we need to fetch the contract
        const Factory=await ethers.getContractFactory("Factory")
        //we need to mock deploy
        const factory=await Factory.deploy()
        //check the name
        const name=await factory.name()
        expect(name).to.equal("Factory")
    })
})
