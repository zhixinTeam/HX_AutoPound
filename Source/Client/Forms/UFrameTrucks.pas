{*******************************************************************************
  作者: dmzn@163.com 2014-06-12
  描述: 车辆管理
*******************************************************************************}
unit UFrameTrucks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameTrucks = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function GetVal(const nRow: Integer; const nField: string): string;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormDateFilter, UFormBase, USysConst, USysDB,
  UDataModule, UFormInputbox;

class function TfFrameTrucks.FrameID: integer;
begin
  Result := cFI_FrameTrucks;
end;

procedure TfFrameTrucks.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTrucks.OnDestroyFrame;
begin
  inherited;
  SaveDateRange(Name, FStart, FEnd);
end;

function TfFrameTrucks.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  //xxxxx

  Result := 'Select tr.*,P_Name From %s tr ' +
            ' Left Join %s pr On pr.P_ID=tr.T_Provider';
  Result := Format(Result, [sTable_Truck, sTable_Provider]);

  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  //xxxxx
end;

//Desc: 查询
procedure TfFrameTrucks.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('T_Truck Like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditMate then
  begin
    EditMate.Text := Trim(EditMate.Text);
    if EditMate.Text = '' then Exit;

    FWhere := Format('T_MName Like ''%%%s%%''', [EditMate.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := Format('T_PName Like ''%%%s%%''', [EditCus.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 刷新
procedure TfFrameTrucks.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameTrucks.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

procedure TfFrameTrucks.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('T_Truck').AsString;
    nStr := Format('确定要删除车辆[ %s ]吗?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: 获取nRow行nField字段的内容
function TfFrameTrucks.GetVal(const nRow: Integer; const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

procedure TfFrameTrucks.BtnEditClick(Sender: TObject);
var nRecords,nTrucks: string;
    nIdx: Integer;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择车辆记录', sHint);
    Exit;
  end;

  nRecords := '';
  nTrucks := '';
  for nIdx:=cxView1.DataController.GetSelectedCount - 1 downto 0 do
  begin
    nRecords := nRecords + GetVal(nIdx, 'R_ID');
    if nIdx > 0 then
      nRecords := nRecords + ',';
    //xxxxx

    nTrucks := nTrucks + GetVal(nIdx, 'T_Truck');
    if nIdx > 0 then
      nTrucks := nTrucks + ',';
    //xxxxx
  end;

  if Length(nTrucks) > 200 then
  begin
    ShowMsg('批量操作的记录太多', sHint);
    Exit;
  end;

  with nParam do
  begin
    FCommand := cCmd_EditData;
    FParamA := nRecords;
    FParamB := SQLQuery.FieldByName('T_FixPound').AsString;
    FParamC := FloatToStr(SQLQuery.FieldByName('T_MaxWeight').AsFloat);
    FParamD := nTrucks;
  end;

  CreateBaseFormItem(cFI_FormSetTruck, FPopedom, @nParam);
  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
    ShowMsg('设置成功', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTrucks, TfFrameTrucks.FrameID);
end.
