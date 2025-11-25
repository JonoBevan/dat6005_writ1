from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import requests
import os
import time
from sqlalchemy import inspect
from sqlalchemy.exc import OperationalError, SQLAlchemyError

'''
This app communicates with the swapi.dev api for Star Wars film data. 
Once active, it accepts GET and POST requests to return specified information. 
It runs off localhost in this iteration
'''

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
    "DATABASE_URI",
    "mysql+pymysql://swapi_user:swapi_pass@swapi-mysql-db.c7ks40ay8cnf.eu-west-2.rds.amazonaws.com:3306/swfavorites"
)

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False



db = SQLAlchemy(app)

class Favorite(db.Model):

    __tablename__ = "favorites"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), unique=True, nullable=False)
    type = db.Column(db.String(50), nullable=False)
    url = db.Column(db.String(512), nullable=True)

def wait_for_sql():
    for i in range(30):
        try:
            with app.app_context():
                db.create_all()
                print("Database is ready: tables created")
                return
        except OperationalError as e:
            print(f"Database not ready yet ({e}), retrying ({i+1}/30)...")
            time.sleep(1)
    raise RuntimeError("Database never became available")

wait_for_sql()
    
def serialise_favourite(fav: Favorite):
    return {
        "_id": fav.id,
        "name": fav.name,
        "type": fav.type,
        "url": fav.url
    }

@app.route("/favorites", methods=["GET"])
def get_favourites():
    favorites = Favorite.query.all()
    return jsonify({"favorites": [serialise_favourite(fav) for fav in favorites]}), 200

@app.route("/favorites", methods=["POST"])
def add_favorite():
    data = request.get_json() or {}
    fav_name = data.get("name")
    fav_type = data.get("type")
    fav_url = data.get("url")

    try:

        if fav_type not in ["movie", "character"]:
            raise ValueError("'type' should be 'movie' of 'character'!")
        
        existing_fav = Favorite.query.filter_by(name=fav_name).first()
        if existing_fav:
            raise ValueError("Favourite exists already!")
        
        favorite = Favorite(
            name = fav_name,
            type = fav_type,
            url = fav_url
        )

        db.session.add(favorite)
        db.session.commit()
        
        return jsonify({"message": "Favorite saved!", "favorite": serialise_favourite(favorite)}), 201
    
    except Exception as e:
        db.session.rollback()
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