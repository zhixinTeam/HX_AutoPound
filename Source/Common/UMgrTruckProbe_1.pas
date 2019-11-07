{*******************************************************************************
  作者：dmzn@163.com 2014-5-28
  描述：车辆检测控制器通讯单元
*******************************************************************************}
unit UMgrTruckProbe_1;

{.$DEFINE DEBUG}
interface

uses
  Windows, Classes, SysUtils, SyncObjs, IdTCPConnection, IdTCPClient, IdGlobal,
  NativeXml, USysLoger, ULibFun;

const
  cProber_NullASCII           = $30;       //ASCII空字节
  cProber_Flag_Begin          = $F0;       //开始标识
  
  cProber_Frame_QueryIO       = $10;       //状态查询(open close)
  cProber_Frame_RelaysOC      = $20;       //心跳真(sweet heart)
  cProber_Frame_DataForward   = $30;       //485数据转发
  cProber_Frame_IP            = $50;       //设置IP
  cProber_Frame_MAC           = $60;       //设置MAC

  cProber_Query_All           = $00;       //查询全部
  cProber_Query_In            = $01;       //查询输入
  cProber_Query_Out           = $02;       //查询输出

  cProber_Len_Frame           = $14;       //普通帧长
  cProber_Len_FrameData       = 16;        //普通定长数据
  cProber_Len_485Data         = 100;       //485转发数据
    
type
  TProberFrameData = array [0..cProber_Len_FrameData - 1] of Byte;
  TProber485Data   = array [0..cProber_Len_485Data - 1] of Byte;

  PProberFrameHeader = ^TProberFrameHeader;
  TProberFrameHeader = record
    FBegin  : Byte;                //起始帧
    FLength : Byte;                //帧长度
    FType   : Byte;                //帧类型
    FExtend : Byte;                //帧扩展
  end;

  PProberFrameControl = ^TProberFrameControl;
  TProberFrameControl = record
    FHeader : TProberFrameHeader;   //帧头
    FData   : TProberFrameData;     //数据
    FVerify : Byte;                //校验位
  end;

  PProberFrameDataForward = ^TProberFrameDataForward;
  TProberFrameDataForward = record
    FHeader : TProberFrameHeader;   //帧头
    FData   : TProber485Data;       //数据
    FVerify : Byte;                //校验位
  end;

  PProberHost = ^TProberHost;
  TProberHost = record
    FID      : string;               //标识
    FName    : string;               //名称
    FHost    : string;               //IP
    FPort    : Integer;              //端口
    FEnable  : Boolean;              //是否启用
  end;

  TProberIOAddress = array[0..7] of Byte;
  //in-out address

  PProberTunnel = ^TProberTunnel;
  TProberTunnel = record
    FID      : string;               //标识
    FName    : string;               //名称
    FHost    : PProberHost;          //所在主机
    FIn      : TProberIOAddress;     //输入地址
    FOut     : TProberIOAddress;     //输出地址
    FEnable  : Boolean;              //是否启用
  end;

  TProberHosts = array of TProberHost;
  //array of host
  TProberTunnels = array of TProberTunnel;
  //array of tunnel

const
  cSize_Prober_IOAddr   = SizeOf(TProberIOAddress);
  cSize_Prober_Control  = SizeOf(TProberFrameControl);
  cSize_Prober_Display  = SizeOf(TProberFrameDataForward);

type
  TProberManager = class(TObject)
  private
    FHosts: TProberHosts;
    FTunnels: TProberTunnels;
    //通道列表
    FRetry: Byte;
    FClient: TIdTCPClient;
    //网络对象
    FSyncLock: TCriticalSection;
    //同步锁定
  protected
    procedure DisconnectClient;
    function SendData(const nHost: PProberHost; var nData: TIdBytes;
      const nRecvLen: Integer): string;
    //发送数据
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadConfig(const nFile: string);
    //读取配置
    function OpenTunnel(const nTunnel: string): Boolean;
    function CloseTunnel(const nTunnel: string): Boolean;
    function TunnelOC(const nTunnel: string; const nOC: Boolean): string;
    //开合通道
    function GetTunnel(const nTunnel: string): PProberTunnel;
    procedure EnableTunnel(const nTunnel: string; const nEnabled: Boolean);
    function QueryStatus(const nHost: PProberHost; const nQType: Byte;
      var nIn,nOut: TProberIOAddress): string;
    function IsTunnelOK(const nTunnel: string): Boolean;
    //查询状态
    property Hosts: TProberHosts read FHosts;
    property RetryOnError: Byte read FRetry write FRetry;
    //属性相关
  end;

var
  gProberManager: TProberManager = nil;
  //全局使用

