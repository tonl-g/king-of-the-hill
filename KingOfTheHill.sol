// SPDX-License-Identifier: MIT

// Pragma statements
pragma solidity ^0.8.0;

// Import statements
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

// Contract
contract KingOfTheHill {
// Library usage
using Address for address payable;

// State variables
address private _firstOwner; // 1er owner et 1ere mise
address private _lastOwner; // winner
address private _owner;
uint256 private _turn; // 1 tour de jeu
uint256 private _percentageFirstOwner; // 10%
uint256 private _percentageLastOwner; // 80%
bool private _endTurn; // fin du tour de jeu

// Events
event SendPot(address indexed sender, uint256 value);

/** constructor */
constructor(address firstOwner_, uint256 delay_) payable firstBet {
    /** Only firstOwner can bet at beggining
      * delay => 1 bloc = 10 secondes
      */
        _firstOwner = firstOwner_;
        _turn = block.number + delay_ * (1 * 10);
    }
    
// Function modifiers

modifier firstBet() { 
    require(msg.value == 1e18, "KingOfTheHill: Start game cost 1 wei!"); // 1 wei
    _;
  }
  
modifier onlyFirstOwner() {
        require(msg.sender == _firstOwner, "KingOfTheHill: Only firstowner can recuperate 10%!");
        _;
    }
    
modifier onlyLastOwner() {
        require(msg.sender == _lastOwner, "KingOfTheHill: Only lastowner can recuperate 80%!");
        _;
    }
  
modifier onlyOwner() {
        require(msg.sender == _owner, "KingOfTheHill: Only owner can play!");
        _;
    }
    
modifier notOwner() {
        require(msg.sender != _owner, "KingOfTheHill: You are not allowed to use this functionality!");
        _;
    }
  
// Functions
function pot() external payable {
        emit SendPot(msg.sender, msg.value);
    }
    
    receive() external payable {
        emit SendPot(msg.sender, msg.value);
    }
    
function game() public payable onlyOwner {
    require(msg.value >= address(this).balance * 2, "KingOfTheHill: Bet *2 the previous bet!");
    }
    
function endTurn() public payable {
    require(_turn >= block.number, "KingOfTheHill: End game, please waiting a new player restarts game!");
    payable(msg.sender).sendValue(address(this).balance);
    _endTurn = true;
    }
    
function setPercentage10(uint256 percentageFirstOwner_) public payable onlyFirstOwner {
        require(
            _percentageFirstOwner >= 0 && _percentageFirstOwner == 10, "KingOfTheHill: Only 10%!");
            _percentageFirstOwner = percentageFirstOwner_;
            uint256 potOwner10 = percentageFirstOwner_;
            payable(msg.sender).sendValue(potOwner10);
    }
    
function setPercentage80(uint256 percentageLastOwner_) public payable onlyLastOwner {
        require(_percentageLastOwner >= 0 && _percentageLastOwner == 80, "KingOfTheHill: Only 80%!");
        _percentageLastOwner = percentageLastOwner_;
        uint256 potOwner80 = percentageLastOwner_;
        payable(msg.sender).sendValue(potOwner80);
    }
    
function viewPot() public view notOwner returns (uint256) {
        return address(this).balance;
    }
    
}



