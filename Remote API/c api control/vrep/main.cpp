#include <iostream>
#include <stdio.h>
#include <stdlib.h>

extern "C" {
#include "extApi.h"
#include "extApiPlatform.h"
}

using namespace std;
#define PI 3.14
int main()
{
    bool VERBOSE = true;
    int clientID = 0;
    int leftmotorHandle = 0;
    int rightmotorHandle = 0;
    int counter = 0;

    //! Todo Naresh: check to run this in parallel with real robot driver. May need to integrate my planner
    bool WORK = true;
    simxFinish(-1);                                                     //! Close any previously unfinished business
    clientID = simxStart((simxChar*)"127.0.0.1", 19000, true, true, 5000, 5);  //!< Main connection to V-REP
    if (clientID != -1)
    {
        cout << " Connection status to VREP: SUCCESS" << endl;
        simxInt syncho = simxSynchronous(clientID, 1);
        int start = simxStartSimulation(clientID, simx_opmode_oneshot_wait);
        int TEST1 = simxGetObjectHandle(clientID, "Pioneer_p3dx_leftMotor", &leftmotorHandle, simx_opmode_oneshot_wait);
        int TEST2 = simxGetObjectHandle(clientID, "Pioneer_p3dx_rightMotor", &rightmotorHandle, simx_opmode_oneshot_wait);

        if (VERBOSE)
        {
            cout << "Computed object handle: " << TEST1 << "  " << leftmotorHandle << endl;
            cout << "Computed object handle: " << TEST2 << "  " << rightmotorHandle << endl;
        }
        simxSetJointTargetVelocity(clientID, leftmotorHandle, 5, simx_opmode_oneshot_wait);
        simxSetJointTargetVelocity(clientID, rightmotorHandle, 1, simx_opmode_oneshot_wait);

        cout << "At Second Block..." << endl;

                //simxPauseCommunication(clientID,1);

                while (simxGetConnectionId(clientID)!=-1  && WORK)              ///**<  while we are connected to the server.. */
                {
                    simxSetJointTargetVelocity(clientID, leftmotorHandle, 7, simx_opmode_oneshot_wait);
                    simxSetJointTargetVelocity(clientID, rightmotorHandle, 2, simx_opmode_oneshot_wait);

                    if(counter>1000)
                        {
                        simxSetJointTargetVelocity(clientID, leftmotorHandle, 0.0, simx_opmode_oneshot_wait);
                        simxSetJointTargetVelocity(clientID, rightmotorHandle, 0.0, simx_opmode_oneshot_wait);
                        break;
                    }
                    counter++;
                }
    }
    else
    {
        cout << " Connection status to VREP: FAILED" << endl;
    }
    simxFinish(clientID);
    return clientID;
}
