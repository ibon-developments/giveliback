pragma solidity ^0.4.23;
import "./Base.sol";

/// @title GiveLibAck | GiveLiBack. A true bond between the analogue and digital world
/// @author ibón (https://ibón.es)
/// @notice This contract manages the creation of items (books), users and the book lending process
/// @dev Based on OpenZeppelin to avoid side effects. Base based on CryptoZombies defines basic authentication for function execution

contract BookShelf is Base{

  	using SafeMath for uint256;
    using SafeMath64 for uint64;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    event NewBook(uint bookId, uint isbn);


  struct Book {
    //string name;//From isbn to get the details of the book from an oracle
    uint64 isbn; //Stripping the dashes from the 13-digit figure
    address creator; //Person who created the book
    uint16 lended_num;
  }

    Book[] public books;

    mapping (uint => address) public bookToOwner;
    mapping (address => uint) ownerBooksCount;
    mapping (uint => address) public bookToBorrower;
    mapping (address => uint) borrowerBooksCount;



    ///@dev By default, current holder is the msg.sender
    function _createBook(uint64 _isbn) internal {
        uint id = books.push(Book(_isbn, msg.sender,0)).sub(1);
        bookToOwner[id] = msg.sender;
        ownerBooksCount[msg.sender] = ownerBooksCount[msg.sender].add(1);
        emit NewBook(id, _isbn);
    }

    function createBook(uint64 _isbn) public {
        require(ownerBooksCount[msg.sender] < 100); //Only for users that have not more than 100 books
        _createBook(_isbn);
    }

}
