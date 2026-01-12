import os
from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
    port=int(os.getenv("DB_PORT", "3306"))
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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
