# import libpyscan
import pyscan


print("PyScan module loaded successfully.")


# import numpy as np
import random



pts = [pyscan.WPoint(1.0, random.random(), random.random(), 1.0) for i in range(400)]
red, blue, max_region = pyscan.plant_halfplane(pts, .5, .1, .9)

