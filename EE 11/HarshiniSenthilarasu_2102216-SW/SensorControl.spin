{
Name       : Harshini Senthilarasu
Student ID : 2102216
File       : SensorControl
Brief      : This file contains the functions for intialising the sensors and reading
             the values from the ultrasonic sensors and time of flights

             Functions that are being implemented are:
             1. Start(mainMSVal,mainToFAdd1, mainToFAdd2, mainUltraAdd1, mainUltraAdd2)
             2. SensorCore(mainToFAdd1, mainToFAdd2, mainUltraAdd1, mainUltraAdd2)
             3. StopCore
             4. Init_ToF
             5. Pause(ms)
}


CON
        'Pin numbers
        'Ultrasonic Pin Numbers
        'Ultra Front
        ultrascl1 = 6
        ultrasda1 = 7

        'Ultra Back
        ultrascl2 = 8
        ultrasda2 = 9

        'Ultra Left
        ultrascl3 = 16
        ultrasda3 = 17

        'Ultra Right
        ultrascl4 = 18
        ultrasda4 = 19


        'Time of Flight Pin Numbers
        'Tof Front
        tofscl1 = 0
        tofsda1 = 1
        tofgp1  = 14

        'Tof Back
        tofscl2 = 2
        tofsda2 = 3
        tofgp2  = 15
        tofadd  = $29              'tof1 and tof2 share the same memory address

VAR        'Global varibales
  long  cogID2, cogstack[64]
  long  _Ms_001

OBJ
  Ultra         : "EE-7_Ultra_v2.spin"
  ToF[2]        : "EE-7_ToF.spin"

PUB Start(mainMSVal, mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)
{Using the addresses inside the calling function allows the other cores to idenitfy
them. If these addresses are initialised under variable they will only be used in
this obj file and not in the other cores}

  _Ms_001 := mainMSVal   'stores number of milliseconds which will be used by Pause function

  StopCore   'ensures a shutdown of the previous Core is made before creating a new one

  'passing address of the parameters from main core to SensorCore
  cogID2 := cognew(SensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add), @cogStack)

  return

PUB StopCore        'used to ensure that Start function is not called more than once

  if cogID2          'if there is a cogID2
    cogstop(cogID2~) 'use cogstop for this number to do a shutdown

PUB SensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)
{Function updates main memory such that the Core 0 can use the parameters}

  'Initialisation of ultrasonic sensors
  Ultra.Init(ultrascl1,ultrasda1,0)    'Assigning and initialising the first element obj in EE-7_Ultra_v2
  Pause(50)
  Ultra.Init(ultrascl2,ultrasda2,1)    'Assigning and initialising the second element obj in EE-7_Ultra_v2
  Pause(5)
  Ultra.Init(ultrascl3,ultrasda3,2)    'Assigning and initialising the third element obj in EE-7_Ultra_v2
  Pause(50)
  Ultra.Init(ultrascl4,ultrasda4,3)    'Assigning and initialising the fourth element obj in EE-7_Ultra_v2

  Init_ToF 'Initialisation of both ToF sensors

  'Run and repeat readings
  repeat
    'replacing address of variables with values read from the sensors
    long[mainUltra1Add] := Ultra.readSensor(0)     'speed is 40Hz
    long[mainUltra2Add] := Ultra.readSensor(1)
    long[mainUltra3Add] := Ultra.readSensor(2)
    long[mainUltra4Add] := Ultra.readSensor(3)
    long[mainToF1Add]   := ToF[0].GetSingleRange(tofadd) 'speed is same as light
    long[mainToF2Add]   := ToF[1].GetSingleRange(tofadd)
    Pause(100)


PRI Init_ToF  | i    'initialisation of time of flights

  ToF[0].Init(tofscl1, tofsda1, tofgp1)
  ToF[0].ChipReset(1)
  Pause(1000)
  ToF[0].FreshReset(tofadd)
  ToF[0].MandatoryLoad(tofadd)
  ToF[0].RecommendedLoad(tofadd)
  ToF[0].FreshReset(tofadd)

  ToF[1].Init(tofscl2, tofsda2, tofgp2)
  ToF[1].ChipReset(1)
  Pause(1000)
  ToF[1].FreshReset(tofadd)
  ToF[1].MandatoryLoad(tofadd)
  ToF[1].RecommendedLoad(tofadd)
  ToF[1].FreshReset(tofadd)

  return

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return