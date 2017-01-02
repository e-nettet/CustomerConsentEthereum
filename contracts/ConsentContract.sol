pragma solidity ^0.4.6;

contract ConsentContract {
  address public organizer;
  uint public funds;
  bool public customerConsent;

  function ConsentContract() payable {
    organizer = msg.sender;
    funds = msg.value;
    customerConsent = false;
  }

  function addFunds() payable public returns (bool success) {
    funds = msg.value;
    return true;
  }

  function approve() public returns (bool success) {
    customerConsent = true;
    return msg.sender.send(1);
  }

  function reject() public returns (bool success) {
    customerConsent = false;
    return msg.sender.send(1);
  }

  function destroy() {
    if (msg.sender == organizer) {
      suicide(organizer);
    }
  }
}
