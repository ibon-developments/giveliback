pragma solidity ^0.4.23;


contract Base {
  /// @title Base
  /// @author CryptoZombies + Esteve Serra Clavera
  /// @notice Basic contract ownership plus standard functions such as timestamp and error logging
  address public owner;
  using SafeMath for uint256;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Constructor ensures who is the owner of the contract
   * account.
   */
  function Base() public {
    owner = msg.sender;
    ///@notice Not to end up sending to 0x0
    if(owner == 0x0) error('[Base constructor] Owner address is 0x0');
  }
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  ///@notice Preventing sending to 0x0 address or to contract's address
  modifier validDestinationAddress( address to ) {
      require(to != address(0x0));
      require(to != address(0)); //Extra
      require(to != address(this));
      _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /// @notice Get the current timestamp from last mined block
  /// @return now is an alias to block.timestamp
  function timestamp() public constant returns (uint256) {
    return now;
  }

  /**
   * @dev Notifies the user something went wrong
   * @param error Message of error to notify
   */
  function error(string _error) internal {
    Error(_error);
  }

  // **** EVENTS
  // @notice Error log
  event Error(string _error);

}


/**
 * Commit: 20180509
 * OpenZeppelin
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @author OpenZeppelin
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * Commit: 20180509
 * OpenZeppelin
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/Math.sol
 * @title Math
 * @author OpenZeppelin
 * @dev Assorted math operations
 */
library Math {
  function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }
}
