// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract DoctorAI {
    address payable public doctorAI;
    mapping(address => uint256) public donations;
    address[] public donators;

    event PaymentReceived(address indexed from, uint256 amount);
    event DonationReceived(address indexed from, uint256 amount);

    constructor(address payable _doctorAI) {
        require(_doctorAI != address(0), "Invalid address");
        doctorAI = _doctorAI;
    }

    function pay() external payable {
        require(msg.value > 0, "Must send ETH to pay");
        doctorAI.transfer(msg.value);
        emit PaymentReceived(msg.sender, msg.value);
    }

    function donate() external payable {
        require(msg.value > 0, "Must send ETH to donate");
        if (donations[msg.sender] == 0) {
            donators.push(msg.sender);
        }
        donations[msg.sender] += msg.value;
        doctorAI.transfer(msg.value);
        emit DonationReceived(msg.sender, msg.value);
    }

    function getDonators() external view returns (address[] memory) {
        return donators;
    }

    function updateDoctorAI(address payable _newDoctorAI) external {
        require(msg.sender == doctorAI, "Only the current project wallet can update the address");
        require(_newDoctorAI != address(0), "Invalid new project wallet address");
        doctorAI = _newDoctorAI;
    }
}

