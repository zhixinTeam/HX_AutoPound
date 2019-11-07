{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}
interface

uses
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormPassword, UFramePProvider, UFormPProvider, UFramePMaterails,
  UFormPMaterails, UFrameTrucks, UFormTruck, UFrameCard, UFormCard, UFormMemo,
  UFramePoundAuto, UFramePoundManual, UFramepoundlog, UFormManualInput;

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  {$IFDEF OldTruckProber}UMgrTruckProbe_1,{$ELSE}UMgrTruckProbe,{$ENDIF}
  SysUtils, USysLoger, USysMAC, U900Reader, UMgrPoundTunnels,
  {$IFDEF HYReader}UMgrRFID102,{$ELSE}UMgrJinMai915,{$ENDIF}
  UMgrRemoteVoice, UTaskMonitor, UMemDataPool, USysBusiness, USysConst;

//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger

  gTaskMonitor := TTaskMonitor.Create;
  //monitor

  gMemDataManager := TMemDataManager.Create;
  //mem pool

  g900MReader := T900MReader.Create;
  g900MReader.Config := gPath + '900M.Ini';

  gPoundTunnelManager := TPoundTunnelManager.Create;
  gPoundTunnelManager.LoadConfig(gPath + 'Tunnels.xml');

  {$IFDEF HYReader}
  gHYReaderManager := THYReaderManager.Create;
  gHYReaderManager.EventMode := emMain;
  gHYReaderManager.LoadConfig(gPath + 'RFID102.xml');
  {$ELSE}
  gJMCardManager := TJMCardManager.Create;
  gJMCardManager.LoadConfig(gPath + 'Readers.xml');
  {$ENDIF}

  gProberManager := TProberManager.Create;
  gProberManager.LoadConfig(gPath + 'TruckProber.xml');

  gVoiceHelper.LoadConfig(gPath + 'Voice.xml');
  //语音服务
end;

//Desc: 运行系统对象
procedure RunSystemObject;
begin
  gSysParam.FLocalMaC := MakeActionID_MAC;
  //gJMCardManager.StartRead;

  {$IFNDEF DEBUG}
    gVoiceHelper.StartVoice;

    {$IFNDEF OldTruckProber}
    gProberManager.StartProber;
    {$ENDIF}
  {$ENDIF}
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  {$IFDEF HYReader}
  gHYReaderManager.StopReader;
  {$ELSE}
  gJMCardManager.StopRead;
  {$ENDIF}
  gVoiceHelper.StopVoice;

  {$IFNDEF OldTruckProber}
  gProberManager.StopProber;
  {$ENDIF}
end;

end.
