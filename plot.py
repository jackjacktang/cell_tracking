import matplotlib.pyplot as plt
import mpld3
import numpy as np
from skimage.segmentation import mark_boundaries

def plot_cell(img,segments,high_light,img2,segments2,high_light2):
	fig = plt.figure(1)
	ax = fig.add_subplot(111)
	# print('shape',img.shape,img.shape,img[1].shape)
	ax.imshow(mark_boundaries(img, segments))
	plt.axis("off")
	scatter = []
	labels = []

	for h in high_light:
		x = []
		y = []
		# print(h)
		loc = np.argwhere(segments==h)
		# print(loc)
		# print(loc.size)
		loc = np.mean(loc,axis=0)
		# print(loc)
		x = loc[1]
		y = loc[0]
		# print(x,y)
		scatter.append(ax.scatter(x,y,s=50,c='red'))
		ax.annotate(h,(x,y))
		labels.append(h)
	# tooltip = mpld3.plugins.PointLabelTooltip(scatter,labels=labels)
	fig2 = plt.figure(2)
	ay = fig2.add_subplot(111)
	ay.imshow(mark_boundaries(img,segments))
	plt.axis("off")
	scatter = []
	labels = []

	for h in high_light2:
		x = []
		y = []
		# print(h)
		loc = np.argwhere(segments==h)
		# print(loc)
		# print(loc.size)
		loc = np.mean(loc,axis=0)
		# print(loc)
		x = loc[1]
		y = loc[0]
		# print(x,y)
		scatter.append(ay.scatter(x,y,s=50,c='red'))
		ay.annotate(h,(x,y))
		labels.append(h)
	plt.show()
