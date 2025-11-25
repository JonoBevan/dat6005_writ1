# INSTRUCTIONS ON USE

## swapi-webapp
The app acts as a webservice that communicates with an API. This API contains data on Star Wars films, and accepts GET requests to return the data. 

The app is designed to pass along these GET requets, but to also store returned information from the API in a MySQL database. 

POST requests supply data to the API via the web service (i.e. for a specific film), and the returned data is stored in a table. The data supplied in the POST request is derived from the GET request, and is structured as below:

```json
{
    "name": "movie_name",
    "type": "data_object_type",
    "url": "api_url"
}
```

A GET request made to the <b>/favorites</b> address of the host will return all the data from the MySQL table. 

## Development 
This app has been developed to be made into a Docker image, which will be made available in Docker Hub. 

## Deployment
This app is meant to be deployed to an AWS EC2 web server, which acts as the host for the service. Requests are to be made to the public DNS of this host. 

An EC2 instance will be created, and provisioned with Docker via an ssh connection from a local client terminal. Once Docker is installed, the app image will be downloaded from Docker Hub and run as a container. 

The app expects a MySQL database to exist already. This will have deployed ahead of time via Terraform, but the public DNS will likely change due to Terraform tear down procedures. Not a concern for this assessment. 

## Accessing the web service

Once deployed, the web service will be accessible by making GET and POST requests via Postman. 

The public DNS will need to be used with the http domain, with the :80 port. Examples below: 


| Method | Endpoint Example | Description | Payload Example | 
| ------ | ---------------- | ----------- | --------------- |
| GET | http://ec2-13-40-189-105.eu-west-2.compute.amazonaws.com:80/movies | Returns all movie data from the API | N/A |
| POST | http://ec2-13-40-189-105.eu-west-2.compute.amazonaws.com:80/favorites | Posts a JSON object to the webservice, where it is added to the database. | {"name": "Return of the Jedi","type": "movie","url": "https://swapi.dev/api/films/3/"} |
| GET | http://ec2-13-40-189-105.eu-west-2.compute.amazonaws.com:80/favorites | Returns all entries from the favorites table in the database via the web service | N/A |



 ## Notes on AWS deployment of image
 Ensure correct port (80) for the web app is used. Format to access via a GET request at http://<public_DNS_Address>:80/movies to get the full list of movies from the API

 Will need to figure out how to configure internal ports for the database (which needs changing to the MySQL instance)

 ## Notes on AWS EC2 config
 Create the instance first before messing about withthe security groups. (change the rules after it is created as per the lab instructions)
