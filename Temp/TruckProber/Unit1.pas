unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdGlobal, ULibFun, USysLoger, UMgrTruckProbe, StdCtrls,
  CPortCtl, ExtCtrls, CPort, UMgrCOMM, UMemDataPool, UMgrERelay;

type
  TForm1 = class(TForm)
    ComPort1: TComPort;
    GroupBox1: TGroupBox;
    EditIP: TLabeledEdit;
    Label1: TLabel;
    EditPort: TLabeledEdit;
    EditMAC: TLabeledEdit;
    Label2: TLabel;
    BtnConn: TButton;
    BtnSetIP: TButton;
    MemoLog: TMemo;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    GroupBox3: TGroupBox;
    Bevel1: TBevel;
    Timer1: TTimer;
    Check1: TCheckBox;
    Check3: TCheckBox;
    Check5: TCheckBox;
    Check7: TCheckBox;
    Check2: TCheckBox;
    Check4: TCheckBox;
    Check6: TCheckBox;
    Check8: TCheckBox;
    Label3: TLabel;
    ComboBox1: TComboBox;
    GroupBox4: TGroupBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox1: TCheckBox;
    EditCOM: TComboBox;
    CheckSrv: TCheckBox;
    BtnMem: TButton;
    EditNo: TLabeledEdit;
    EditTxt: TLabeledEdit;
    BtnDisplay: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnConnClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure BtnSetIPClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckSrvClick(Sender: TObject);
    procedure BtnMemClick(Sender: TObject);
    procedure BtnDisplayClick(Sender: TObject);
  private
    { Private declarations }
    FCOMBuf: string;
    //接收缓冲
    function MakeValidIPData(const nData: PProberFrameControl): Boolean;
    //构建IP数据
    function MakeValidMACData(const nData: PProberFrameControl): Boolean;
    //构建MAC数据
    procedure WriteLog(const nEvent: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  gPath: string;

procedure EnableAll(const nP: TWinControl; const nEnable: Boolean);
var i: Integer;
begin
  for i:=nP.ControlCount - 1 downto 0 do
   if nP.Controls[i] is TWinControl then
    if nP.Controls[i].Tag > 0 then
         nP.Controls[i].Enabled := not nEnable
    else nP.Controls[i].Enabled := nEnable;
end;

procedure TForm1.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogSync := True;
  gSysLoger.LogEvent := WriteLog;

  EnableAll(GroupBox1, False);
  MemoLog.Enabled := True;
  GetValidCOMPort(EditCOM.Items);

  gMemDataManager := TMemDataManager.Create;
  //xxxxx
  
  gProberManager := TProberManager.Create;
  with gProberManager do
  begin
    LoadConfig(gPath + 'TruckProber.xml');
    for nIdx:=0 to Hosts.Count-1 do
      ComboBox1.Items.Add(PProberHost(Hosts[nIdx]).FName);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
procedure TForm1.BtnConnClick(Sender: TObject);
begin
  if EditCOM.ItemIndex > -1 then
  begin
    ComPort1.Port := EditCOM.Text;
    ComPort1.Open;
    EnableAll(GroupBox1, ComPort1.Connected);
  end;
end;

procedure TForm1.ComPort1RxChar(Sender: TObject; Count: Integer);
var nStr: string;
begin
  MemoLog.Lines.BeginUpdate;
  try
    if MemoLog.Lines.Count > 50 then
    begin
      MemoLog.Clear;
      FCOMBuf := '';
    end;

    if Count > 0 then
    begin
      ComPort1.ReadStr(nStr, Count);
      FCOMBuf := FCOMBuf + nStr;

      MemoLog.Text := FCOMBuf;
      MemoLog.Perform(WM_VSCROLL, SB_BOTTOM, 0);
    end;
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

//Desc: 校验用户输入的IP数据
function TForm1.MakeValidIPData(const nData: PProberFrameControl): Boolean;
var nStr: string;
    nIdx,nLen: Integer;
begin
  Result := False;
  nStr := EditIP.Text;
  nLen := Length(nStr);

  if nLen <> 15 then
  begin
    ShowMessage('IP为定长15位');
    EditIP.SetFocus; Exit;
  end;

  for nIdx:=1 to nLen do
  if not (nStr[nIdx] in ['0'..'9', '.']) then
  begin
    ShowMessage('IP由0-9数字和"."号组成');
    EditIP.SetFocus; Exit;
  end;

  nStr := StringReplace(nStr, '.', '', [rfReplaceAll]);
  nStr := StringReplace(nStr, '0', ' ', [rfReplaceAll]);

  if not (IsNumber(EditPort.Text, False) and
         (StrToInt(EditPort.Text) < 10000)) then
  begin
    ShowMessage('端口为小于10000的数字');
    EditPort.SetFocus; Exit;
  end;

  EditPort.Text := IntToStr(StrToInt(EditPort.Text));
  nStr := nStr + StringOfChar('0', 4-Length(EditPort.Text)) + EditPort.Text;

  FillChar(nData^, cSize_Prober_Control, cProber_NullASCII);
  //init
  
  with nData.FHeader do
  begin
    FBegin  := cProber_Flag_Begin;
    FLength := cProber_Len_Frame;
    FType   := cProber_Frame_IP;
  end;

  ProberStr2Data(nStr, nData.FData);
  Result := True;
end;

//Desc: 校验用户输入的MAC数据
function TForm1.MakeValidMACData(const nData: PProberFrameControl): Boolean;
var nStr: string;
    nList: TStrings;
    i,nIdx,nLen: Integer;
begin
  nList := TStringList.Create;
  try
    Result := False;
    SplitStr(EditMAC.Text, nList, 0, '-');
    
    if nList.Count <> 6 then
    begin
      ShowMessage('MAC地址由"-"分割的6段组成');
      EditMAC.SetFocus; Exit;
    end;

    for nIdx:=0 to 5 do
    begin
      nStr := UpperCase(nList[nIdx]);
      nLen := Length(nStr);

      if nLen <> 2 then
      begin
        ShowMessage('MAC地址每节两个字母');
        EditMAC.SetFocus; Exit;
      end;

      for i:=1 to 2 do
      if not (nStr[i] in ['0'..'9', 'A'..'Z']) then
      begin
        ShowMessage('MAC地址由"数字,字母"组成');
        EditMAC.SetFocus; Exit;
      end;
    end;
    
    FillChar(nData^, cSize_Prober_Control, cProber_NullASCII);
    //init
            
    with nData.FHeader do
    begin
      FBegin  := cProber_Flag_Begin;
      FLength := cProber_Len_Frame;
      FType   := cProber_Frame_MAC;
    end;

    nStr := '';
    for nIdx:=0 to 5 do
      nStr := nStr + nList[nIdx];
    //xxxxx

    ProberStr2Data(nStr, nData.FData);
    Result := True;
  finally
    nList.Free;
  end;
end;

procedure TForm1.BtnSetIPClick(Sender: TObject);
var nInt: Integer;
    nBuf: TIdBytes;
    nIP,nMAC: TProberFrameControl;
begin
  if not MakeValidIPData(@nIP) then Exit;
  if not MakeValidMACData(@nMAC) then Exit;

  nBuf := RawToBytes(nIP, cSize_Prober_Control);
  nInt := Length(nBuf);

  ProberVerifyData(nBuf, nInt, True);
  ComPort1.Write(@nBuf[0], nInt);
  //set ip

  for nInt:=1 to 10 do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;

  nBuf := RawToBytes(nMAC, cSize_Prober_Control);
  nInt := Length(nBuf);

  ProberVerifyData(nBuf, nInt, True);
  ComPort1.Write(@nBuf[0], nInt);
  //set mac
end;

//------------------------------------------------------------------------------
procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nCheck: TCheckBox;
    nHost: PProberHost;
    nI,nO: TProberIOAddress;
begin
  if ComboBox1.ItemIndex < 0 then Exit;
  nHost := gProberManager.Hosts[ComboBox1.ItemIndex];

  nStr := gProberManager.QueryStatus(nHost, nI, nO);
  if nStr <> '' then MemoLog.lines.add(nStr + IntToStr(MemoLog.lines.Count));

  for nIdx:=Low(nI) to High(nI) do
  begin
    nCheck := (FindComponent('Check' + IntToStr(nIdx+1)) as TCheckBox);
    nCheck.Checked := nI[nIdx] >= 1;

    with nCheck.Font do
    begin
      if nCheck.Checked then
      begin
        Color := clYellow;
        Style := Style + [fsBold];
      end else
      begin
        Color := clBlack;
        Style := Style - [fsBold];
      end;
    end;
  end;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
var nStr: string;
    nCheck: TCheckBox;
begin
  nCheck := Sender as TCheckBox;
  nStr := nCheck.Caption;
  nStr := Copy(nStr, Length(nStr), 1);

  gProberManager.TunnelOC('T' + nStr, not nCheck.Checked);
end;

procedure TForm1.CheckSrvClick(Sender: TObject);
begin
  if CheckSrv.Checked then
       gProberManager.StartProber
  else gProberManager.StopProber;
end;

procedure TForm1.BtnMemClick(Sender: TObject);
begin
  MemoLog.Clear;
  gMemDataManager.GetStatus(MemoLog.Lines);
end;

procedure TForm1.WriteLog(const nEvent: string);
var nInt: Integer;
begin
  with MemoLog do
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

procedure TForm1.BtnDisplayClick(Sender: TObject);
begin
  gProberManager.ShowTxt('T1', EditTxt.Text);
end;

end.