function ProberVerifyData(var nData: TIdBytes; const nDataLen: Integer;
  const nLast: Boolean): Byte;
procedure ProberStr2Data(const nStr: string; var nData: TProberFrameData);
//入口函数

implementation

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TProberManager, '车辆检测控制', nEvent);
end;

//Desc: 对nData做异或校验
function ProberVerifyData(var nData: TIdBytes; const nDataLen: Integer;
  const nLast: Boolean): Byte;
var nIdx,nLen: Integer;
begin
  Result := 0;
  if nDataLen < 1 then Exit;

  nLen := nDataLen - 2;
  //末位不参与计算
  Result := nData[0];

  for nIdx:=1 to nLen do
    Result := Result xor nData[nIdx];
  //xxxxx

  if nLast then
    nData[nDataLen - 1] := Result;
  //附加到末尾
end;

//Date: 2014-05-30
//Parm: 字符串;数据
//Desc: 将nStr填充到nData中
procedure ProberStr2Data(const nStr: string; var nData: TProberFrameData);
var nIdx,nLen: Integer;
begin
  nLen := Length(nStr);
  if nLen > cProber_Len_FrameData then
    nLen := cProber_Len_FrameData;
  //长度矫正

  for nIdx:=1 to nLen do
    nData[nIdx-1] := Ord(nStr[nIdx]);
  //xxxxx
end;

//Date: 2012-4-13
//Parm: 字符
//Desc: 获取nTxt的内码
function ConvertStr(const nTxt: WideString; var nBuf: array of Byte): Integer;
var nStr: string;
    nIdx: Integer;
begin
  Result := 0;
  for nIdx:=1 to Length(nTxt) do
  begin
    nStr := nTxt[nIdx];
    nBuf[Result] := Ord(nStr[1]);
    Inc(Result);

    if Length(nStr) = 2 then
    begin
      nBuf[Result] := Ord(nStr[2]);
      Inc(Result);
    end;

    if Result >= cProber_Len_485Data then Break;
  end;
end;

//Date：2014-5-13
//Parm：地址结构;地址字符串,类似: 1,2,3
//Desc：将nStr拆开,放入nAddr结构中
procedure SplitAddr(var nAddr: TProberIOAddress; const nStr: string);
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    SplitStr(nStr, nList, 0 , ',');
    if nList.Count < 1 then Exit;

    for nIdx:=Low(nAddr) to High(nAddr) do
    begin
      if nIdx < nList.Count then
           nAddr[nIdx] := StrToInt(nList[nIdx])
      else nAddr[nIdx] := cProber_NullASCII;
    end;
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
constructor TProberManager.Create;
begin
  FRetry := 2;
  //retry times on error
  FSyncLock := TCriticalSection.Create;
  
  FClient := TIdTCPClient.Create;
  FClient.ReadTimeout := 3 * 1000;
  FClient.ConnectTimeout := 3 * 1000;
end;

destructor TProberManager.Destroy;
begin
  FClient.Disconnect;
  FClient.Free;

  FSyncLock.Free;
  inherited;
end;

//Desc: 载入nFile配置文件
procedure TProberManager.LoadConfig(const nFile: string);
var nXML: TNativeXml;
    nHost: PProberHost;
    nNode,nTmp: TXmlNode;
    i,nIdx,nNum: Integer;
begin
  SetLength(FHosts, 0);
  SetLength(FTunnels, 0);
  
  nXML := TNativeXml.Create;
  try
    nXML.LoadFromFile(nFile);
    //load config

    for nIdx:=0 to nXML.Root.NodeCount - 1 do
    begin
      nNode := nXML.Root.Nodes[nIdx];
      nNum := Length(FHosts);
      SetLength(FHosts, nNum + 1);

      with FHosts[nNum],nNode do
      begin
        FID    := AttributeByName['id'];
        FName  := AttributeByName['name'];
        FHost  := NodeByName('ip').ValueAsString;
        FPort  := NodeByName('port').ValueAsInteger;
        FEnable := NodeByName('enable').ValueAsInteger = 1;
      end;

      nTmp := nNode.FindNode('tunnels');
      if not Assigned(nTmp) then Continue;
      nHost := @FHosts[nNum];

      for i:=0 to nTmp.NodeCount - 1 do
      begin
        nNode := nTmp.Nodes[i];
        nNum := Length(FTunnels);
        SetLength(FTunnels, nNum + 1);

        with FTunnels[nNum],nNode do
        begin
          FID    := AttributeByName['id'];
          FName  := AttributeByName['name'];
          FHost  := nHost;
          
          SplitAddr(FIn, NodeByName('in').ValueAsString);
          SplitAddr(FOut, NodeByName('out').ValueAsString);

          nNode := nNode.FindNode('enable');
          FEnable := (not Assigned(nNode)) or (nNode.ValueAsString <> '0');
        end;
      end;
    end;
  finally
    nXML.Free;
  end;
