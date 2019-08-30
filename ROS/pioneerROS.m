rosinit %inicializa el nodo
    
leftmotor = rospublisher('/leftMotorSpeed', 'std_msgs/Float32'); %publica un topico para el motor izquierdo 
rightmotor = rospublisher('/rightMotorSpeed', 'std_msgs/Float32'); %publica un topico para el motor derecho

vl = 8;
vr = 5;

leftrosmsg = rosmessage(leftmotor);
leftrosmsg.Data = vl;

send(leftmotor,leftrosmsg); %publica un valor para el motor izquierdo


rightrosmsg = rosmessage(rightmotor);
rightrosmsg.Data = vr;

send(rightmotor,rightrosmsg); %publica un valor para el motor derecho

sensor = rossubscriber('/sensorTrigger'); %crear un suscripcion al topico del sensor

leftmotor_suscriber = rossubscriber('/leftMotorSpeedPublisher'); %crear un suscripcion al topico del motor izquierdo
rightmotor_suscriber = rossubscriber('/rightMotorSpeedPublisher'); %crear un suscripcion al topico del motor derecho

sensordata = receive(sensor,10);

disp(sensordata.Data);

vrref = 2;
vlref = 1;
kp=2;

while 1
    vl = receive(leftmotor_suscriber,10); 
    vr = receive(rightmotor_suscriber,10);
    vl = kp*(vrref-vl.Data);
    vr = kp*(vlref-vr.Data);
    
    leftrosmsg.Data = vl;
    send(leftmotor,leftrosmsg); %publica un valor para el motor izquierdo
    rightrosmsg.Data = vr;
    send(rightmotor,rightrosmsg); %publica un valor para el motor derecho
    
    
end


rosshutdown %cierra el nodo
