// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

// Imports
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract EnhancedPayPool is ReentrancyGuard {
    struct Student {
        string name;
        uint256 point;
        bool isActive;
    }

    // Teacher address
    address public teacher;

    // Students array
    Student[] public students;

    // Events
    event StudentAdded(string name, uint256 point, bool isActive);
    event PointsDecreased(uint256 amount);

    // Constructor to set the deployer as the teacher
    constructor() {
        teacher = msg.sender;
    }

    // Modifier to allow only the teacher to make changes
    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only the teacher can perform this action");
        _;
    }

    // Function to add a new student with error handling
    function addStudent(string memory _name, uint256 _point) public onlyTeacher {
        if (students.length >= 10) {
            revert("No more than 10 students can be enrolled");
        } else {
            students.push(Student(_name, _point, true));
            emit StudentAdded(_name, _point, true);
        }
    }

    // Function to decrease points from a student with error handling
    function decreasePoints(uint256 studentIndex, uint256 amount) public onlyTeacher {
        require(students[studentIndex].point >= amount, "Insufficient points to decrease");
        students[studentIndex].point -= amount;
        emit PointsDecreased(amount);
    }

    // Function to check a student's points
    function checkPoints(uint256 studentIndex) public view returns (uint256) {
        return students[studentIndex].point;
    }

    // Function to check how many students have points greater than 100
    function checkStudents() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].point > 100) {
                count++;
            }
        }
        return count;
    }

    struct DepositRecord {
        address depositor;
        uint256 amount;
        uint256 timestamp;
        DepositStatus status;
    }

    enum DepositStatus {
        Pending,
        Approved,
        Rejected
    }

    DepositRecord[] public depositHistory;

    event Deposit(address indexed depositor, uint256 amount);
    event DepositStatusChanged(uint256 index, DepositStatus status);

    address public owner;
    uint public totalBalance;
    address[] public depositAddresses;
    mapping(address => uint256) public allowances;

    modifier isOwner() {
        require(msg.sender == owner, "Not owner!");
        _;
    }

    modifier gotAllowance(address user) {
        require(hasAllowance(user), "This address has no allowance");
        _;
    }

    modifier canDepositTokens(address depositor) {
        require(canDeposit(depositor), "This address is not allowed to deposit tokens");
        _;
    }

    constructor() payable {
        totalBalance = msg.value;
        owner = msg.sender;
    }

    function hasAllowance(address user) internal view returns (bool) {
        return allowances[user] > 0;
    }

    function canDeposit(address depositor) internal view returns (bool) {
        for (uint i = 0; i < depositAddresses.length; i++) {
            if (depositAddresses[i] == depositor) {
                return true;
            }
        }
        return false;
    }

    function addDepositAddress(address depositor) external isOwner {
        depositAddresses.push(depositor);
        emit AddressAdded(depositor);
    }

    function removeDepositAddress(uint index) external isOwner canDepositTokens(depositAddresses[index]) {
        depositAddresses[index] = address(0);
        emit AddressRemoved(depositAddresses[index]);
    }

    function deposit() external canDepositTokens(msg.sender) payable {
        totalBalance += msg.value;
        depositHistory.push(DepositRecord({
            depositor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp,
            status: DepositStatus.Pending
        }));
        emit Deposit(msg.sender, msg.value);
    }

    function approveDeposit(uint256 index) external isOwner {
        require(index < depositHistory.length, "Invalid index");
        depositHistory[index].status = DepositStatus.Approved;
        emit DepositStatusChanged(index, DepositStatus.Approved);
    }

    function rejectDeposit(uint256 index) external isOwner {
        require(index < depositHistory.length, "Invalid index");
        depositHistory[index].status = DepositStatus.Rejected;
        emit DepositStatusChanged(index, DepositStatus.Rejected);
    }

    function getDepositHistory() public view returns (DepositRecord[] memory) {
        return depositHistory;
    }

    function retrieveBalance() external isOwner nonReentrant {
        uint balance = totalBalance;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
        totalBalance = 0;
        emit FundsRetrieved(owner, balance);
    }

    function giveAllowance(uint amount, address user) external isOwner {
        require(totalBalance >= amount, "There are not enough tokens inside the pool to give allowance");
        allowances[user] = amount;
        unchecked {
            totalBalance -= amount;
        }
        emit AllowanceGranted(user, amount);
    }

    function removeAllowance(address user) external isOwner gotAllowance(user) {
        allowances[user] = 0;
        emit AllowanceRemoved(user);
    }

    function allowRetrieval() external gotAllowance(msg.sender) nonReentrant {
        uint amount = allowances[msg.sender];
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Retrieval failed");
        allowances[msg.sender] = 0;
        emit FundsRetrieved(msg.sender, amount);
    }
}
