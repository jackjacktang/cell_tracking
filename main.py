# import the necessary packages
from skimage.segmentation import slic
from skimage.segmentation import mark_boundaries
from skimage.util import img_as_float
from skimage import io
from feature import *
import matplotlib.pyplot as plt
import argparse
import numpy as np

def main():
	parser = argparse.ArgumentParser(description='The arguments for cell tracking')
	parser.add_argument('--image', type=str, default=None, required=True, help='The path of input file')
	parser.add_argument("--seg", required = True, help = "The rough number of the segmentations")

	args = parser.parse_args()

	
	image = img_as_float(io.imread(args.image))
	img = io.imread(args.image)
	# print(t)
	print(image.shape)

	# apply SLIC and extract (approximately) the supplied number
	# of segments
	grey_image = np.dstack([image,image,image])
	numSegments = int(args.seg)
	segments = slic(grey_image, n_segments = numSegments, sigma = 5,compactness=0.1, enforce_connectivity=True)
	seg_size = np.unique(segments).size
	print('actual segments size: ', seg_size)

	total,max_intensity = intensity(img,segments,np.unique(segments).size)
	print(total)
	mean = np.sum(total)/seg_size
	print(mean)

	sort_max = np.sort(max_intensity)
	high_light = np.where(np.logical_or(max_intensity < sort_max[0.015*seg_size],max_intensity > sort_max[-0.015*seg_size]))

	# high_light = list(high_light)
	print('the number of highlighted points: ',high_light)

	# show the output of SLIC
	fig = plt.figure("Superpixels -- %d segments" % (numSegments))
	ax = fig.add_subplot(1, 1, 1)
	ax.imshow(mark_boundaries(img, segments))
	plt.axis("off")
	# print(np.argwhere(segments==37))
	print(type(high_light))
	print(high_light[0])
	for h in high_light[0]:
		x = []
		y = []
		# print(h)
		loc = np.argwhere(segments==h)
		# print(loc.size)
		x = loc[:,1]
		y = loc[:,0]
		# print(np.argwhere(segments==37))
		plt.plot(x,y,'ro')

	plt.show()


if __name__ == "__main__":
    main()