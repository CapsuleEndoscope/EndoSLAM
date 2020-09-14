import numpy as np
import cv2
import argparse
import imutils

ap = argparse.ArgumentParser()
ap.add_argument("--image", required=True,
	help="path to the image file")
ap.add_argument("--mask", required=True,
	help="path to the mask image file")
args = vars(ap.parse_args())

filename=args["image"]
maskname=args["mask"]
img = cv2.imread(filename)
mask = cv2.imread(maskname,0)

dst = cv2.inpaint(img,mask,24,cv2.INPAINT_TELEA)

cv2.imwrite(filename+"_result.jpg", dst) 