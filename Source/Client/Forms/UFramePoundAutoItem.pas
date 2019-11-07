{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 自动称重通道项
*******************************************************************************}
unit UFramePoundAutoItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UFrameBase, USysBusiness,
  {$IFDEF HYReader}UMgrRFID102,{$ELSE}UMgrJinMai915,{$ENDIF} cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, ExtCtrls, StdCtrls, UTransEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel, ULEDFont;

type
  TfFrameAutoPoundItem = class(TBaseFrame)
    GroupBox1: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    ImageGS: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ImageBT: TImage;
    Label18: TLabel;
    ImageBQ: TImage;
    ImageOff: TImage;
    ImageOn: TImage;
    HintLabel: TcxLabel;
    EditTruck: TcxComboBox;
    EditMID: TcxComboBox;
    EditPID: TcxComboBox;
    EditMValue: TcxTextEdit;
    EditPValue: TcxTextEdit;
    EditJValue: TcxTextEdit;
    MemoLog: TZnTransMemo;
    Timer1: TTimer;
    TimerDelay: TTimer;
    TimerStart: TTimer;
    Label1: TcxLabel;
    Label2: TcxLabel;
    Label3: TcxLabel;
    Label4: TcxLabel;
    Label5: TcxLabel;
    Label6: TcxLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure EditMValuePropertiesEditValueChanged(Sender: TObject);
    procedure EditValueDblClick(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
  private
    { Private declarations }
    FReceiver: Integer;
    //卡号接收
    FLastGS,FLastBT,FLastBQ: Int64;
    //上次活动
    FLastCardDone: Int64;
    FLastCard: string;
    //上次卡号
    FPoundTunnel: PPTTunnelItem;
    //磅站通道
    FPoundItem,FItemSaved: TPoundItem;
    //界面数据
    FIsWeighting: Boolean;
    //称重标识
    FSampleIndex: Integer;
    FValueSamples: array of Double;
    //数据采样
    procedure UpdateUIData(const nData: TPoundItem; const nAll: Boolean = True);
    //更新界面
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    procedure SetButtonStatus(const nHasCard: Boolean);
    //设置状态
    procedure InitTunnelData;
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //关联通道
    procedure OnPoundData(const nValue: Double);
    procedure OnPoundDataEvent(const nValue: Double);
    //读取磅重
    {$IFDEF HYReader}
    procedure OnHYReaderEvent(const nReader: PHYReaderItem);
    {$ELSE}
    procedure OnReaderDataEvent(const nReader: PJMReaderItem);
    {$ENDIF}
    procedure OnReaderData(const nReader,nCard: string);
    //读取卡号
    function IsDataValid(const nHasM: Boolean): Boolean;
    //校验数据
    procedure InitSamples;
    procedure AddSample(const nValue: Double);
    function IsValidSamaple: Boolean;
    //处理采样
    procedure WriteLog(nEvent: string);
    //记录日志
  public
    { Public declarations }
    class function FrameID: integer; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //子类继承
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    //属性相关
  end;

implementation

{$R *.dfm}

uses
  {$IFDEF OldTruckProber}UMgrTruckProbe_1,{$ELSE}UMgrTruckProbe,{$ENDIF}
  ULibFun, UTaskMonitor, UAdjustForm, USysDB, USysLoger, USysConst;

const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameAutoPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameAutoPoundItem.OnCreateFrame;
begin
  inherited;
  FIsWeighting := False;
  FPoundTunnel := nil;

  SetButtonStatus(False);
  //init ui
end;

procedure TfFrameAutoPoundItem.OnDestroyFrame;
begin
  {$IFDEF HYReader}
  gHYReaderManager.StopReader;
  gHYCardEvent := nil;
  {$ELSE}
  gJMCardManager.StopRead;
  gJMCardManager.DelReceiver(FReceiver);
  {$ENDIF}

  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
  inherited;
end;

//Desc: 按场景设置界面
procedure TfFrameAutoPoundItem.SetButtonStatus(const nHasCard: Boolean);
begin
  EditValue.Text := '0.00';
  //default value
  FIsWeighting := nHasCard;

  if not nHasCard then
    InitTunnelData;
  UpdateUIData(FPoundItem, True);

  if Assigned(FPoundTunnel) then
  begin
    {$IFNDEF debug}
    if nHasCard then
         gPoundTunnelManager.ActivePort(FPoundTunnel.FID, OnPoundDataEvent, True)
    else gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
    {$ENDIF}
  end;
end;

//Desc: 更新界面数据
procedure TfFrameAutoPoundItem.UpdateUIData(const nData: TPoundItem;
 const nAll: Boolean);
var nBool: Boolean;
begin
  with nData do
  begin
    if not Assigned(FPoundTunnel) then Exit;
    nBool := FPoundTunnel.FUserInput;
    FPoundTunnel.FUserInput := False;
    //锁定界面输入

    if nAll then
    begin
      EditTruck.Text := FTruck;
      EditMID.Text := FMName;
      EditPID.Text := FPName;
    end;

    EditPValue.Text := Format('%.2f', [FPValue]);
    EditMValue.Text := Format('%.2f', [FMValue]);

    if FMValue > 0 then
         EditJValue.Text := Format('%.2f', [FMValue - FPValue])
    else EditJValue.Text := '0.00';

    FPoundTunnel.FUserInput := nBool;
    //还原锁定
  end;
end;

//Desc: 设置运行状态图标
procedure TfFrameAutoPoundItem.SetImageStatus(const nImage: TImage;
  const nOff: Boolean);
begin
  if nOff then
  begin
    if nImage.Tag <> cFlag_OFF then
    begin
      nImage.Tag := cFlag_OFF;
      nImage.Picture.Bitmap := ImageOff.Picture.Bitmap;
    end;
  end else
  begin
    if nImage.Tag <> cFlag_ON then
    begin
      nImage.Tag := cFlag_ON;
      nImage.Picture.Bitmap := ImageOn.Picture.Bitmap;
    end;
  end;
end;

procedure TfFrameAutoPoundItem.WriteLog(nEvent: string);
var nInt: Integer;
begin
  with MemoLog do
  try
    Lines.BeginUpdate;
    if Lines.Count > 20 then
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

procedure WriteSysLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameAutoPoundItem, '自动称重业务', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 更新运行状态
procedure TfFrameAutoPoundItem.Timer1Timer(Sender: TObject);
var nFlag: Integer;
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);

  nFlag := ImageBQ.Tag;
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 3 * 1000);

  if (nFlag <> ImageBQ.Tag) and (ImageBQ.Tag = cFlag_OFF) then
  begin
    SetButtonStatus(False);
    gProberManager.CloseTunnel(FPoundTunnel.FProber);
  end; //关闭称重
