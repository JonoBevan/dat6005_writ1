README
 ## Notes on AWS deployment of image
 Ensure correct port (80) for the web app is used. Format to access via a GET request at http://<public_DNS_Address>:80/movies to get the full list of movies from the API

 Will need to figure out how to configure internal ports for the database (which needs changing to the MySQL instance)

 ## Notes on AWS EC2 config
 Create the instance first before messing about withthe security groups. (change the rules after it is created as per the lab instructions)