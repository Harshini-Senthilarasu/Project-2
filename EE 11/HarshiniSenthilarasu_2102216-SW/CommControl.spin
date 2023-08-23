{
Name       : Harshini Senthilarasu
Student ID : 2102216
File       : CommControl
Brief      : This file contains the functions for transmitting data and recieving data
             using the zigbee transmittor and receiver
                                          c
             Functions that are being implemented are:
             1.Start(msVal, Val)
             2.StopCore
             3.CommCommands(Val)
             4.Pause(ms)
}


CON
  'Pin numbers
  RxPin         = 21 'DOUT
  TxPin         = 20 'DIN
  CommBaud      = 9600

  'Comm Hex Keys
  CommStart     = $7A
  CommStopAll   = $AA
  CommForward   = $01
  CommReverse   = $02
  CommLeft      = $03
  CommRight     = $04

VAR
  long  cogID3, cogStack[128]
  long  rxValue, _Ms_001

OBJ
  Comm      : "FullDuplexSerial.spin"

PUB Start(msVal, Val)       'Core 3

   _Ms_001 := MSVal   'stores number of milliseconds which will be used by Pause function

  StopCore      'stops cog

  cogID3 := cognew(CommCommands(Val),@cogStack)   'cog that runs the ValueGiven function

  return

PUB StopCore       'Stops cog if cog3ID is called

  if cogID3
    cogstop(cogID3)

PUB CommCommands(Val)

  Comm.Start(TxPin,RxPin,0,CommBaud)    'terminal for your receiver and transmitter
  Pause(3000) 'wait 3 seconds

  repeat
    rxValue := Comm.Rx  '<- Wait at this statement for a byte
    'Comm.Str(String(13, "Hello"))
    'rxValue := Comm.RxCheck '<- Check if byte but not wait
    if (rxValue == CommStart)
      'Comm.Str(String(13, "Start"))
      repeat
        rxValue := Comm.Rx
        'rxValue := Comm.RxCheck
        case rxValue
          commForward:
            'Comm.Str(String(13, "Forward"))
          ' 'Motors move forward
            long[Val] := 1
          commReverse:
            'Motors move backwards
            'Comm.Str(String(13, "Reverse"))
            long[Val] := 2
          commLeft:
            'Turn vehicle to the left
            'Comm.Str(String(13, "Left"))
            long[Val] := 3
          commRight:
            'Turn vehicle to the right
            'Comm.Str(String(13, "Right"))
            long[Val] := 4
          commStopAll:
            'Stop all the motors from working
            'Comm.Str(String(13, "Stop"))
            long[Val] := 5

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return