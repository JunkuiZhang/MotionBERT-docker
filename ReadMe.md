## How to build

```shell
sudo docker build -f alphapose.Dockerfile -t zhangxiaobaichina/alphapose .
sudo docker build -f motionbert.Dockerfile -t zhangxiaobaichina/motionbert .
```

## How to run

### AlphaPose

```shell
sudo docker run -it -gpus=all --shm-size=16G --mount type=bind,source="$(pwd)"/AlphaPose,target=/root/AlphaPose/data --gpus all zhangxiaobaichina/alphapose
# container
conda activate alphapose
python setup.py build develop
python scripts/demo_inference.py --cfg configs/halpe_26/resnet/256x192_res50_lr1e-3_1x.yaml --checkpoint pretrained_models/halpe26_fast_res50_256x192.pth --video data/test_video.mp4 --outdir data/ --save_video
```

### MotionBERT

```shell
sudo docker run -it --gpus=all --mount type=bind,source="$(pwd)"/MotionBERT,target=/root/MotionBERT/data --gpus all zhangxiaobaichina/motionbert
# container
conda activate motionbert
python infer_wild.py --vid_path data/test_video.mp4 --json_path data/alphapose-results.json --out_path data/
python infer_wild_mesh.py --vid_path data/test_video.mp4 --json_path data/alphapose-results.json --out_path data/
```
