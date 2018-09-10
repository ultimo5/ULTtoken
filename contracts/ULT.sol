pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol";

/**
 * @title Ultimo5 token
 *
 * @dev Implementation of the Ultimo5 token 
 */
contract Ultimo5Token is Ownable, StandardBurnableToken, MintableToken, PausableToken {

    string public name = "Ultimo5 Token";
    string public symbol = "ULT";
    uint8 public decimals = 18;
    uint public INITIAL_SUPPLY = 100000000000000000000000000;

    // Frozen account
    mapping (address => bool) public frozenAccount;

    event Freeze(address target, bool freezed);
    event UnFreeze(address target, bool freezed);

    /**
     * @dev constructor for Ultimo5Token
     */
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     */
    function () external payable {
        revert();
    }

    /**
     * @dev Function to freeze address
     * @param _target The address that will be freezed.
     */
    function freezeAccount(address _target) onlyOwner public {
        require(_target != address(0));
        require(_target != address(this));
        require(frozenAccount[_target] == false);
        frozenAccount[_target] = true;
        emit Freeze(_target, frozenAccount[_target]);
    }

    /**
     * @dev Function to unfreeze address
     * @param _target The address that will be unfreezed.
     */
    function unFreezeAccount(address _target) onlyOwner public {
        require(_target != address(0));
        require(_target != address(this));
        require(frozenAccount[_target] == true);
        frozenAccount[_target] = false;
        emit UnFreeze(_target, frozenAccount[_target]);
    }

    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(!frozenAccount[msg.sender]);        // Check if sender is frozen
        require(!frozenAccount[_to]);               // Check if recipient is frozen
        require(_to!=address(this));                // Check if _to is contract address
        return super.transfer(_to,_value);
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(!frozenAccount[msg.sender]);        // Check if approved is frozen
        require(!frozenAccount[_from]);             // Check if sender is frozen
        require(!frozenAccount[_to]);               // Check if recipient is frozen
        require(_to!=address(this));                // Check if _to is contract address
        return super.transferFrom(_from, _to, _value);
    }
}