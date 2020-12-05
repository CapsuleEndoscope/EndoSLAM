After installation and environment building is completed, one can follow the the below steps to train and test. 

#### Datasets
The data used for training are expected to be organized as follows:
```bash
Data_Path                # DIR_TO_TRAIN_DATASET
 ├──  train_dataset
 |      ├── cam.txt      #camera calibration parameters
 |      ├── 1.jpg
 |      ├── 2.jpg
 |      ├── ...
 ├──  validation_dataset     
 |      ├── cam.txt      #camera calibration parameters
 |      ├── 1.jpg
 |      ├── 2.jpg
 |      ├── ...
 ├──  train.txt #including the folder names for training dataset
 └──  val.txt   #including the folder names for validation dataset

```



#### Training

 One can start training by following commend:

```bash
CUDA_VISIBLE_DEVICES=0 python train.py DIR_TO_TRAIN_DATASET --name DIR_TO_MODELS
```

#### Testing

To test the PoseNet:

```bash
python test_vo.py  --pretrained-posenet DIR_TO_PRETRAINED_MODEL --dataset-dir DIR_TO_TEST_DATASET --output-dir DIR_TO_RESULTS
```
To test the DispNet:

```bash
python test_disp.py --pretrained-dispnet  DIR_TO_PRETRAINED_MODEL --dataset-dir DIR_TO_TEST_DATASET --output-dir DIR_TO_RESULTS
```

### Pretrained Models

Pretrained models for Endo-SfMLearner can be downloaded [here!](https://www.dropbox.com/s/92qjxy2uxvf599b/08-13-00%3A00.zip?dl=0)
