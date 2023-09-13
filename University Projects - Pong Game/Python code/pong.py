
# ==============================================================================================
# -- IMPORTS -----------------------------------------------------------------------------------
# ==============================================================================================



from vpython import * 

import serial
import matplotlib.pyplot as plt

import numpy as np 
from   numpy import sin, cos

import pylab as py
import math
from   drawnow import *



# ==============================================================================================
# -- ARDUINO PREP ------------------------------------------------------------------------------
# ==============================================================================================



arduinodata = serial.Serial('COM8',9600) 	#port name and baud rate

t = -1



# ==============================================================================================
# -- FILTERS -----------------------------------------------------------------------------------
# ==============================================================================================



def kalman(data):
	"""
		the data must be 1D and the dimension shoulh be equal to (2n+1)
	"""
	data = np.array(data)
	return float(np.sum(data)/np.size(data))



# ==============================================================================================
# -- CONSTANTS ---------------------------------------------------------------------------------
# ==============================================================================================



# ============================================
# define simulation constants 
room_x				= 12 
room_y				= 10
room_z 				= 16
wall_thickness		= 0.5
wall_color 			= vector(1, 1, 1)
wall_opacity		= 0.8 
front_opacity 		= 0.7
marble_radius 		= 0.5
ball_color 			= vector(0, 0, 1)
ball_color_attack	= vector(1, 0, 0)
racket_color 		= vector(0, 1, 0)
racket_speed 		= 0.3

racket_size 		= vector(room_x, room_y, wall_thickness)
# ============================================

# ============================================
# temp values initilization 
temp_value 			= 5
roll_kalman_temp 	= np.zeros(temp_value)
pitch_kalman_temp 	= np.zeros(temp_value)
yaw_kalman_temp 	= np.zeros(temp_value)
# ============================================



# ==============================================================================================
# -- ROOM DEFINITION ---------------------------------------------------------------------------
# ==============================================================================================



# making the box 
my_floor 	= box(size=vector(room_x, wall_thickness, room_z), pos=vector(0, -room_y/2, 0), color=wall_color, opacity=wall_opacity)
my_ceiling 	= box(size=vector(room_x, wall_thickness, room_z), pos=vector(0, room_y/2, 0), color=wall_color, opacity=wall_opacity)
left_wall 	= box(size=vector(wall_thickness, room_y, room_z), pos=vector(-room_x/2, 0, 0), color=wall_color, opacity=wall_opacity)
right_wall 	= box(size=vector(wall_thickness, room_y, room_z), pos=vector(+room_x/2, 0, 0), color=wall_color, opacity=wall_opacity)
back_wall 	= box(size=vector(room_x, room_y, wall_thickness), pos=vector(0, 0, -room_z/2), color=wall_color, opacity=wall_opacity)
racket	 	= box(size=racket_size, pos=vector(0, 0, +room_z/2), color=racket_color, opacity=front_opacity)

# making the ball
marble = sphere(color=ball_color, radius=marble_radius)

# assigning marble speed
marble_x 	= 0
marble_y 	= 0
marble_z 	= 0

delta_x		= 0.1
delta_y 	= 0.1
delta_z 	= -0.1


racket_speed_x = 0
racket_speed_y = 0



# ==============================================================================================
# -- MAIN LOOP ---------------------------------------------------------------------------------
# ==============================================================================================



# start the loop 
while True:

	#reset the game
	if marble_z > room_z/2:
		break

	t += 1

	# reading the data from arduino
	while(arduinodata.inWaiting()==0):
		pass

	arduinostring=arduinodata.readline()
	arduinostring=str(arduinostring,encoding="utf-8")
	dataArray=arduinostring.split(',')  

	# skip the first few lines 
	if t <= 20: 
		continue

	# current roll, pitch and yaw
	roll  = float(dataArray[0])
	pitch = float(dataArray[1])
	yaw   = float(dataArray[2])

	# kalman implemented
	roll_kalman_temp[-t%temp_value] 	= roll 
	pitch_kalman_temp[-t%temp_value] 	= pitch 
	yaw_kalman_temp[-t%temp_value] 		= yaw 

	# movement from arduino kit to the racket 
	if roll_kalman_temp[int((temp_value-1)/2)] > 5:
		racket_speed_x = -racket_speed
	if roll_kalman_temp[int((temp_value-1)/2)] < -5:
		racket_speed_x = +racket_speed
	if  (roll_kalman_temp[int((temp_value-1)/2)] < 5) and (roll_kalman_temp[int((temp_value-1)/2)] > -5):
		racket_speed_x = 0

	if pitch_kalman_temp[int((temp_value-1)/2)] > 5:
		racket_speed_y = +racket_speed
	if pitch_kalman_temp[int((temp_value-1)/2)] < -5:
		racket_speed_y = -racket_speed
	if  (pitch_kalman_temp[int((temp_value-1)/2)] < 5) and (pitch_kalman_temp[int((temp_value-1)/2)] > -5):
		racket_speed_y = 0

	marble_x = marble_x + delta_x
	marble_y = marble_y + delta_y
	marble_z = marble_z + delta_z

	racket.pos.x = racket.pos.x + racket_speed_x
	racket.pos.y = racket.pos.y + racket_speed_y

	# collision detection 
	if ((marble_x + marble_radius)>(room_x/2 - wall_thickness/2)) or ((marble_x - marble_radius)<(-room_x/2 + wall_thickness/2)):
		delta_x = -delta_x

	if ((marble_y + marble_radius)>(room_y/2 - wall_thickness/2)) or ((marble_y - marble_radius)<(-room_y/2 + wall_thickness/2)):
		delta_y = -delta_y

	if ((marble_z - marble_radius)<(-room_z/2 + wall_thickness/2)):
		delta_z = -delta_z

	# collision with racket
	is_marbel_in_front_of_racket = (marble_x > racket.pos.x - racket_size.x/2) and (marble_x < racket.pos.x + racket_size.x/2) and (marble_y > racket.pos.y - racket_size.y/2) and (marble_y <racket.pos.y + racket_size.y/2)

	if  ((marble_z + marble_radius)>(room_z/2 - wall_thickness/2)) and is_marbel_in_front_of_racket:
		delta_z = -delta_z

	# change color when near on attack mode
	if delta_z > 0:
		marble.color = ball_color_attack
	elif delta_z <= 0: 
		marble.color = ball_color

	# update the marble position
	marble.pos = vector(marble_x, marble_y, marble_z)


