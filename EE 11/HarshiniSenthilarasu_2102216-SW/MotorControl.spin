{
Name       : Harshini Senthilarasu
Student ID : 2102216
File       : MotorControl
Brief      : This file contains the functions that allow the motors to move
             forward, reverse, right and left

             The fucntions that are being implemeneted are:
             1. Init(msVal,para)
             2. AllMotors(msVal,para)
             3. MotorsInit
             4. StopCore
             5. StopAllMotors
             6. Forward
             7. Reverse
             8. TurnRight
             9. Turnleft
             10. Pause(ms)
}


CON
        Motor1 = 10
        Motor2 = 11
        Motor3 = 12
        Motor4 = 13

        Motor1Zero = 1490
        Motor2Zero = 1490
        Motor3Zero = 1480
        Motor4Zero = 1480

VAR

  long Init1[64],cog1ID, _Ms_001

OBJ
   motors      : "Servo8Fast_vZ2.spin"
   'Term      : "FullDuplexSerial.spin"

PUB Start(msVal,para,speed)    'Core 2


  _Ms_001 := msVal      'takes in the Ms value
  StopCore              'stops cog
  cog1ID := cognew(AllMotors(para, speed),@Init1)     'cog that runs the AllMotors function
  'return

PUB AllMotors(para, speed)

  MotorsInit           'Initialising the motors
  'using case condition to select the parameter required which calls a specific motorcontrol function
  repeat
    case long[para]
      0:
        Motors.Set(motor1, motor1Zero + long[speed])
        Motors.Set(motor2, motor2Zero + long[speed])
        Motors.Set(motor3, motor3Zero + long[speed])
        Motors.Set(motor4, motor4Zero + long[speed])
      1:
        Motors.Set(motor1, motor1Zero - long[speed])
        Motors.Set(motor2, motor2Zero - long[speed])
        Motors.Set(motor3, motor3Zero - long[speed])
        Motors.Set(motor4, motor4Zero - long[speed])
      2:
        Motors.Set(motor1, motor1Zero - long[speed])
        Motors.Set(motor2, motor2Zero + long[speed])
        Motors.Set(motor3, motor3Zero - long[speed])
        Motors.Set(motor4, motor4Zero + long[speed])
      3:
        Motors.Set(motor1, motor1Zero + long[speed])
        Motors.Set(motor2, motor2Zero - long[speed])
        Motors.Set(motor3, motor3Zero + long[speed])
        Motors.Set(motor4, motor4Zero - long[speed])
      4:
        Motors.Set(motor1, Motor1Zero)
        Motors.Set(motor2, Motor2Zero)
        Motors.Set(motor3, Motor3Zero)
        Motors.Set(motor4, Motor4Zero)


PUB MotorsInit              'Function that inititalises the motors

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(100)

PUB StopCore   'Stops the cog from running if cog2ID is called

  if cog1ID
   cogstop(cog1ID~)


PUB StopAllMotors    'Function sets the motors to its zero value speed such that they stop

  Motors.Set(motor1, Motor1Zero)
  Motors.Set(motor2, Motor2Zero)
  Motors.Set(motor3, Motor3Zero)
  Motors.Set(motor4, Motor4Zero)

PUB Forward(Val)   'Function allows motors to move forward at increments of 10 from 0 to 200

  repeat
    Motors.Set(motor1, motor1Zero + long[Val])
    Motors.Set(motor2, motor2Zero + long[Val])
    Motors.Set(motor3, motor3Zero + long[Val])
    Motors.Set(motor4, motor4Zero + long[Val])
    Pause(100)


PUB Reverse(Val)    'Function allows motors to move backwards at increments of 10 from 0 to 200

  repeat
    Motors.Set(motor1, motor1Zero - long[Val])
    Motors.Set(motor2, motor2Zero - long[Val])
    Motors.Set(motor3, motor3Zero - long[Val])
    Motors.Set(motor4, motor4Zero - long[Val])
    Pause(100)



PUB TurnRight(Val)  'Function allows motors to turn rught at increments of 9 from 0 to 150

  repeat
    Motors.Set(motor1, motor1Zero - long[Val])
    Motors.Set(motor2, motor2Zero + long[Val])
    Motors.Set(motor3, motor3Zero - long[Val])
    Motors.Set(motor4, motor4Zero + long[Val])
    Pause(100)


PUB Turnleft(Val)   'Function allows motors to turn left at increments of 9 from 0 to 150

  repeat
    Motors.Set(motor1, motor1Zero + long[Val])
    Motors.Set(motor2, motor2Zero - long[Val])
    Motors.Set(motor3, motor3Zero + long[Val])
    Motors.Set(motor4, motor4Zero - long[Val])
    Pause(100)

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return