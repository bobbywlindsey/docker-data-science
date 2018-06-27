# docker-data-science

Set up an automated data science environment using Docker

Any changes to the Dockerfile will be automatically built in Docker Hub, so just pull the container:

`docker pull bobbywlindsey/docker-data-science`

Then you can either run the container interactively:

`docker run -it -v ~/GitProjects:/root/GitProjects -p 8888:8888 -i data-science-image`

Or run the container in a detached mode so that you can use Jupyter Notebooks but still use bash

```
docker run -d --name data-science -v ~/GitProjects:/root/GitProjects -p 8888:8888 -i data-science-image
```

To use Jupyter Notebooks on your host machine, just navigate to `localhost:8888` and enter the token `data-science`.