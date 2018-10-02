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
    mkdir -p ~/.jupyter/custom && \
    mkdir -p ~/.jupyter/nbconfig && \
    cp /dotfiles/jupyter_configs/jupyter_notebook_config.py ~/.jupyter/ && \
    cp /dotfiles/jupyter_configs/custom/custom.js ~/.jupyter/custom/ && \
    cp /dotfiles/jupyter_configs/nbconfig/notebook.json ~/.jupyter/nbconfig/ && \
    rm -rf /dotfiles && \
    # Install Anaconda
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    # Update Anaconda
    conda update conda && \
    conda update anaconda && \
    conda update --all && \
    # Install Jupyter theme
    pip install msgpack jupyterthemes && \
    jt -t grade3 && \
    # Install 
    # Install other Python packages
    conda install pymssql mkl=2018 && \
    pip install SQLAlchemy \
        missingno \
        json_tricks \
        bcolz \
        gensim \
        elasticsearch \
        psycopg2-binary \
        jupyter_contrib_nbextensions \
        jupyter_nbextensions_configurator \
        pymc3 && \
    # Enable Jupyter Notebook extensions
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    jupyter nbextension enable codefolding/main && \
    jupyter nbextension enable collapsible_headings/main && \
    # Add vim-binding extension
    mkdir -p $(jupyter --data-dir)/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding $(jupyter --data-dir)/nbextensions/vim_binding && \
    cd $(jupyter --data-dir)/nbextensions \
    chmod -R go-w vim_binding && \
    # remove everything you don't need
    apt-get remove -y wget git-core pkg-config


# Configure access to Jupyter
WORKDIR /root/GitProjects
EXPOSE 8888
CMD jupyter lab --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token='data-science'
