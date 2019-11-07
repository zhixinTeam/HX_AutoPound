{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 手动称重通道项
*******************************************************************************}
unit UFramePoundManualItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UFrameBase, USysBusiness,
  {$IFDEF HYReader}UMgrRFID102,{$ELSE}UMgrJinMai915,{$ENDIF} cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinsDefaultPainters, Menus, ExtCtrls, cxCheckBox,
  StdCtrls, cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel,
  ULEDFont;

type
  TfFrameManualPoundItem = class(TBaseFrame)
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
    BtnPreW: TcxButton;
    BtnInputTruck: TcxButton;
    BtnSave: TcxButton;
    BtnNext: TcxButton;
    Timer1: TTimer;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    CheckLock: TcxCheckBox;
    N4: TMenuItem;
    N5: TMenuItem;
    Label1: TcxLabel;
    Label2: TcxLabel;
    Label3: TcxLabel;
    Label4: TcxLabel;
    Label5: TcxLabel;
    Label6: TcxLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BtnInputTruckClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnPreWClick(Sender: TObject);
    procedure EditMValuePropertiesEditValueChanged(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
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
    FPoundItem: TPoundItem;
    //界面数据
    FPrePWeight: Double;
    FIsWeighting: Boolean;
    //称重标识
    FAllowedInputTruck: Boolean;
    //允许手动
    procedure UpdateUIData(const nData: TPoundItem; const nAll: Boolean = True);
    //更新界面
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    procedure SetButtonStatus(const nHasCard: Boolean);
    //设置状态
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //关联通道
    procedure OnPoundData(const nValue: Double);
    //读取磅重
    {$IFDEF HYReader}
    procedure OnHYReaderEvent(const nReader: PHYReaderItem);
    {$ELSE}
    procedure OnReaderDataEvent(const nReader: PJMReaderItem);
    {$ENDIF}
    procedure OnReaderData(const nReader,nCard: string);
    //读取卡号
    function VerifyPoundItem(const nItem: TPoundItem): string;
    function IsDataValid(const nHasM: Boolean): Boolean;
    //校验数据
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
  ULibFun, UAdjustForm, UFormInputbox, USysLoger, USysConst, USysPopedom,
  USysDB, UDataModule;
  
const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameManualPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameManualPoundItem.OnCreateFrame;
begin
  inherited;
  FIsWeighting := False;
  FPoundTunnel := nil;

  FPrePWeight := 0;
  FAllowedInputTruck := False;
  SetButtonStatus(False);

  LoadMaterails(EditMID.Properties.Items);
  LoadProviders(EditPID.Properties.Items);
end;

procedure TfFrameManualPoundItem.OnDestroyFrame;
begin
  {$IFDEF HYReader}           
  if Assigned(gHYCardEvent) then
       gHYReaderManager.OnCardEvent := gHYCardEvent //恢复自动过磅
  else gHYReaderManager.StopReader;
  {$ELSE}
  gJMCardManager.StopRead;
  gJMCardManager.DelReceiver(FReceiver);
  {$ENDIF}
  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);

  AdjustStringsItem(EditMID.Properties.Items, True);
  AdjustStringsItem(EditPID.Properties.Items, True); 
  inherited;
end;

//Desc: 按场景设置界面按钮状态
procedure TfFrameManualPoundItem.SetButtonStatus(const nHasCard: Boolean);
begin
  BtnPreW.Enabled := nHasCard and (gPopedomManager.HasPopedom(PopedomItem, sPopedom_Add));
  BtnSave.Enabled := nHasCard and (FPrePWeight > 0);
  BtnInputTruck.Enabled := (not nHasCard) and FAllowedInputTruck;

  EditValue.Text := '0.00';
  //default value
  FIsWeighting := nHasCard;

  if Assigned(FPoundTunnel) then
  begin
    {$IFNDEF debug}
    if nHasCard then
         gPoundTunnelManager.ActivePort(FPoundTunnel.FID, OnPoundData, True)
    else gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
    {$ENDIF}
  end;
end;

//Desc: 更新界面数据
procedure TfFrameManualPoundItem.UpdateUIData(const nData: TPoundItem;
 const nAll: Boolean);
var nBool: Boolean;
begin
  with nData do
  begin
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
procedure TfFrameManualPoundItem.SetImageStatus(const nImage: TImage;
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

procedure WriteSysLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameManualPoundItem, '手动称重业务', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 更新运行状态
procedure TfFrameManualPoundItem.Timer1Timer(Sender: TObject);
var nFlag: Integer;
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);

  nFlag := ImageBQ.Tag;
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 5 * 1000);

  if (nFlag <> ImageBQ.Tag) and (ImageBQ.Tag = cFlag_OFF) then
  begin
    SetButtonStatus(False);
    {$IFNDEF debug}
    gProberManager.CloseTunnel(FPoundTunnel.FProber);
    {$ENDIF}
  end; //关闭称重
