docker run --gpus all -v `pwd`:/ms19cb/gnn-freeze:rw --hostname $HOSTNAME --workdir /ms19cb/gnn-freeze/ -it cuda-101-conda-graph:latest
