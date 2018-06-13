pragma solidity ^0.4.23;
import "./BookShelf.sol";


contract GiveLibAck is BookShelf, ERC721 {

  uint lendingFee = 0.001 ether; //Amount to be used to cover lender requests for return
  mapping (uint => address) bookApprovals; //Identifying all the book approvals

  modifier theOwnerOf (uint _bookId){
    require(msg.sender == bookToOwner[_bookId]);
    _;
  }

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerBookCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return bookToOwner[_tokenId];
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

    function changeIsbn(uint _bookId, string _newIsbn) external theOwnerOf(_bookId) {
       zombies[_bookId].isbn = _newIsbn;
     }

     function _lendBook(address _from, address _to, uint256 _tokenId) private{
       ownerBooksCount[_from] = ownerBooksCount[_from].add(1);
       ownerBooksCount[_to] = ownerBooksCount[_to].sub(1);
       bookToOwner[_tokenId] = _to;
       Transfer(_from, _to, _tokenId);
     }

    ///@dev Requires the book to be of the current user and that the  current holder is the user
    function lendBook(address _to, uint256 _tokenId) public theOwnerOf(_bookId){
      _transfer(msg.sender, _to, _tokenId);

      //Change the book's holder
    }

    function approve(address _to, uint256 _tokenId) public theOwnerOf(_tokenId) {
      bookApprovals[_tokenId] = _to;
      Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
      require(bookApprovals[_tokenId] == msg.sender);
      address owner = ownerOf(_tokenId);
      _transfer(owner, msg.sender, _tokenId);
    }

    //@title requestBook
    //@author Esteve Serra Clavera
    //notice Some user requests a book and pays for such request
    function requestBook(uint _bookId) external payable {
      require(msg.value >= lendingFee);
      //Notify the owner that book is requested
      //Approve+takeownership or transfer
    }

}
