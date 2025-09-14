program ExecScripts;

uses
  System.StartUpCopy,
  FMX.Forms,
  uScripts in 'uScripts.pas' {Form1},
  uCliente in 'uCliente.pas' {Form2},
  uNotaFiscal in 'uNotaFiscal.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
