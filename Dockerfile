# docker build -t data-science-image .
# docker run -it -v ~/GitProjects:/root/GitProjects -p 8888:8888 -i data-science-image
# docker run -d --name data-science -v ~/GitProjects:/root/GitProjects -p 8888:8888 -i data-science-image
# docker exec -it data-science bash

# reference: https://hub.docker.com/_/ubuntu/
FROM ubuntu:16.04

# Adds metadata to the image as a key value pair example LABEL version="1.0"
LABEL maintainer="Bobby Lindsey <me@bobbywlindsey.com>"

# Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Create empty directory to attach volume
RUN mkdir ~/GitProjects

# Install Ubuntu packages
RUN apt-get update
RUN apt-get install wget -y 
RUN apt-get install bzip2 -y 
RUN apt-get install ca-certificates -y 
RUN apt-get install build-essential -y 
RUN apt-get install curl -y 
RUN apt-get install git-core -y 
RUN apt-get install htop -y 
RUN apt-get install pkg-config -y 
RUN apt-get install unzip -y 
RUN apt-get install unrar -y 
RUN apt-get install tree -y 
RUN apt-get install freetds-dev -y

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install Jupyter config
RUN mkdir ~/.ssh
RUN touch ~/.ssh/known_hosts
RUN ssh-keygen -F github.com || ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN git clone https://github.com/bobbywlindsey/dotfiles.git
RUN mkdir ~/.jupyter
RUN cp /dotfiles/jupyter_configs/jupyter_notebook_config.py ~/.jupyter/
RUN rm -rf /dotfiles

# Install Anaconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh
RUN /bin/bash ~/anaconda.sh -b -p /opt/conda
RUN rm ~/anaconda.sh

# Set path to conda
ENV PATH /opt/conda/bin:$PATH

# Update Anaconda
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# Install Jupyter theme
RUN pip install msgpack
RUN pip install jupyterthemes
RUN jt -t grade3

# Install other Python packages
RUN conda install pymssql
RUN pip install SQLAlchemy
RUN pip install missingno
RUN pip install json_tricks
RUN pip install bcolz
RUN pip install gensim
RUN pip install elasticsearch
RUN pip install psycopg2-binary

# Configure access to Jupyter
WORKDIR /root/GitProjects
EXPOSE 8888
CMD jupyter lab --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token='data-science'

# ENTRYPOINT ["/bin/bash"]
