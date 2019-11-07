unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, CPort, StdCtrls, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer, IdGlobal, IdSocketHandle;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    ComPort1: TComPort;
    Memo1: TMemo;
    CheckBox2: TCheckBox;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
    procedure WriteLog(const nEvent: string);
    procedure OnData(const nValue: Double);
    procedure OnDataEx(const nValue: Double; const nPort: PPTPortItem);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  ULibFun, USysLoger, WinSock;

var
  gPath: string;


function OnParseData(const nPort: PPTPortItem): Boolean;
var nIdx,nLen: Integer;
    nVerify: Word;
    nBuf: TIdBytes;
begin
  Result := False;
  nBuf := ToBytes(nPort.FCOMBuff, Indy8BitEncoding);
  nLen := Length(nBuf) - 2;
  if nLen < 52 then Exit; //48-51为磅重数据

  nVerify := 0;
  nIdx := 0;

  while nIdx < nLen do
  begin
    nVerify := nBuf[nIdx] + nVerify;
    Inc(nIdx);
  end;

  if (nBuf[nLen] <> (nVerify shr 8 and $00ff)) or
     (nBuf[nLen+1] <> (nVerify and $00ff)) then Exit;
  //校验失败

  nPort.FCOMData := IntToStr(StrToInt('$' +
    IntToHex(nBuf[51], 2) + IntToHex(nBuf[50], 2) +
    IntToHex(nBuf[49], 2) + IntToHex(nBuf[48], 2)));
  //毛重显示数据

  Result := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogSync := True;
  gSysLoger.LogEvent := WriteLog;

  gPoundTunnelManager := TPoundTunnelManager.Create;
  gPoundTunnelManager.LoadConfig(gPath + 'Tunnels.xml');
  //gPoundTunnelManager.OnUserParseWeight := OnParseData;

  ComboBox1.Clear;
  for nIdx:=gPoundTunnelManager.Tunnels.Count - 1 downto 0 do
    ComboBox1.Items.Add(PPTTunnelItem(gPoundTunnelManager.Tunnels[nIdx]).FID);
  //xxxxx
end;

procedure TForm1.WriteLog(const nEvent: string);
var nInt: Integer;
begin
  with Memo1 do
  try
    Lines.BeginUpdate;
    if Lines.Count > 200 then
     for nInt:=1 to 10 do
      Lines.Delete(0);
    //清理多余

    Lines.Add(DateTime2Str(Now) + #9 + nEvent);
  finally
    Lines.EndUpdate;
    Perform(EM_SCROLLCARET,0,0);
    Application.ProcessMessages;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if ComboBox1.ItemIndex >= 0 then
   if CheckBox1.Checked then
        gPoundTunnelManager.ActivePort(ComboBox1.Text, OnData, True, OnDataEx)
   else gPoundTunnelManager.ClosePort(ComboBox1.Text);
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
var nIdx: Integer;
    nTunnel: PPTTunnelItem;
begin
  for nIdx:=gPoundTunnelManager.Tunnels.Count-1 downto 0 do
  begin
    nTunnel := gPoundTunnelManager.Tunnels[nIdx];
    if not CheckBox2.Checked then
    begin
      gPoundTunnelManager.ClosePort(nTunnel.FID);
      Continue;
    end;

    if not gPoundTunnelManager.ActivePort(nTunnel.FID, OnData, True, OnDataEx) then
      Memo2.lines.Add(nTunnel.FID + ' wrong');
  end;
end;

procedure TForm1.OnData(const nValue: Double);
begin

end;

procedure TForm1.OnDataEx(const nValue: Double; const nPort: PPTPortItem);
var nStr: string;
    nIdx,nInt: Integer;
begin
  nStr := Format('%.2f', [nValue]);
  Edit1.Text := nStr;

  if Memo2.Lines.Count > 200 then
  begin
    while Memo2.Lines.Count > 100 do
      Memo2.Lines.Delete(0);
  end;

  memo2.Lines.Add(TimeToStr(Now) + ' : ' + nStr);
  Exit;

  nIdx := Memo2.Lines.IndexOf(nStr);
  if nIdx < 0 then
    memo2.Lines.Add(nStr);
  exit;

  nInt := gPoundTunnelManager.Tunnels.Count - Memo1.Lines.Count;
  if nInt > 0 then
  begin
    Memo1.Clear;
    nInt := gPoundTunnelManager.Tunnels.Count;
  end;

  while nInt > 0 do
  begin
    Memo1.Lines.Add('');
    Dec(nInt);
  end;

  nStr := nPort.FEventTunnel.FID + ' ';
  for nIdx:=Memo1.Lines.Count - 1 downto 0 do
  begin
    if Pos(nStr, Memo1.Lines[nIdx]) > 0 then
    begin
      Memo1.Lines[nIdx] := Format('%s Value:%.2f', [nStr, nValue]);
      Exit;
    end;
  end;

  nStr := nPort.FEventTunnel.FID;
  System.Delete(nStr, 1, 1);
  nInt := StrToInt(nStr) - 1;

  nStr := Format('%s Value:%.2f', [nPort.FEventTunnel.FID, nValue]);
  if nInt < 0 then
    Memo1.Lines.Add(nStr)
  else  Memo1.Lines.Insert(nInt, nStr);
end;

procedure TForm1.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
begin
//
end;

end.
