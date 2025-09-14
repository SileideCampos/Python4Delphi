unit uColorDetection;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Colors, FMX.Controls.Presentation, PythonEngine,
  FMX.PythonGUIInputOutput;

type
  TForm1 = class(TForm)
    pnlInfo: TPanel;
    ColorButton: TColorButton;
    lblRGB: TLabel;
    edtRGB: TEdit;
    mPythonCode: TMemo;
    pnlExecuta: TPanel;
    lblResult: TLabel;
    btnRequest: TButton;
    mResult: TMemo;
    PythonDelphiRGB: TPythonDelphiVar;
    PythonGUIInputOutput: TPythonGUIInputOutput;
    PythonModule: TPythonModule;
    PythonEngine: TPythonEngine;
    edtColor: TEdit;
    procedure PythonDelphiRGBSetData(Sender: TObject; Data: Variant);
    procedure btnRequestClick(Sender: TObject);
    procedure PythonModuleInitialization(Sender: TObject);
    procedure PythonDelphiRGBGetData(Sender: TObject; var Data: Variant);
  private
    { Private declarations }
    function RGBAlphaColor(R, G, B: Byte; A: Byte = 255): TAlphaColor;
    function ShowColor(pyobj, CorHex: PPyObject): PPyObject; cdecl;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnRequestClick(Sender: TObject);
begin
  var Command := TStringList.Create;
  try
    Command.Add(mPythonCode.Text);
    PythonEngine.ExecStrings(Command);
  finally
    Command.Free;
  end;
end;

procedure TForm1.PythonDelphiRGBGetData(Sender: TObject; var Data: Variant);
begin
  data := edtColor.Text;
end;

procedure TForm1.PythonDelphiRGBSetData(Sender: TObject; Data: Variant);
begin
  ColorButton.Color := RGBAlphaColor(StrToInt(Data[0]), StrToInt(Data[1]), StrToInt(Data[2]));
end;

procedure TForm1.PythonModuleInitialization(Sender: TObject);
begin
  PythonModule.AddDelphiMethod('ShowColor', ShowColor, 'The function will receive the color and show on edit and label');
end;

function TForm1.RGBAlphaColor(R, G, B, A: Byte): TAlphaColor;
begin
  Result := (A shl 24) or (R shl 16) or (G shl 8) or B;
end;

function TForm1.ShowColor(pyobj, CorHex: PPyObject ): PPyObject; cdecl;
var
  r, g, b: string;
begin
  var dados := PythonEngine.PyObjectAsVariant(CorHex);
  r := dados[0];
  g := dados[1];
  b := dados[2];
  lblRGB.Text := 'R:'+r+' G:'+g+' B:'+b;
  edtRGB.Text := 'R:'+r+' G:'+g+' B:'+b;

  Result := PythonEngine.ReturnNone;
end;



end.
