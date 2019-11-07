{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 手动称重
*******************************************************************************}
unit UFramePoundManual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, StdCtrls,
  ComCtrls, cxSplitter;

type
  TfFramePoundManual = class(TBaseFrame)
    WorkPanel: TScrollBox;
    Timer1: TTimer;
    cxSplitter1: TcxSplitter;
    RichEdit1: TRichEdit;
    procedure WorkPanelMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
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
  IniFiles, UlibFun, UMgrControl, UMgrPoundTunnels, UFramePoundManualItem,
  USysLoger, USysConst;

class function TfFramePoundManual.FrameID: integer;
begin
  Result := cFI_FramePoundManual;
end;

function TfFramePoundManual.FrameTitle: string;
begin
  Result := '称重 - 人工';
end;

procedure TfFramePoundManual.OnCreateFrame;
var nInt: Integer;
    nIni: TIniFile;
begin
  inherited;
  gSysParam.FIsManual := True;

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
end;

procedure TfFramePoundManual.OnDestroyFrame;
var nIni: TIniFile;
begin
  gSysParam.FIsManual := False;
  //关闭手动称重
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'MemoLog', RichEdit1.Height);
  finally
    nIni.Free;
  end;

  gSysLoger.DelReceiver(FReceiver);
  inherited;
end;

procedure TfFramePoundManual.OnLog(const nStr: string);
begin
  WriteLog(nStr, clBlue, False, False);
end;

procedure TfFramePoundManual.WriteLog(const nEvent: string; const nColor: TColor;
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
//Desc: 延时载入通道
procedure TfFramePoundManual.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  LoadPoundItems;
  WorkPanel.Invalidate;
end;

//Desc: 支持滚轮
procedure TfFramePoundManual.WorkPanelMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  with WorkPanel do
    VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
  //xxxxx
end;

//Desc: 载入通道
procedure TfFramePoundManual.LoadPoundItems;
var nIdx: Integer;
    nT: PPTTunnelItem;
begin
  with gPoundTunnelManager do
  begin
    for nIdx:=0 to Tunnels.Count - 1 do
    begin
      nT := Tunnels[nIdx];
      //tunnel
      
      with TfFrameManualPoundItem.Create(Self) do
      begin
        Name := 'fFrameManualPoundItem' + IntToStr(nIdx);
        PopedomItem := Self.PopedomItem;
        Parent := WorkPanel;

        Align := alTop;
        HintLabel.Caption := nT.FName;
        PoundTunnel := nT;
      end;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePoundManual, TfFramePoundManual.FrameID);
end.
