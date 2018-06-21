from flask import Flask, render_template, request, jsonify
import json
import string
import os
from node_connector import NodeConnector
import pandas as pd
import json

app = Flask(__name__)
connection = NodeConnector()


@app.route('/')
def home():
    return render_template("base.html")


@app.route('/create_book')
#http://127.0.0.1:8888/create_book?book_name=test&isbn=981299902
#input
#book_name: name of the book
#isbn: 13-digit identifier
#creator: msg.sender()
#output: book_id (function), book_name (input), isbn (input), creator (input)
def create_book():
    book_name = request.args.get('book_name','N/A', type=str)
    isbn = request.args.get('isbn','N/A', type=int)
    creator = '0x83bc3f4a1bf70bd0abe450bd60a2c82c95c8c542'
    book_id = 0
    data = pd.DataFrame(data={'book_id': [book_id], 'book_name': [book_name], 'isbn': [isbn], 'creator': [creator]})
    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")


@app.route('/get_books_by_owner')
#The method has
#owner: address [ToDo or user_id]
def get_books_by_owner():
    owner = '0x83bc3f4a1bf70bd0abe450bd60a2c82c95c8c542'
    book_ids = [0,1]
    data = pd.DataFrame(data={'owner': owner, 'book_ids':book_ids})
    print(data)
    print(data.to_json(orient="records"))
    return data.to_json(orient="records")


if __name__ == '__main__':
    app.run(debug=True,threshold=True)
