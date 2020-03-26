from skimage import io
from skimage.util import img_as_float
import numpy as np
from skimage.segmentation import slic
from skimage.segmentation import mark_boundaries

def readImage(file):
	image = img_as_float(io.imread(file))
	img = io.imread(file)
	grey_img = np.dstack([image,image,image])
	return img,grey_img

def superpixel(grey_img,num):
	return slic(grey_img, n_segments = num, sigma = 5,compactness=0.1, enforce_connectivity=True)