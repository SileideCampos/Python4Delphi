unit uScripts;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, PythonEngine, FMX.PythonGUIInputOutput,
  FMX.Edit, FMX.Layouts, FMX.Menus, FMXTee.Engine, FMXTee.Procs, FMXTee.Chart;

type
  TForm1 = class(TForm)
    mPythonCode: TMemo;
    btnRequest: TButton;
    mResult: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonModule1: TPythonModule;
    PythonEngine1: TPythonEngine;
    PythonDelphiVar1: TPythonDelphiVar;
    StyleBook1: TStyleBook;
    Splitter1: TSplitter;
    lScriptCompleto: TLayout;
    Layout2: TLayout;
    mScriptCompleto: TMemo;
    Splitter2: TSplitter;
    Layout3: TLayout;
    chkFullExecutedScript: TCheckBox;
    btnPrev: TButton;
    btnNext: TButton;
    chkTest: TCheckBox;
    btnLoadScript: TButton;
    edtFileScript: TEdit;
    lblQtd: TLabel;
    procedure btnRequestClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure chkFullExecutedScriptClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLoadScriptClick(Sender: TObject);
  private
    procedure LoadScripts(const FileName: string);
    procedure ShowScript(Index: Integer);
    { Private declarations }
  public
    { Public declarations }
    FScripts: TArray<string>;
    FIndex: Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormShow(Sender: TObject);
begin
  PythonEngine1.SetPythonHome('C:\Users\Sileide\AppData\Local\Programs\Python\Python310\');
  PythonEngine1.DllName := 'python310.dll';
  PythonEngine1.DllPath := 'C:\Users\Sileide\AppData\Local\Programs\Python\Python310\';

  PythonEngine1.LoadDll;
end;

procedure TForm1.btnLoadScriptClick(Sender: TObject);
begin
  LoadScripts(edtFileScript.Text);
  FIndex := 0;
  if Length(FScripts) > 0 then
    ShowScript(FIndex);
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
  if FIndex < High(FScripts) then
  begin
    Inc(FIndex);
    ShowScript(FIndex);
  end;
end;

procedure TForm1.btnPrevClick(Sender: TObject);
begin
  if FIndex > 0 then
  begin
    Dec(FIndex);
    ShowScript(FIndex);
  end;
end;

procedure TForm1.LoadScripts(const FileName: string);
var
  sList: TStringList;
begin
  sList := TStringList.Create;
  try
    if FileExists(FileName) then
    begin
      sList.LoadFromFile(FileName, TEncoding.UTF8);
      FScripts := sList.Text.Split(['##separador##'], TStringSplitOptions.None);
    end;
  finally
    sList.Free;
  end;
end;

procedure TForm1.ShowScript(Index: Integer);
begin
  if (Index >= 0) and (Index < Length(FScripts)) then
  begin
    mPythonCode.Lines.Text := Trim(FScripts[Index]);
    lblQtd.Text := Format('%d de %d', [Index + 1, Length(FScripts)]);
  end;
end;

procedure TForm1.btnRequestClick(Sender: TObject);
begin
  var Command := TStringList.Create;
  try
    Command.Text := mPythonCode.Text;
    PythonEngine1.ExecStrings(Command);
  finally
    if not chkTest.IsChecked then
      mScriptCompleto.Lines.Add(mPythonCode.Text);
    Command.Free;
  end;
end;

procedure TForm1.chkFullExecutedScriptClick(Sender: TObject);
begin
  lScriptCompleto.Visible := chkFullExecutedScript.IsChecked;
end;


end.
