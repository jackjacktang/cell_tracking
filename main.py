# import the necessary packages
from skimage.segmentation import slic
from skimage.segmentation import mark_boundaries
from skimage.util import img_as_float
from skimage import io
import matplotlib.pyplot as plt
import argparse
import numpy as np

def main():
	parser = argparse.ArgumentParser(description='The arguments for cell tracking')
	parser.add_argument('--file', type=str, default=None, required=True, help='The path of input file')


	args = parser.parse_args()
	print(args.file)

if __name__ == "__main__":
    main()