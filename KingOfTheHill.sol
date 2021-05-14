// SPDX-License-Identifier: MIT

// Pragma statements
pragma solidity ^0.8.0;

// Import statements
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
import "../Ownable.sol";

// Contract
contract KingOfTheHill is Ownable {

// Library usage
using Address for address payable;

// State variables
address private _firstOwner;
address private _lastOwner;
uint256 private _turn;
uint256 currentPot = address(this).balance - msg.value;

// Events
event JointPotting(address indexed sender, uint256 ammount);

/** constructor */
constructor(address firstOwner_, uint256 delay_) payable firstStake {
    /** Only firstOwner can bet at beggining
      * delay => 1 bloc = 10 secondes
      */
        _turn = block.number + delay_ * (1 * 10);
    }

// Function modifiers
modifier onlyOwner {
        require(msg.sender == _owner, "KingOfTheHill: Only owner can play!");
    }
    
modifier notOwner {
        require(msg.sender != _owner, "KingOfTheHill: You are not allowed to use this functionality!");
        _;
    }
    
modifier firstStake() { 
    require(msg.value = 1e18, "KingOfTheHill: Start game cost 1 wei!"); // 1 wei
    _;
  }

// Functions

function pot() external payable firstStake onlyOwner notOwner { // mise en jeu
    }
    
    receive() external payable {
        emit JointPotting(msg.sender, msg.value);
    }
    
function game(int256 _turn) public onlyOwner {
    require(msg.value >= address(this).balance * 2, "KingOfTheHill: Bet *2 the previous bet!");
    _turn += 1;
    }
    
function endGame() public onlyOwner {
    require(_turn >= block.number, "KingOfTheHill: End game, please waiting a new player restarts game!");
    payable(msg.sender).sendValue(address(this).balance);
    _turn = 0;
    _firstOwner += currentPot * 0.10;
    _lastOwner += currentPot * 0.80;
    }
    
function viewPot() public view notOwner returns (uint256) {
        return address(this).balance;
    }

}


