pragma solidity ^0.4.23;
import "./Base.sol";

/// @title GiveLibAck | GiveLiBack. A true bond between the analogue and digital world
/// @author ibón (https://ibón.es)
/// @notice This contract manages the creation of items (books), users and the book lending process
/// @dev Based on OpenZeppelin to avoid side effects. Base based on CryptoZombies defines basic authentication for function execution

contract BookShelf is Base{

  //*****
  	using SafeMath for uint256;
    uint public book_id;
    uint public user_id;
//*****
    event NewBook(uint bookId, string name, uint isbn);


  struct Book {
    //string name;//From isbn to get the details of the book from an oracle
    uint64 isbn; //Stripping the dashes from the 13-digit figure
    address holder; //Person to whom the book has been lended to
    uint8 lended_num;
  }

    Book[] public books;

    mapping (uint => address) public bookToOwner;
    mapping (address => uint) ownerBooksCount;

    ///@dev By default, current holder is the msg.sender
    function _createBook(uint32 _isbn) internal ownerOf {
        uint id = zombies.push(Books(_isbn, msg.sender,0)) - 1;
        bookToOwner[id] = msg.sender;
        ownerBookCount[msg.sender]++;
        NewBook(id, _name, _isbn);
    }

    function createBook(uint32 _isbn) public {
        require(ownerBookCount[msg.sender] == 0); //Only for users that have no books
        _createBook(_isbn);
    }

}
