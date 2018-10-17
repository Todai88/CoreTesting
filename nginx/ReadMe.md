### To test this:

#### Running this will create both an image and container running nginx on your local machine.

1. Make sure Docker is installed (run `docker version`).
2. Navigate your choice of CLI (I suggest powershell) to /nginx
3. Run `docker build -t some-content-nginx .` to build a version of the image. `some-content-nginx` will be the tag of your image.
4. Run your container with `docker run --name some-nginx -d -p 8080:80 some-content-nginx`.
5. Check that the container is running on `localhost:8080` and by running `docker ps`.