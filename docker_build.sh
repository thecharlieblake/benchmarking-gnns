if [ "$1" = 'cu101' ] || [ "$1" = 'cpu' ]; then
    docker build --build-arg uid=$UID --build-arg user=$USER --build-arg
    cuda=$1 -t "ms19cb-gnn-freeze-$1" .
else
    echo "Invalid cpu/cuda value: $1"
fi
