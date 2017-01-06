import skfmm
import numpy as np
from skimage import io
from skimage.util import img_as_float
import matplotlib.pyplot as plt

img = io.imread('cell.jpg',as_grey=True)
print(img.shape)
result = skfmm.distance(img, dx=0.25)
boundary = np.argwhere(result == 0)
print(boundary[:,1])
# fig, ax = plt.subplots()
fig = plt.imread('cell.jpg')
implot = plt.imshow(fig,cmap='gray')
plt.scatter(boundary[:,0], boundary[:,1], color='red')
plt.show()
# img[b]
