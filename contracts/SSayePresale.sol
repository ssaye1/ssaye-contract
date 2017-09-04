pragma solidity ^0.4.12;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';

contract SSayePresale is Pausable {
  using SafeMath for uint;
  uint constant totalPresaleSupply = 5000000;

  address ssayeTokenFactory;
  uint totalUsedTokens;
  mapping(address => uint) balances;

  address[] purchasers;

  uint startBlock;
  uint endBlock;

  uint constant PRESALE_PRICE = 0.004 ether; //assuming 1 ETH = 250 USD

  function SSayePresale(address _ssayeTokenFactory,uint _startBlock,uint _endBlock) {
    require(_ssayeTokenFactory != address(0));
    require(_endBlock >= _startBlock);

    startBlock = _startBlock;
    endBlock = _endBlock;
    ssayeTokenFactory = _ssayeTokenFactory;
    totalUsedTokens = 0;
  }

  function () external whenNotPaused payable {
    require(block.number >= startBlock);
    require(block.number <= endBlock);
    require(totalUsedTokens < totalPresaleSupply);
    require(msg.value >= PRESALE_PRICE);

    uint numTokens = msg.value.div(PRESALE_PRICE);
    if(numTokens < 1) revert();

    uint temp = 0;
    uint discountTokens = 0;
    uint multiples = numTokens.div(1000);

    /*
    if(numTokens >= 1000) {
      discountTokens = numTokens.mul(15);
      discountTokens = discountTokens.div(100);
    }
    */
    
    if(multiples > 1 && numTokens < 10000) {
      temp = numTokens.sub(1000);
      temp = temp.div(1000);
      temp = multiples.sub(temp);
      if(temp >= 1) {
        temp = temp.mul(2000);
        temp = temp.div(100);
        discountTokens = discountTokens.add(temp);
      }
    }

    temp = temp.div(100);
    if(multiples > 10 && numTokens < 50000) {
      temp = numTokens.sub(10000);
      temp = multiples.sub(temp);
      if(temp >= 1) {
        temp = temp.mul(3000);
        temp = temp.div(100);
        discountTokens = discountTokens.add(temp);
      }
    }

    if(numTokens > 50000) {
      temp = numTokens.sub(50000);
      temp = temp.div(100);
      temp = multiples.sub(temp);
      if(temp >= 1) {
        temp = temp.mul(5000);
        temp = temp.div(100);
        discountTokens = discountTokens.add(temp);
      }
    }

    numTokens = numTokens.add(discountTokens);

    totalUsedTokens = totalUsedTokens.add(numTokens);
    if (totalUsedTokens > totalPresaleSupply) revert();

    //transfer money to ssayeTokenFactory MultisigWallet
    ssayeTokenFactory.transfer(msg.value);

    purchasers.push(msg.sender);
    balances[msg.sender] = balances[msg.sender].add(numTokens);
  }

  function getTotalPresaleSupply() external constant returns (uint256) {
    return totalPresaleSupply;
  }

  //@notice Function reports the number of tokens available for sale
  function numberOfTokensLeft() constant returns (uint256) {
    uint tokensAvailableForSale = totalPresaleSupply.sub(totalUsedTokens);
    return tokensAvailableForSale;
  }

  function finalize() external whenNotPaused onlyOwner {
    if(block.number < endBlock && totalUsedTokens < totalPresaleSupply) revert();

    ssayeTokenFactory.transfer(this.balance);
    paused = true;
  }

  function balanceOf(address owner) constant returns (uint) {
    return balances[owner];
  }

  function getPurchasers() onlyOwner whenPaused external returns (address[]) {
    return purchasers;
  }

  function numOfPurchasers() onlyOwner external constant returns (uint) {
    return purchasers.length;
  }

  function unpause(uint _startBlock,uint _endBlock) onlyOwner whenPaused returns (bool) {
    startBlock = _startBlock;
    endBlock = _endBlock;
    super.unpause();
  }

  function destroyContract() external onlyOwner {
      selfdestruct(ssayeTokenFactory);
  }
}
