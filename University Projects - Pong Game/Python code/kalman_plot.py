# ==============================================================================
# -- IMPORTS -------------------------------------------------------------------
# ==============================================================================

import serial
import matplotlib.pyplot as plt

import numpy as np 
from   numpy import sin, cos

import pylab as py
import math
from   drawnow import *

# ==============================================================================
# -- PREPARATION  --------------------------------------------------------------
# ==============================================================================

rpy_plotcheck 			= 1
quaternion_plotcheck 	= 0

# ========================
# initializing empty lists
ROLL = []
PITCH= []
YAW  = []
W    = []
X    = []
Y    = []
Z    = []

ROLL_KALMAN 	= []
PITCH_KALMAN 	= []
YAW_KALMAN		= []
W_KALMAN 		= []
X_KALMAN 		= []
Y_KALMAN 		= []
Z_KALMAN 		= []
# ========================

arduinodata = serial.Serial('COM8',9600) 	#port name and baud rate

plt.ion() 									# initializing the user interface of pyplot

t = -1

# ==============================================================================
# -- FUNCTIONS -----------------------------------------------------------------
# ==============================================================================

def makeplotting():							# PLOT

	plt.ylabel('ACCX, ACCY, ACCZ, GYX, GYY, GYZ (°/sec)')
	plt.xlabel('Time')

	if 	rpy_plotcheck:
		plt.plot(ROLL, label=['ROLL'])
		plt.plot(PITCH, label=['PITCH'])
		plt.plot(YAW, label=['YAW'])
		plt.plot(ROLL_KALMAN, label=['ROLL-KALMAN'], linewidth=3)
		plt.plot(PITCH_KALMAN, label=['PITCH-KALMAN'], linewidth=3)
		plt.plot(YAW_KALMAN, label=['YAW-KALMAN'], linewidth=3)

	elif 	quaternion_plotcheck:
		plt.plot(W, label=['W'])
		plt.plot(X, label=['X'])
		plt.plot(Y, label=['Y'])
		plt.plot(Z, label=['W'])
		plt.plot(W_KALMAN, label=['W_KALMAN'], linewidth=3)
		plt.plot(X_KALMAN, label=['X_KALMAN'], linewidth=3)
		plt.plot(Y_KALMAN, label=['Y_KALMAN'], linewidth=3)
		plt.plot(Z_KALMAN, label=['Z_KALMAN'], linewidth=3)

	plt.legend()

	plt.xlim([max(0, t-500), t])


def rpy_to_rotmat(roll, pitch, yaw):
	R_roll 	= np.matrix([[1, 0, 0], [0, cos(roll), -sin(roll)], [0, sin(roll), cos(roll)]])
	R_pitch = np.matrix([[cos(pitch), 0, sin(pitch)], [0, 1, 0], [-sin(pitch), 0, cos(pitch)]])
	R_yaw	= np.matrix([[cos(yaw), -sin(yaw), 0], [sin(yaw), cos(yaw), 0], [0, 0, 1]])

	rotation_matrix = R_yaw*R_pitch*R_roll

	print(rotation_matrix)


def quat_to_rotmat(q0, q1, q2, q3):
	
	rotation_matrix = np.matrix([	[2*(q0**2 + q1**2) - 1, 2*(q1*q2 - q0*q3), 2*(q1*q3 + q0*q2)], 
									[2*(q1*q2 + q0*q3), 2*(q0**2 + q2**2) - 1, 2*(q2*q3 - q0*q1)], 
									[2*(q1*q3 - q0*q2), 2*(q2*q3 + q0*q1), 2*(q0**2 + q3**2) - 1]])

	print(rotation_matrix)


# ==============================================================================
# -- FILTERS -----------------------------------------------------------------
# ==============================================================================

def kalman(data):
	"""
		the data must be 1D and the dimension shoulh be equal to (2n+1)
	"""
	data = np.array(data)
	return float(np.sum(data)/np.size(data))

# ==============================================================================
# -- MAIN LOOP -----------------------------------------------------------------
# ==============================================================================


# ============================================
# temp values initilization 
temp_value 			= 15
roll_kalman_temp 	= np.zeros(temp_value)
pitch_kalman_temp 	= np.zeros(temp_value)
yaw_kalman_temp 	= np.zeros(temp_value)
w_kalman_temp 		= np.zeros(temp_value)
x_kalman_temp 		= np.zeros(temp_value)
y_kalman_temp 		= np.zeros(temp_value)
z_kalman_temp 		= np.zeros(temp_value)
# ============================================

while True:
	
	for k in range(10):
		t += 1
		while(arduinodata.inWaiting()==0):
			pass

		arduinostring=arduinodata.readline()
		arduinostring=str(arduinostring,encoding="utf-8")
		dataArray=arduinostring.split(',')  

		if t <= 48: #skip the first 20 lines 
			continue

		


		if    rpy_plotcheck:

			roll  = float(dataArray[0])
			pitch = float(dataArray[1])
			yaw   = float(dataArray[2])

			roll_kalman_temp[-t%temp_value] 	= roll 
			pitch_kalman_temp[-t%temp_value] 	= pitch 
			yaw_kalman_temp[-t%temp_value] 		= yaw 

			ROLL.append(roll)
			PITCH.append(pitch)
			YAW.append(yaw)

			ROLL_KALMAN.append(kalman(roll_kalman_temp))
			PITCH_KALMAN.append(kalman(pitch_kalman_temp))
			YAW_KALMAN.append(kalman(yaw_kalman_temp))


			rpy_to_rotmat(roll, pitch, yaw)

		elif    quaternion_plotcheck:
			w = float(dataArray[0])
			x = float(dataArray[1])
			y = float(dataArray[2])
			z = float(dataArray[3])

			W.append(w)
			X.append(x)
			Y.append(y)
			Z.append(z)

			quat_to_rotmat(w, x, y, z)

	drawnow(makeplotting) #plotting 
