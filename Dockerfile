FROM nvcr.io/nvidia/l4t-tensorflow:r32.4.4-tf2.3-py3

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
          python3-pip \
		  python3-dev \
          python3-matplotlib \
		  build-essential \
		  gfortran \
		  git \
		  cmake \
		  libopenblas-dev \
		  liblapack-dev \
		  libblas-dev \
		  libhdf5-serial-dev \
		  hdf5-tools \
		  libhdf5-dev \
		  zlib1g-dev \
		  zip \
		  libjpeg8-dev \
		  libopenmpi2 \
          openmpi-bin \
          openmpi-common \
		  nodejs \
		  npm \
		  protobuf-compiler \
          libprotoc-dev \
		llvm-9 \
          llvm-9-dev \
    && rm -rf /var/lib/apt/lists/*
EXPOSE 8888
EXPOSE 5000

RUN pip3 install jupyter jupyterlab --verbose
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@2
RUN jupyter lab --generate-config
RUN python3 -c "from notebook.auth.security import set_password; set_password('chico','/root/.jupyter/jupyter_notebook_config.json')"
RUN mkdir /opt/app
WORKDIR /opt/app
ENV PATH /opt/conda/bin:$PATH
RUN echo "source activate base" > ~/.bashrc
CMD /bin/bash -c "jupyter lab --ip 0.0.0.0 --port 8888 --allow-root" & \
	echo "allow 10 sec for JupyterLab to start @ http://localhost:8888 (password nvidia)" && \
	echo "JupterLab logging location:  /opt/app/jupyter.log  (inside the container)" && \
	/bin/bash