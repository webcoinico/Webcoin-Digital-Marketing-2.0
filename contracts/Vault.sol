pragma solidity ^0.4.18;

interface Vault {
  function sendFunds() payable public returns (bool);
  event Transfer(address beneficiary, uint256 amountWei);
}