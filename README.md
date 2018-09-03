# GiveLibAck
## Give {my} Lib{rary with} Ack{nowledgment}
## Give {my} Li{brary} Back

Web DApp to track all the books from your library which have been lended to friends and colleagues. A true bond between the analogue and digital world.

## ToDo
* Slim the requirements.txt
* Craft the Angular framework

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
* Python Modules via requirements.txt {pip, web3py, py-solc, Flask, CherryPy, ...}
* Git
`sudo apt-get update`
`sudo apt-get install git`
##### Frontend:
* Node.js `curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -` `after sudo apt-get install -y nodejs`
* NPM `apt-get install npm`
* `npm install`
* Serving angular code: Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`
#### Steps
* Clone the repository `git clone https://github.com/ibon-developments/giveliback.git`
* On that folder (`giveliback`) setup a Python3 virtual environment `virtualenv -p python3 giveliback` and initiate it `cd giveliback && source bin/activate`
* Install the required Python modules `pip install -r requirements.txt`
* Update web3 with `sudo pip install --upgrade web3`
* Install flask-cors `pipenv install flask-cors`
* cd giveliback

* For install Quorum read these instructions: `https://ibón.es/2018/07/06/despliegue-de-web-dapp-con-quorumangularpythonflask-en-un-vps-con-ubuntu-16-04/`
* Initiate Quorum nodes:
* Node 1: `geth --datadir qdata/node1 init genesis.json 2>>qdata/logs/node1.log`
* Node 2: `geth --datadir qdata/node2 init genesis.json 2>>qdata/logs/node2.log`
* Launch the nodes:
* Node 1: `geth --datadir=qdata/node1 --raft --emitcheckpoints --raftport 50401 --unlock 0 --password password.txt --config config.toml 2>>qdata/logs/node1.log`
* Node 2: `geth --datadir=qdata/node2 --raft --emitcheckpoints --raftport 50402 --unlock 0 --password password.txt --config config_2.toml 2>>qdata/logs/node2.log`
* If you have errors with gas limit reached: `geth --datadir=qdata/node1 --raft --emitcheckpoints --raftport 50401 --unlock 0 --password password.txt --config config.toml --targetgaslimit 3758096384 2>qdata/logs/node1.log`

* Initiate the python code `python cherrypy_server.py` connected to the node 1 and a webserver will be listening on localhost:8888
* Initiate the python code `python cherrypy_server_2.py` connected to the node 2 and a webserver will be listening on localhost:8889
* Invoke  `http://localhost:8888/compile_contracts`
* Invoke  `http://localhost:8888/create_book?book_name=2666&isbn=9788420423920`

####  IPFS
* Install IPFS
`sudo apt-get update`

`sudo apt-get install golang-go -y`

`wget https://dist.ipfs.io/go-ipfs/v0.4.10/go-ipfs_v0.4.10_linux-386.tar.gz`

`tar xvfz go-ipfs_v0.4.10_linux-386.tar.gz`

`ipfs --version`

* Use IPFS
 `ipfs init`
 
 `ng build`
 
 `in dist folder comment   <!--<base href="/">-->`
 
 `ipfs add -r dist`
 
 `Optional:`
 
 `ipfs name publish <hash-generated-from-previous-command>`
 
 `ipfs name resolve <hash-generated-from-previous-command>`
 
* URL with Giveliback in IPFS and backend in localhost:

  https://ipfs.io/ipfs/QmRMcacKdbKAFyoejrQ3eHztT4LE8a9zSSDVGJVABWseii/
 

## User actions
* Users can create their own libraries of books
* Users can request books to other users
* Users can lend books to other users
* Users can request the lended books to be returned
* Users can return the lended books (or cancel with a drama unfolding!)

## Smart Contracts
There are several files of contracts which GiveLibAck relies upon.
* Base.sol: Contract ownership, overflow management on mathematical functions
* ERC721.sol: Open standard for non-fungible tokens
* Bookshelf.sol: Book creation
* GiveLibAck.sol: Book management including request and lending based on ERC721. Book request involves a payment fee
