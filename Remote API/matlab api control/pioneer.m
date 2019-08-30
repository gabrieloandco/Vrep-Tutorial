vrep=remApi('remoteApi');
vrep.simxFinish(-1);

clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

if (clientID>-1)
    disp('Connected')
    %Handle
    [returnCode,left_Motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_leftMotor',vrep.simx_opmode_blocking);
    [returnCode,right_Motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor',vrep.simx_opmode_blocking);
    [returnCode,front_Sensor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_ultrasonicSensor5',vrep.simx_opmode_blocking);
    [returnCode,camera]=vrep.simxGetObjectHandle(clientID,'Vision_sensor',vrep.simx_opmode_blocking);
    
    %Other Code
    vl = 10;
    vr = 5;
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,vl,vrep.simx_opmode_blocking);
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,vr,vrep.simx_opmode_blocking);
    [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_streaming);
    [returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_streaming);
    
    tic
    for i=1:20
       [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_buffer);
       [returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_buffer);
       
       %imshow(image)
       disp(toc)
       disp(norm(detectedPoint));
       pause(0.1);
    end
    
    while 1
        vrefr = 2;
        vrefl = 1;
        kp = 1.5;
        var = 0.5;
        vr = vr+ var*randn(1,1);
        vl = vl+ var*randn(1,1);
        vr = kp*(vrefr-vr);
        vl = kp*(vrefr-vl);
        [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,vrefl,vrep.simx_opmode_blocking);
        [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,vrefr,vrep.simx_opmode_blocking);
        
    end
    
    %[returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
    
    vrep.simxFinish(-1);
end

vrep.delete();
    