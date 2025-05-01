unit uMemoryLeaks;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, PythonEngine, FMX.PythonGUIInputOutput,
  FMX.Edit, FMX.Layouts;

type
  TForm1 = class(TForm)
    mPythonCode: TMemo;
    btnRequest: TButton;
    lblResult: TLabel;
    mResult: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonModule1: TPythonModule;
    PythonEngine1: TPythonEngine;
    PythonDelphiVar1: TPythonDelphiVar;
    Layout1: TLayout;
    chkDebugMode: TCheckBox;
    edtPath: TEdit;
    getPath: TButton;
    procedure btnRequestClick(Sender: TObject);
    procedure PythonDelphiVar1GetData(Sender: TObject; var Data: Variant);
    procedure getPathClick(Sender: TObject);
    procedure chkDebugModeChange(Sender: TObject);
  private
    function MemoryLeakScript: string;
    { Private declarations }
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
    if chkDebugMode.IsChecked then
      Command.Add(mPythonCode.Text)
    else
      Command.Add(MemoryLeakScript);
    PythonEngine1.ExecStrings(Command);
  finally
    Command.Free;
  end;
end;

function TForm1.MemoryLeakScript: string;
begin
  Result := '''
  import re
  import os

  caminho = varPath.Value

  padrao_create = re.compile(r"\b(\w+)\s*:=\s*\w+\.Create\b", re.IGNORECASE)
  #padrao_create = re.compile(r"\b(\w+)\s*:=\s*\w+\.Create(?!\s*\(\s*Self\s*\))", re.IGNORECASE)

  possiveis_leaks = []

  for root, _, files in os.walk(caminho):
      for file in files:
          if file.endswith(".pas"):
              with open(os.path.join(root, file), "r") as f:
                  codigo = f.read()
                  objetos_criados = padrao_create.findall(codigo)

                  for obj in objetos_criados:
                      padrao_free =  re.compile(rf"\b{re.escape(obj)}\.Free\b", re.IGNORECASE)
                      if not padrao_free.search(codigo):
                          possiveis_leaks.append(f"{file}: {obj}")

  print(possiveis_leaks)
  possiveis_leaks = []
  ''';
end;

procedure TForm1.chkDebugModeChange(Sender: TObject);
begin
  mPythonCode.Visible := chkDebugMode.IsChecked;
end;

procedure TForm1.getPathClick(Sender: TObject);
var
  path: string;
begin
  if SelectDirectory('Project Path', 'D:\Projetos\', path) then
    edtPath.Text := path;
end;

procedure TForm1.PythonDelphiVar1GetData(Sender: TObject; var Data: Variant);
begin
  Data := edtPath.Text;
end;

end.
