unit Uinterface;

interface

function BC900_GetDLLVersion:pchar;stdcall;
function BC900_SetRS232BaudRate(BaudRate:pchar):integer;stdcall;
function BC900_SetRS485BaudRate(BaudRate:pchar):integer;stdcall;
function BC900_SETRS485ALIAS(ALIASID:PCHAR):integer;stdcall;
function BC900_QueryRS485ALIAS(var ALIASID:PCHAR):integer;stdcall;
function BC900_QueryRS485BaudRate(var Baudrate:PCHAR):integer;stdcall;
function BC900_QueryRS232BaudRate(var Baudrate:PCHAR):integer;stdcall;
function BC900_GPIOTest:integer;stdcall;
function BC900_SetRFPowerONOFF(IsRFPower:PCHAR):integer;stdcall;

function BC900_QueryBUMAC(var BUMAC:pchar):integer;stdcall;
function BC900_SetBUMAC(BUMAC:PCHAR):integer;stdcall;
function BC900_SetSNCode(SNCode:PCHAR):integer;stdcall;
function BC900_QuerySNCode(var SNCode:pchar):integer;stdcall;

function BC900_SetAntenna(Antenna:pchar):integer;stdcall;
function BC900_QueryAntenna(var Antenna:pchar):integer;stdcall;
function BC900_SetRFTagtype(RFTagtype:pchar):integer;stdcall;
function BC900_QueryRFTagtype(var RFTagtype:pchar):integer;stdcall;
function BC900_SetRFPower(RFPower:pchar):integer;stdcall;
function BC900_QueryRFPower(var RFPower:pchar):integer;stdcall;
function BC900_SetRFFrequency(freqBtm,freqTop,frequency:PCHAR):integer;stdcall;
function BC900_QueryRFFrequencyAttribute(var frequencyAttribute:pchar):integer;stdcall;

function BC900_SetRFFrequencyHOP(IsFixFrequency:PCHAR):integer;stdcall;
function BC900_QueryRFFrequencyHOP(var IsFixFrequency:pchar):integer;stdcall;
function BC900_SetRFEPCInitialQ(EPCInitialQ:PCHAR):integer;stdcall;
function BC900_QueryRFEPCInitialQ(var EPCInitialQ:pchar):integer;stdcall;
function BC900_SetRFEPCSession(EPCSession:pchar):integer;stdcall;
function BC900_QueryRFEPCSession(var EPCSession:pchar):integer;stdcall;
function BC900_SetRFInitialTries(InitialTries:pchar):integer;stdcall;
function BC900_QueryRFInitialTries(var InitialTries:pchar):integer;stdcall;
function BC900_QueryRFSELTries(var SELTries:pchar):integer;stdcall;
function BC900_SetRFSELTries(SELTries:PCHAR):integer;stdcall;
function BC900_QueryANTTimeOut(var ANTTimeOut:pchar):integer;stdcall;
function BC900_SetANTTimeOut(ANTTimeOut:PCHAR):integer;stdcall;

function BC900_QueryANTTries(var ANTTries:pchar):integer;stdcall;
function BC900_SetANTTries(ANTTries:PCHAR):integer;stdcall;
function BC900_QueryRDTries(var RDTries:pchar):integer;stdcall;
function BC900_SetRDTries(RDTries:PCHAR):integer;stdcall;
function BC900_QueryRPTTimeOut(var RPTTimeOut:pchar):integer;stdcall;
function BC900_SetRPTTimeOut(RPTTimeOut:PCHAR):integer;stdcall;
function BC900_QueryTIMEOUTMODE(var TimeOutMode:integer):integer;stdcall;
function BC900_SetTIMEOUTMODE(TimeOutMode:PCHAR):integer;stdcall;
function BC900_QueryCHKSUM(var CHKSUM:pchar):integer;stdcall;
function BC900_SetCHKSUM(CHKSUM:PCHAR):integer;stdcall;
function BC900_SetRFDataInteface(DataInteface:pchar):integer;stdcall;//RS485UP1 0 ,RS485UP2 1,RS485U1D1 2,RS485U2D1 3,RS485U1D2 4,RS485U2D2 5 WG26 6 WG34 7 TCPIP 8 RS232 9
function BC900_QueryRFDataInteface(var DataInteface:pchar):integer;stdcall;

function BC900_QueryMODE(var MODE:pchar):integer;stdcall;//工作模式
function BC900_SetMODE(MODE:PCHAR):integer;stdcall;
function BC900_QueryVerifyCode(var VerifyCode:pchar):integer;stdcall;
function BC900_SetVerifyCode(VerifyCode:PCHAR):integer;stdcall;
function BC900_6B_QueryDataMask(var DataMask:pchar):integer;stdcall;
function BC900_6B_SetDataMask(DataMask:PCHAR):integer;stdcall;
function BC900_QueryWGPulse(var WGPulse:pchar):integer;stdcall;
function BC900_SETWGPulse(WGPulse:pchar):integer;stdcall;
function BC900_SETWGPulInterval(WGPulInterval:pchar):integer;stdcall;//us
function BC900_QueryWGPulInterval(var WGPulInterval:pchar):integer;stdcall; //us
function BC900_QueryWGDataInterval(var WGDataInterval:pchar):integer;stdcall;//MS
function BC900_SETWGDataInterval(WGDataInterval:pchar):integer;stdcall; //MS

