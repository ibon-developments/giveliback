pragma solidity ^0.4.23;
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

  modifier theOwnerOf (uint _bookId){
    require(msg.sender == bookToOwner[_bookId]);
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
  function getBooksByOwner(address _owner) external view returns(uint[]) {
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

  function changeIsbn(uint _tokenId, uint64 _newIsbn) external theOwnerOf(_tokenId) {
     books[_tokenId].isbn = _newIsbn;
   }

   function _transfer(address _from, address _to, uint256 _tokenId) private{
     ownerBooksCount[_from] = ownerBooksCount[_from].sub(1);
     ownerBooksCount[_to] = ownerBooksCount[_to].add(1);
     bookToOwner[_tokenId] = _to;
     bookLend(_to, _tokenId);
     emit Transfer(_from, _to, _tokenId);
   }

    ///@dev Requires the book to be of the current user and that the  current holder is the user
  function transfer(address _to, uint256 _tokenId) public theOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

    function approve(address _to, uint256 _tokenId) public theOwnerOf(_tokenId) {
      bookApprovals[_tokenId] = _to;
      emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
      require(bookApprovals[_tokenId] == msg.sender);
      address owner = ownerOf(_tokenId);
      _transfer(owner, msg.sender, _tokenId);
    }

    //notice Only counting when lending to a user, not when returned
    function bookLend (address _to, uint256 _tokenId) private {
        if(books[_tokenId].creator != _to){
            books[_tokenId].lended_num = books[_tokenId].lended_num.add(1);
        }
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
