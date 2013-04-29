import numpy as np 
NAME = "../../data/P1_1_1_p06.csv"
data = np.loadtxt(NAME)
print data.shape
data = np.reshape(data, ())
print data[0]
