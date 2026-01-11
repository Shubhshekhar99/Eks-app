from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="mysql",
    user="root",
    password="rootpass",
    database="demo"
)

@app.route("/")
def home():
    return "Backend running"

@app.route("/users")
def users():
    cursor = db.cursor()
    cursor.execute("SELECT name FROM users")
    data = cursor.fetchall()
    return jsonify([x[0] for x in data])

app.run(host="0.0.0.0", port=5000)
