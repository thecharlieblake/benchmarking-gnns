NV_GPU="$1" nvidia-docker run -it -v `pwd`:/ms19cb/gnn-freeze:rw gnn-freeze
docker run --runtime=nvidia -it -v `pwd`:/ms19cb/gnn-freeze:rw --hostname
$HOSTNAME --workdir /ms19cb/gnn-freeze/nervenet3/scripts gnn-freeze
docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 -it -v
`pwd`:/ms19cb/gnn-freeze:rw gnn-freeze

if [ "$1" = 'cu101' ] || [ "$1" = 'cpu' ]; then
    docker run -it -v `pwd`:/ms19cb/gnn-freeze:rw --hostname $HOSTNAME
    --workdir /ms19cb/gnn-freeze/nervenet3/scripts "gnn-freeze-ms19cb-$1"
else
    echo "Invalid cpu/cuda value: $1"
fi
