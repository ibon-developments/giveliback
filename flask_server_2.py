import sys
import time
import json
import string
import pandas as pd
from flask import Flask, render_template, request, jsonify
from web3 import Web3, HTTPProvider, IPCProvider
from web3.contract import ConciseContract
from solc import compile_source, compile_files
from node_connector import NodeConnector

#flask setup
app = Flask(__name__)
connection = NodeConnector()

#web3 setup
#connecting to node 1
web3 = Web3(HTTPProvider('http://localhost:22001'))
#default_gas = 4000000
default_gas = 3740000000
#gas limit
#3689010802
#createbook estimated gas
#3758096384

contract_address = None
contract_instance = None
contract_interface_GiveLibAck = None
contract_interface_BookShelf = None
contract_interface_ERC721 = None
contract_interface_Base = None


##
#def instantiate_contract(contract_address):
#    return web3.eth.contract(address=contract_address,abi=contract_interface['abi'])
##



@app.route('/')
def home():
    return render_template("base.html")


@app.route('/compile_contracts')
def compile_contracts():
    global contract_address
    global contract_instance
    '''
    global contract_interface_GiveLibAck
    global contract_interface_BookShelf
    global contract_interface_ERC721
    global contract_interface_Base
    '''
    tx_hash_hex = None
    typology = None
    try:
        if contract_instance is None:
            print('No contract deployed')
            #The key is found under contracts/GiveLibAck.sol:GiveLibAck'
            contract_compiled = compile_files(["contracts/GiveLibAck.sol"])
            contract_interface_GiveLibAck = contract_compiled['contracts/GiveLibAck.sol:GiveLibAck']
            contract_interface_BookShelf = contract_compiled['contracts/BookShelf.sol:BookShelf']
            contract_interface_ERC721 = contract_compiled['contracts/ERC721.sol:ERC721']
            contract_interface_Base = contract_compiled['contracts/Base.sol:Base']

            contract=web3.eth.contract(abi=contract_interface_GiveLibAck['abi'], bytecode=contract_interface_GiveLibAck['bin'])
            print('Synch:', web3.eth.syncing)
            print('Estimated gas:', contract.constructor().estimateGas())
            print ('Default gas:', default_gas)
            tx_hash = contract.constructor().transact(transaction={'from': web3.eth.accounts[0], 'gas': default_gas})
            time.sleep(10)
            print('Transaction hash:', tx_hash)
            print('Type:' ,type(tx_hash))
            tx_hash_hex = web3.toHex(tx_hash)
            print('Transaction hash (hex):', tx_hash_hex)
            tx_receipt = web3.eth.getTransactionReceipt(tx_hash)
            #tx_receipt = web3.eth.getTransactionReceipt('0x415df47aff729937965f78393ca72f6d770f1f6b482ae5a36d53f90041f754ef')
            print ('Tx receipt:', tx_receipt)
            contract_address=tx_receipt['contractAddress']
            print ('Contract address:', contract_address)
            typology = 'new'
            #Instantiate the contract upon deployment
            contract_instance = web3.eth.contract(address=contract_address,abi=contract_interface_GiveLibAck['abi'])

        else:
            typology = 'existing'

    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)

    print('The contract has been deployed at address ' + str(contract_address))
    compilation_data=pd.DataFrame(data={'type': [typology], 'tx_hash': [tx_hash_hex], 'contract_address': [contract_address]})
    print ('Gas limit:', web3.eth.getBlock("latest").gasLimit)

    return compilation_data.to_json(orient="records")

