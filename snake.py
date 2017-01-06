import numpy as np
import matplotlib.pyplot as plt
from skimage.color import rgb2gray
from skimage import data
from skimage.filters import gaussian
from skimage.segmentation import active_contour
from skimage import io

# Test scipy version, since active contour is only possible
# with recent scipy version
import scipy
scipy_version = list(map(int, scipy.__version__.split('.')))
new_scipy = scipy_version[0] > 0 or \
            (scipy_version[0] == 0 and scipy_version[1] >= 14)

img = io.imread('cell.jpg')
img = rgb2gray(img)

s = np.linspace(0, 2*np.pi, 400)
x = 220 + 100*np.cos(s)
y = 100 + 100*np.sin(s)
init = np.array([x, y]).T


snake = active_contour(gaussian(img, 3),init, alpha=0.015, beta=10, gamma=0.001,max_iterations=10)

fig = plt.figure(figsize=(7, 7))
ax = fig.add_subplot(111)
plt.gray()
ax.imshow(img)
ax.plot(init[:, 0], init[:, 1], '--r', lw=3)
ax.plot(snake[:, 0], snake[:, 1], '-b', lw=3)
ax.set_xticks([]), ax.set_yticks([])
ax.axis([0, img.shape[1], img.shape[0], 0])

plt.show()