end;

procedure TfFrameManualPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
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

  EditMID.Properties.ReadOnly := False;
  EditPID.Properties.ReadOnly := False;
  //允许修改特例

  FAllowedInputTruck := AllowedInputTruck;
  BtnInputTruck.Enabled := FAllowedInputTruck;
  //允许手动录入车牌
  N5.Checked := FAllowedInputTruck;
  N5.Enabled := gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit);
  //切换手工录入
  
  {$IFDEF HYReader}
  gHYReaderManager.OnCardEvent := OnHYReaderEvent;
  gHYReaderManager.StartReader;
  {$ELSE}
  FReceiver := gJMCardManager.AddReceiver(OnReaderDataEvent);
  gJMCardManager.StartRead;
  {$ENDIF}
end;

procedure TfFrameManualPoundItem.EditMValuePropertiesEditValueChanged(
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
  end;

  UpdateUIData(FPoundItem, False);
  //ui sync
end;

//Desc: 启用or关闭手动称重
procedure TfFrameManualPoundItem.N1Click(Sender: TObject);
begin
  N1.Checked := not N1.Checked;
  //status change
  
  if N1.Checked then
       gProberManager.OpenTunnel(FPoundTunnel.FProber)
  else gProberManager.CloseTunnel(FPoundTunnel.FProber)
end;

//Desc: 启用or关闭手动输入车牌
procedure TfFrameManualPoundItem.N5Click(Sender: TObject);
begin
  SetAllowedInputTruck(not N5.Checked);
  FAllowedInputTruck := AllowedInputTruck;

  N5.Checked := FAllowedInputTruck;
  BtnInputTruck.Enabled := FAllowedInputTruck and (not BtnPreW.Enabled);
end;

//Desc: 关闭称重页面
procedure TfFrameManualPoundItem.N3Click(Sender: TObject);
var nP: TWinControl;
begin
  nP := Parent;
  while Assigned(nP) do
  begin
    if (nP is TBaseFrame) and
       (TBaseFrame(nP).FrameID = cFI_FramePoundManual) then
    begin
      TBaseFrame(nP).Close();
      Exit;
    end;

    nP := nP.Parent;
  end;
end;

//Desc: 验证读回的预置数据
function TfFrameManualPoundItem.VerifyPoundItem(const nItem: TPoundItem): string;
var nLast: Integer;
begin
  Result := '';
  if nItem.FLastTime = 0 then Exit;

  nLast := Trunc((nItem.FServerNow - nItem.FLastTime) * 24 * 3600);
  if nLast < FPoundTunnel.FCardInterval then
  begin
    Result := '磅站[ %s.%s ]: 车辆[ %s ]需等待 %d 秒后才能过磅.';
    Result := Format(Result, [FPoundTunnel.FID, FPoundTunnel.FName,
              nItem.FTruck, FPoundTunnel.FCardInterval - nLast]);
    Exit;
  end;
end;

//Desc: 手工录入车牌
procedure TfFrameManualPoundItem.BtnInputTruckClick(Sender: TObject);
var nStr,nTruck,nCard: string;
    nItem: TPoundItem;
begin
  nTruck := '';
  //init
  
  while True do
  begin
    if not ShowInputBox('请输入要称重的车牌号码:', '应急', nTruck) then Exit;
    //user cancel

    nStr := GetTruckCard(nTruck, nCard);
    if nStr = '' then
         Break
    else ShowMsg(nStr, sHint);
  end;

  if not ReadPoundItem(nCard, nItem, nStr, False, not CheckLock.Checked) then
  begin
    WriteSysLog(nStr);
    Exit;
  end;
  
  if nStr <> '' then
    ShowDlg(nStr, sHint);
  //xxxxx

  nStr := VerifyPoundItem(nItem);
  if nStr <> '' then
  begin
    ShowDlg(nStr, sHint);
    Exit;
  end;
  
  FPoundItem := nItem;
  FPrePWeight := nItem.FPValue;

  UpdateUIData(FPoundItem);
  SetButtonStatus(FPoundItem.FTruck <> '');
end;

{$IFDEF HYReader}
procedure TfFrameManualPoundItem.OnHYReaderEvent(const nReader: PHYReaderItem);
begin
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
end;
{$ELSE}
//Desc: 读取到卡号
procedure TfFrameManualPoundItem.OnReaderDataEvent(const nReader: PJMReaderItem);
begin
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
end;
{$ENDIF}

//Desc: 读远距卡
procedure TfFrameManualPoundItem.OnReaderData(const nReader,nCard: string);
var nStr: string;
    nItem: TPoundItem;
begin
  if nReader <> FPoundTunnel.FReader then Exit;
  FLastBQ := GetTickCount;

  if FIsWeighting then Exit;
  //称重中
  if nCard <> FLastCard then
    FLastCardDone := 0;
  //新卡时重置
  
  if GetTickCount - FLastCardDone < 10 * 1000 then Exit;
  //重复刷卡,间隔内无效

  if not ReadPoundItem(nCard, nItem, nStr, False, not CheckLock.Checked) then
  begin
    WriteSysLog(nStr);
    Exit;
  end;

  FLastCard := nCard;
  FLastCardDone := GetTickCount;
  nStr := VerifyPoundItem(nItem);

  if nStr <> '' then
  begin
    WriteSysLog(nStr);
    Exit;
  end;

  FPoundItem := nItem;
  FPrePWeight := nItem.FPValue;
  
  UpdateUIData(FPoundItem);
  SetButtonStatus(True);
end;

procedure TfFrameManualPoundItem.OnPoundData(const nValue: Double);
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);;

  if CheckLock.Checked or (FPrePWeight <= 0) then
       FPoundItem.FPValue := nValue
  else FPoundItem.FMValue := nValue;

  UpdateUIData(FPoundItem, False);
  //ui sync
