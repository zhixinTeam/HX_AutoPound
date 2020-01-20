{*******************************************************************************
  作者: dmzn@163.com 2008-08-07
  描述: 系统数据库常量定义

  备注:
  *.自动创建SQL语句,支持变量:$Inc,自增;$Float,浮点;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,二进制流
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //系统表项

var
  gSysTableList: TList = nil;                        //系统表数组
  gSysDBType: TSysDatabaseType = dtSQLServer;        //系统数据类型

//------------------------------------------------------------------------------
const
  //自增字段
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //小数字段
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //图片字段
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //日期相关
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_Integer       = 'I';                         //整数
  sFlag_Decimal       = 'D';                         //小数

  sFlag_NotMatter     = '@';                         //无关编号(任意编号都可)
  sFlag_ForceDone     = '#';                         //强制完成(未完成前不换)
  sFlag_FixedNo       = '$';                         //指定编号(使用相同编号)

  sFlag_Provide       = 'P';                         //供应
  sFlag_Sale          = 'S';                         //销售
  sFlag_Other         = 'O';                         //其它

  sFlag_Dai           = 'D';                         //袋装
  sFlag_PoundDai      = 'P';                         //袋装(磅房标记)
  sFlag_San           = 'S';                         //散装
  sFlag_PoundSan      = 'B';                         //散装(磅房标记)

  sFlag_SerialSAP     = 'SAPFunction';               //SAP编码组
  sFlag_SAPMsgNo      = 'SAP_MsgNo';                 //SAP消息号

  sFlag_SerailSYS     = 'SYSTableID';                //SYS编码组
  sFlag_TruckLog      = 'SYS_TruckLog';              //车辆记录
  sFlag_PoundLog      = 'SYS_PoundLog';              //过磅记录

  sFlag_CardIdle      = 'I';                         //空闲卡
  sFlag_CardUsed      = 'U';                         //使用中
  sFlag_CardLoss      = 'L';                         //挂失卡
  sFlag_CardInvalid   = 'N';                         //注销卡

  sFlag_CustomerItem  = 'CustomerItem';              //客户信息项
  sFlag_ProviderItem  = 'ProviderItem';              //供应商信息项
  sFlag_MaterailsItem = 'MaterailsItem';             //原材料信息项

  sFlag_SysParam      = 'SysParam';
  sFlag_InputTruck    = 'AllowedInputTruck';         //手动输入车牌
  sFlag_PrePValidLen  = 'PrePValidLength';           //预置皮重时长
  sFlag_PrePValidMon  = 'ValidOneMonth';             //预置皮重当月有效
  sFlag_PoundList     = 'PoundList';                 //磅站列表

  {*数据表*}
  sTable_Factorys     = 'Sys_Factorys';              //工厂列表
  sTable_Group        = 'Sys_Group';                 //用户组
  sTable_User         = 'Sys_User';                  //用户表
  sTable_Menu         = 'Sys_Menu';                  //菜单表
  sTable_Popedom      = 'Sys_Popedom';               //权限表
  sTable_PopItem      = 'Sys_PopItem';               //权限项
  sTable_Entity       = 'Sys_Entity';                //字典实体
  sTable_DictItem     = 'Sys_DataDict';              //字典明细

  sTable_SysDict      = 'Sys_Dict';                  //系统字典
  sTable_ExtInfo      = 'Sys_ExtInfo';               //附加信息
  sTable_SysLog       = 'Sys_EventLog';              //系统日志
  sTable_BaseInfo     = 'Sys_BaseInfo';              //基础信息

  sTable_SerialBase   = 'Sys_SerialBase';            //编码种子
  sTable_SerialStatus = 'Sys_SerialStatus';          //编号状态
  sTable_Card         = 'Sys_Card';                  //销售磁卡
  sTable_Truck        = 'Sys_Truck';                 //车辆表
  sTable_Picture      = 'Sys_Picture';               //存放图片

  sTable_TruckLog     = 'P_TruckLog';                //车辆日志
  sTable_Provider     = 'P_Provider';                //客户表
  sTable_Materails    = 'P_Materails';               //物料表
  sTable_PoundLog     = 'P_PoundLog';                //过磅数据
  sTable_PoundBak     = 'P_PoundBak';                //过磅作废

  {*新建表*}
  sSQL_NewFactorys = 'Create Table $Table(R_ID $Inc, F_ID varChar(32),' +
       'F_Name varChar(100), F_MITUrl varChar(128), F_HardUrl varChar(128),' +
       'F_WechatUrl varChar(128), F_DBConn varChar(500),' +
       'F_Valid Char(1), F_Index Integer)';
  {-----------------------------------------------------------------------------
   工厂列表: Factorys
   *.R_ID: 编号
   *.F_ID: 工厂编号
   *.F_Name: 工厂名称
   *.F_MITUrl: 中间件地址
   *.F_HardUrl: 硬件守护地址
   *.F_WechatUrl: 微信服务地址
   *.F_DBConn: 数据库连接配置
   *.F_Valid: 有效(Y/N)
   *.F_Index: 加载顺序
  -----------------------------------------------------------------------------}

  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   系统字典: SysDict
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_Desc: 描述
   *.D_Value: 取值
   *.D_Memo: 相关信息
   *.D_ParamA: 浮点参数
   *.D_ParamB: 字符参数
   *.D_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.I_ID: 编号
   *.I_Group: 信息分组
   *.I_ItemID: 信息标识
   *.I_Item: 信息项
   *.I_Info: 信息内容
   *.I_ParamA: 浮点参数
   *.I_ParamB: 字符参数
   *.I_Memo: 备注信息
   *.I_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   系统日志: SysLog
   *.L_ID: 编号
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_Group: 信息分组
   *.L_ItemID: 信息标识
   *.L_KeyID: 辅助标识
   *.L_Event: 事件
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   基本信息表: BaseInfo
   *.B_ID: 编号
   *.B_Group: 分组
   *.B_Text: 内容
   *.B_Py: 拼音简写
   *.B_Memo: 备注信息
   *.B_PID: 上级节点
   *.B_Index: 创建顺序
  -----------------------------------------------------------------------------}

  sSQL_NewSerialBase = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer)';
  {-----------------------------------------------------------------------------
   串行编号基数表: SerialBase
   *.B_ID: 编号
   *.B_Group: 分组
   *.B_Object: 对象
   *.B_Prefix: 前缀
   *.B_IDLen: 编号长
   *.B_Base: 基数
  -----------------------------------------------------------------------------}

  sSQL_NewSerialStatus = 'Create Table $Table(S_ID $Inc, S_Object varChar(32),' +
       'S_SerailID varChar(32), S_PairID varChar(32), S_Status Char(1),' +
       'S_Date DateTime)';
  {-----------------------------------------------------------------------------
   串行状态表: SerialStatus
   *.S_ID: 编号
   *.S_Object: 对象
   *.S_SerailID: 串行编号
   *.S_PairID: 配对编号
   *.S_Status: 状态(Y,N)
   *.S_Date: 创建时间
  -----------------------------------------------------------------------------}

  sSQL_NewPicture = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Name varChar(32), P_Mate varChar(80), P_Date DateTime, P_Picture Image)';
  {-----------------------------------------------------------------------------
   图片: Picture
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_Mate: 物料
   *.P_Date: 时间
   *.P_Picture: 图片
  -----------------------------------------------------------------------------}

  sSQL_NewCard = 'Create Table $Table(R_ID $Inc, C_Card varChar(32),' +
       'C_Card2 varChar(32), C_Card3 varChar(32), C_Owner varChar(15),' +
       'C_Truck varChar(15), C_Status Char(1),' +
       'C_Freeze Char(1), C_Used Char(1), C_UseTime Integer Default 0,' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   磁卡表:Card
   *.R_ID:记录编号
   *.C_Card:主卡号
   *.C_Card2,C_Card3:副卡号
   *.C_Owner:持有人
   *.C_Truck:提货车牌
   *.C_Used:用途(供应,销售)
   *.C_UseTime:使用次数
   *.C_Status:状态(空闲,使用,注销,挂失)
   *.C_Freeze:是否冻结
   *.C_Man:办理人
   *.C_Date:办理时间
   *.C_Memo:备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewTruck = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15), ' +
       'T_PY varChar(15), T_Owner varChar(32), T_Phone varChar(15), ' +
       'T_Used Char(1), T_Mate varChar(32), T_MName varChar(80),' +
       'T_FixPound varChar(10),T_MaxWeight $Float,' +
       'T_Provider varChar(32), T_PName varChar(80), T_PrePValue $Float,' +
       'T_PrePMan varChar(32), T_PrePTime DateTime, T_LastPound varChar(15),' +
       'T_LastTime DateTime, T_Valid Char(1))';
  {-----------------------------------------------------------------------------
   车辆信息:Truck
   *.R_ID: 记录号
   *.T_Truck: 车牌号
   *.T_PY: 车牌拼音
   *.T_Owner: 车主
   *.T_Phone: 联系方式
   *.T_Used: 用途(供应,销售)
   *.T_Mate,T_MName: 物料
   *.T_FixPound: 指定磅站
   *.T_MaxWeight:净重上限(吨)
   *.T_Provider,T_PName: 供应
   *.T_PrePValue: 预置皮重
   *.T_PrePMan: 预置司磅
   *.T_PrePTime: 预置时间
   *.T_LastPound: 上次记录号
   *.T_LastTime: 上次称重
   *.T_Valid: 是否有效
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(R_ID $Inc, P_ID varChar(32),' +
       'P_Name varChar(80),P_PY varChar(80), P_Phone varChar(20),' +
       'P_Saler varChar(32),P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   供应商: Provider
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_PY: 拼音简写
   *.P_Phone: 联系方式
   *.P_Saler: 业务员
   *.P_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(R_ID $Inc, M_ID varChar(32),' +
       'M_Name varChar(80),M_PY varChar(80),M_Unit varChar(20),M_Price $Float,' +
       'M_PrePValue Char(1), M_PrePTime Integer, M_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   物料表: Materails
   *.M_ID: 编号
   *.M_Name: 名称
   *.M_PY: 拼音简写
   *.M_Unit: 单位
   *.M_PrePValue: 预置皮重
   *.M_PrePTime: 皮重时长(天)
   *.M_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewPoundLog = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Type varChar(1), P_Order varChar(20), P_Card varChar(16),' +
       'P_Bill varChar(20), P_Truck varChar(15), P_CusID varChar(32),' +
       'P_CusName varChar(80), P_MID varChar(32),P_MName varChar(80),' +
       'P_MType varChar(10), P_LimValue $Float,' +
       'P_PValue $Float, P_PDate DateTime, P_PMan varChar(32), ' +
       'P_MValue $Float, P_MDate DateTime, P_MMan varChar(32), ' +
       'P_LastMDate DateTime, P_LastInterval Integer,' +
       'P_FactID varChar(32), P_Station varChar(10), P_MAC varChar(32),' +
       'P_Direction varChar(10), P_PModel varChar(10), P_Status Char(1),' +
       'P_Valid Char(1), P_OverNet Char(1), P_PrintNum Integer Default 1,' +
       'P_DelMan varChar(32), P_DelDate DateTime)';
  {-----------------------------------------------------------------------------
   过磅记录: PoundLog
   *.P_ID: 编号
   *.P_Type: 类型(销售,供应,临时)
   *.P_Order: 订单号
   *.P_Bill: 交货单
   *.P_Truck: 车牌
   *.P_CusID: 客户号
   *.P_CusName: 物料名
   *.P_MID: 物料号
   *.P_MName: 物料名
   *.P_MType: 包,散等
   *.P_LimValue: 票重
   *.P_PValue,P_PDate,P_PMan: 皮重
   *.P_MValue,P_MDate,P_MMan: 毛重
   *.P_LastMDate: 上次称毛时间
   *.P_LastInterval: 两次称毛间隔
   *.P_FactID: 工厂编号
   *.P_Station,P_MAC: 磅站标识
   *.P_Direction: 物料流向(进,出)
   *.P_PModel: 过磅模式(标准,配对等)
   *.P_Status: 记录状态
   *.P_Valid: 是否有效
   *.P_OverNet: 是否超重(Y/N)
   *.P_PrintNum: 打印次数
   *.P_DelMan,P_DelDate: 删除记录
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// 数据查询
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   从数据字典读取数据
   *.$Table:数据字典表
   *.$Name:字典项名称
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   从扩展信息表读取数据
   *.$Table:扩展信息表
   *.$Group:分组名称
   *.$ID:信息标识
  -----------------------------------------------------------------------------}
  
implementation

//Desc: 添加系统表项
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: 系统表
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;
  AddSysTableItem(sTable_Factorys, sSQL_NewFactorys);
  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);

  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);

  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase);
  AddSysTableItem(sTable_SerialStatus, sSQL_NewSerialStatus);
  AddSysTableItem(sTable_Picture, sSQL_NewPicture);

  AddSysTableItem(sTable_Card, sSQL_NewCard);
  AddSysTableItem(sTable_Truck, sSQL_NewTruck);
  AddSysTableItem(sTable_Provider, ssql_NewProvider);
  AddSysTableItem(sTable_Materails, sSQL_NewMaterails);
  AddSysTableItem(sTable_PoundLog, sSQL_NewPoundLog);
  AddSysTableItem(sTable_PoundBak, sSQL_NewPoundLog);
end;

//Desc: 清理系统表
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


