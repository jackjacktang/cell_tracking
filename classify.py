import numpy as np
from sklearn import svm
from sklearn.naive_bayes import GaussianNB
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from preprocessing import *
from feature import *

def match(cell,size,pre_stats,next_stats):
	pre_img,pre_greyimg = readImage('1.jpg')
	next_img,next_greyimg = readImage('2.jpg')
	super1 = superpixel(pre_greyimg,2000)
	super2 = superpixel(next_greyimg,2000)
	# pre_stats = intensity(pre_img,super1,np.unique(super1).size).T
	# next_stats = intensity(next_img,super2,np.unique(super2).size).T
	pre_label = np.zeros(np.unique(super1).size)
	cell = [252,398,244,46,1152,1461,1459,1410,1869,895,946]
	for c in cell:
		pre_label[c] = 1
	# pre_label[252,398,244,173,46,1152,1461,1459,1410,1869,895,946] = 1
	print(pre_stats)
	print('shape',pre_stats.shape)
	svc = svm.LinearSVC()
	ada = AdaBoostClassifier(n_estimators=100)
	gnb = GaussianNB()
	dt = DecisionTreeClassifier()  #best method for the moment
	# next_label = dt.fit(pre_stats,pre_label).predict(pre_stats)
	next_label = svc.fit(pre_stats,pre_label).predict(next_stats)
	# next_label = gnb.fit(pre_stats,pre_label).predict(next_stats)
	# next_label = ada.fit(pre_stats,pre_label).predict(next_stats)
	# print(np.argwhere(next_label==1))
	print('number of cells after classifications: ',np.argwhere(next_label==1))
	return next_label