@app.route('/create_book')
#http://127.0.0.1:8888/create_book?book_name=test&isbn=981299902
#input
#book_name: name of the book
#isbn: 13-digit identifier
#creator: msg.sender()
#output: book_id (function), book_name (input), isbn (input), creator (input)
#####
#Default gas: 3758096384 3678236826
#Estimate Gas: 3685425784
#
def create_book():
    #global contract_instance
    #global default_gas
    token_id = None
    creator = None
    isbn = None
    book_name = None
    tx_hash_hex = None
    status = None
    try:
        if contract_instance:
            print('Synch:', web3.eth.syncing)
            print ('Default gas:', default_gas)
            isbn = request.args.get('isbn','N/A', type=int)
            book_name = request.args.get('book_name','N/A', type=str)


            creator = web3.eth.accounts[0]
            #Hardcoded address!!
            #unlock before?!! Not necessary as the node unlocks it at the beginning
            print(contract_instance.functions.createBook(isbn).estimateGas())
            tx_hash = contract_instance.functions.createBook(isbn).transact({'from': creator, 'gas': default_gas})

            time.sleep(10)
            print('Transaction hash:', tx_hash)
            print('Type:' ,type(tx_hash))
            tx_hash_hex = web3.toHex(tx_hash)
            print('Transaction hash (hex):', tx_hash_hex)
            tx_receipt = web3.eth.getTransactionReceipt(tx_hash)
            print (tx_receipt)
            if tx_receipt:
                status = 'Created'
            else:
                print ('Issue while creating the book')
                status =  'Not created'
            #Get book_id

            #data = pd.DataFrame(data={'book_id': [book_id], 'book_name': [book_name], 'isbn': [isbn], 'creator': [creator], 'status': 'not created', 'tx_hash': tx_hash})

    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)

    '''
    book_name = request.args.get('book_name','N/A', type=str)
    isbn = request.args.get('isbn','N/A', type=int)
    creator = '0x83bc3f4a1bf70bd0abe450bd60a2c82c95c8c542'
    book_id = 0
    '''
    #data = pd.DataFrame(data={'book_id': [book_id], 'book_name': [book_name], 'isbn': [isbn], 'creator': [creator]})
    data = pd.DataFrame(data={'token_id': [token_id], 'book_name': [book_name], 'isbn': [isbn], 'creator': [creator], 'status': [status], 'tx_hash': tx_hash_hex})
    print ('Gas limit:', web3.eth.getBlock("latest").gasLimit)

    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")

@app.route('/get_books_by_owner')
#The method has
#owner: address [ToDo or user_id]
def get_books_by_owner():
    token_ids = []
    owner = None
    try:
        if contract_instance:
            #Defaulting to self if no address provided
            owner = request.args.get('owner',web3.eth.accounts[0], type=str)
            token_ids = contract_instance.functions.getBooksByOwner(owner).call()
            print(token_ids)


    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)


    data = pd.DataFrame(data={'owner': [owner], 'token_ids': [token_ids]})
    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")

@app.route('/lend_book')
#The method has
#owner: address [ToDo or user_id]
def lend_book():

    owner = None
    toAddress = None
    tokenId = None
    status = None
    try:
        if contract_instance:
            #Defaulting to self
            owner = web3.eth.accounts[0]
            toAddress = request.args.get('to','', type=str)
            tokenId = request.args.get('tokenId','', type=int)
            tx_hash = contract_instance.functions.lendBook(toAddress, tokenId).transact({'from': owner, 'gas': default_gas})
            time.sleep(10)
            print('Transaction hash:', tx_hash)
            tx_hash_hex = web3.toHex(tx_hash)
            print('Transaction hash (hex):', tx_hash_hex)
            tx_receipt = web3.eth.getTransactionReceipt(tx_hash)
            print (tx_receipt)
            if tx_receipt:
                status = 'Lended'
            else:
                print ('Issue while creating the book')
                status =  'Not lended'



    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)

    data = pd.DataFrame(data={'issuer': [owner], 'to': [toAddress], 'token_ids': [tokenId], 'status': [status]})
    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")

