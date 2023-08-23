{
Name       : Harshini Senthilarasu
Student ID : 2102216
File       : MecanumControl
Brief      : This file contains the functions that allow the mecanum wheels
             to move in 8 directions:
                1. Forward
                2. Forward Right
                3. Right
                4. Back Right
                5. Back
                6. Back Left
                7. Left
                8. Forward Left

             The fucntions that are being implemented are:
                1. Start(msVal, para)
                2. Init
                3. StopCore
                4. MotorCases(para)
                5. Forward
                6. Reverse
                7. ForwardRight
                8. ForwardLeft
                9. ReverseRight
                10. ReverseLeft
                11. Right
                12. Left
                13. RotateClock
                14. RotateAntiClock
}

CON

  'Roboclaw 1
  R1S1 = 3
  R1S2 = 2

  'Roboclaw 2
  R2S1 = 5
  R2S2 = 4

  'Simple Serial
  SSBaud = 57_600

  'Speeds
  Stop1 = 64
  Stop2 = 192

  Relax = 2000

VAR

  long cog1ID
  long cogstack[256]
  long _Ms_001

OBJ
  MD[2]      : "FullDuplexSerial.spin"

PUB Start(msVal, dir, speed)     'Core 1

  StopCore

  _Ms_001 := msVal     'stores number of milliseconds which will be used by Pause function
  cog1ID := cognew(Cases(dir, speed),@cogstack)    'cog that runs the Cases function

  return
PRI StopCore

  if cog1ID
    cogstop(cog1ID~)

PRI Init
  'Intialises the roboclaws in order of channel 2 and channel 1
  MD[0].Start(R1S2, R1S1, 0, SSBaud)   'roboclaw 1
  MD[1].Start(R2S2, R2S1, 0, SSBaud)   'roboclaw 2

PRI Cases(dir, speed)

  Init  'Intialises the motors
  repeat
    case long[dir]
      1:
        Right(speed)
        Stop
        Pause(200)
      2:
        Left(speed)
        Stop
        Pause(200)
      3:
        Forward(speed)
        Stop
        Pause(200)
      4:
        Reverse(speed)
        Stop
        Pause(200)
      5:
        ForwardRight(speed)
        Stop
        Pause(200)
      6:
        ReverseRight(speed)
        Stop
        Pause(200)
      7:
        ForwardLeft(speed)
        Stop
        Pause(200)
      8:
        ReverseLeft(speed)
        Stop
        Pause(200)
      9:
        RotateClockwise(speed)
        Stop
        Pause(200)
      10:
        RotateAntiClockwise(speed)
        Stop
        Pause(200)
      11:
        Stop

  StopAllMotors


PRI Forward(speed) | i                     'step 5% = 5/100*50

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1 + i) 'Motor1
    MD[0].Tx(Stop2 + i) 'Motor2
    MD[1].Tx(Stop1 + i) 'Motor3
    MD[1].Tx(Stop2 + i) 'Motor4
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1 + i)
    MD[0].Tx(Stop2 + i)
    MD[1].Tx(Stop1 + i)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)

PRI Reverse(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1 - i)
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 - i)
    MD[1].Tx(Stop2 - i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1 - i)
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 - i)
    MD[1].Tx(Stop2 - i)
    Pause(Relax)

PRI Right(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1 - i)
    MD[1].Tx(Stop2 - i)
    MD[0].Tx(Stop2 + i)
    MD[1].Tx(Stop1 + i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1 - i)
    MD[1].Tx(Stop2 - i)
    MD[0].Tx(Stop2 + i)
    MD[1].Tx(Stop1 + i)
    Pause(Relax)

PRI Left(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 - i)
    MD[0].Tx(Stop1 + i)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 - i)
    MD[0].Tx(Stop1 + i)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)

PRI ForwardRight(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1)
    MD[0].Tx(Stop2 + i)
    MD[1].Tx(Stop1 + i)
    MD[1].Tx(Stop2)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1)
    MD[0].Tx(Stop2 + i)
    MD[1].Tx(Stop1 + i)
    MD[1].Tx(Stop2)
    Pause(Relax)

PRI ReverseRight(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1)
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 - i)
    MD[1].Tx(Stop2)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1)
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 - i)
    MD[1].Tx(Stop2)
    Pause(Relax)

PRI ForwardLeft(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1 + i)
    MD[0].Tx(Stop2)
    MD[1].Tx(Stop1)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1 + i)
    MD[0].Tx(Stop2)
    MD[1].Tx(Stop1)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)

PRI ReverseLeft(speed) | i

  repeat i from 0 to long[speed] step 2
    MD[0].Tx(Stop1 - i)
    MD[0].Tx(Stop2)
    MD[1].Tx(Stop1)
    MD[1].Tx(Stop2 - i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 2
    MD[0].Tx(Stop1 - i)
    MD[0].Tx(Stop2)
    MD[1].Tx(Stop1)
    MD[1].Tx(Stop2 - i)
    Pause(Relax)

PRI RotateClockwise(speed) | i

  repeat i from 0 to long[speed] step 3
    Pause(100)
    MD[0].Tx(Stop1 + i)
    MD[0].Tx(Stop2 - i)
    MD[1].Tx(Stop1 + i)
    MD[1].Tx(Stop2 - i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 3
    MD[0].Tx(Stop1 + i)
    MD[0].TX(Stop2 - i)
    MD[1].Tx(Stop1 + i)
    MD[1].Tx(Stop2 - i)
    Pause(Relax)

PRI RotateAntiClockwise(speed)| i

  repeat i from 0 to long[speed] step 3
    MD[0].Tx(Stop1 - i)
    MD[0].Tx(Stop2 + i)
    MD[1].Tx(Stop1 - i)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)

  repeat i from long[speed] to 0 step 3
    MD[0].Tx(Stop1 - i)
    MD[0].TX(Stop2 + i)
    MD[1].Tx(Stop1 - i)
    MD[1].Tx(Stop2 + i)
    Pause(Relax)


PRI Stop

  MD[0].Tx(Stop1)
  MD[0].Tx(Stop2)
  MD[1].Tx(Stop1)
  MD[1].Tx(Stop2)

PRI StopAllMotors

  MD[0].Tx(0)
  MD[0].Tx(0)
  MD[1].Tx(0)
  MD[1].Tx(0)

PRI Pause(ms) | t

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return