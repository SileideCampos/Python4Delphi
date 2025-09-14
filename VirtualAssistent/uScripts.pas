unit uScripts;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, PythonEngine, FMX.PythonGUIInputOutput,
  FMX.Edit, FMX.Layouts, FMX.Menus;

type
  TForm1 = class(TForm)
    mPythonCode: TMemo;
    btnRequest: TButton;
    mResult: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonModule1: TPythonModule;
    PythonEngine1: TPythonEngine;
    StyleBook1: TStyleBook;
    Splitter1: TSplitter;
    btnAsistenteVirtual: TButton;
    Button1: TButton;
    procedure btnRequestClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAsistenteVirtualClick(Sender: TObject);
    procedure PythonModule1Initialization(Sender: TObject);
  private
    { Private declarations }
    function MostraDados(pyobj, CorHex: PPyObject): PPyObject; cdecl;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses uCliente, uNotaFiscal;

procedure TForm1.FormShow(Sender: TObject);
begin
  //criada com a versão 3.13 do python
  PythonEngine1.VenvPythonExe := 'D:\Projetos\Python\Python4DelphiVenv\Scripts\python.exe';
  PythonEngine1.LoadDll;
end;

procedure TForm1.btnRequestClick(Sender: TObject);
begin
  var Command := TStringList.Create;
  try
    Command.Text := mPythonCode.Text;
    PythonEngine1.ExecStrings(Command);
  finally
    Command.Free;
  end;
end;

procedure TForm1.btnAsistenteVirtualClick(Sender: TObject);
begin
  PythonEngine1.ExecString('''
    import speech_recognition as sr
    import pyaudio
    import keyboard
    import changeInfo

    ativou = False

    r = sr.Recognizer()
    mic = sr.Microphone()

    def capturarAudio():
        with mic as source:
          r.adjust_for_ambient_noise(source)
          audio = r.listen(source)
        reproduzirAudio(audio)
        return audio

    def processarAudio(audio):
        global ativou
        if ativou:
            changeInfo.MostraDados("Processando...")
        texto = r.recognize_google(audio, language="pt-BR")
        if texto.lower().startswith("delphi"):
            changeInfo.MostraDados("Diga, estou lhe escutando...")
            ativou = True
        else:
            changeInfo.MostraDados(texto)
            ativou = False

    def reproduzirAudio(audio):
      p = pyaudio.PyAudio()
      stream = p.open(format=p.get_format_from_width(2),
                      channels=2,
                      rate=22000,
                      output=True)
      stream.write(audio.get_raw_data())

    def assistente():
      global ativou
      resultado = ""
      changeInfo.MostraDados("Vamos comecar!!")
      ativou = False

      while True:
        if keyboard.is_pressed("esc"):
          break

        try:
            audio = capturarAudio()
            processarAudio(audio)
        except sr.UnknownValueError:
          changeInfo.MostraDados("Nao entendi o que voce falou!")
        except:
          changeInfo.MostraDados("Erro ao processar!")

    assistente()
    ''');

end;

procedure TForm1.PythonModule1Initialization(Sender: TObject);
begin
  PythonModule1.AddDelphiMethod('MostraDados', MostraDados, 'The function will receive a string and will show on memo');
end;

function TForm1.MostraDados(pyobj, CorHex: PPyObject): PPyObject; cdecl;
begin
  var dados := PythonEngine1.PyObjectAsString(CorHex);
  mResult.Lines.Add(dados);

  dados := LowerCase(dados);
  if (dados.contains('abrir') or dados.contains('abra')) and dados.contains('cliente') then
  begin
    mResult.Lines.Add('Vai abrir a tela de cliente');
    Form2.Show
  end
  else if dados.contains('nota fiscal') then
  begin
    mResult.Lines.Add('Vai abrir a tela de nota fiscal');
    Form3.Show;
  end
  else if (dados.contains('fechar') or dados.contains('feche')) and dados.contains('cliente') then
  begin
    mResult.Lines.Add('Vai fechar a tela de cliente');
    Form2.Close;
  end;

  Application.ProcessMessages;
  Result := PythonEngine1.ReturnNone;
end;


end.
