pragma solidity ^0.4.23;

import "./ownable.sol";
import "./standardtoken.sol";

contract Split is Ownable {

  //exchange token by owner
  StandardToken public prev;
  StandardToken public next;
  uint256 public rate;

  event NewSplit(address, address, uint256);
  event Receive(address, uint256);

  using SafeMath for uint256;

  constructor(
    address _from,
    address _to,
    uint256 _rate
  ) public {
    prev = StandardToken(_from);
    next = StandardToken(_to);
    rate = _rate;
  }

  function setSplit(address _from, address _to, uint _rate) onlyOwner public {
    prev = StandardToken(_from);
    next = StandardToken(_to);
    rate = _rate;

    emit NewSplit(_from, _to, _rate);
  }

  function approvalRemain() public constant returns (uint256){
    return next.allowance(owner,this);
  }

  function giveAndReceive() public returns (bool done) {
    uint256 balance = prev.balanceOf(msg.sender);
    bool success = prev.burnFrom(msg.sender, balance); //burn previous token balance of msg.sender
    require(success);
    next.transferFrom(owner, msg.sender, balance.mul(rate));  //receive token from contract owner
    emit Receive(msg.sender,balance);
    return true;
  }
}
