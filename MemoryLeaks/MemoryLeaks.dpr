program MemoryLeaks;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMemoryLeaks in 'uMemoryLeaks.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
