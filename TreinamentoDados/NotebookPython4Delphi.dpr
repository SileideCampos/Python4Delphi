program NotebookPython4Delphi;

uses
  System.StartUpCopy,
  FMX.Forms,
  uScripts in 'uScripts.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
