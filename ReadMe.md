## Prepare

### AlphaPose

To build images and run, you need to download the following:
1. [halpe26_fast_res50_256x192.pth](https://drive.google.com/file/d/1S-ROA28de-1zvLv-hVfPFJ5tFBYOSITb/view)
2. [yolov3-spp.weights](https://drive.usercontent.google.com/download?id=1D47msNOOiJKvPOXlnpyzdKA3k6E97NTC&export=download&authuser=0&confirm=t&uuid=b5c52340-197e-4d47-b874-b856e2ce469c&at=APZUnTVpX9wiVk-5-mfRVhmeZwS5%3A1717743467375)

Put them in current work dir.

### MotionBERT

To build images and run, you need to download the following:
1. Download [best_epoch.bin](https://onedrive.live.com/?authkey=%21ALuKCr9wihi87bI&id=A5438CD242871DF0%21190&cid=A5438CD242871DF0), then rename and move it to `motionbert-data/3dpose_best_epoch.bin`
2. Download [best_epoch.bin](https://onedrive.live.com/?authkey=%21AKBg2yUINYw1CL0&id=A5438CD242871DF0%21185&cid=A5438CD242871DF0), then rename and move it to `motionbert-data/mesh_best_epoch.bin`

### Result

Your file tree should look like:

```shell
.
├── AlphaPose
│   ├── ...
├── AlphaPose-master.zip
├── MotionBERT
│   ├── ...
├── MotionBERT-main.zip
├── ReadMe.md
├── alphapose.Dockerfile
├── file-tree.png
├── halpe26_fast_res50_256x192.pth  <- Added
├── motionbert-data
│   ├── 3dpose_best_epoch.bin       <- Added
│   └── mesh_best_epoch.bin         <- Added
├── motionbert.Dockerfile
└── yolov3-spp.weights              <- Added
```

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
