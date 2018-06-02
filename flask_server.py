from flask import Flask, render_template, request, jsonify
import json
import string
import os
from node_connector import NodeConnector


app = Flask(__name__)
connection = NodeConnector()


@app.route("/")
def home():
    return render_template("base.html")




if __name__ == '__main__':
    app.run(debug=True,threshold=True)
