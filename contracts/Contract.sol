// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract DoctorAI {

  // store information about each donation.
  struct Donation {
    address donor; // Address of the person who donated.
    uint256 amount; // Amount of cryptocurrency donated.
  }

  address public doctorAI_address;
  Donation[] public donations;
  uint256 public totalDonations;

  // it's called when the contract is deployed
  // set as the initial DoctorAI address
  constructor(address _doctorAI_address) {
    doctorAI_address = _doctorAI_address;
  }

  // NOTE:
  // msg.value : amount of crypto sent 
  // msg.address : amount of donor's address
  
  function donate() public payable {
    uint256 donationAmount = msg.value; 

    donations.push(Donation(msg.sender, donationAmount));

    totalDonations += donationAmount;

    // send the donated amount to the DoctorAI address
    //
    // payable(address) : converts the address to a payable address for sending funds
    //
    // call{value: amount}("") : calls a (receive) function at the address 
    // with the donation amount and an empty string as data
    //
    // returns a boolean indicating success (sent) and any additional data 
    (bool sent,) = payable(doctorAI_address).call{value: donationAmount}("");

    // checks if the transfer was successfull, or throws an error message
    require(sent, "Failed to send donation to DoctorAI");
  }

  // "public" & "view" : because it doesn't modify the contract state
  // returns a copy of the "donations" array
  function viewDonations() public view returns (Donation[] memory) {
    return donations;
  }

  function getTotalDonations() public view returns (uint256) {
    return totalDonations;
  }

  // update the DoctorAI address
  function updateDoctorAddress(address _newAddress) public {
    doctorAI_address = _newAddress;
  }
}

