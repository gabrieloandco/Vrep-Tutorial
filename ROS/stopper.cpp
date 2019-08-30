#include "ros/ros.h"
#include "std_msgs/Float32.h"

#include <sstream>

void chatterCallback(const std_msgs::String::ConstPtr& msg)
{
  ROS_INFO("I heard: [%s]", msg->data.c_str());
}



int main(int argc, char **argv)
{
  ros::init(argc, argv, "stopper"); //inicializa el nodo

  ros::NodeHandle n; //define el handle del nodo

  ros::Publisher left_motor = n.advertise<std_msgs::Float32>("/leftMotorSpeed", 1000); //publica un topico para el motor izquierdo
  ros::Publisher right_motor = n.advertise<std_msgs::Float32>("/rightMotorSpeed", 1000); //publica un topico para el motor derecho

 

  ros::Rate loop_rate(10);

  int count = 0;
  while (ros::ok())
  {
    std_msgs::Float32 msg1; //se define un mensaje como del tipo float32
    std_msgs::Float32 msg2; //se define un mensaje como del tipo float32
    msg1=8;
    msg2=5;


    left_motor.publish(msg1);
    right_motor.publish(msg2);

    ros::Subscriber sub = n.subscribe("/sensorTrigger", 1000, chatterCallback); //se llama la funcion para imprimir los datos del sensor
    ros::Subscriber sub = n.subscribe("/leftMotorSpeedPublisher", 1000, chatterCallback); //se llama la funcion para imprimir los datos del motor izquierdo
    ros::Subscriber sub = n.subscribe("/rightMotorSpeedPublisher", 1000, chatterCallback); //se llama la funcion para imprimir los datos del motor derecho


    ros::spinOnce();

    loop_rate.sleep();
  }


  return 0;
}
