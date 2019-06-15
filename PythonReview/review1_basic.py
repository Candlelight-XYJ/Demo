#name=input()
#name

import math
def quadratic(a,b,c):
    y = math.sqrt(b*b-4*a*c)
    x1=(-b+y)/(2*a)
    x2=(-b-y)/(2*a)
    return x1,x2