end;

{$IFDEF DEBUG}
procedure LogHex(const nData: TIdBytes);
var nStr: string;
    nIdx: Integer;
begin
  nStr := '';
  for nIdx:=Low(nData) to High(nData) do
    nStr := nStr + IntToHex(nData[nIdx], 1) + ' ';
  WriteLog(nStr);
end;
{$ENDIF}

//------------------------------------------------------------------------------
//Desc: 断开客户端套接字
procedure TProberManager.DisconnectClient;
begin
  FClient.Disconnect;
  if Assigned(FClient.IOHandler) then
    FClient.IOHandler.InputBuffer.Clear;
  //try to swtich connection
end;

//Date：2014-5-13
//Parm：主机;发送数据[in],应答数据[out];待接收长度
//Desc：向nHost发送nData数据,并接收应答
function TProberManager.SendData(const nHost: PProberHost; var nData: TIdBytes;
  const nRecvLen: Integer): string;
var nBuf: TIdBytes;
    nIdx,nLen: Integer;
begin
  Result := '';
  try
    nLen := Length(nData);
    ProberVerifyData(nData, nLen, True);
    //添加异或校验

    SetLength(nBuf, nLen);
    CopyTIdBytes(nData, 0, nBuf, 0, nLen);
    //备份待发送内容

    DisconnectClient;
    //断开客户端
    nIdx := 0;

    while nIdx < FRetry do
    try
      {$IFDEF DEBUG}
      LogHex(nBuf);
      {$ENDIF}

      if not FClient.Connected then
      begin
        FClient.Host := nHost.FHost;
        FClient.Port := nHost.FPort;
        FClient.Connect;
      end;

      Inc(nIdx);
      FClient.IOHandler.Write(nBuf);
      //send data

      if nRecvLen < 1 then Exit;
      //no data to receive

      FClient.IOHandler.ReadBytes(nData, nRecvLen, False);
      //read respond
      
      {$IFDEF DEBUG}
      LogHex(nData);
      {$ENDIF}

      nLen := Length(nData);
      if (nLen = nRecvLen) and
         (nData[nLen-1] = ProberVerifyData(nData, nLen, False)) then Exit;
      //校验通过

      if nIdx = FRetry then
      begin
        Result := '未从[ %s:%s.%d ]收到能通过校验的应答数据.';
        Result := Format(Result, [nHost.FName, nHost.FHost, nHost.FPort]);
      end;
    except
      on E: Exception do
      begin
        Inc(nIdx);
        if nIdx < FRetry then
             Sleep(100)
        else raise;

        DisconnectClient;
        //断开重连
      end;
    end;
  except
    on E: Exception do
    begin
      Result := '向[ %s:%s:%d ]发送数据失败,描述: %s';
      Result := Format(Result, [nHost.FName, nHost.FHost, nHost.FPort, E.Message]);
    end;
  end;
end;

//Date：2014-5-13
//Parm：通道号;True=Open,False=Close
//Desc：对nTunnel执行开合操作,若有错误则返回
function TProberManager.TunnelOC(const nTunnel: string;
  const nOC: Boolean): string;
var i,j,nIdx: Integer;
    nBuf: TIdBytes;
    nData: TProberFrameControl;
begin
  Result := '';
  nIdx := -1;
  //default
  
  for i:=Low(FTunnels) to High(FTunnels) do
  if CompareText(nTunnel, FTunnels[i].FID) = 0 then
  begin
    nIdx := i;
    Break;
  end;

  if nIdx < 0 then
  begin
    Result := '通道[ %s ]编号无效.';
    Result := Format(Result, [nTunnel]); Exit;
  end;

  with FTunnels[nIdx] do
  begin
    if not (FHost.FEnable and FEnable) then Exit;
    //不启用,不发送

    FillChar(nData, cSize_Prober_Control, cProber_NullASCII);
    //init
    
    with nData.FHeader do
    begin
      FBegin := cProber_Flag_Begin;
      FLength := cProber_Len_Frame;
      FType := cProber_Frame_RelaysOC;

      if nOC then
           FExtend := $01
      else FExtend := $02;
    end;

    j := 0;
    for i:=Low(FOut) to High(FOut) do
    begin
      if FOut[i] = cProber_NullASCII then Continue;
      //invalid out address

      nData.FData[j] := FOut[i];
      Inc(j);
    end;

    FSyncLock.Enter;
    try
      nBuf := RawToBytes(nData, cSize_Prober_Control);
      Result := SendData(FHost, nBuf, cSize_Prober_Control);
    finally
      FSyncLock.Leave;
    end;
  end;
