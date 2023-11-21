# # -*- coding: utf-8 -*-
# """
# Created on Fri Nov 17 12:24:28 2023

# @author: XCEPT
# """

import turtle
import math
import random
import os

from PIL import Image 

screen = turtle.Screen()
screen.setup(1000,1000)
screen.title("Random Cloud - PythonTurtle.Academy")


# Set the turtle speed
turtle.speed(0)

# Set the initial position
turtle.penup()
#turtle.goto(-200, 0)
#turtle.bgcolor('white')
turtle.pensize(2)
turtle.pendown()
turtle.clear()

n = 500 # number of points on each ellipse
# X,Y is the center of ellipse, a is radius on x-axis, b is radius on y-axis
# ts is the starting angle of the ellipse, te is the ending angle of the ellipse
# P is the list of coordinates of the points on the ellipse
def ellipse(X, Y, a, b, ts, te, P):
    t = ts
    for i in range(n):
        x = a * math.cos(t)
        y = b * math.sin(t)
        P.append((x+X,y+Y))
        t += (te-ts)/(n-1)
    return P
     
# computes Euclidean distance between p1 and p2
def dist(p1,p2):
    return ((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2) ** 0.5

# draws an arc from p1 to p2 with extent value ext
def draw_arc(p1,p2,ext):
    turtle.up()
    turtle.goto(p1)
    turtle.seth(turtle.towards(p2))
    a = turtle.heading() 
    b = 360 - ext 
    c = (180  -b) / 2
    d = a-c
    e = d-90
    r = dist(p1, p2) / 2 / math.sin(math.radians(b / 2)) # r is the radius of the arc
    turtle.seth(e) # e is initial heading of the circle
    
    # Random border width
    width = random.randint(1, 5)
    turtle.pensize(width)
    
    turtle.down()
    turtle.circle(r, ext, 100)
    return (turtle.xcor(), turtle.ycor()) # returns the landing position of the circle
                                         # this position should be extremely close to p2 but may not be exactly the same
                                         # return this for continuous drawing to the next point


def cloud(P):
    step = n//10 # draw about 10 arcs on top and bottom part of cloud
    a = 0 # a is index of first point
    b = a + random.randint(step // 2, step * 2) # b is index of second point
    p1 = P[a] # p1 is the position of the first point
    
    # Random color
    p2 = P[b] # p2 is the position of the second point
    color = (random.random(), random.random(), random.random())
    turtle.fillcolor(color)
    turtle.begin_fill()
    p3 = draw_arc(p1,p2,random.uniform(70, 180)) # draws the arc with random extention
    while b < len(P) - 1:
        p1 = p3 # start from the end of the last arc 
        if b < len(P)/2: # first half is top, more ragged
            ext = random.uniform(70, 180)
            b += random.randint(step//2, step*2)
        else: # second half is bottom, more smooth
            ext = random.uniform(30,70)
            b += random.randint(step, step*2)
        b = min(b,len(P)-1) # make sure to not skip past the last point
        p2 = P[b] # second point
        p3 = draw_arc(p1,p2,ext) # draws an arc and return the end position
    turtle.end_fill()

def quit_window():
    turtle.bye()

turtle.onkey(quit_window, 'e')
turtle.listen()

save_path = os.path.dirname(os.path.abspath(__file__))

# Draw 24 numbers with random height, width, and color
for i in range(24):
    P = [] # starting from empty list
    
    # Random border width
    a = random.randint(50, 400) 
    b = a * 2 / 3
    
    P = ellipse(0, 0, a, b, 0, math.pi, P) # taller top half
    P = ellipse(0, 0, a, b / 4, math.pi, math.pi*2, P) # shorter bottom half
    cloud(P)
    
    # Save the picture with an incremented name
    file_name = f"picture_{i+1}"
    file_path = os.path.join(save_path, file_name + '.eps')
    
    # Get the turtle canvas
    canvas = turtle.getcanvas()
    
    # Save the canvas as an image file
    canvas.postscript(file=file_path, colormode='color')
    img = Image.open(file_name + '.eps') 
    img.save(file_name + '.jpg') 
    turtle.clear()

# Hide the turtle
turtle.hideturtle()

# Exit the turtle graphics window
turtle.done()
