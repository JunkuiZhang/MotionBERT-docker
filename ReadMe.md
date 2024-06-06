## How to build

```shell
sudo docker build -f alphapose.Dockerfile -t alphapose .
sudo docker build -f motionbert.Dockerfile -t motionbert .
```

## How to run

```shell
sudo docker run -it --gpus all alphapose
sudo docker run -it --gpus all motionbert
```
