# EnhancedPayPool

EnhancedPayPool is a decentralized application designed to manage student points and deposits with advanced features. This project leverages Solidity's struct and enum capabilities to organize data and manage states, ensuring a secure and efficient contract.

## Key Features

- **Student Management**: Add and manage student records, including points and active status.
- **Deposit Management**: Record and manage deposits with timestamps and statuses.
- **Enhanced Security**: Only the contract owner (teacher) can modify student records and approve or reject deposits.

## Smart Contract Overview

### Structs

- **Student**: 
  - `name` (string): The name of the student.
  - `point` (uint256): The student's score.
  - `isActive` (bool): Indicates if the student account is active.

- **DepositRecord**: 
  - `depositor` (address): The address of the depositor.
  - `amount` (uint256): The amount deposited.
  - `timestamp` (uint256): The time when the deposit was made.
  - `status` (DepositStatus): The status of the deposit (Pending, Approved, Rejected).

### Enums

- **DepositStatus**: 
  - `Pending`: The deposit is awaiting approval.
  - `Approved`: The deposit has been approved.
  - `Rejected`: The deposit has been rejected.

### Functions

- **Student Management**:
  - `addStudent(string memory _name, uint256 _point)`: Adds a new student to the list, ensuring no more than 10 students are enrolled.
  - `addPoints(uint256 studentIndex, uint256 amount)`: Adds points to a student.
  - `decreasePoints(uint256 studentIndex, uint256 amount)`: Decreases points from a student, ensuring the points do not go below zero.
  - `checkPoints(uint256 studentIndex)`: Returns the points of a student.
  - `checkStudents()`: Returns the number of students with more than 100 points.

- **Deposit Management**:
  - `deposit()`: Allows deposits from approved addresses, recording the deposit with a timestamp and setting the status to Pending.
  - `approveDeposit(uint256 index)`: Approves a deposit, changing its status to Approved.
  - `rejectDeposit(uint256 index)`: Rejects a deposit, changing its status to Rejected.
  - `getDepositHistory()`: Returns the entire deposit history.

## Deployment

This contract has been deployed on the Scroll Sepolia testnet. You can find the deployed contract address and further interaction details below.

## Usage

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/your-github-username/EnhancedPayPool.git
    cd EnhancedPayPool
    ```

2. **Compile and Deploy**:
    - Use Remix IDE or any Ethereum development framework like Truffle or Hardhat to compile and deploy the contract.

3. **Interact with the Contract**:
    - Use the provided functions to add students, manage deposits, and more. Make sure to use an account with owner privileges for restricted functions.

## License

This project is licensed under the MIT License.