function BC900_QueryTriggerDelay(var TriggerDelay:pchar):integer;stdcall;//MS
function BC900_SETTriggerDelay(TriggerDelay:pchar):integer;stdcall;//MS
function BC900_QueryCYCInterval(var CYCInterval:pchar):integer;stdcall;//MS
function BC900_SETCYCInterval(CYCInterval:pchar):integer;stdcall;//MS
function BC900_SetBUZZ(IsBUZZ:PCHAR):integer;stdcall;
function BC900_QueryBUZZ(var IsBUZZ:pchar):integer;stdcall; //1 ON 0 OFF
function BC900_SetNestDistGU(NestDistGU:PCHAR):integer;stdcall;//1 ON 0 OFF 2 TIMING
function BC900_QueryNestDistGU(var NestDistGU:pchar):integer;stdcall; ////1 ON 0 OFF 2 TIMING
function BC900_SetNestDistGUINT(NestDistGUINT:PCHAR):integer;stdcall;     //S
function BC900_QueryNestDistGUINT(var NestDistGUINT:pchar):integer;stdcall; //S
function BC900_SetWGDatas(WG,Antenna:pchar):integer;stdcall;
function BC900_QueryWGDatas(WG:pchar; var Antenna:pchar):integer;stdcall;

function BC900_QueryDrivANTS(var TR,ANTS:pchar):integer;stdcall;
function BC900_SetDrivANTS(TR,ANTS:PCHAR):integer;stdcall;
function BC900_SetTriggerV(TriggerV:PCHAR):integer;stdcall;
function BC900_QueryTriggerV(var TriggerV:pchar):integer;stdcall; //1 HIGH 0 LOW

function BC900_ToFactDflt:integer;stdcall;
function BC900_RESET:integer;stdcall;
function BC900_QueryListID(var ListID:pchar):integer;stdcall;

function BC900_SetDate(YEAR,MONTH,DAY:PCHAR):integer;stdcall;   //按照系统格式日期构造的字符串
function BC900_QueryDate(var YEAR,MONTH,DAY:PCHAR):integer;stdcall;
function BC900_SetTime(HOUR,MINUTE,SECOND:PCHAR):integer;stdcall;   //按照系统时间格式构造的字符串
function BC900_QueryTime(var HOUR,MINUTE,SECOND:PCHAR):integer;stdcall;
function BC900_QueryANTSCheck(var Antenna:pchar):integer;stdcall;
function BC900_QueryHARDVersion(var HARDVersion:pchar):integer;stdcall;
function BC900_QuerySOFTVersion(var SOFTVersion:pchar):integer;stdcall;

function BC900_6B_QueryReadMEMHex(UID,WriteAdd,WriteLen:PCHAR;var MEMHex:pchar):integer;stdcall;
function BC900_QueryRead(var EVENTRecord:pchar):integer;stdcall;
//park
function BC900_PARK_SetTermID(PARK_TermID:PCHAR):integer;stdcall;
function BC900_PARK_QueryTermID(var PARK_TermID:PCHAR):integer;stdcall;
function BC900_PARK_QueryRecord(var EVENTRecord:pchar):integer;stdcall;
function BC900_PARK_OpenDoor(PARK_DoorID:PCHAR):integer;stdcall;
function BC900_PARK_CloseDoor(PARK_DoorID:PCHAR):integer;stdcall;
function BC900_PARK_UploadStart:integer;stdcall;
function BC900_PARK_UploadEnd:integer;stdcall;
function BC900_PARK_Upload(UploadInfor:PCHAR):integer;stdcall;

