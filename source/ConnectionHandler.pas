unit ConnectionHandler;

{$mode objfpc}{$H+}

interface

uses
  cthreads,
  SysUtils,
  Sockets,
  baseunix,
  Classes;

const
  Sal: TSockLen = SizeOf(TInetSockAddr);

type
  TThreaded = class(TThread)
  protected
    Client: longint;
    procedure Execute; override;
  end;



var
  S: longint;
  ServerAddr, ClientAddr: TInetSockAddr;
  sTime: string[255];
  sHeader: ansistring;
  sVersion: string[50];
  iPort: integer;
  sUserInput: string[10];
  Client: longint;
  OptVal: longint;
  PID: longint;
  Thread: TThreaded;



procedure runSocketServer;


implementation


procedure TThreaded.Execute;
var
  SIn, SOut: Text;
  ThisMoment : TDateTime;
  sDisplayTime: string[255];
begin
  sockets.Sock2Text(client, SIn, SOut);
  Reset(Sin);
  ReWrite(Sout);

  //Set Date
  ThisMoment := Now;
  sDisplayTime := FormatDateTime('hh:nn:sam/pm mm/dd/yy ',ThisMoment);
  Writeln(SOut, sDisplayTime);

  Write(SOut, '');
  flush(SOut);
  fpclose(client);

end;


//Code To Run Socket Server
procedure runSocketServer;

begin
  OptVal := 1;
  //Port
  iPort := 5000;

  S := fpsocket(AF_INET, SOCK_STREAM, 0);

  //Set Server Options
  ServerAddr.sin_port := htons(iPort);
  ServerAddr.sin_addr := Sockets.StrToNetAddr('0.0.0.0');
  ServerAddr.sin_family := AF_INET;

  sockets.fpsetsockopt(S, SOL_SOCKET, SO_REUSEADDR, @OptVal, sizeof(OptVal));

  //Display Output
  writeln('=============================================');
  writeln('|            xNTP Time Server               |');
  writeln('=============================================');
  writeln('               CTL-C to exit                 ');
  writeln();
  writeln('LOG:');
  writeln('Server started...');


  //Bind Socket
  fpbind(S, @ServerAddr, sizeof(ServerAddr));

  writeln('Binded to port: ' + iPort.ToString());


  //Listen
  while (fplisten(S, 0) <> -1) do
  begin
    writeln('Listening for connections...');

    client := fpaccept(S, @ClientAddr, @Sal);

    if (client <> -1) then
    begin

      writeln('New Connection: ');
      writeln('IP: ' + Sockets.NetAddrToStr(ClientAddr.sin_addr));
      Thread := TThreaded.Create(True);
      Thread.FreeOnTerminate := True;
      Thread.Client := client;
      Thread.Start;
    end;

  end;


  //Set Header & Ver
  sVersion := '1.0';
  sHeader := 'xNtp - NTP Server';

  halt;

end;

end.