end;

//Date：2014-5-13
//Parm：通道号
//Desc：对nTunnel执行吸合操作
function TProberManager.OpenTunnel(const nTunnel: string): Boolean;
var nStr: string;
begin
  nStr := TunnelOC(nTunnel, False);
  Result := nStr = '';

  if not Result then
    WriteLog(nStr);
  //xxxxxx
end;

//Date：2014-5-13
//Parm：通道号
//Desc：对nTunnel执行断开操作
function TProberManager.CloseTunnel(const nTunnel: string): Boolean;
var nStr: string;
begin
  nStr := TunnelOC(nTunnel, True);
  Result := nStr = '';

  if not Result then
    WriteLog(nStr);
  //xxxxxx
end;

//------------------------------------------------------------------------------
//Date：2014-5-14
//Parm：主机;查询类型;输入输出结果
//Desc：查询nHost的输入输出状态,存入nIn nOut.
function TProberManager.QueryStatus(const nHost: PProberHost; const nQType: Byte;
  var nIn, nOut: TProberIOAddress): string;
var nBuf: TIdBytes;
    nData: TProberFrameControl;
begin
  Result := '';
  FillChar(nIn, cSize_Prober_IOAddr, cProber_NullASCII);
  FillChar(nOut, cSize_Prober_IOAddr, cProber_NullASCII);

  if not nHost.FEnable then Exit;
  //不启用,不发送

  FillChar(nData, cSize_Prober_Control, cProber_NullASCII);
  //init
  
  with nData.FHeader do
  begin
    FBegin  := cProber_Flag_Begin;
    FLength := cProber_Len_Frame;
    FType   := cProber_Frame_QueryIO;
    FExtend := nQType;
  end;

  FSyncLock.Enter;
  try
    nBuf := RawToBytes(nData, cSize_Prober_Control);
    Result := SendData(nHost, nBuf, cSize_Prober_Control);
    if Result <> '' then Exit;

    BytesToRaw(nBuf, nData, cSize_Prober_Control);
    if (nQType = cProber_Query_All) or (nQType = cProber_Query_In) then
      Move(nData.FData[0], nIn[0], cSize_Prober_IOAddr);
    //in status

    if (nQType = cProber_Query_All) or (nQType = cProber_Query_Out) then
      Move(nData.FData[cSize_Prober_IOAddr], nOut[0], cSize_Prober_IOAddr);
    //out status
  finally
    FSyncLock.Leave;
  end;
end;

//Date：2014-5-14
//Parm：通道号
//Desc：获取nTunnel的通道数据
function TProberManager.GetTunnel(const nTunnel: string): PProberTunnel;
var nIdx: Integer;
begin
  Result := nil;

  for nIdx:=Low(FTunnels) to High(FTunnels) do
  if CompareText(nTunnel, FTunnels[nIdx].FID) = 0 then
  begin
    Result := @FTunnels[nIdx];
    Break;
  end;
end;

//Date: 2014-07-03
//Parm: 通道号;启用
//Desc: 是否启用nTunnel通道
procedure TProberManager.EnableTunnel(const nTunnel: string;
  const nEnabled: Boolean);
var nPT: PProberTunnel;
begin
  nPT := GetTunnel(nTunnel);
  if Assigned(nPT) then
    nPT.FEnable := nEnabled;
  //xxxxx
end;

//Date：2014-5-14
//Parm：通道号
//Desc：查询nTunnel的输入是否全部为无信号
function TProberManager.IsTunnelOK(const nTunnel: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nPT: PProberTunnel;
    nIn,nOut: TProberIOAddress;
begin
  Result := False;
  nPT := GetTunnel(nTunnel);

  if Assigned(nPT) then
  try
    if not (nPT.FEnable and nPT.FHost.FEnable) then
    begin
      Result := True;
      Exit;
    end;

    nStr := QueryStatus(nPT.FHost, cProber_Query_In, nIn, nOut);
    //query all
    
    if nStr <> '' then
    begin
      WriteLog(nStr);
      Exit;
    end;

    for nIdx:=Low(nPT.FIn) to High(nPT.FIn) do
    begin
      if nPT.FIn[nIdx] = cProber_NullASCII then Continue;
      //invalid addr

      if nIn[nPT.FIn[nIdx] - 1] = $00 then Exit;
      //某路输入有信号,认为车辆未停妥
    end;

    Result := True;
  except
    on E: Exception do
    begin
      nStr := '函数[ IsTunnelOK.%s ]错误,描述: %s';
      nStr := Format(nStr, [nTunnel, E.Message]);
      WriteLog(nStr);
    end;
  end;  
end;

initialization
  gProberManager := nil;
finalization
  FreeAndNil(gProberManager);
end.
