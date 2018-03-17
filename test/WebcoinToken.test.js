import decodeLogs from './helpers/decodeLogs';
const WebcoinToken = artifacts.require('WebcoinToken');

contract('WebcoinToken', accounts => {
  let token;
  const totalSupplyCap = "70000000000000000000000000"; // 70M * 10**18 wei

  beforeEach(async function () {
    token = await WebcoinToken.new(totalSupplyCap, accounts);
  });

  it('has a name Webcoin', async function () {
    const name = await token.name();
    assert.equal(name, 'Webcoin');
  });

  it('has a symbol WEB', async function () {
    const symbol = await token.symbol();
    assert.equal(symbol, 'WEB');
  });

  it('has 18 decimals', async function () {
    const decimals = await token.decimals();
    assert(decimals.eq(18));
  });

  it('total supply is 45M', async function () {
    const totalSupply = await token.totalSupply();
    assert(totalSupply.eq("45000000000000000000000000"));
  });

  it('total supply cap is 70M', async function () {
    const totalSupplyCap = await token.cap();
    assert(totalSupplyCap.eq(totalSupplyCap));
  });

  it('tokens assigned according to distribution 5M/15M/10M/10M/2M/2M/1M', async function () {
    const teamBalance = await token.balanceOf(accounts[0]);
    assert(teamBalance.eq("5000000000000000000000000"));
    const miningBalance = await token.balanceOf(accounts[1]);
    assert(miningBalance.eq("15000000000000000000000000"));
    const marketingBalance = await token.balanceOf(accounts[2]);
    assert(marketingBalance.eq("10000000000000000000000000"));
    const developmentBalance = await token.balanceOf(accounts[3]);
    assert(developmentBalance.eq("10000000000000000000000000"));
    const functionalCostsBalance = await token.balanceOf(accounts[4]);
    assert(functionalCostsBalance.eq("2000000000000000000000000"));
    const legalBalance = await token.balanceOf(accounts[5]);
    assert(legalBalance.eq("2000000000000000000000000"));
    const earlyAdoptersBalance = await token.balanceOf(accounts[6]);
    assert(earlyAdoptersBalance.eq("1000000000000000000000000"));
  });
});
