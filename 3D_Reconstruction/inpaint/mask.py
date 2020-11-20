from imutils import contours
from skimage import measure
import numpy as np
import argparse
import imutils
import cv2

ap = argparse.ArgumentParser()
ap.add_argument("--image", required=True,
	help="path to the image file")
args = vars(ap.parse_args())

# load the image, convert it to grayscale, and blur it
image = cv2.imread(args["image"])
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (11, 11), 0)

#determine a threshold 
thresh = cv2.threshold(blurred, 150, 255, cv2.THRESH_BINARY)[1]
#thresh = cv2.erode(thresh, None, iterations=2)
#thresh = cv2.dilate(thresh, None, iterations=4)

cv2.imwrite(args["image"][:-4]+"_mask.jpg", thresh) 