@app.route('/return_book')
#The method has
#owner: address [ToDo or user_id]
def return_book():
    borrower = None
    tokenId = None
    status = None
    try:
        if contract_instance:
            #Defaulting to self
            borrower = web3.eth.accounts[0]
            tokenId = request.args.get('tokenId','', type=int)
            tx_hash = contract_instance.functions.returnBook(tokenId).transact({'from': borrower, 'gas': default_gas})
            time.sleep(10)
            print('Transaction hash:', tx_hash)
            tx_hash_hex = web3.toHex(tx_hash)
            print('Transaction hash (hex):', tx_hash_hex)
            tx_receipt = web3.eth.getTransactionReceipt(tx_hash)
            print (tx_receipt)
            if tx_receipt:
                status = 'Returned'
            else:
                print ('Issue while creating the book')
                status =  'Not returned'



    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)

    data = pd.DataFrame(data={'issuer': [borrower], 'token_id': [tokenId], 'status': [status]})
    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")

@app.route('/get_books_by_borrower')
#The method has
#owner: address [ToDo or user_id]
def get_books_by_borrower():
    token_ids = []
    try:
        if contract_instance:
            #Defaulting to self if no address provided
            borrower = request.args.get('borrower',web3.eth.accounts[0], type=str)
            token_ids = contract_instance.functions.getBooksByBorrower(borrower).call()
            print(token_ids)


    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)


    data = pd.DataFrame(data={'borrower': [borrower], 'token_ids': [token_ids]})
    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")

@app.route('/books')
def books():
    global contract_address
    global contract_instance
    global contract_interface_BookShelf
    book_id = None
    creator = None
    isbn = None
    book_name = None
    tx_hash_hex = None

    ###HARDCODED###############
    #contract_instance = fake_instanciate()
    ###HARDCODED###############
    try:
        if contract_instance:
            print ('Dins')
            print(contract_address)
            #print(contract_interface_BookShelf['abi'])
            #contract_instance_BookShelf = web3.eth.contract(address=contract_address,abi=contract_interface_BookShelf['abi'])
            #print(contract_instance_BookShelf)
            book_id = request.args.get('book_id','N/A', type=int)
            book_internal, isbn, creator = contract_instance.functions.books(book_id).call()
            print(book_internal + isbn + creator)


    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)
    else:
            print('The contract has not been deployed')
            status = 'Not created'
    data = pd.DataFrame(data={'book_id': [book_id], 'book_name': [book_name], 'isbn': [isbn], 'creator': [creator], 'tx_hash': tx_hash_hex})

    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")

