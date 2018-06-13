pragma solidity ^0.4.23;
import "./BookShelf.sol";


contract GiveLibAck is BookShelf {

  uint lendingFee = 0.001 ether;

  modifier ownerOf (uint _bookId){
    require(msg.sender == booksToOwner[_bookId]);
    _;
  }

  ///@notice Ability to modify the amount for lending books
  function setLendingFee (uint _fee) external onlyOwner{
    lendingFee = _fee;
  }

  ///@author CryptoZombies
  function getBooksByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerBooksCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < books.length; i++) {
      if (bookToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;

    ///@dev Requires the book to be of the current user and that the  current holder is the user
    function lendBook(uint _bookId) internal ownerOf(_bookId){
      require(msg.sender == books[holder]);
      books[_bookId].holder = msg.sender;
      //Change the book's holder
    }


    //@title requestBook
    //@author Esteve Serra Clavera
    //notice Some user requests a book and pays for such request
    function requestBook(uint _bookId) external payable {
      require(msg.value >= lendingFee);
      //Notify the owner that book is requested
    }

}
