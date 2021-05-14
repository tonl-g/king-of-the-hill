// SPDX-License-Identifier: MIT

// Pragma statements
pragma solidity ^0.8.0;

// Import statements
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
// import "./Ownable.sol";

// Contract
contract KingOfTheHill {

// Library usage
using Address for address payable;

// State variables
mapping(address => uint256) private _balances;
address private _firstOwner;
address private _lastOwner;
address private _owner;
uint256 private _turn;
uint256 currentPot = address(this).balance - msg.value;
uint256 private _percentageFirstOwner;
uint256 private _percentageLastOwner;
bool private _endGame;

// Events
event JointPotting(address indexed sender, uint256 ammount);

/** constructor */
constructor(address firstOwner_, uint256 delay_) payable firstStake {
    /** Only firstOwner can bet at beggining
      * delay => 1 bloc = 10 secondes
      */
        _firstOwner = firstOwner_;
        _turn = block.number + delay_ * (1 * 10);
    }

// Function modifiers
modifier onlyOwner() {
        require(msg.sender == _owner, "KingOfTheHill: Only owner can play!");
        _;
    }
    
modifier notOwner() {
        require(msg.sender != _owner, "KingOfTheHill: You are not allowed to use this functionality!");
        _;
    }
    
modifier firstStake() { 
    require(msg.value == 1e18, "KingOfTheHill: Start game cost 1 wei!"); // 1 wei
    _;
  }

// Functions

function pot(address sender, uint256 amount) external payable firstStake onlyOwner notOwner { // mise en jeu
    _balances[sender] += amount;
    emit JointPotting(sender, amount);
    }
    
    receive() external payable {
    }
    
function game() public payable onlyOwner {
    require(msg.value >= address(this).balance * 2, "KingOfTheHill: Bet *2 the previous bet!");
    _turn += 1;
    }
    
function endGame() public onlyOwner {
    require(_turn >= block.number, "KingOfTheHill: End game, please waiting a new player restarts game!");
    payable(msg.sender).sendValue(address(this).balance);
    _endGame = true;
    _turn = 0;
    _firstOwner += percentageFirstOwner_;
    _lastOwner += percentageLastOwner_;
    }
    
function setPercentage80(uint256 percentageFirstOwner_) public onlyOwner {
        require(
            _percentageFirstOwner >= 0 && _percentageFirstOwner == 80, "KingOfTheHill: Only 80%!");
            _percentageFirstOwner = percentageFirstOwner_;
    }
    
function setPercentage10(uint256 percentageLastOwner_) public onlyOwner {
        require(_percentageLastOwner >= 0 && _percentageLastOwner == 10, "KingOfTheHill: Only 10%!");
        _percentageLastOwner = percentageLastOwner_;
    }
    
function viewPot() public view notOwner returns (uint256) {
        return address(this).balance;
    }

}