//EPC特殊
function BC900_EPC_WriteTAG(TagID,WriteInfor,WriteAdd,writeLen:PCHAR):integer;stdcall;
function BC900_EPC_ProtectUSERMem(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall; //保护
function BC900_EPC_ProtectTIDMem(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_ProtectEPCMem(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_ProtectAccessPas(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_ProtectKILLPas(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_SET_AccessPass(OriAccessPass,NewAccessPass,EPCID:PCHAR):integer;stdcall;//设置密码
function BC900_EPC_SET_KillPass(AccessPass,KillPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_WriteUSERMem(ReadAdd,ReadLen,WriteData,AccessPass,EPCID:PCHAR):integer;stdcall; //写内存区
function BC900_EPC_WriteTIDMem(WriteLen,WriteData,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_WriteEPCMem(WriteData:PCHAR):integer;stdcall;
function BC900_EPC_KillAEPCTag(KillPass,EPCID:PCHAR):integer;stdcall;//杀死

function BC900_EPC_ReadReseverMEM_KillPass(AccessPass,EPCID:PCHAR; var KillPass:pchar):integer;stdcall;
function BC900_EPC_ReadReseverMEM_AccessPass(EPCID:PCHAR; var AccessPass:pchar):integer;stdcall;
function BC900_EPC_ReadUSERMem(ReadAdd,ReadLen,EPCID,AccessPass:PCHAR; var UserMEMData:Pchar):integer;stdcall;
function BC900_EPC_ReadTIDMem(ReadLen,AccessPass,EPCID:PCHAR;var TIDMemData:pchar):integer;stdcall;
function BC900_EPC_ReadEPCMem(AccessPass,EPCID:PCHAR;var EPCMemData:pchar):integer;stdcall;

function BC900_RS232CALL:integer;stdcall;
function BC900_TCPIPCALL(MyHost,MyPort:Pchar):integer;stdcall;
function BC900_TCPIPDisconnected:integer;stdcall;

function CloseCommPort: Integer;stdcall;
function OpenCommPort(PortName: PChar): Integer;stdcall;
function EnumMyComPorts:pchar;stdcall;

//net set
function BC900_SetSRCIP(SRCIP:PCHAR):integer;stdcall;
function BC900_QuerySRCIP(var SRCIP:PCHAR):integer;stdcall;
function BC900_SetSRCPort(SRCPort:PCHAR):integer;stdcall;
function BC900_QuerySRCPort(var SRCPort:PCHAR):integer;stdcall;
function BC900_SetDSTIP(DSTIP:PCHAR):integer;stdcall;
function BC900_QueryDSTIP(var DSTIP:PCHAR):integer;stdcall;
function BC900_SetDSTPort(DSTPort:PCHAR):integer;stdcall;
function BC900_QueryDSTPort(var DSTPort:PCHAR):integer;stdcall;
function BC900_SetDHCP(DHCP:PCHAR):integer;stdcall; //0 OFF 1 ON
function BC900_QueryDHCP(var DHCP:PCHAR):integer;stdcall; //0 OFF 1 ON
function BC900_SetIPMASK(IPMASK:PCHAR):integer;stdcall;
function BC900_QueryIPMASK(var IPMASK:PCHAR):integer;stdcall;
function BC900_SetGATEWAY(GATEWAY:PCHAR):integer;stdcall;
function BC900_QueryGATEWAY(var GATEWAY:PCHAR):integer;stdcall;
function BC900_QueryDeviceMAC(var MAC:PCHAR):integer;stdcall;

function SaveBaud(MyBaud:pchar):integer;stdcall;

//todo net set 2007-12-04
function BC900_Net_SetRS232BaudRate(BaudRate:pchar):integer;stdcall;
function BC900_Net_QueryRS232BaudRate(var Baudrate:Pbyte):integer;stdcall

function BC900_Net_SetSRCIP(SRCIP:PCHAR):integer;stdcall;
function BC900_Net_SetSRCPort(SRCPort:PCHAR):integer;stdcall;
function BC900_Net_QuerySRCIP(var SRCIP:PCHAR):integer;stdcall;
function BC900_Net_QuerySRCPort(var SRCPort:PCHAR):integer;stdcall;
function BC900_Net_SetDSTIP(DSTIP:PCHAR):integer;stdcall;
function BC900_Net_SetDSTPort(DSTPort:PCHAR):integer;stdcall;
function BC900_Net_QueryDSTIP(var DSTIP:PCHAR):integer;stdcall;
function BC900_Net_QueryDSTPort(var DSTPort:PCHAR):integer;stdcall;

function BC900_Net_SetDHCP(DHCP:PCHAR):integer;stdcall; //0 OFF 1 ON
function BC900_Net_QueryDHCP(var DHCP:PCHAR):integer;stdcall; //0 OFF 1 ON
function BC900_Net_SetIPMASK(IPMASK:PCHAR):integer;stdcall;
function BC900_Net_QueryIPMASK(var IPMASK:PCHAR):integer;stdcall;
function BC900_Net_SetGATEWAY(GATEWAY:PCHAR):integer;stdcall;
function BC900_Net_QueryGATEWAY(var GATEWAY:PCHAR):integer;stdcall;
function BC900_Net_QueryDeviceMAC(var MAC:PCHAR):integer;stdcall;

function BC900_Net_SetRS485BaudRate(BaudRate:pchar):integer;stdcall;
function BC900_Net_SETRS485ALIAS(ALIASID:PCHAR):integer;stdcall;
function BC900_Net_QueryRS485ALIAS(var ALIASID:PCHAR):integer;stdcall;
function BC900_Net_QueryRS485BaudRate(var Baudrate:PCHAR):integer;stdcall;

function BC900_Net_SetAntenna(Antenna:pchar):integer;stdcall;
function BC900_Net_QueryAntenna(var Antenna:pchar):integer;stdcall;
function BC900_Net_SetRFPower(RFPower:pchar):integer;stdcall;
function BC900_Net_QueryRFPower(var RFPower:pchar):integer;stdcall;

function BC900_Net_SetRFTagtype(RFTagtype:pchar):integer;stdcall;
function BC900_Net_QueryRFTagtype(var RFTagtype:pchar):integer;stdcall;
function BC900_Net_SetRFFrequency(freqBtm,freqTop,frequency:PCHAR):integer;stdcall;
function BC900_Net_QueryRFFrequencyAttribute(var freqAttribute:pchar):integer;stdcall;

function BC900_Net_SetMODE(MODE:PCHAR):integer;stdcall;
function BC900_Net_QueryMODE(var MODE:pchar):integer;stdcall;//工作模式
function BC900_Net_SetRFDataInteface(DataInteface:pchar):integer;stdcall;//RS485UP1 0 ,RS485UP2 1,RS485U1D1 2,RS485U2D1 3,RS485U1D2 4,RS485U2D2 5 WG26 6 WG34 7 TCPIP 8 RS232 9
function BC900_Net_QueryRFDataInteface(var DataInteface:pchar):integer;stdcall;

function BC900_Net_SetRFEPCInitialQ(EPCInitialQ:PCHAR):integer;stdcall;
function BC900_Net_QueryRFEPCInitialQ(var EPCInitialQ:pchar):integer;stdcall;
function BC900_Net_SetRFEPCSession(EPCSession:pchar):integer;stdcall;
function BC900_Net_QueryRFEPCSession(var EPCSession:pchar):integer;stdcall;

function BC900_Net_SETCYCInterval(CYCInterval:pchar):integer;stdcall;//MS
function BC900_Net_QueryCYCInterval(var CYCInterval:pchar):integer;stdcall;//MS
function BC900_Net_QueryDrivANTS(var TR,ANTS:pchar):integer;stdcall;
function BC900_Net_SetDrivANTS(TR,ANTS:PCHAR):integer;stdcall;

function BC900_Net_SetTriggerV(TriggerV:PCHAR):integer;stdcall;
function BC900_Net_QueryTriggerV(var TriggerV:pchar):integer;stdcall; //1 HIGH 0 LOW
function BC900_Net_QueryTriggerDelay(var TriggerDelay:pchar):integer;stdcall;//MS
function BC900_Net_SETTriggerDelay(TriggerDelay:pchar):integer;stdcall;//MS

function BC900_Net_SetVerifyCode(VerifyCode:PCHAR):integer;stdcall;//写不写H无所谓
function BC900_Net_QueryVerifyCode(var VerifyCode:pchar):integer;stdcall;
function BC900_Net_6B_QueryDataMask(var DataMask:pchar):integer;stdcall;
function BC900_Net_6B_SetDataMask(DataMask:PCHAR):integer;stdcall;
function BC900_Net_SetWGDatas(WG,Antenna:pchar):integer;stdcall;
function BC900_Net_QueryWGDatas(WG:pchar; var Antenna:pchar):integer;stdcall;
function BC900_Net_QueryWGPulse(var WGPulse:pchar):integer;stdcall;
function BC900_Net_SETWGPulse(WGPulse:pchar):integer;stdcall;
function BC900_Net_SETWGPulInterval(WGPulInterval:pchar):integer;stdcall;//us
function BC900_Net_QueryWGPulInterval(var WGPulInterval:pchar):integer;stdcall; //us
function BC900_Net_QueryWGDataInterval(var WGDataInterval:pchar):integer;stdcall;//MS
function BC900_Net_SETWGDataInterval(WGDataInterval:pchar):integer;stdcall; //MS

function BC900_Net_SetBUZZ(IsBUZZ:PCHAR):integer;stdcall;
function BC900_Net_QueryBUZZ(var IsBUZZ:pchar):integer;stdcall;
function BC900_Net_SetRFFrequencyHOP(IsFixFrequency:PCHAR):integer;stdcall;
function BC900_Net_QueryRFFrequencyHOP(var IsFixFrequency:pchar):integer;stdcall;

function BC900_Net_RESET:integer;stdcall;
function BC900_Net_QueryANTSCheck(var Antenna:pchar):integer;stdcall;
function BC900_Net_ToFactDflt:integer;stdcall;

function BC900_Net_SetRFInitialTries(InitialTries:pchar):integer;stdcall;
function BC900_Net_QueryRFInitialTries(var InitialTries:pchar):integer;stdcall;
function BC900_Net_SetRFSELTries(SELTries:PCHAR):integer;stdcall;
function BC900_Net_QueryRFSELTries(var SELTries:pchar):integer;stdcall;

function BC900_Net_SetANTTimeOut(ANTTimeOut:PCHAR):integer;stdcall;
function BC900_Net_QueryANTTimeOut(var ANTTimeOut:pchar):integer;stdcall;
function BC900_Net_SetANTTries(ANTTries:PCHAR):integer;stdcall;
function BC900_Net_QueryANTTries(var ANTTries:pchar):integer;stdcall;

function BC900_Net_SetTIMEOUTMODE(TimeOutMode:PCHAR):integer;stdcall;
function BC900_Net_QueryTIMEOUTMODE(var TimeOutMode:integer):integer;stdcall;
function BC900_Net_SetCHKSUM(CHKSUM:PCHAR):integer;stdcall;
function BC900_Net_QueryCHKSUM(var CHKSUM:pchar):integer;stdcall;

function BC900_Net_SetNestDistGU(NestDistGU:PCHAR):integer;stdcall;//1 ON 0 OFF 2 TIMING
function BC900_Net_QueryNestDistGU(var NestDistGU:pchar):integer;stdcall; ////1 ON 0 OFF 2 TIMING
function BC900_Net_SetNestDistGUINT(NestDistGUINT:PCHAR):integer;stdcall;     //S
function BC900_Net_QueryNestDistGUINT(var NestDistGUINT:pchar):integer;stdcall; //S

function BC900_Net_SetRDTries(RDTries:PCHAR):integer;stdcall;
function BC900_Net_QueryRDTries(var RDTries:pchar):integer;stdcall;
function BC900_Net_SetRPTTimeOut(RPTTimeOut:PCHAR):integer;stdcall;
function BC900_Net_QueryRPTTimeOut(var RPTTimeOut:pchar):integer;stdcall;

function BC900_Net_SetRFPowerONOFF(IsRFPower:PCHAR):integer;stdcall;
function BC900_Net_GPIOTest:integer;stdcall;
function BC900_Net_QueryListID(var ListID:pchar):integer;stdcall;

function BC900_Net_SetBUMAC(BUMAC:PCHAR):integer;stdcall;
function BC900_Net_QueryBUMAC(var BUMAC:pchar):integer;stdcall;
function BC900_Net_SetSNCode(SNCode:PCHAR):integer;stdcall;
function BC900_Net_QuerySNCode(var SNCode:pchar):integer;stdcall;

//6B
function BC900_6B_Net_WriteTAG(TagID,WriteInfor,WriteAdd,WriteLen:PCHAR):integer;stdcall;
function BC900_6B_Net_QueryReadMEMHex(UID,WriteAdd,WriteLen:PCHAR;var MEMHex:pchar):integer;stdcall;

//EPC
function BC900_EPC_Net_ReadReseverMEM_KillPass(AccessPass,EPCID:PCHAR; var KillPass:pchar):integer;stdcall;
function BC900_EPC_Net_ReadReseverMEM_AccessPass(EPCID:PCHAR; var AccessPass:pchar):integer;stdcall;
function BC900_EPC_Net_ReadUSERMem(ReadAdd,ReadLen,EPCID,AccessPass:PCHAR; var UserMEMData:Pchar):integer;stdcall;
function BC900_EPC_Net_ReadTIDMem(ReadLen,AccessPass,EPCID:PCHAR;var TIDMemData:pchar):integer;stdcall;
function BC900_EPC_Net_ReadEPCMem(AccessPass,EPCID:PCHAR;var EPCMemData:pchar):integer;stdcall;

function BC900_EPC_Net_WriteEPCMem(WriteData:PCHAR):integer;stdcall;
function BC900_EPC_Net_WriteTIDMem(WriteLen,WriteData,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_Net_WriteUSERMem(ReadAdd,ReadLen,WriteData,AccessPass,EPCID:PCHAR):integer;stdcall; //写内存区
function BC900_EPC_Net_SET_KillPass(AccessPass,KillPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_Net_SET_AccessPass(OriAccessPass,NewAccessPass,EPCID:PCHAR):integer;stdcall;//设置密码

function BC900_EPC_Net_ProtectUSERMem(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall; //保护
function BC900_EPC_Net_ProtectTIDMem(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_Net_ProtectEPCMem(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_Net_ProtectAccessPas(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;
function BC900_EPC_Net_ProtectKILLPas(ProtectOrNot,Permannet,AccessPass,EPCID:PCHAR):integer;stdcall;

function BC900_EPC_Net_KillAEPCTag(KillPass,EPCID:PCHAR):integer;stdcall;//杀死

implementation

function CloseCommPort;external 'BC900MAPI.dll';
function OpenCommPort;external 'BC900MAPI.dll';
function EnumMyComPorts;external 'BC900MAPI.dll';

function BC900_RS232CALL;external 'BC900MAPI.dll';
function BC900_TCPIPCALL;external 'BC900MAPI.dll';
function BC900_TCPIPDisconnected;external 'BC900MAPI.dll';

function BC900_GetDLLVersion;external 'BC900MAPI.dll';
function BC900_SetRS232BaudRate;external 'BC900MAPI.dll';
function BC900_SetRS485BaudRate; external 'BC900MAPI.dll';
function BC900_SETRS485ALIAS; external 'BC900MAPI.dll';
function BC900_QueryRS485ALIAS;external 'BC900MAPI.dll';
function BC900_QueryRS485BaudRate; external 'BC900MAPI.dll';
function BC900_QueryRS232BaudRate; external 'BC900MAPI.dll';

function BC900_QueryBUMAC; external 'BC900MAPI.dll';
function BC900_SetBUMAC; external 'BC900MAPI.dll';
function BC900_SetSNCode; external 'BC900MAPI.dll';
function BC900_QuerySNCode; external 'BC900MAPI.dll';

function BC900_SetAntenna;external 'BC900MAPI.dll';
function BC900_QueryAntenna;external 'BC900MAPI.dll';
function BC900_SetRFTagtype;external 'BC900MAPI.dll';
function BC900_QueryRFTagtype;external 'BC900MAPI.dll';
function BC900_SetRFPower;external 'BC900MAPI.dll';
function BC900_QueryRFPower;external 'BC900MAPI.dll';
function BC900_SetRFFrequency;external 'BC900MAPI.dll';
function BC900_QueryRFFrequencyAttribute;external 'BC900MAPI.dll';

function BC900_SetRFFrequencyHOP;external 'BC900MAPI.dll';
function BC900_QueryRFFrequencyHOP;external 'BC900MAPI.dll';
function BC900_SetRFEPCInitialQ;external 'BC900MAPI.dll';
function BC900_QueryRFEPCInitialQ;external 'BC900MAPI.dll';
function BC900_SetRFEPCSession;external 'BC900MAPI.dll';
function BC900_QueryRFEPCSession;external 'BC900MAPI.dll';
function BC900_SetRFInitialTries;external 'BC900MAPI.dll';
function BC900_QueryRFInitialTries;external 'BC900MAPI.dll';
function BC900_QueryRFSELTries;external 'BC900MAPI.dll';
function BC900_SetRFSELTries;external 'BC900MAPI.dll';
function BC900_QueryANTTimeOut;external 'BC900MAPI.dll';
function BC900_SetANTTimeOut;external 'BC900MAPI.dll';

function BC900_QueryANTTries;external 'BC900MAPI.dll';
function BC900_SetANTTries;external 'BC900MAPI.dll';
function BC900_QueryRDTries;external 'BC900MAPI.dll';
function BC900_SetRDTries;external 'BC900MAPI.dll';
function BC900_QueryRPTTimeOut;external 'BC900MAPI.dll';
function BC900_SetRPTTimeOut;external 'BC900MAPI.dll';
function BC900_QueryTIMEOUTMODE;external 'BC900MAPI.dll';
function BC900_SetTIMEOUTMODE;external 'BC900MAPI.dll';
function BC900_QueryCHKSUM;external 'BC900MAPI.dll';
function BC900_SetCHKSUM;external 'BC900MAPI.dll';
function BC900_SetRFDataInteface;external 'BC900MAPI.dll';//RS485UP1 0 ,RS485UP2 1,RS485U1D1 2,RS485U2D1 3,RS485U1D2 4,RS485U2D2 5 WG26 6 WG34 7 TCPIP 8 RS232 9
function BC900_QueryRFDataInteface;external 'BC900MAPI.dll';

function BC900_QueryMODE;external 'BC900MAPI.dll';//工作模式
function BC900_SetMODE;external 'BC900MAPI.dll';
function BC900_QueryVerifyCode;external 'BC900MAPI.dll';
function BC900_SetVerifyCode;external 'BC900MAPI.dll';
function BC900_6B_QueryDataMask;external 'BC900MAPI.dll';
function BC900_6B_SetDataMask;external 'BC900MAPI.dll';
function BC900_QueryWGPulse;external 'BC900MAPI.dll';
function BC900_SETWGPulse;external 'BC900MAPI.dll';
function BC900_SETWGPulInterval;external 'BC900MAPI.dll';
function BC900_QueryWGPulInterval;external 'BC900MAPI.dll';
function BC900_QueryWGDataInterval;external 'BC900MAPI.dll';
function BC900_SETWGDataInterval;external 'BC900MAPI.dll';

function BC900_QueryTriggerDelay;external 'BC900MAPI.dll';
function BC900_SETTriggerDelay;external 'BC900MAPI.dll';
function BC900_QueryCYCInterval;external 'BC900MAPI.dll';
function BC900_SETCYCInterval;external 'BC900MAPI.dll';
function BC900_SetBUZZ;external 'BC900MAPI.dll';
function BC900_QueryBUZZ;external 'BC900MAPI.dll';
function BC900_SetNestDistGU;external 'BC900MAPI.dll';
function BC900_QueryNestDistGU;external 'BC900MAPI.dll';
function BC900_SetNestDistGUINT;external 'BC900MAPI.dll';
function BC900_QueryNestDistGUINT;external 'BC900MAPI.dll';
function BC900_SetWGDatas;external 'BC900MAPI.dll';
function BC900_QueryWGDatas;external 'BC900MAPI.dll';

function BC900_QueryDrivANTS;external 'BC900MAPI.dll';
function BC900_SetDrivANTS;external 'BC900MAPI.dll';
function BC900_SetTriggerV;external 'BC900MAPI.dll';
function BC900_QueryTriggerV;external 'BC900MAPI.dll';

function BC900_ToFactDflt;external 'BC900MAPI.dll';
function BC900_RESET:integer;external 'BC900MAPI.dll';
function BC900_QueryListID;external 'BC900MAPI.dll';

function BC900_SetDate;external 'BC900MAPI.dll';
function BC900_QueryDate;external 'BC900MAPI.dll';
function BC900_SetTime;external 'BC900MAPI.dll';
function BC900_QueryTime;external 'BC900MAPI.dll';
function BC900_QueryANTSCheck;external 'BC900MAPI.dll';
function BC900_QueryHARDVersion;external 'BC900MAPI.dll';
function BC900_QuerySOFTVersion;external 'BC900MAPI.dll';

function BC900_6B_QueryReadMEMHex;external 'BC900MAPI.dll';
function BC900_QueryRead;external 'BC900MAPI.dll';

function BC900_PARK_SetTermID;external 'BC900MAPI.dll';
function BC900_PARK_QueryTermID;external 'BC900MAPI.dll';
function BC900_PARK_QueryRecord;external 'BC900MAPI.dll';
function BC900_PARK_OpenDoor;external 'BC900MAPI.dll';
function BC900_PARK_CloseDoor;external 'BC900MAPI.dll';
function BC900_PARK_UploadStart;external 'BC900MAPI.dll';
function BC900_PARK_UploadEnd;external 'BC900MAPI.dll';
function BC900_PARK_Upload;external 'BC900MAPI.dll';

//EPC特殊
function BC900_EPC_WriteTAG;external 'BC900MAPI.dll';
function BC900_EPC_ProtectUSERMem;external 'BC900MAPI.dll';
function BC900_EPC_ProtectTIDMem;external 'BC900MAPI.dll';
function BC900_EPC_ProtectEPCMem;external 'BC900MAPI.dll';
function BC900_EPC_ProtectAccessPas;external 'BC900MAPI.dll';
function BC900_EPC_ProtectKILLPas;external 'BC900MAPI.dll';
function BC900_EPC_SET_AccessPass;external 'BC900MAPI.dll';
function BC900_EPC_SET_KillPass;external 'BC900MAPI.dll';
function BC900_EPC_WriteUSERMem;external 'BC900MAPI.dll';
function BC900_EPC_WriteTIDMem;external 'BC900MAPI.dll';
function BC900_EPC_WriteEPCMem;external 'BC900MAPI.dll';
function BC900_EPC_KillAEPCTag;external 'BC900MAPI.dll';

function BC900_EPC_ReadReseverMEM_KillPass;external 'BC900MAPI.dll';
function BC900_EPC_ReadReseverMEM_AccessPass;external 'BC900MAPI.dll';
function BC900_EPC_ReadUSERMem;external 'BC900MAPI.dll';
function BC900_EPC_ReadTIDMem;external 'BC900MAPI.dll';
function BC900_EPC_ReadEPCMem;external 'BC900MAPI.dll';

//net set
function BC900_SetSRCIP;external 'BC900MAPI.dll';
function BC900_QuerySRCIP;external 'BC900MAPI.dll';
function BC900_SetSRCPort;external 'BC900MAPI.dll';
function BC900_QuerySRCPort;external 'BC900MAPI.dll';
function BC900_SetDSTIP; external 'BC900MAPI.dll';
function BC900_QueryDSTIP;external 'BC900MAPI.dll';
function BC900_SetDSTPort; external 'BC900MAPI.dll';
function BC900_QueryDSTPort;external 'BC900MAPI.dll';
function BC900_SetDHCP;external 'BC900MAPI.dll'; //0 OFF 1 ON
function BC900_QueryDHCP; external 'BC900MAPI.dll';//0 OFF 1 ON
function BC900_SetIPMASK; external 'BC900MAPI.dll';
function BC900_QueryIPMASK;external 'BC900MAPI.dll';
function BC900_SetGATEWAY; external 'BC900MAPI.dll';
function BC900_QueryGATEWAY; external 'BC900MAPI.dll';
function BC900_QueryDeviceMAC; external 'BC900MAPI.dll';

function SaveBaud;external 'BC900MAPI.dll';
function BC900_GPIOTest;external 'BC900MAPI.dll';
function BC900_SetRFPowerONOFF;external 'BC900MAPI.dll';

//todo net set 2007-12-04
function BC900_Net_SetRS232BaudRate; external 'BC900MAPI.dll';
function BC900_Net_QueryRS232BaudRate; external 'BC900MAPI.dll';

function BC900_Net_SetSRCIP; external 'BC900MAPI.dll';
function BC900_Net_SetSRCPort; external 'BC900MAPI.dll';
function BC900_Net_QuerySRCIP; external 'BC900MAPI.dll';
function BC900_Net_QuerySRCPort; external 'BC900MAPI.dll';
function BC900_Net_SetDSTIP; external 'BC900MAPI.dll';
function BC900_Net_SetDSTPort; external 'BC900MAPI.dll';
function BC900_Net_QueryDSTIP; external 'BC900MAPI.dll';
function BC900_Net_QueryDSTPort; external 'BC900MAPI.dll';

function BC900_Net_SetDHCP; external 'BC900MAPI.dll'; //0 OFF 1 ON
function BC900_Net_QueryDHCP; external 'BC900MAPI.dll'; //0 OFF 1 ON
function BC900_Net_SetIPMASK; external 'BC900MAPI.dll';
function BC900_Net_QueryIPMASK; external 'BC900MAPI.dll';
function BC900_Net_SetGATEWAY; external 'BC900MAPI.dll';
function BC900_Net_QueryGATEWAY; external 'BC900MAPI.dll';
function BC900_Net_QueryDeviceMAC; external 'BC900MAPI.dll';

function BC900_Net_SetRS485BaudRate; external 'BC900MAPI.dll';
function BC900_Net_SETRS485ALIAS; external 'BC900MAPI.dll';
function BC900_Net_QueryRS485ALIAS; external 'BC900MAPI.dll';
function BC900_Net_QueryRS485BaudRate; external 'BC900MAPI.dll'; 

function BC900_Net_SetAntenna; external 'BC900MAPI.dll';
function BC900_Net_QueryAntenna; external 'BC900MAPI.dll';

function BC900_Net_SetRFPower; external 'BC900MAPI.dll';
function BC900_Net_QueryRFPower; external 'BC900MAPI.dll';

function BC900_Net_SetRFTagtype; external 'BC900MAPI.dll';
function BC900_Net_QueryRFTagtype; external 'BC900MAPI.dll';
function BC900_Net_SetRFFrequency; external 'BC900MAPI.dll';
function BC900_Net_QueryRFFrequencyAttribute; external 'BC900MAPI.dll';

function BC900_Net_SetMODE; external 'BC900MAPI.dll';
function BC900_Net_QueryMODE; external 'BC900MAPI.dll';//工作模式
function BC900_Net_SetRFDataInteface; external 'BC900MAPI.dll';//RS485UP1 0 ,RS485UP2 1,RS485U1D1 2,RS485U2D1 3,RS485U1D2 4,RS485U2D2 5 WG26 6 WG34 7 TCPIP 8 RS232 9
function BC900_Net_QueryRFDataInteface; external 'BC900MAPI.dll';

function BC900_Net_SetRFEPCInitialQ; external 'BC900MAPI.dll';
function BC900_Net_QueryRFEPCInitialQ; external 'BC900MAPI.dll';
function BC900_Net_SetRFEPCSession; external 'BC900MAPI.dll';
function BC900_Net_QueryRFEPCSession; external 'BC900MAPI.dll';

function BC900_Net_SETCYCInterval; external 'BC900MAPI.dll';//MS
function BC900_Net_QueryCYCInterval; external 'BC900MAPI.dll';//MS
function BC900_Net_QueryDrivANTS; external 'BC900MAPI.dll';
function BC900_Net_SetDrivANTS; external 'BC900MAPI.dll';

function BC900_Net_SetTriggerV; external 'BC900MAPI.dll';
function BC900_Net_QueryTriggerV; external 'BC900MAPI.dll';//1 HIGH 0 LOW
function BC900_Net_QueryTriggerDelay; external 'BC900MAPI.dll';//MS
function BC900_Net_SETTriggerDelay; external 'BC900MAPI.dll';//MS

function BC900_Net_SetVerifyCode; external 'BC900MAPI.dll';//写不写H无所谓
function BC900_Net_QueryVerifyCode; external 'BC900MAPI.dll';
function BC900_Net_6B_QueryDataMask; external 'BC900MAPI.dll';
function BC900_Net_6B_SetDataMask; external 'BC900MAPI.dll';
function BC900_Net_SetWGDatas; external 'BC900MAPI.dll';
function BC900_Net_QueryWGDatas; external 'BC900MAPI.dll';
function BC900_Net_QueryWGPulse; external 'BC900MAPI.dll';
function BC900_Net_SETWGPulse; external 'BC900MAPI.dll';
function BC900_Net_SETWGPulInterval; external 'BC900MAPI.dll';//us
function BC900_Net_QueryWGPulInterval; external 'BC900MAPI.dll';//us
function BC900_Net_QueryWGDataInterval; external 'BC900MAPI.dll';//MS
function BC900_Net_SETWGDataInterval; external 'BC900MAPI.dll';//MS

function BC900_Net_SetBUZZ;external 'BC900MAPI.dll';
function BC900_Net_QueryBUZZ;external 'BC900MAPI.dll';
function BC900_Net_SetRFFrequencyHOP;external 'BC900MAPI.dll';
function BC900_Net_QueryRFFrequencyHOP;external 'BC900MAPI.dll';

function BC900_Net_RESET; external 'BC900MAPI.dll';
function BC900_Net_QueryANTSCheck; external 'BC900MAPI.dll';
function BC900_Net_ToFactDflt; external 'BC900MAPI.dll';

function BC900_Net_SetRFInitialTries; external 'BC900MAPI.dll';
function BC900_Net_QueryRFInitialTries; external 'BC900MAPI.dll';
function BC900_Net_SetRFSELTries; external 'BC900MAPI.dll';
function BC900_Net_QueryRFSELTries; external 'BC900MAPI.dll';

function BC900_Net_SetANTTimeOut; external 'BC900MAPI.dll';
function BC900_Net_QueryANTTimeOut; external 'BC900MAPI.dll';
function BC900_Net_SetANTTries; external 'BC900MAPI.dll';
function BC900_Net_QueryANTTries; external 'BC900MAPI.dll';

function BC900_Net_SetTIMEOUTMODE; external 'BC900MAPI.dll';
function BC900_Net_QueryTIMEOUTMODE; external 'BC900MAPI.dll';
function BC900_Net_SetCHKSUM; external 'BC900MAPI.dll';
function BC900_Net_QueryCHKSUM; external 'BC900MAPI.dll';

function BC900_Net_SetNestDistGU; external 'BC900MAPI.dll';//1 ON 0 OFF 2 TIMING
function BC900_Net_QueryNestDistGU; external 'BC900MAPI.dll'; //1 ON 0 OFF 2 TIMING
function BC900_Net_SetNestDistGUINT; external 'BC900MAPI.dll';    //S
function BC900_Net_QueryNestDistGUINT; external 'BC900MAPI.dll';//S

function BC900_Net_SetRDTries; external 'BC900MAPI.dll';
function BC900_Net_QueryRDTries; external 'BC900MAPI.dll';
function BC900_Net_SetRPTTimeOut; external 'BC900MAPI.dll';
function BC900_Net_QueryRPTTimeOut; external 'BC900MAPI.dll';

function BC900_Net_SetRFPowerONOFF; external 'BC900MAPI.dll';
function BC900_Net_GPIOTest:integer; external 'BC900MAPI.dll';
function BC900_Net_QueryListID; external 'BC900MAPI.dll';

function BC900_Net_SetBUMAC; external 'BC900MAPI.dll';
function BC900_Net_QueryBUMAC; external 'BC900MAPI.dll';
function BC900_Net_SetSNCode; external 'BC900MAPI.dll';
function BC900_Net_QuerySNCode; external 'BC900MAPI.dll';

//6B
function BC900_6B_Net_WriteTAG; external 'BC900MAPI.dll';
function BC900_6B_Net_QueryReadMEMHex; external 'BC900MAPI.dll';

//EPC
function BC900_EPC_Net_ReadReseverMEM_KillPass; external 'BC900MAPI.dll';
function BC900_EPC_Net_ReadReseverMEM_AccessPass; external 'BC900MAPI.dll';
function BC900_EPC_Net_ReadUSERMem; external 'BC900MAPI.dll';
function BC900_EPC_Net_ReadTIDMem; external 'BC900MAPI.dll';
function BC900_EPC_Net_ReadEPCMem; external 'BC900MAPI.dll';

function BC900_EPC_Net_WriteEPCMem; external 'BC900MAPI.dll';
function BC900_EPC_Net_WriteTIDMem; external 'BC900MAPI.dll';
function BC900_EPC_Net_WriteUSERMem; external 'BC900MAPI.dll'; //写内存区
function BC900_EPC_Net_SET_KillPass; external 'BC900MAPI.dll';
function BC900_EPC_Net_SET_AccessPass; external 'BC900MAPI.dll';//设置密码

function BC900_EPC_Net_ProtectUSERMem; external 'BC900MAPI.dll';//保护
function BC900_EPC_Net_ProtectTIDMem; external 'BC900MAPI.dll';
function BC900_EPC_Net_ProtectEPCMem; external 'BC900MAPI.dll';
function BC900_EPC_Net_ProtectAccessPas; external 'BC900MAPI.dll';
function BC900_EPC_Net_ProtectKILLPas; external 'BC900MAPI.dll';

function BC900_EPC_Net_KillAEPCTag; external 'BC900MAPI.dll';//杀死

end.
