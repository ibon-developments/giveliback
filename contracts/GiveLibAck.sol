pragma solidity ^0.5.1;

import "./BookShelf.sol";
import "./ERC721.sol";


contract GiveLibAck is BookShelf, ERC721 {

  using SafeMath for uint256;
  using SafeMath64 for uint64;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  uint lendingFee = 0.001 ether; //Amount to be used to cover lender requests for return
  mapping (uint => address) bookApprovals; //Identifying all the book approvals

  event Transfer(address indexed from, address indexed to, uint tokenId);
  event Approval(address indexed from, address indexed to, uint tokenId);
  event Lend(address indexed from, address indexed to, uint tokenId);
  event Return(address indexed from, address indexed to, uint tokenId);

  modifier theOwnerOf (uint _bookId){
    require(msg.sender == bookToOwner[_bookId]);
    _;
  }

  modifier theBorrowerOf (uint _bookId){
    require(msg.sender == bookToBorrower[_bookId]);
    _;
  }

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerBooksCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return bookToOwner[_tokenId];
  }

  ///@notice Ability to modify the amount for lending books
  function setLendingFee (uint _fee) external onlyOwner {
    lendingFee = _fee;
  }

  ///@author CryptoZombies
  function getBooksByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerBooksCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < books.length; i=i.add(1)) {
      if (bookToOwner[i] == _owner) {
        result[counter] = i;
        counter=counter.add(1);
      }
    }
    return result;
  }

  ///@author CryptoZombies
  function getBooksByBorrower(address _borrower) external view returns(uint[] memory) {
    uint[] memory result = new uint[](borrowerBooksCount[_borrower]);
    uint counter = 0;
    for (uint i = 0; i < books.length; i=i.add(1)) {
      if (bookToBorrower[i] == _borrower) {
        result[counter] = i;
        counter=counter.add(1);
      }
    }
    return result;
  }

  function changeIsbn(uint _tokenId, uint64 _newIsbn) external theOwnerOf(_tokenId) {
     books[_tokenId].isbn = _newIsbn;
   }

  //@notice Transfer the ownership of a book
  function _transfer(address _from, address _to, uint256 _tokenId) private{
   require(_to != address(0));
   ownerBooksCount[_from] = ownerBooksCount[_from].sub(1);
   ownerBooksCount[_to] = ownerBooksCount[_to].add(1);
   bookToOwner[_tokenId] = _to;
   emit Transfer(_from, _to, _tokenId);
  }

    ///@dev Requires the book to be of the current user and that the  current holder is the user
  function transfer(address _to, uint256 _tokenId) public theOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  //@notice Book transfer approval
  function approve(address _to, uint256 _tokenId) public theOwnerOf(_tokenId) {
    bookApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }

  //@notice Book transfer closure upon approval
  function takeOwnership(uint256 _tokenId) public {
    require(bookApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }

    ///@dev Requires the book to be of the current user and that the current owner is the user
  function lendBook(address _to, uint256 _tokenId) public {
    _lendBook(_to, _tokenId);
  }

  //@notice For lending and returning. Only counting when lending to a user, not when returned
  function _lendBook (address _to, uint256 _tokenId) private theOwnerOf(_tokenId) {
      require(bookToBorrower[_tokenId] == address(0));
      require(bookToOwner[_tokenId]!=_to);
      require(_to != address(0));
      borrowerBooksCount[_to] = borrowerBooksCount[_to].add(1);
      bookToBorrower[_tokenId] = _to;
      books[_tokenId].lended_num = books[_tokenId].lended_num.add(1);
      emit Lend(bookToOwner[_tokenId], _to, _tokenId);

  }

    ///@dev Requires the book to be of the current user and that the current borrower is the user
  function returnBook(uint256 _tokenId) public {
    _returnBook(_tokenId);
  }

  //@notice For lending and returning. Only counting when lending to a user, not when returned
  function _returnBook (uint256 _tokenId) private theBorrowerOf(_tokenId) {
      borrowerBooksCount[msg.sender] = borrowerBooksCount[msg.sender].sub(1);
      delete bookToBorrower[_tokenId];
      emit Return(msg.sender, bookToOwner[_tokenId], _tokenId);

  }


    //@title requestBook
    //@author Esteve Serra Clavera
    //notice Some user requests a book and pays for such request
    /*function requestBook(uint _bookId) external payable {
      require(msg.value >= lendingFee);
      //Notify the owner that book is requested
      //Approve+takeownership or transfer
    }*/

}
