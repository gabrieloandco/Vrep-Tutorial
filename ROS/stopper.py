#!/usr/bin/env python

import roslib;roslib.load_manifest("my_stage")
import rospy
import sys
import tf
from geometry_msgs .msg import Twist
from sensor_msgs.msg import LaserScan
from math import tanh
from std_msgs.msg import Float32, Bool, Float32MultiArray



class Stopper():
    
    def __init__(self):
        
        rospy.init_node("stopper", anonymous=False) #Inicializa el nodo
        self.leftmotor = rospy.Publisher("/leftMotorSpeed",Float32) #Inicializa el publisher del motor izquierdo
        self.rightmotor = rospy.Publisher("/rightMotorSpeed",Float32) #Inicializa el publisher del motor derecho
        self.leftmotor.publish(0) #Publica un 0 en el motor izquierdo
        self.rightmotor.publish(0) #Publica un 0 en el motor derecho
        self.left = 0
        self.right = 0
        self.K = 2
        self.rightref = 2
        self.leftref = 1
        self.turn()
 
    def update_left(self, data):
        newleft = self.K*(self.leftref-data.data) 
        self.left = newleft
        print(newleft)

    def update_right(self, data):
        newright = self.K*(self.rightref-data.data) 
        self.right = newright
        print(newright)
  
    def call(self,data):
        print(data.data)

    def turn(self):
        self.left=8
        self.right=5
        while not rospy.is_shutdown():
            self.leftmotor.publish(self.left)
            self.rightmotor.publish(self.right)
            rospy.Subscriber("/sensorTrigger", Float32MultiArray, self.call) #Llama la funcion call para imprimir los datos del sensor
            rospy.Subscriber("/leftMotorSpeedPublisher", Float32, self.update_left) #Llama la funcion update_left para actualizar el valor de la izquierda
            rospy.Subscriber("/rightMotorSpeedPublisher", Float32, self.update_right) #Llama la funcion update_right para actualizar el valor de la derecha

def main(args):
    try:
        Stopper()
        rospy.spin() #python no termina el programa hasta que el nodo se cierre
    except KeyboardInterrupt:
        print "Finalizando Stopper."


if __name__ == '__main__':
    main(sys.argv)
