# GiveLibAck
## Give {my} Lib{rary with} Ack{nowledgment}
## Give {my} Li{brary} Back

Web DApp to track all the books from your library which have been lended to friends and colleagues. A true bond between the analogue and digital world.

## ToDo
* Define the user actions
* Design the architecture
* Outline the Smart Contract (eventually collectible tokens)
* Slim the requirements.txt

## Architecture
* Angular
* Web3
* Python 3.5 [Flask+CherryPy]
* POA (Proof of Authority)
* Target network: Quorum | Rinkeby

### Setting up the environment (Ubuntu 16.04 alike)
#### Requirements
##### Backend:
* Python 3.5
`sudo apt-get update`
`sudo apt-get install python3-dev`
* Virtualenv
` sudo apt install virtualenv`
* Pip
`sudo apt install python-pip`
* Solc
`sudo add-apt-repository ppa:ethereum/ethereum`
`sudo apt-get update`
`sudo apt-get install solc`
* Python Modules via requirements.txt {pip, web3py, py-solc, jsonstream, Flask, CherryPy, ...}
* Git
`sudo apt-get update`
`sudo apt-get install git`
##### Frontend:
* Node.js `curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -` `after sudo apt-get install -y nodejs`
* NPM `apt-get install npm`
#### Steps
* Clone the repository `git clone https://github.com/ibon-developments/giveliback.git`
* On that folder (`giveliback`) setup a Python3 virtual environment `virtualenv -p python3 giveliback` and initiate it `cd giveliback && source bin/activate`
* Install the required Python modules `pip install -r requirements.txt`
* Install Angular framework on that folder `npm install -g @angular/cli`
* Install Bootstrap `npm install bootstrap`
* [ToDo] Initialise an angular project
* Initiate the python code `python cherry_server.py` and a webserver will be listening on localhost:8888
* Serving angular code: Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`

## User actions
* Users can create their own libraries of books
* Users can requests books to other users
* Users can lend books to other users
* Users can request the lended books to be returned
* Users can return the lended books (or cancel with a drama unfolding!)

## Smart Contracts
There are several files of contracts which GiveLibAck relies upon.
* Base.sol: Contract ownership, overflow management on mathematical functions
* Bookshelf.sol: Book creation
* GiveLibAck.sol: Book management including request and lending based on ERC721. Book request involves a payment fee

