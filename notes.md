## On the execution of smoke tests in an image

As part of the CI pipeline, smoke tests are conducted from within the container (meaning pytest etc needs to be included as part of the image).

When running tests in the CI pipeline yaml file, the following command needs to be run:

```bash
docker compose exec -T -w /favorites_app web pytest -q 
```

-w /favorites_app: Sets the working directory, which is sourced from the WORKINGDIR in the dockerfile. 

web: is the service name in the docker-compose.yml file. In this case, it is just called web 

