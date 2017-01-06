# import the necessary packages
from skimage.segmentation import slic
from skimage.segmentation import mark_boundaries
from skimage.util import img_as_float
from skimage import io
import matplotlib.pyplot as plt
import argparse
import numpy as np
 
# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True, help = "Path to the image")
args = vars(ap.parse_args())
 
# load the image and convert it to a floating point data type
image = img_as_float(io.imread(args["image"]))
print(image.shape)

# print(image)
 
# apply SLIC and extract (approximately) the supplied number
# of segments
image = np.dstack([image,image,image])
numSegments = 1000
segments = slic(image, n_segments = numSegments, sigma = 5)
print('actual segments size: ', np.unique(segments).size)
print(type(segments))
print(segments.shape)
print(segments)
 
# show the output of SLIC
fig = plt.figure("Superpixels -- %d segments" % (numSegments))
ax = fig.add_subplot(1, 1, 1)
ax.imshow(mark_boundaries(image, segments))
plt.axis("off")

# show the plots
plt.show()