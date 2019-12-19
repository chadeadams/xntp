unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, baseunix, ConnectionHandler;

procedure main();


implementation

procedure main();

begin
  ConnectionHandler.runSocketServer;
  halt;

end;

end.

