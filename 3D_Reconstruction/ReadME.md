# 3D Reconstruction and Evaluation
### Multiple Image Stitching

This codebase implements the system described in the paper:

 >    Automatic Panoramic Image Stitching using Invariant Features, 
 >    Matthew Brown and David G. Lowe
 >    [[PDF](http://matthewalunbrown.com/papers/ijcv2007.pdf)] [[Project webpage](http://matthewalunbrown.com/autostitch/autostitch.html)]
 
### Inpainting

The damaged, deteriorating parts of stitched images are filtered by OpenCV functions and photoshop [GIMP](https://www.gimp.org/downloads/). To inpaint the stitched result, 

```bash
python inpaint/mask.py --image <stitching_result_image_path>
python inpaint/inpainting.py --image <stitching_result_image_path> --mask <mask_image_path>
```

### Depth Acquisition

Tsai-Shah shape from shading method, EndoSfMLearner and SC-SfMLearner models were applied. 

### Point Cloud Data File Creation

To reconstruct .ply file, run the following instructions:  

```bash
run depth.m  % You can specify the path of stitched image to be used for reconstruction inside the depth.m file! 
python points.py 
run create_ply.m
```

### ICP Alignment

[Cloud Compare](https://www.danielgm.net/cc/) is used to align ground truth ply files acquired from 3D Scanner and reconstructed Point Cloud data. 

