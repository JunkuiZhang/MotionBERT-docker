## How to build

```shell
sudo docker build -f alphapose.Dockerfile -t alphapose .
sudo docker build -f motionbert.Dockerfile -t motionbert .
```

## How to run

```shell
sudo docker run -it --mount source=AlphaPose,target=/root/AlphaPose --gpus all alphapose
sudo docker run -it --mount source=MotionBERT,target=/root/MotionBERT --gpus all motionbert
```
