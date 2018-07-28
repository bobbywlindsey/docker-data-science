# reference: https://hub.docker.com/_/ubuntu/
FROM ubuntu:16.04

# Adds metadata to the image as a key value pair example LABEL version="1.0"
LABEL maintainer="Bobby Lindsey <me@bobbywlindsey.com>"

# Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 PATH=/opt/conda/bin:$PATH

# create empty directory to attach volume
RUN mkdir ~/GitProjects && \
    # install Ubuntu packages
    apt-get update && \
    apt-get install -y \
    wget \
    ca-certificates \
    git-core \
    pkg-config \
    tree \
    freetds-dev && \
    # clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Install Jupyter config
    mkdir ~/.ssh && touch ~/.ssh/known_hosts && \
    ssh-keygen -F github.com || ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    git clone https://github.com/bobbywlindsey/dotfiles.git && \
    mkdir ~/.jupyter && \
    cp /dotfiles/jupyter_configs/jupyter_notebook_config.py ~/.jupyter/ && \
    rm -rf /dotfiles && \
    # Install Anaconda
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    # Update Anaconda
    conda update conda && \
    conda update anaconda && \
    conda update --all && \
    # Install Jupyter theme
    pip install msgpack jupyterthemes && \
    jt -t grade3 && \
    # Install other Python packages
    conda install pymssql mkl=2018 && \
    pip install SQLAlchemy \
        missingno \
        json_tricks \
        bcolz \
        gensim \
        elasticsearch \
        psycopg2-binary \
        pymc3 && \
    # remove everything you don't need
    apt-get remove -y wget git-core pkg-config


# Configure access to Jupyter
WORKDIR /root/GitProjects
EXPOSE 8888
CMD jupyter lab --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token='data-science'
