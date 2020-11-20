import csv
import numpy as np
import scipy
from scipy import io
x=[]
y=[]

filename="x.csv"
inf = csv.reader(open(filename,'r'))
for row in inf:
    x.append(float(row[0]))

filename="y.csv"
inf = csv.reader(open(filename,'r'))
for row in inf:
    y.append(float(row[0]))

rows, cols = (len(x), len(y)) 
z = [[0]*cols]*rows 
filename="z.csv"
inf = csv.reader(open(filename,'r'))
rows=[]
for row in inf:
    row_float=[float(item) for item in row]
    rows.append(row_float)

z=rows   
points=[]
for i in range(len(x)):
    for j in range(len(y)):
        points.append([x[i],y[j],z[i][j]])

scipy.io.savemat('test.mat', {'points': points})