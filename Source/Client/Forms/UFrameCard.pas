{*******************************************************************************
  作者: dmzn@163.com 2012-04-07
  描述: 办理磁卡
*******************************************************************************}
unit UFrameCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  IniFiles, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, Menus, dxLayoutControl, cxMaskEdit, cxButtonEdit,
  cxTextEdit, ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameBillCard = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, USysDataDict, USysConst, USysDB, USysGrid,
  UDataModule, UFormDateFilter, U900Reader;

//------------------------------------------------------------------------------
class function TfFrameBillCard.FrameID: integer;
begin
  Result := cFI_FrameCard;
end;

procedure TfFrameBillCard.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBillCard.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameBillCard.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $CD cd ';
  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where (C_Date>=''$S'' and C_Date<''$End'')'
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$CD', sTable_Card),
          MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 刷新
procedure TfFrameBillCard.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  InitFormData(FWhere);
end;

//Date: 2014-06-09
//Parm: 记录号
//Desc: 为nTruck绑定新的磁卡
function BindTruckCard(const nRID: string): Boolean;
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_EditData;
  nP.FParamA := nRID;

  CreateBaseFormItem(cFI_FormBindCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Desc: 办理
procedure TfFrameBillCard.BtnAddClick(Sender: TObject);
begin
  if BindTruckCard('') then
  begin
    InitFormData(FWhere);
    ShowMsg('办理成功', sHint);
  end;
end;

//Desc 删除
procedure TfFrameBillCard.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的磁卡', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_Status').AsString;
  if (nStr <> sFlag_CardIdle) and (nStr <> sFlag_CardInvalid) then
  begin
    ShowMsg('空闲或注销卡允许删除', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_Freeze').AsString;
  if nStr = sFlag_Yes then
  begin
    ShowMsg('该卡已经被冻结', sHint); Exit;
  end;

  nSQL := '确定要对卡[ %s ]执行删除操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Delete From %s Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('删除操作成功', sHint);
end;

//Desc: 日期筛选
procedure TfFrameBillCard.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameBillCard.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := 'C_Card like ''%%%s%%'' Or C_Card2 like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCard.Text, EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'C_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end;
end;

procedure TfFrameBillCard.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditCard.Text := g900MReader.ReadCard(ParentForm, False, cCard_M1);
  EditTruckPropertiesButtonClick(Sender, AButtonIndex);
end;

procedure TfFrameBillCard.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditTruckPropertiesButtonClick(Sender, 0);
  end;
end;

//Desc: 无效磁卡
procedure TfFrameBillCard.N5Click(Sender: TObject);
begin
  FWhere := Format('C_Status=''%s''', [sFlag_CardInvalid]);
  InitFormData(FWhere);
end;

//Desc: 全部磁卡
procedure TfFrameBillCard.N6Click(Sender: TObject);
begin
  FWhere := '1=1';
  InitFormData(FWhere);
end;

//Desc: 冻结磁卡
procedure TfFrameBillCard.N8Click(Sender: TObject);
begin
  FWhere := Format('C_Freeze=''%s''', [sFlag_Yes]);
  InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: 控制菜单项
procedure TfFrameBillCard.PMenu1Popup(Sender: TObject);
var nStr: string;
    i,nCount: integer;
begin
  nCount := PMenu1.Items.Count - 1;
  for i:=0 to nCount do
    PMenu1.Items[i].Enabled := False;
  //xxxxx
  
  N1.Enabled := True;
  N17.Enabled := cxView1.DataController.GetSelectedCount > 0;
  //备注信息

  if (cxView1.DataController.GetSelectedCount > 0) and BtnAdd.Enabled then
  begin
    nStr := SQLQuery.FieldByName('C_Status').AsString;
    N9.Enabled := nStr = sFlag_CardUsed;
    //使用中的卡可以挂失
    N10.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以解挂失
    N11.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以补办卡
    N12.Enabled := nStr <> sFlag_CardInvalid;
    //可随时销卡
  end;

  if (cxView1.DataController.GetSelectedCount > 0) and BtnEdit.Enabled then
  begin
    nStr := SQLQuery.FieldByName('C_Freeze').AsString;
    N14.Enabled := nStr <> sFlag_Yes;   //冻结
    N15.Enabled := nStr = sFlag_Yes;    //解除
  end;
end;

//Desc: 挂失磁卡
procedure TfFrameBillCard.N9Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_CardLoss, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('挂失操作成功', sHint);
end;

//Desc: 解除挂失
procedure TfFrameBillCard.N10Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_CardUsed, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除挂失操作成功', sHint);
end;

//Desc: 补办磁卡
procedure TfFrameBillCard.N11Click(Sender: TObject);
begin
  if BindTruckCard(SQLQuery.FieldByName('R_ID').AsString) then
  begin
    InitFormData(FWhere);
    ShowMsg('补卡操作成功', sHint);
  end;
end;

//Desc: 注销磁卡
procedure TfFrameBillCard.N12Click(Sender: TObject);
var nStr,nCard: string;
begin
  nCard := SQLQuery.FieldByName('C_Card').AsString;
  nStr := Format('确定要对卡[ %s ]执行销卡操作吗?', [nCard]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, nCard]);
  FDM.ExecuteSQL(nStr);

  InitFormData(FWhere);
  ShowMsg('注销操作成功', sHint);
end;

//Desc: 冻结磁卡
procedure TfFrameBillCard.N14Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Freeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_Yes, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('冻结操作成功', sHint);
end;

//Desc: 解除冻结
procedure TfFrameBillCard.N15Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Freeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_No, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除冻结操作成功', sHint);
end;

//Desc: 修改备注
procedure TfFrameBillCard.N17Click(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  if BtnEdit.Enabled then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
    nP.FParamB := 500;

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    nP.FParamC := 'Update %s Set C_Memo=''$Memo'' Where R_ID=%s';
    nP.FParamC := Format(nP.FParamC, [sTable_Card, nStr]);

    CreateBaseFormItem(cFI_FormMemo, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      InitFormData(FWhere);
    //xxxxx
  end else
  begin
    nP.FCommand := cCmd_ViewData;
    nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
    CreateBaseFormItem(cFI_FormMemo, '', @nP);
  end;;
end;

initialization
  gControlManager.RegCtrl(TfFrameBillCard, TfFrameBillCard.FrameID);
end.
