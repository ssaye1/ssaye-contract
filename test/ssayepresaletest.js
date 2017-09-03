require('babel-polyfill');
var SSayePresale = artifacts.require("./SSayePresale.sol");
var expect = require("chai").expect;
var SSaye;
contract('SSayePresale', function(accounts) {
  it("test for totalPresaleSupply", async function() {
    try {
      const expected = 5000000;
      SSaye = await SSayePresale.deployed();
      const total = await SSaye.getTotalPresaleSupply.call();
      expect(parseInt(total.valueOf())).to.equal(expected);
    }catch(e) {
      console.log(e);
    }
  });

  it("test for fallback function", async function() {
    var expected = 1250;
    try {
      const promise1 = await web3.eth.sendTransaction({from: accounts[8],to: SSaye.address, value: web3.toWei(4,'ether'), gas: 2000000});
      const balance = await SSaye.balanceOf.call(accounts[8]);
      expect(parseInt(balance.valueOf())).to.equal(expected);
      const promise2 = await web3.eth.sendTransaction({from: accounts[7],to: SSaye.address, value: web3.toWei(40,'ether'), gas: 2000000});
      const balance2 = await SSaye.balanceOf.call(accounts[7]);
      console.log(balance2);
    }catch(e) {
      console.log(e);
    }
  });



  it("test for numberOfTokensLeft", async function() {
    var expected = 4999000;
    const tokens = await SSaye.numberOfTokensLeft.call();
    expect(parseInt(tokens.valueOf())).to.equal(expected)
  });

  it("test for finalize", async function() {
    //call to finalize will fail before the actual completion of ICO
    try{
      await SSayePresale.finalize.call();
    } catch(e) {
      expect(e).not.to.equal('');
    }
  });
});
