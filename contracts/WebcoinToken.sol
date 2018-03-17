pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/CappedToken.sol';

contract WebcoinToken is CappedToken {
	string constant public name = "Webcoin";
	string constant public symbol = "WEB";
	uint8 constant public decimals = 18;
    address private miningWallet;

	function WebcoinToken(uint256 _cap, address[] _wallets) public CappedToken(_cap) {
        require(_wallets[0] != address(0) && _wallets[1] != address(0) && _wallets[2] != address(0) && _wallets[3] != address(0) && _wallets[4] != address(0) && _wallets[5] != address(0) && _wallets[6] != address(0));
        
        uint256 mil = (10**6);
        uint256 teamSupply = mil.mul(5).mul(1 ether);
        uint256 miningSupply = mil.mul(15).mul(1 ether);
        uint256 marketingSupply = mil.mul(10).mul(1 ether);
        uint256 developmentSupply = mil.mul(10).mul(1 ether);
        uint256 legalSupply = mil.mul(2).mul(1 ether);
        uint256 functionalCostsSupply = mil.mul(2).mul(1 ether);
        uint256 earlyAdoptersSupply = mil.mul(1).mul(1 ether);
        miningWallet = _wallets[1];
        mint(_wallets[0], teamSupply);
        mint(_wallets[1], miningSupply);
        mint(_wallets[2], marketingSupply);
        mint(_wallets[3], developmentSupply);
        mint(_wallets[4], legalSupply);
        mint(_wallets[5], functionalCostsSupply);
        mint(_wallets[6], earlyAdoptersSupply);
    }

    function finishMinting() onlyOwner canMint public returns (bool) {
        mint(miningWallet, cap.sub(totalSupply()));
        return super.finishMinting();
    }
}
