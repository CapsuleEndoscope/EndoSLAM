
from PIL import Image,ImageFilter
import cv2
import numpy as np
import matplotlib.pyplot as plt
import math
import argparse
import glob  

argPar = argparse.ArgumentParser(description='High Modified')

argPar.add_argument("--INPUT_PATH",required=True,help="input data path")
argPar.add_argument("--INPUT_FILE",required=True,help="input file name")
argPar.add_argument("--OUTPUT_PATH",required=True,help="output path")
argPar.add_argument("--OUTPUT_FILE",required=True,help="output file name")
argPar.add_argument("--IMAGE_SIZE",required=True,type=int, default=400,help="squre image with IMAGE_SIZE")

args = argPar.parse_args()
img_path = args.INPUT_PATH + args.INPUT_FILE
output_image_path = args.OUTPUT_PATH + args.OUTPUT_FILE
image_size = args.IMAGE_SIZE
print(filename)



#================================= OpenCV version ===============================

#generate vignette mask using Gaussian kernels
def vignette(image,kern_size=240):
    rows, cols = image.shape[:2]
    kernel_x = cv2.getGaussianKernel(cols,kern_size)
    kernel_y = cv2.getGaussianKernel(rows,kern_size)
    kernel = kernel_y * kernel_x.T
    mask = 255 * kernel / np.linalg.norm(kernel)
    output_vignette = np.copy(image)
    for k in range(3):
        for i in range(0,image_size):
            for j in range(0,image_size):
                if ((math.pow(i-image_size/2,2)+math.pow(j-image_size/2,2))<=math.pow(image_size/2,2)):
                    continue
                else:      
                    output_vignette[i][j][k] = output_vignette[i][j][k] * mask[i][j] # applying the mask to each channel in the input image
    return output_vignette

def cv2_blur_multiple(im,filter_size=5, amount=1):
    for i in range(amount):
        im = cv2.blur(im,(filter_size,filter_size)) #5x5 all ones matrix applied
    return im

def cv2_gaussianblur_multiple(img,filter_size=5, amount=5):
    for i in range(amount):
        img = cv2.GaussianBlur(img,(filter_size,filter_size),0)
        return img
    
def cv2_resize(img,width,height):
    img = cv2.resize(img,(width,height),interpolation = cv2.INTER_AREA)
    return img

def vignette2(image):
        
    # Store location of center pixel
    centerX = math.floor(len(image) / 2)
   
    centerY = math.floor(len(image[0]) / 2)
    rows, cols = image.shape[:2]
    # Iterate rows
    for x, row in enumerate(image):
        # Iterate columns
        for y, pixel in enumerate(row):
            # Determine scale (rate of fade)
            scale = darkenPercent(centerX, centerY, x, y)            
            
            # Iterate colors
            for i in [0,1,2]:
                image[x][y][i] = image[x][y][i] * scale
                
    return image

def darkenPercent(x1, y1, x2, y2):
    
    # Distance Formula: Distance in pixels between 2 points
    distanceToCenterPixel = math.sqrt(math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2))
    
    # Area un-effected by shading
    if ((math.pow(x2-image_size/2,2)+math.pow(y2-image_size/2,2))<=math.pow(image_size/2,2)):
        offset = 1
    
    elif (math.pow(200,2)<(math.pow(x2-image_size/2,2)+math.pow(y2-image_size/2,2))<=math.pow(216,2)):
        offset = 0.8
    
    elif (math.pow(216,2)<(math.pow(x2-image_size/2,2)+math.pow(y2-image_size/2,2))<=math.pow(232,2)):
        offset = 0.6
    
    elif (math.pow(232,2)<(math.pow(x2-image_size/2,2)+math.pow(y2-image_size/2,2))<=math.pow(248,2)):
        offset = 0.4
    
    elif (math.pow(248,2)<(math.pow(x2-image_size/2,2)+math.pow(y2-image_size/2,2))<=math.pow(264,2)):
        offset = 0.2
    
    elif (math.pow(264,2)<(math.pow(x2-image_size/2,2)+math.pow(y2-image_size/2,2))):
        offset = 0

    # Calculate float (Scale by the max distance - x1 in this case)
    result = (1 + offset - (distanceToCenterPixel / x1))
    # Ensure result is within scaling limits.
    if result < 0:
        return 0
    elif result > 1:
        return 1
    else:
        return result
    
def crop(file):
    im = Image.open(file)
    left = 80
    top = 0
    right = 560
    bottom = 480
    b=(left,top,right,bottom)
    c_i=im.crop(box=b)
    print(c_i.size)
    c_i.save(file, "JPEG") 
    
 

img_cntr = 0 

for img in sorted(glob.glob(img_path)):    
    #crop(img)
    img2 = cv2.imread(img)   
    im2 = vignette(cv2_gaussianblur_multiple(cv2_resize(img,image_size,image_size)),100)
    result = vignette2(im2)
    cv2.imwrite(output_image_path+str(img_cntr), result) 
    img_cntr += 1

