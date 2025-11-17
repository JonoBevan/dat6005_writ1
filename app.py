from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
import requests
from bson import ObjectId
import os

'''
This app communicates with the swapi.dev api for Star Wars film data. 
Once active, it accepts GET and POST requests to return specified information. 
It runs off localhost in this iteration
'''

app = Flask(__name__)
# app.config["MONGO_URI"] = "mongodb://172.17.0.2:27017/swfavorites"
app.config["MONGO_URI"] = os.getenv("MONGO_URI", "mongodb://172.17.0.2:27017/swfavorites")
mongo = PyMongo(app)

# Helper that converts MongoDB docs to JSON serialisable format 
def serialise_favourite(fav):
    return {
        "_id": str(fav["_id"]),
        "name": fav["name"],
        "type": fav["type"],
        "url": fav["url"]
    }


@app.route("/favorites", methods=["GET"])
def get_favourites():
    favorites = mongo.db.favorites.find()
    return jsonify({"favorites": [serialise_favourite(fav) for fav in favorites]}), 200

@app.route("/favorites", methods=["POST"])
def add_favorite():
    data = request.get_json()
    fav_name = data.get("name")
    fav_type = data.get("type")
    fav_url = data.get("url")

    try:
        if fav_type not in ["movie", "character"]:
            raise ValueError("'type' should be 'movie' of 'character'!")
        
        existing_fav = mongo.db.favorites.find_one({"name": fav_name})
        if existing_fav:
            raise ValueError("Favourite exists already!")
        
        favorite = {
            "name": fav_name,
            "type": fav_type,
            "url": fav_url
        }
        mongo.db.favorites.insert_one(favorite)
        return jsonify({"message": "Favorite saved!", "favorite": serialise_favourite(favorite)}), 201
    
    except Exception as e:
        return jsonify({"message": str(e)}), 500

@app.route("/movies", methods=["GET"])
def get_movies():
    try:
        response = requests.get ("https://swapi.dev/api/films")
        response.raise_for_status()
        return jsonify({"movies": response.json()}), 200
    
    except Exception:
        return jsonify({"message": "Something went wrong."}), 500
    
@app.route("/people", methods=["GET"])
def get_people():
    try:
        response = requests.get("https://swapi.dev/api/people")
        response.raise_for_status()
        return jsonify({"people": response.json()}), 200
    except Exception:
        return jsonify({"message": "Something went wrong."}), 500
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)