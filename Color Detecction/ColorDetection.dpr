program ColorDetection;

uses
  System.StartUpCopy,
  FMX.Forms,
  uColorDetection in 'uColorDetection.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