@app.route('/manual_instance')
def manual_instance():
    global contract_address
    global contract_instance
    print('contract instance', contract_instance)
    try:
        if not contract_instance:
            print('No contract instance available')
            print('Synch:', web3.eth.syncing)
            print ('Default gas:', default_gas)
            contract_address = request.args.get('contract_address','', type=str)
            print('contract address:', contract_address)
            #contract_instance = instantiate_contract(contract_address)
            abi = [{'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'address', 'name': ''}], 'name': 'bookToOwner', 'inputs': [{'type': 'uint256', 'name': ''}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'approve', 'inputs': [{'type': 'address', 'name': '_to'}, {'type': 'uint256', 'name': '_tokenId'}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'changeIsbn', 'inputs': [{'type': 'uint256', 'name': '_tokenId'}, {'type': 'uint64', 'name': '_newIsbn'}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'uint256[]', 'name': ''}], 'name': 'getBooksByOwner', 'inputs': [{'type': 'address', 'name': '_owner'}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'address', 'name': '_owner'}], 'name': 'ownerOf', 'inputs': [{'type': 'uint256', 'name': '_tokenId'}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'uint64', 'name': 'isbn'}, {'type': 'address', 'name': 'creator'}, {'type': 'uint16', 'name': 'lended_num'}], 'name': 'books', 'inputs': [{'type': 'uint256', 'name': ''}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'uint256', 'name': '_balance'}], 'name': 'balanceOf', 'inputs': [{'type': 'address', 'name': '_owner'}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'address', 'name': ''}], 'name': 'owner', 'inputs': []}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'transfer', 'inputs': [{'type': 'address', 'name': '_to'}, {'type': 'uint256', 'name': '_tokenId'}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'setLendingFee', 'inputs': [{'type': 'uint256', 'name': '_fee'}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'uint256[]', 'name': ''}], 'name': 'getBooksByBorrower', 'inputs': [{'type': 'address', 'name': '_borrower'}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'takeOwnership', 'inputs': [{'type': 'uint256', 'name': '_tokenId'}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'address', 'name': ''}], 'name': 'bookToBorrower', 'inputs': [{'type': 'uint256', 'name': ''}]}, {'constant': True, 'stateMutability': 'view', 'type': 'function', 'payable': False, 'outputs': [{'type': 'uint256', 'name': ''}], 'name': 'timestamp', 'inputs': []}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'lendBook', 'inputs': [{'type': 'address', 'name': '_to'}, {'type': 'uint256', 'name': '_tokenId'}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'returnBook', 'inputs': [{'type': 'uint256', 'name': '_tokenId'}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [{'type': 'uint256', 'name': '_bookId'}], 'name': 'createBook', 'inputs': [{'type': 'uint64', 'name': '_isbn'}]}, {'constant': False, 'stateMutability': 'nonpayable', 'type': 'function', 'payable': False, 'outputs': [], 'name': 'transferOwnership', 'inputs': [{'type': 'address', 'name': 'newOwner'}]}, {'type': 'event', 'inputs': [{'indexed': True, 'name': 'from', 'type': 'address'}, {'indexed': True, 'name': 'to', 'type': 'address'}, {'indexed': False, 'name': 'tokenId', 'type': 'uint256'}], 'anonymous': False, 'name': 'Transfer'}, {'type': 'event', 'inputs': [{'indexed': True, 'name': 'from', 'type': 'address'}, {'indexed': True, 'name': 'to', 'type': 'address'}, {'indexed': False, 'name': 'tokenId', 'type': 'uint256'}], 'anonymous': False, 'name': 'Approval'}, {'type': 'event', 'inputs': [{'indexed': True, 'name': 'from', 'type': 'address'}, {'indexed': True, 'name': 'to', 'type': 'address'}, {'indexed': False, 'name': 'tokenId', 'type': 'uint256'}], 'anonymous': False, 'name': 'Lend'}, {'type': 'event', 'inputs': [{'indexed': True, 'name': 'from', 'type': 'address'}, {'indexed': True, 'name': 'to', 'type': 'address'}, {'indexed': False, 'name': 'tokenId', 'type': 'uint256'}], 'anonymous': False, 'name': 'Return'}, {'type': 'event', 'inputs': [{'indexed': False, 'name': 'bookId', 'type': 'uint256'}, {'indexed': False, 'name': 'isbn', 'type': 'uint256'}], 'anonymous': False, 'name': 'NewBook'}, {'type': 'event', 'inputs': [{'indexed': False, 'name': '_error', 'type': 'string'}], 'anonymous': False, 'name': 'Error'}, {'type': 'event', 'inputs': [{'indexed': True, 'name': 'previousOwner', 'type': 'address'}, {'indexed': True, 'name': 'newOwner', 'type': 'address'}], 'anonymous': False, 'name': 'OwnershipTransferred'}]

            contract_instance = web3.eth.contract(address=contract_address,abi=abi)
            if contract_instance:
                status = 'Loaded'
            else:
                status = 'Not loaded'
    except NameError as error:
            #error = 'This variable is not defined'
            print(error)
    except Exception as exception:
            print(exception)

    #data = pd.DataFrame(data={'book_id': [book_id], 'book_name': [book_name], 'isbn': [isbn], 'creator': [creator]})
    data = pd.DataFrame(data={'contract_address': [contract_address], 'status': [status]})
    print ('Gas limit:', web3.eth.getBlock("latest").gasLimit)

    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")



if __name__ == '__main__':
    app.run(debug=True,threshold=True)
