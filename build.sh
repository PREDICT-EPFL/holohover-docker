if [ "$#" -ne 1 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 [pi/pc]"
    exit -1
fi

if [ "$1" = "pi" ]; then
    platform="linux/arm64"
    image="holohover-light-aa"
    cp Dockerfile.pi Dockerfile
elif [ "$1" = "pc" ]; then
    platform="linux/amd64"
    image="holohover"
    cp Dockerfile.pc Dockerfile
else
    echo "Invalid platform: $1"
    echo "Usage:"
    echo "   $0 [pi/pc]"
    exit -1
fi

echo $0" - Building docker image $image for platform $platform"
sudo docker build --platform $platform . -t $image
echo $0" - Finish!"
rm Dockerfile