end;

procedure TfFrameAutoPoundItem.InitTunnelData;
var nItem: TPoundItem;
begin
  FillChar(nItem, cSizePoundItem, #0);
  FPoundItem := nItem;
end;

procedure TfFrameAutoPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
var nIdx: Integer;
begin
  FPoundTunnel := nTunnel;
  //xxxxx

  for nIdx:=ControlCount - 1 downto 0 do
  begin
    if Controls[nIdx] is TcxComboBox then
     with (Controls[nIdx] as TcxComboBox) do
      Properties.ReadOnly := not nTunnel.FUserInput;
    //xxxxx

    if Controls[nIdx] is TcxTextEdit then
     with (Controls[nIdx] as TcxTextEdit) do
      Properties.ReadOnly := not nTunnel.FUserInput;
    //xxxxx
  end;

  {$IFDEF HYReader}
  gHYReaderManager.OnCardEvent := OnHYReaderEvent;
  gHYReaderManager.StartReader;
  gHYCardEvent := OnHYReaderEvent;
  {$ELSE}
  FReceiver := gJMCardManager.AddReceiver(OnReaderDataEvent);
  gJMCardManager.StartRead;
  {$ENDIF}
end;

//Desc: 手动输入
procedure TfFrameAutoPoundItem.EditMValuePropertiesEditValueChanged(
  Sender: TObject);
begin
  if not FPoundTunnel.FUserInput then Exit;
  //非用户输入

  if Sender = EditMValue then
  begin
    if IsNumber(EditMValue.Text, True) then
         FPoundItem.FMValue := StrToFloat(EditMValue.Text)
    else FPoundItem.FMValue := 0;
  end else

  if Sender = EditPValue then
  begin
    if IsNumber(EditPValue.Text, True) then
         FPoundItem.FPValue := StrToFloat(EditPValue.Text)
    else FPoundItem.FPValue := 0;
  end else

  if Sender = EditTruck then
  begin
    FPoundItem.FTruck := EditTruck.Text;
  end else

  if Sender = EditMID then
  begin
    FPoundItem.FMate := EditMID.Text;
  end else

  if Sender = EditPID then
  begin
    FPoundItem.FProvider := EditPID.Text;
  end;

  UpdateUIData(FPoundItem, False);
  //ui sync
end;

//------------------------------------------------------------------------------
//Desc: 验证数据是否有效
function TfFrameAutoPoundItem.IsDataValid(const nHasM: Boolean): Boolean;
var nStr: string;
begin
  Result := False;

  with FPoundItem do
  begin
    if FTruck = '' then
    begin
      WriteLog('车牌号为空不能称重.');
      nStr := '磅站[ %s.%s ]: 车牌号为空.';

      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName]);
      WriteSysLog(nStr);
      Exit;
    end;

    if FMate = '' then
    begin
      WriteLog('物料为空不能称重.');
      nStr := '磅站[ %s.%s ]: 物料号为空.';

      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName]);
      WriteSysLog(nStr);
      Exit;
    end;

    if FPValue <= 0 then
    begin
      WriteLog('皮重为0不能称重,需预置皮重.');
      nStr := '磅站[ %s.%s ]: 车辆皮重为空.';

      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName]);
      WriteSysLog(nStr);
      Exit;
    end;

    if nHasM and (FMValue <= 0) then
    begin
      WriteLog('毛重为0不能称重,请检查表头读数.');
      nStr := '磅站[ %s.%s ]: 车辆毛重为空.';

      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName]);
      WriteSysLog(nStr);
      Exit;
    end;

    if nHasM and (FMValue < FPValue) then
    begin
      WriteLog('毛重不能大于皮重,逻辑错误.');
      nStr := '磅站[ %s.%s ]: 逻辑错误,毛重%.2f > 皮重%.2f';

      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
                           FMValue, FPValue]);
      WriteSysLog(nStr);
      Exit;
    end;
  end;

  Result := True;
