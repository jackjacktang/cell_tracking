import numpy as np
import math
from skimage.exposure import histogram

# return total,max,min intensity of corresponding superpixels
def intensity(img,segments,size):
	total_intensity = []
	mean_intensity = []
	max_intensity = []
	min_intensity = []
	sd = []
	# hist = []
	
	for i in range(size):
		segs = np.argwhere(segments == i)
		# print(segs)
		no_segs = segs.size
		temp = []
		for j in segs:
			temp.append(img[j[0]][j[1]])
		# sum = np.sum(temp)
		# total_intensity.append(sum)
		# mean_intensity.append(sum/no_segs)
		# max_intensity.append(np.max(temp))
		# min_intensity.append(np.min(temp))
		# sd.append(np.std(temp))
		# hist.append()
	total_intensity = np.asarray(total_intensity)
	max_intensity = np.asarray(max_intensity)
	min_intensity = np.asarray(min_intensity)
	mean_intensity = np.asarray(mean_intensity)
	sd = np.asarray(sd)
	print(total_intensity.shape,mean_intensity.shape,sd.shape,max_intensity.shape,min_intensity.shape)
	stats = np.vstack((mean_intensity,sd,max_intensity,min_intensity))
	# stats = np.vstack((max_intensity,min_intensity))
	print('stats shape',stats.shape)
	# return total_intensity,mean_intensity,sd,max_intensity,min_intensity
	return stats

# divide histogram into several parts
def intensity_hist(img,segments,size,gap):
	width = 1/gap*255
	result = []
	for i in range(size):
		segs = np.argwhere(segments == i)
		# print(segs)
		no_segs = segs.size
		temp = []
		for s in segs:
			temp.append(img[s[0]][s[1]])

		lower = 0
		region = []
		temp = np.asarray(temp)
		for j in range(0,gap):
			# region.append(np.count_nonzero((temp >= lower) & (temp <= lower+width)))
			region.append(((temp >= lower) & (temp <= lower+width)).sum())
			# print(temp,temp+width,np.count_nonzero((temp >= lower) & (temp <= lower+width)))
			lower += width
		region = np.asarray(region)
		if (len(result) == 0):
			result = region
		else:
			result = np.vstack((result,region))

	
	# print(hist)
	# hist = hist[0]
	# result = []
	# temp = 0
	# for i in range(0,gap):
	# 	result.append(np.count_nonzero((hist >= temp) & (hist <= temp+width)))
	# 	print(temp,temp+width,np.count_nonzero((hist >= temp) & (hist <= temp+width)))
	# 	temp += width


	# print(hist)
	# print(result)
	return result

# return p2a shape index of the superpixel
# p2a = PERIMETER * PERIMETER / (4π * AREA)
def p2a(img,segments,size):
	p2a = []
	for i in range(0,size):
		loc = np.argwhere(segments==i)
		region = np.count_nonzero(segments==i)
		perimeter = calculate_perimeter(segments,i,loc)
		# print('i',i)
		# print('per',perimeter)
		# print('region',region)
		temp = perimeter * perimeter / (4*math.pi*region)
		# print(temp)
		p2a.append(temp)
	return p2a



def calculate_perimeter(img,target,loc):
	total = 0
	for l in loc:
		neighbor = isEdge(img,l,target)
		if neighbor == True:
			total += 1
	return total

# True for edge, False for not edge
def isEdge(img,loc,target):
	x,y = img.shape
	l_x,l_y = loc
	n = 0
	if(loc[0]-1 >= 0):
		if img[loc[0]-1][loc[1]] == target:
			n += 1
	if(loc[1]-1 >= 0):
		if img[loc[0]][loc[1]-1] == target:
			n += 1
	if(loc[0]+1 < x):
		if img[loc[0]+1][loc[1]] == target:
			n += 1
	if(loc[1]+1 < y):
		if img[loc[0]][loc[1]+1] == target:
			n += 1

	if (n == 4):
		return False
	else:
		return True
	# return flag

