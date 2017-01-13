import numpy as np

# return total,max,min intensity of corresponding superpixels
def intensity(img,segments,size):
	total_intensity = []
	max_intensity = []
	
	for i in range(size):
		segs = np.argwhere(segments == i)
		# print(segs)
		no_segs = segs.size
		total = 0
		max = 0
		temp = []
		for j in segs:
			# print(j[0],j[1])
			# print(img[j[0]][j[1]])
			temp.append(img[j[0]][j[1]])
			# total_intensity += img[j[0]][j[1]]
			# print(total_intensity)
		total= np.sum(temp)
		max = np.max(temp)
		total_intensity.append(total)
		max_intensity.append(max)
	total_intensity = np.asarray(total_intensity)
	max_intensity =np.asarray(max_intensity)
	return total_intensity,max_intensity

