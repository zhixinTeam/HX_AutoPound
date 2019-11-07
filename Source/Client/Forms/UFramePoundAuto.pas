{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 自动称重
*******************************************************************************}
unit UFramePoundAuto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, cxSplitter,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfFramePoundAuto = class(TBaseFrame)
    RichEdit1: TRichEdit;
    WorkPanel: TScrollBox;
    cxSplitter1: TcxSplitter;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure WorkPanelMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FReceiver: Integer;
    //事件标识
    procedure LoadPoundItems;
    //载入通道
    procedure OnLog(const nStr: string);
    //记录日志
  public
    { Public declarations }
    class function FrameID: integer; override;
    function FrameTitle: string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //子类继承
    procedure WriteLog(const nEvent: string; const nColor: TColor = clGreen;
      const nBold: Boolean = False; const nAdjust: Boolean = True);
    //记录日志
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UMgrPoundTunnels, UFramePoundAutoItem,
  UTaskMonitor, USysLoger, USysConst;

class function TfFramePoundAuto.FrameID: integer;
begin
  Result := cFI_FramePoundAuto;
end;

function TfFramePoundAuto.FrameTitle: string;
begin
  Result := '称重 - 自动';
end;

procedure TfFramePoundAuto.OnCreateFrame;
var nInt: Integer;
    nIni: TIniFile;
begin
  inherited;
  gSysLoger.LogSync := True;
  FReceiver := gSysLoger.AddReceiver(OnLog); 

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nInt := nIni.ReadInteger(Name, 'MemoLog', 0);
    if nInt > 20 then
      RichEdit1.Height := nInt;
    //xxxxx
  finally
    nIni.Free;
  end;

  gTaskMonitor.StartMon;
  //monitor start
end;

procedure TfFramePoundAuto.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'MemoLog', RichEdit1.Height);
  finally
    nIni.Free;
  end;

  gSysLoger.DelReceiver(FReceiver);
  gTaskMonitor.StopMon;
  inherited;
end;

procedure TfFramePoundAuto.OnLog(const nStr: string);
begin
  WriteLog(nStr, clBlue, False, False);
end;

procedure TfFramePoundAuto.WriteLog(const nEvent: string; const nColor: TColor;
  const nBold: Boolean; const nAdjust: Boolean);
var nInt: Integer;
begin
  with RichEdit1 do
  try
    Lines.BeginUpdate;
    if Lines.Count > 200 then
     for nInt:=1 to 50 do
      Lines.Delete(0);
    //清理多余

    if nBold then
         SelAttributes.Style := SelAttributes.Style + [fsBold]
    else SelAttributes.Style := SelAttributes.Style - [fsBold];

    SelStart := GetTextLen;
    SelAttributes.Color := nColor;

    if nAdjust then
         Lines.Add(DateTime2Str(Now) + #9 + nEvent)
    else Lines.Add(nEvent);
  finally
    Lines.EndUpdate;
    Perform(EM_SCROLLCARET,0,0);
    Application.ProcessMessages;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 延时载入
procedure TfFramePoundAuto.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  LoadPoundItems;
  WorkPanel.Invalidate;
end;

//Desc: 支持滚轮
procedure TfFramePoundAuto.WorkPanelMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  with WorkPanel do
    VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
  //xxxxx
end;

//Desc: 载入通道
procedure TfFramePoundAuto.LoadPoundItems;
var nIdx: Integer;
    nT: PPTTunnelItem;
begin
  with gPoundTunnelManager do
  begin
    for nIdx:=0 to Tunnels.Count - 1 do
    begin
      nT := Tunnels[nIdx];
      //tunnel
      
      with TfFrameAutoPoundItem.Create(Self) do
      begin
        Name := 'fFrameAutoPoundItem' + IntToStr(nIdx);
        Parent := WorkPanel;
        Align := alTop;

        HintLabel.Caption := nT.FName;
        PoundTunnel := nT;
      end;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePoundAuto, TfFramePoundAuto.FrameID);
end.