end;

//Desc: 手动验证数据
procedure TfFrameAutoPoundItem.EditValueDblClick(Sender: TObject);
begin
  IsDataValid(True);
end;

//------------------------------------------------------------------------------
{$IFDEF HYReader}
procedure TfFrameAutoPoundItem.OnHYReaderEvent(const nReader: PHYReaderItem);
var nTask: Int64;
begin
  nTask := gTaskMonitor.AddTask('处理电子签业务.', 5000);
  //new task

  try
    OnReaderData(nReader.FID, AdjustHYCard(nReader.FCard));
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;

  gTaskMonitor.DelTask(nTask);
  //task done
end; 
{$ELSE}
//Desc: 读取到卡号
procedure TfFrameAutoPoundItem.OnReaderDataEvent(const nReader: PJMReaderItem);
var nTask: Int64;
begin
  nTask := gTaskMonitor.AddTask('处理电子签业务.', 5000);
  //new task

  try
    OnReaderData(nReader.FID, nReader.FCard);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;

  gTaskMonitor.DelTask(nTask);
  //task done
end;
{$ENDIF}

//Desc: 地磅数据
procedure TfFrameAutoPoundItem.OnPoundDataEvent(const nValue: Double);
var nTask: Int64;
begin
  nTask := gTaskMonitor.AddTask('处理地磅数据.', 10 * 1000);
  //new task

  try
    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;

  gTaskMonitor.DelTask(nTask);
  //task done
end;

//Desc: 读远距卡
procedure TfFrameAutoPoundItem.OnReaderData(const nReader,nCard: string);
var nStr: string;
    nLast: Integer;
    nItem: TPoundItem;
