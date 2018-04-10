pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import 'zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import "./WebcoinToken.sol";
import "./Vault.sol";

/**
 * @title SampleCrowdsale
 * CappedCrowdsale - sets a max boundary for raised funds
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract WebcoinCrowdsale is CappedCrowdsale, TimedCrowdsale, FinalizableCrowdsale, Pausable {
  Vault public vaultWallet;
  WebcoinToken token;
  address[] wallets;
  uint256[] rates;
  uint256 public softCap;
  uint256 public initialSupply = 0;
  
  function WebcoinCrowdsale(uint256 _openingTime, uint256 _closingTime, uint256[] _rates, uint256 _softCap, uint256 _cap, address _vaultAddress, address[] _wallets, ERC20 _token) public
    CappedCrowdsale(_cap)
    TimedCrowdsale(_openingTime, _closingTime)
    FinalizableCrowdsale()
    Crowdsale(_rates[0], _wallets[0], _token) 
    {
        require(_softCap > 0);
        require(_wallets[1] != address(0) && _wallets[2] != address(0) && _wallets[3] != address(0) && _vaultAddress != address(0));
        require(_rates[1] > 0 && _rates[2] > 0 && _rates[3] > 0 && _rates[4] > 0 && _rates[5] > 0 && _rates[6] > 0 && _rates[7] > 0);
        wallets = _wallets;
        vaultWallet = Vault(_vaultAddress);
        rates = _rates;
        token = WebcoinToken(_token);
        softCap = _softCap;
        initialSupply = token.totalSupply();
    }
  
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    require(_weiAmount <= 1000 ether);
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }
  
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    token.mint(_beneficiary, _tokenAmount);
  }
  
  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
    uint256 crowdsaleSupply = token.totalSupply().sub(initialSupply);
    uint256 mil = (10**6) * 1 ether;
    if (crowdsaleSupply >= mil.mul(2) && crowdsaleSupply < mil.mul(5)) {
      rate = rates[1];
    } else if (crowdsaleSupply >= mil.mul(5) && crowdsaleSupply < mil.mul(11)) {
      rate = rates[2];
    } else if (crowdsaleSupply >= mil.mul(11) && crowdsaleSupply < mil.mul(16)) {
      rate = rates[3];
    } else if (crowdsaleSupply >= mil.mul(16) && crowdsaleSupply < mil.mul(20)) {
      rate = rates[4];
    } else if (crowdsaleSupply >= mil.mul(20) && crowdsaleSupply < mil.mul(22)) {
      rate = rates[5];
    } else if (crowdsaleSupply >= mil.mul(22) && crowdsaleSupply < mil.mul(24)) {
      rate = rates[6];
    } else if (crowdsaleSupply >= mil.mul(24)) {
      rate = rates[7];
    }
  }
  
  function ceil(uint256 a, uint256 m) private pure returns (uint256) {
    return ((a + m - 1) / m) * m;
  }
  
  function _forwardFunds() internal {
    if (softCapReached()) {
        uint256 totalInvestment = msg.value;
        uint256 miningFund = totalInvestment.mul(10).div(100);
        uint256 teamFund = totalInvestment.mul(15).div(100);
        uint256 devFund = totalInvestment.mul(35).div(100);
        uint256 marketingFund = totalInvestment.mul(40).div(100);
        require(wallets[0].send(miningFund) && wallets[1].send(teamFund) && wallets[2].send(devFund) && wallets[3].send(marketingFund));
    } else {
        require(vaultWallet.sendFunds.value(msg.value)());
    }
  }
  
  function softCapReached() public view returns (bool) {
    return weiRaised > softCap;
  }
  
  function capReached() public view returns (bool) {
    return ceil(token.totalSupply(),1 ether).sub(initialSupply) >= cap;
  }
  
  function hasClosed() public view returns (bool) {
    return capReached() || super.hasClosed(); 
  }
  
  function pause() onlyOwner whenNotPaused public {
    token.transferOwnership(owner);
    super.pause();
  }
  
  function finalization() internal {
    token.finishMinting();
    token.transferOwnership(owner);  
  }
}