After installation and environment building is completed, one can follow the the below steps to train and test. 

#### Training

 To use the Endo-SfMLearner, you will need to build the environment by following commend:

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
