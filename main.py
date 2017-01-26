# import the necessary packages
from skimage.segmentation import slic
from skimage.exposure import histogram
# from skimage.util import img_as_float
# from skimage import io
from feature import *
from preprocessing import *
from classify import *
from plot import*
import matplotlib.pyplot as plt
import argparse
import numpy as np
import mpld3
# np.set_printoptions(threshold=np.inf)

def main():
	parser = argparse.ArgumentParser(description='The arguments for cell tracking')
	parser.add_argument('--image', type=str, default=None, required=True, help='The path of input file')
	parser.add_argument("--seg", required = True, help = "The rough number of the segmentations")

	args = parser.parse_args()

	
	# image = img_as_float(io.imread(args.image))
	# img = io.imread(args.image)
	# # print(t)
	# print(image.shape)

	# # apply SLIC and extract (approximately) the supplied number
	# # of segments
	# grey_image = np.dstack([image,image,image])

	img,grey_img = readImage(args.image)
	img2,grey_img2 = readImage('2.jpg')
	numSegments = int(args.seg)
	segments = slic(grey_img, n_segments = numSegments, sigma = 5,compactness=0.1, enforce_connectivity=True)
	segments2 = slic(grey_img2, n_segments = numSegments, sigma = 5,compactness=0.1, enforce_connectivity=True)
	seg_size = np.unique(segments).size
	seg_size2 = np.unique(segments2).size
	print('actual segments size: ', seg_size,np.max(segments))
	print(segments)

	# print(histogram(img2))
	stats = intensity_hist(img,segments,seg_size,20)
	stats2 = intensity_hist(img2,segments2,seg_size2,20)

	result_label = match(895,seg_size,stats,stats2)
	print(result_label)
	print(np.count_nonzero(result_label==1))

	# stats = intensity(img,segments,seg_size)
	# stats2 = intensity(img2,segments2,seg_size2)
	# shape_index = p2a(img,segments,seg_size)


	# print(stats)
	# sort_max = np.sort(stats[2])
	# high_light = np.argwhere(np.logical_or(stats[2] < sort_max[0.015*seg_size],stats[2] > sort_max[-0.015*seg_size]))
	# sort_max = np.sort(stats2[1])
	# high_light2 = np.argwhere(np.logical_or(stats2[1] < sort_max[0.015*seg_size],stats2[1] > sort_max[-0.015*seg_size]))
	# high_light = np.array([398,716,1152,1963])
	# sort_index = np.sort(shape_index)
	# high_light = np.where(np.logical_or(shape_index < sort_index[0.015*seg_size],shape_index > sort_index[-0.015*seg_size]))

	# print('the number of highlighted points: ',high_light.shape)


	# show the output of SLIC
	plot_cell(img,segments,np.argwhere(result_label==1),img2,segments2,np.argwhere(result_label==1))


def onpick3(event):
	ind = event.ind
	print('onpick3 scatter:', ind, np.take(x, ind), np.take(y, ind))

if __name__ == "__main__":
    main()