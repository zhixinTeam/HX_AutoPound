unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USysLoger, UMgrJinMai915, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WriteLog(const nStr: string);
    procedure DoCard(const nReader: PJMReaderItem);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses ULibFun;

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath);
  gSysLoger.LogEvent := WriteLog;
  gSysLoger.LogSync := True;

  gJMCardManager := TJMCardManager.Create;
  gJMCardManager.LoadConfig(gPath + 'readers.xml');
  gJMCardManager.OnCardEvent := DoCard;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       gJMCardManager.StartRead
  else gJMCardManager.StopRead;
end;

procedure TForm1.WriteLog(const nStr: string);
begin
  Memo1.Lines.Add(nStr);
end;

procedure TForm1.DoCard(const nReader: PJMReaderItem);
begin
  Memo1.Lines.Add(Time2Str(Now) + #9 + nReader.FCard);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  gJMCardManager.LoadConfig(gPath + 'readers.xml');
end;

end.
