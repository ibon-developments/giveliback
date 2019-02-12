pragma solidity ^0.5.1;


contract Base {
  /// @title Base
  /// @author CryptoZombies + Esteve Serra Clavera
  /// @notice Basic contract ownership plus standard functions such as timestamp and error logging
  address public owner;
  using SafeMath for uint256;

  // **** EVENTS
  // @notice Error log
  event Error(string _error);
  // @notice Contract ownership change
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  ///@notice Preventing sending to 0x0 address or to contract's address
  modifier validDestinationAddress( address to ) {
      require(to != address(0));
      require(to != address(this));
      _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner validDestinationAddress(newOwner){
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /// @notice Get the current timestamp from last mined block
  /// @return now is an alias to block.timestamp
  function timestamp() public view returns (uint256) {
    return now;
  }

  /**
   * @dev Notifies the user something went wrong
   * @param _error Message of error to notify
   */
  function throwError(string memory _error) internal  {
    emit Error(_error);
  }


  /**
   * @dev Constructor ensures who is the owner of the contract
   * account.
   */
  constructor() public {
    owner = msg.sender;
    ///@notice Not to end up sending to 0x0
    if(owner == address(0)) throwError('[Base constructor] Owner address is 0x0');
  }

}


/**
 * Commit: 20190117
 * OpenZeppelin
https://github.com/OpenZeppelin/openzeppelin-solidity/commit/b7d60f2f9a849c5c2d59e24062f9c09f3390487a * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
 * @title SafeMath32
 * @dev SafeMath library implemented for uint32
 */
library SafeMath32 {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint32 a, uint32 b) internal pure returns (uint32) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint32 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint32 a, uint32 b) internal pure returns (uint32) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint32 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint32 a, uint32 b) internal pure returns (uint32) {
        require(b <= a);
        uint32 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint32 a, uint32 b) internal pure returns (uint32) {
        uint32 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint32 a, uint32 b) internal pure returns (uint32) {
        require(b != 0);
        return a % b;
    }
}
/**
 * @title SafeMath16
 * @dev SafeMath library implemented for uint16
 */
library SafeMath16 {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint16 a, uint16 b) internal pure returns (uint16) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint16 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint16 a, uint16 b) internal pure returns (uint16) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint16 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint16 a, uint16 b) internal pure returns (uint16) {
        require(b <= a);
        uint16 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint16 a, uint16 b) internal pure returns (uint16) {
        uint16 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint16 a, uint16 b) internal pure returns (uint16) {
        require(b != 0);
        return a % b;
    }
}


library SafeMath64 {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint64 a, uint64 b) internal pure returns (uint64) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint64 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint64 a, uint64 b) internal pure returns (uint64) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint64 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint64 a, uint64 b) internal pure returns (uint64) {
        require(b <= a);
        uint64 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint64 a, uint64 b) internal pure returns (uint64) {
        uint64 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint64 a, uint64 b) internal pure returns (uint64) {
        require(b != 0);
        return a % b;
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
