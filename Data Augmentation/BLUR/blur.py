from PIL import Image,ImageFilter
import cv2
import numpy as np
import math
import argparse
import glob  

argPar = argparse.ArgumentParser(description='High Modified')
argPar.add_argument("--INPUT_PATH",required=True,help="input data path")
argPar.add_argument("--OUTPUT_PATH",required=True,help="output path")
argPar.add_argument("--BLUR_TYPE",required=True,type=str, default=400,help="Gaussian or Blur")
argPar.add_argument("--FILTERING_COUNT",required=False,type=int,default=1,help="the integer defining filtering times")
argPar.add_argument("--FILTER_SIZE",required=False,type=int,default=3,help="the integer defining filtering times")
args = argPar.parse_args()

input_path = args.INPUT_PATH
output_folder_name = args.OUTPUT_PATH
blur_type = args.BLUR_TYPE
amount = args.FILTERING_COUNT
filter_size = args.FILTER_SIZE

def cv2_blur_multiple(im,filter_size=5, amount=amount):
    for i in range(amount):
        im = cv2.blur(im,(filter_size,filter_size)) #5x5 all ones matrix applied
    return im

def cv2_gaussianblur_multiple(img,filter_size=5, amount=amount):
    for i in range(amount):
        img = cv2.GaussianBlur(img,(filter_size,filter_size),0)
        return img
        
img_cntr = 0

if blur_type == "Gaussian":
    for frame in sorted(glob.glob(input_path)):   
	img = cv2.imread(frame) 
	gauss_blured = cv2_gaussianblur_multiple(img) 
        cv2.imwrite(output_folder_name+str(img_cntr)+".png",gauss_blured) 
        img_cntr += 1

elif blur_type == "Blur":
    for frame in sorted(glob.glob(input_path)):   
	img = cv2.imread(frame)  
	blured = cv2_blur_multiple(img) 
        cv2.imwrite(output_folder_name+str(img_cntr)+".png", blured) 
        img_cntr += 1
else:
    print("Please enter a valid Blur type: Gaussian or Blur.")
