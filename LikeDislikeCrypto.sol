// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract ERC20Token {
    string public constant name = "LikeDislikeCrypto";
    string public constant symbol = "LDCrypto";
    uint8 public constant decimals = 18;  

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 totalSupply_;
    address public owner;

    using SafeMath for uint256;

    constructor(uint256 total) {
        totalSupply_ = total * (10 ** uint256(decimals));
        balances[msg.sender] = totalSupply_;
        owner = msg.sender;
    }  

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address tokenOwner, address delegate) public view returns (uint) {
        return allowed[tokenOwner][delegate];
    }

    function transferFrom(address tokenOwner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[tokenOwner]);    
        require(numTokens <= allowed[tokenOwner][msg.sender]);
    
        balances[tokenOwner] = balances[tokenOwner].sub(numTokens);
        allowed[tokenOwner][msg.sender] = allowed[tokenOwner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(tokenOwner, buyer, numTokens);
        return true;
    }
    
    function renounceOwnership() public {
        require(msg.sender == owner, "Only the contract owner can renounce ownership");
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}

library SafeMath { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