begin
  if nReader <> FPoundTunnel.FReader then Exit;
  FLastBQ := GetTickCount;

  if gSysParam.FIsManual then
  begin
    FIsWeighting := False;
    Exit;
  end; //手动时无效

  if FIsWeighting then Exit;
  //称重中
  
  if nCard <> FLastCard then
    FLastCardDone := 0;
  //新卡时重置

  if GetTickCount - FLastCardDone < 5 * 1000 then Exit;
  //重复刷卡,间隔内无效

  FLastCard := nCard;
  FLastCardDone := GetTickCount;
  WriteLog('接收到卡号: ' + nCard);
      
  if not ReadPoundItem(nCard, nItem, nStr) then
  begin
    WriteLog(nStr);
    //loged

    nStr := Format('磅站[ %s.%s ]: ',[FPoundTunnel.FID,
            FPoundTunnel.FName]) + nStr;
    WriteSysLog(nStr);
    Exit;
  end;

  if (nItem.FPTime = 0) or (nItem.FPValue <= 0) then
  begin
    WriteLog('皮重为0不能称重,需预置皮重.');
    nStr := '磅站[ %s.%s ]: 车辆皮重为空.';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName]);
    WriteSysLog(nStr); Exit;
  end;

  nLast := Trunc((nItem.FServerNow - nItem.FLastTime) * 24 * 3600);
  if nLast < FPoundTunnel.FCardInterval then
  begin
    nStr := '车辆[ %s ]需等待 %d 秒后才能过磅';
    nStr := Format(nStr, [nItem.FTruck, FPoundTunnel.FCardInterval - nLast]);
    WriteLog(nStr);

    nStr := Format('磅站[ %s.%s ]: ',[FPoundTunnel.FID,
            FPoundTunnel.FName]) + nStr;
    WriteSysLog(nStr);
    Exit;
  end;

  InitSamples;
  FPoundItem := nItem;
  TimerStart.Enabled := True;
end;

procedure TfFrameAutoPoundItem.TimerStartTimer(Sender: TObject);
var nStr: string;
    nTask: Int64;
begin
  TimerStart.Enabled := False;
  nTask := gTaskMonitor.AddTask('开始称重业务.', 5000);
  //new task

  try
    SetButtonStatus(True); 
    nStr := Format('开始对车辆[ %s ]称重.', [FPoundItem.FTruck]);
    WriteLog(nStr);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;

  gTaskMonitor.DelTask(nTask);
  //task done
end;

procedure TfFrameAutoPoundItem.OnPoundData(const nValue: Double);
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);

  if not FIsWeighting then Exit;
  //不在称重中
  if gSysParam.FIsManual then Exit;
  //手动时无效

  FPoundItem.FMValue := nValue;
  UpdateUIData(FPoundItem, False);
  //ui sync

  if ImageBQ.Tag = cFlag_On then
  begin
    AddSample(nValue);
    if not (IsValidSamaple and IsDataValid(True)) then Exit;
    //验证不通过

    if GetTickCount - FLastCardDone < 3 * 1000 then Exit;
    FLastCardDone := GetTickCount;
    //重复刷卡,间隔内无效

    if SavePoundWeight(FPoundItem, FPoundTunnel) then
    begin
      FItemSaved := FPoundItem;
      FIsWeighting := False;
      TimerDelay.Enabled := True;
    end;
  end; 
end;

//Desc: 延时清理界面
procedure TfFrameAutoPoundItem.TimerDelayTimer(Sender: TObject);
begin
  try
    TimerDelay.Enabled := False;
    FLastCardDone := GetTickCount;
    WriteLog(Format('对车辆[ %s ]称重完毕.', [FItemSaved.FTruck]));

    AfterSavePoundItem(FItemSaved, FPoundTunnel);
    SetButtonStatus(False);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

//Desc: 初始化样本
procedure TfFrameAutoPoundItem.InitSamples;
var nIdx: Integer;
begin
  SetLength(FValueSamples, FPoundTunnel.FSampleNum);
  FSampleIndex := Low(FValueSamples);

  for nIdx:=High(FValueSamples) downto FSampleIndex do
    FValueSamples[nIdx] := 0;
  //xxxxx
end;

//Desc: 添加采样
procedure TfFrameAutoPoundItem.AddSample(const nValue: Double);
begin
  FValueSamples[FSampleIndex] := nValue;
  Inc(FSampleIndex);

  if FSampleIndex >= FPoundTunnel.FSampleNum then
    FSampleIndex := Low(FValueSamples);
  //循环索引
end;

//Desc: 验证采样是否稳定
function TfFrameAutoPoundItem.IsValidSamaple: Boolean;
var nIdx: Integer;
    nVal: Integer;
begin
  Result := False;

  for nIdx:=FPoundTunnel.FSampleNum-1 downto 1 do
  begin
    if FValueSamples[nIdx] < 1 then Exit;
    //样本不完整

    nVal := Trunc(FValueSamples[nIdx] * 1000 - FValueSamples[nIdx-1] * 1000);
    if Abs(nVal) >= FPoundTunnel.FSampleFloat then Exit;
    //浮动值过大
  end;

  Result := True;
end;

end.