end;

//Desc: 继续
procedure TfFrameManualPoundItem.BtnNextClick(Sender: TObject);
var nItem: TPoundItem;
begin
  FIsWeighting := False;
  FillChar(nItem, cSizePoundItem, #0);
  
  FPoundItem := nItem;
  FPrePWeight := 0;
  UpdateUIData(nItem);

  SetButtonStatus(False);
  CheckLock.Checked := False;
end;

//------------------------------------------------------------------------------
//Desc: 验证数据是否有效
function TfFrameManualPoundItem.IsDataValid(const nHasM: Boolean): Boolean;
begin
  Result := False;

  if EditMID.ItemIndex < 0 then
  begin
    EditMID.SetFocus;
    ShowMsg('请选择物料', sHint); Exit;
  end;

  if EditPID.ItemIndex < 0 then
  begin
    EditPID.SetFocus;
    ShowMsg('请选择客户', sHint); Exit;
  end;

  with FPoundItem do
  begin
    if FPValue <= 0 then
    begin
      ShowMsg('皮重不能为0', sHint);
      Exit;
    end;

    if nHasM and (FMValue <= 0) then
    begin
      ShowMsg('毛重不能为0', sHint);
      Exit;
    end;

    if nHasM and (FMValue < FPValue) then
    begin
      ShowMsg('皮重不能大于毛重', sHint);
      Exit;
    end;

    FMate := GetStringsItemData(EditMID.Properties.Items, EditMID.ItemIndex);
    FMName := EditMID.Text;

    FProvider := GetStringsItemData(EditPID.Properties.Items, EditPID.ItemIndex);
    FPName := EditPID.Text;
  end;

  Result := True;
end;

//Desc: 预置皮重
procedure TfFrameManualPoundItem.BtnPreWClick(Sender: TObject);
var nStr: string;
begin
  if IsDataValid(False) and SavePreWeight(FPoundItem) then
  begin
    nStr := '客户:[ %s ] 物料:[ %s ] 皮重:[ %.2f ]';
    with FPoundItem do
      nStr := Format(nStr, [FPName, FMName, FPValue]);
    FDM.WriteSysLog('预置皮重', FPoundItem.FTruck, nStr);

    FPoundItem.FFixPound := FPoundTunnel.FID;
    AfterSavePoundItem(FPoundItem, FPoundTunnel);
    
    BtnNextClick(nil);
    ShowMsg('预置成功', sHint);
  end;
end;

//Desc: 保存称重
procedure TfFrameManualPoundItem.BtnSaveClick(Sender: TObject);
begin
  if IsDataValid(True) and SavePoundWeight(FPoundItem, FPoundTunnel) then
  begin
    AfterSavePoundItem(FPoundItem, FPoundTunnel);
    if CompareText(FPoundItem.FFixPound, FPoundTunnel.FID) = 0 then
      ShowMsg('称重成功', sHint);
    BtnNextClick(nil);
  end;
end;

end.
