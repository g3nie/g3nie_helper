# Code modified from Michael Guerzhoy of UofT 
# Thank you Michael for a great course

from pylab import *
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
import random
import time
from scipy.misc import imread
from scipy.misc import imresize
import matplotlib.image as mpimg
import os
from scipy.ndimage import filters
import urllib

def timeout(func, args=(), kwargs={}, timeout_duration=1, default=None):
    '''From:
    http://code.activestate.com/recipes/473878-timeout-function-using-threading/'''
    import threading
    class InterruptableThread(threading.Thread):
        def __init__(self):
            threading.Thread.__init__(self)
            self.result = None

        def run(self):
            try:
                self.result = func(*args, **kwargs)
            except:
                self.result = default

    it = InterruptableThread()
    it.start()
    it.join(timeout_duration)
    if it.isAlive():
        return False
    else:
        return it.result

testfile = urllib.URLopener()            

# Allowable extensions
extensions = ["jpeg", "jpg", "png","gif"]
i = 1
for line in open("no_singing.txt"):
    # if line is empty: skip
    current = line.split()
    if current == []:
        continue

    # current[0] -> name
    # current[1] -> number
    # current[2] -> bounding box
    # current[3] -> url
    filename = str(i) + '.png'

    timeout(testfile.retrieve, (line, "no_singing/" + filename), {}, 30)
    i = i + 1
