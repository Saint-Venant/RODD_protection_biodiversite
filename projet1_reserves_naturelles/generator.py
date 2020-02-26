#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 22 15:41:39 2020

@author: Guilhem
"""
import random

m=200
n=200
p=3
q=3

alpha1 =0.5
alpha2 = 0.5

cMin=0
cMax=10

alpha1 = [alpha1 for i in range(p)]
alpha2 = [alpha2 for i in range(q)]
alpha = alpha1+alpha2


pPresence = 0.3
proba = [[[0 for i in range(m)] for j in range (n)] for k in range (p+q)]
for i in range(m):
    for j in range (n):
        for k in range (p+q):
            if (random.random()<pPresence):
                proba [k][j][i] = int (random.uniform(0,5))/10.
                

c= [[0 for i in range(m)] for j in range (n)]
for i in range(m):
    for j in range (n):
        c[j][i]=int(random.uniform(cMin,cMax))

fileName = str(n) + "x" + str(m) + "-instance.dat"

file = open(fileName,"w")

file.write("m="+str(m)+";\n")
file.write("n="+str(n)+";\n")
file.write("p="+str(p)+";\n")
file.write("q="+str(q)+";\n")
file.write("alpha="+str(alpha)+";\n")

file.write("proba="+str(proba)+";\n")
file.write("c="+str(c)+";\n")

file.close()
