# Webcoin ERC20 

npm install -g truffle truffle-flattener
git clone ssh://git@bitbucket.3zinventions.com:7999/cryp/webcoin.git
cd webcoin
npm init -y
npm install --save-dev zeppelin-solidity truffle-hdwallet-provider
truffle compile
truffle migrate
truffle test
truffle-flattener contracts/WebcoinToken.sol >> deploy/WebcoinToken.sol

