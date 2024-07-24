// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IStudentManager {
    // Event for when a student is added
    event StudentAdded(string name, uint256 point, bool isActive);

    // Event for when points are decreased
    event PointsDecreased(uint256 amount);

    // Event for when a deposit is made
    event Deposit(address indexed depositor, uint256 amount);

    // Event for when a deposit status is changed
    event DepositStatusChanged(uint256 index, DepositStatus status);

    // Function to add a new student
    function addStudent(string memory _name, uint256 _point) external;

    // Function to add points to a student
    function addPoints(uint256 studentIndex, uint256 amount) external;

    // Function to decrease points from a student
    function decreasePoints(uint256 studentIndex, uint256 amount) external;

    // Function to check a student's points
    function checkPoints(uint256 studentIndex) external view returns (uint256);

    // Function to check how many students have points greater than 100
    function checkStudents() external view returns (uint256);

    // Function to deposit funds
    function deposit() external payable;

    // Function to approve a deposit
    function approveDeposit(uint256 index) external;

    // Function to reject a deposit
    function rejectDeposit(uint256 index) external;

    // Function to get deposit history
    function getDepositHistory() external view returns (DepositRecord[] memory);
}
