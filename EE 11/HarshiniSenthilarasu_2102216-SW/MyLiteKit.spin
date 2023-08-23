{
Name       : Harshini Senthilarasu
Student ID : 2102216
File       : MyLiteKit
Brief      : This file contains the main file that controls the movements of the lite kit based on the
             following object files
             1.MotorControl
             2.SensorControl
             3.CommControl

             Functions that are being implemented are:
             1. Main function
             2. Pause(ms)

}

CON
        _clkmode     = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq     = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) + _xinfreq
        _Ms_001      = _ConClkFreq / 1_000


        'Creating safe values
        ultrasafe = 500  'safe value for ultrasonic sensors where value returned needs to be greater than this
        tofsafe   = 200  'safe value for tof sensors where value returned needs to be lesser than this

        mainMotorForward = 0
        mainMotorReverse = 1
        mainMotorLeft    = 2
        mainMotorRight   = 3
        mainMotorStopAll = 4
        mainMotor   = 200

VAR    'Global Variables
  long  mainToFVal1, mainToFVal2, mainUltraVal1, mainUltraVal2, rxVal
  long  Val
  long  para, speed

OBJ
  Term      : "FullDuplexSerial.spin"   'UART communication for debugging
  Sensor    : "SensorControl.spin"      '<-- Object / Blackbox
  Motor     : "MotorControl.spin"
  Comm      : "CommControl.spin"

PUB Main

  'Declaration and Initialisation
  Term.Start(31,30,0,115200)
  Pause(3000) 'wait 3 seconds

  {Main function declares variables and using the addresses, the function in Sensor
  Control will perform the actions and send back the values}
  'Comm.Start(_Ms_001, @Val)
  Sensor.Start(_Ms_001, @mainToFVal1, @mainToFVal2, @mainUltraVal1, @mainUltraVal2)
  Motor.Start(_Ms_001, @para, @speed)

  repeat
    Term.Str(String(13, "Ultrasonic 1 Reading: "))
    Term.Dec(mainUltraVal1)
    Term.Str(String(13, "Ultrasonic 2 Reading: "))
    Term.Dec(mainUltraVal2)
    Term.Str(String(13, "Ultrasonic 3 Reading: "))
    Term.Dec(mainUltraVal3)
    Term.Str(String(13, "Ultrasonic 4 Reading: "))
    Term.Dec(mainUltraVal4)
    Term.Str(String(13, "ToF 1 Reading: "))
    Term.Dec(mainToFVal1)
    Term.Str(String(13, "ToF 2 Reading: "))
    Term.Dec(mainToFVal2)
    Pause(300)
    Term.Tx(0)
  {
  repeat
    'If the values from sensors are within the limits...
    case Val
      1:                                      'Motors move forward
        'Term.Str(String(13,"Hello"))
        if (mainUltraVal1 > 300) and (mainToFVal1 < 150)
          'Term.Str(String(13,"Forward"))
          para := 0
          speed := 100
        else
          para := 4

      2:                      'Motors move reverse
        if (mainUltraVal2 > 300) and (mainToFVal2 < 150)
          'Term.Str(String(13,"Reverse"))
          para := 1
          speed := 100
        else
          para := 4

      3:                      'Lite Kit turns Left
        para := 2
        speed := 100



      4:                      'Lite Kit turns Right
        para := 3
        speed := 100

      5:                      'Lite Kit stops all motors
        para := 4
        speed := 100
 }
PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return