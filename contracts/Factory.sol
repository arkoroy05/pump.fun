// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Token} from "./Token.sol";

contract Factory {
    uint256 public immutable fee;
    address public owner;
    address[] public tokens;
    uint256 public totalTokens;
    mapping(address=>TokenSale) public tokenSales;

    event Created(address token);
    event Buy(address token, uint256 amount);

    struct TokenSale{
        address token;
        string name;
        string symbol;
        uint256 totalSupply;
        uint256 sold;
        uint256 raised;
        bool isOpen;


    }
    constructor(uint256 _fee) {
        fee = _fee;
        owner = msg.sender;
    }

    function create(string memory _name,string memory _symbol,uint256 totalSupply) external payable{
        require(msg.value>=fee,"Not enough fee sent");
        //create a new token
        Token token=new Token(msg.sender,_name,_symbol,totalSupply);
        //storing the token address
        tokens.push(address(token));
        totalTokens++;
        TokenSale memory sale=TokenSale(
            address(token),
            _name,
            _symbol,
            totalSupply,
            0,
            0,
            true
        );
        tokenSales[address(token)]=sale;
        emit Created(address(token));
    }

    function buy(address _token,uint amount) external payable{
        TokenSale storage sale=tokenSales[_token]; //fetches you the struct, and puts inside the sale variable
        //conditions to check if the sale is open
        require(sale.isOpen,"Sale is closed");
        require(sale.totalSupply>=sale.sold+amount,"Not enough tokens left");

        //upddate the sale struct
        sale.sold+=amount;
        sale.raised+=msg.value;
        //transfer the tokens to the buyer
        Token(_token).transfer(msg.sender,amount);
        
        emit Buy(_token,amount);
    }
}
