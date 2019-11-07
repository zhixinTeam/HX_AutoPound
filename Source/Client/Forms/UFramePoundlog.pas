{*******************************************************************************
  作者: dmzn@163.com 2014-06-12
  描述: 称重记录
*******************************************************************************}
unit UFramePoundlog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxCheckBox, Menus;

type
  TfFramePoundLog = class(TfFrameNormal)
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
    Check1: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnRefreshClick(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FBaseTitle: string;
    //报表表头
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadPopedom; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, ShellAPI, UFormDateFilter, UFormBase, UFormInputbox,
  UFormWait, UDataModule, USysConst, USysDB;

class function TfFramePoundLog.FrameID: integer;
begin
  Result := cFI_FramePoundLog;
end;

procedure TfFramePoundLog.OnCreateFrame;
begin
  inherited;
  FBaseTitle := FReportTitle;

  InitDateRange(Name, FStart, FEnd);
  FEnd := FEnd + 1;
end;

procedure TfFramePoundLog.OnDestroyFrame;
begin
  inherited;
  SaveDateRange(Name, FStart, FEnd);
end;

procedure TfFramePoundLog.OnLoadPopedom;
begin
  inherited;
  if BtnDel.Enabled then
       BtnDel.Tag := 10
  else BtnDel.Tag := 0;
end;

function TfFramePoundLog.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  //xxxxx

  FReportTitle := FBaseTitle;
  if FReportTitle <> '' then
    FReportTitle := FReportTitle + #13#10;
  FReportTitle := FReportTitle + DateTime2Str(FStart) + ' 至 ' + DateTime2Str(FEnd);

  if Check1.Checked then
       nStr := sTable_PoundBak
  else nStr := sTable_PoundLog;

  Result := 'Select *,P_MValue-P_PValue as P_Weight From %s ' +
            'Where (P_MDate>=''%s'' and P_MDate<''%s'')';
  Result := Format(Result, [nStr, DateTime2Str(FStart), DateTime2Str(FEnd)]);

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

//Desc: 切换新旧表
procedure TfFramePoundLog.Check1Click(Sender: TObject);
begin
  BtnDel.Enabled := (BtnDel.Tag = 10) and (not Check1.Checked);
  InitFormData(FWhere);
end;

//Desc: 查询
procedure TfFramePoundLog.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('P_Truck Like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditMate then
  begin
    EditMate.Text := Trim(EditMate.Text);
    if EditMate.Text = '' then Exit;

    FWhere := Format('P_MName Like ''%%%s%%''', [EditMate.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := Format('P_CusName Like ''%%%s%%''', [EditCus.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 刷新
procedure TfFramePoundLog.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFramePoundLog.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd, True) then InitFormData(FWhere);
end;

//Desc: 单车单次查看
procedure TfFramePoundLog.N1Click(Sender: TObject);
var nStr,nID,nDir: string;
    nPic: TPicture;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要查看的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;
  nDir := gSysParam.FPicPath + nID + '\';

  if DirectoryExists(nDir) then
  begin
    ShellExecute(GetDesktopWindow, 'open', PChar(nDir), nil, nil, SW_SHOWNORMAL);
    Exit;
  end else ForceDirectories(nDir);

  nPic := nil;
  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Picture, nID]);

  ShowWaitForm(ParentForm, '读取图片', True);
  try
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('本次称重无抓拍', sHint);
        Exit;
      end;

      nPic := TPicture.Create;
      First;

      While not eof do
      begin
        nStr := nDir + Format('%s_%s_%s_%s.jpg', [FieldByName('P_Name').AsString,
                FieldByName('P_Mate').AsString, FieldByName('P_ID').AsString,
                FieldByName('R_ID').AsString]);
        //xxxxx

        FDM.LoadDBImage(FDM.SqlTemp, 'P_Picture', nPic);
        nPic.SaveToFile(nStr);
        Next;
      end;
    end;

    ShellExecute(GetDesktopWindow, 'open', PChar(nDir), nil, nil, SW_SHOWNORMAL);
    //open dir
  finally
    nPic.Free;
    CloseWaitForm;
    FDM.SqlTemp.Close;
  end;
end;

//Desc: 删除nDir文件夹
function DeleteFolder(const nDir:string): Boolean;
var nFO: TSHFILEOPSTRUCT;
begin
  FillChar(nFO, SizeOf(nFO), 0);
  //init

  with nFO do
  begin
    Wnd := 0;
    wFunc := FO_DELETE;
    pFrom := PChar(nDir+#0);
    pTo := #0#0;
    fFlags := FOF_NOCONFIRMATION+FOF_SILENT;
  end;

  Result := (SHFileOperation(nFO) = 0);
end;

//Desc: 单车多次查看
procedure TfFramePoundLog.N3Click(Sender: TObject);
var nStr,nID,nDir,nDate: string;
    nInt: Integer;
    nPic: TPicture;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要查看的记录', sHint);
    Exit;
  end;

  nInt := 0;
  nStr := '10';

  while True do
  begin
    nDir := '请输入从本次开始,向前查看的拍照张数(1-50):';
    if not ShowInputBox(nDir, sAsk, nStr) then Exit;
    if not IsNumber(nStr, False) then continue;

    nInt := StrToInt(nStr);
    if (nInt > 0) and (nInt <= 50) then break;
  end;

  nID := SQLQuery.FieldByName('P_Truck').AsString;
  nDir := gSysParam.FPicPath + nID + '\';

  if DirectoryExists(nDir) then
    DeleteFolder(nDir);
  //xxxxx

  if not DirectoryExists(nDir) then
    ForceDirectories(nDir);
  //xxxxx
                      
  nDate := DateTime2Str(SQLQuery.FieldByName('P_MDate').AsDateTime+2/(24*3600));
  //称重时间延后2秒

  nStr := 'Select Top %d * From %s ' +
          'Where P_Date<''%s'' And P_Name=''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [nInt, sTable_Picture, nDate, nID]);
  //xxxxx

  nPic := nil;
  ShowWaitForm(ParentForm, '读取图片', True);
  try
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('没有满足条件的图片', sHint);
        Exit;
      end;

      nPic := TPicture.Create;
      nInt := 0;
      First;

      While not eof do
      try
        ShowWaitForm(ParentForm, IntToStr(RecordCount - nInt));
        Inc(nInt);

        nStr := nDir + Format('%s_%s_%s_%s.jpg', [FieldByName('P_Name').AsString,
                FieldByName('P_Mate').AsString, FieldByName('P_ID').AsString,
                FieldByName('R_ID').AsString]);
        //xxxxx

        FDM.LoadDBImage(FDM.SqlTemp, 'P_Picture', nPic);
        nPic.SaveToFile(nStr);
      finally
        Next;
      end;
    end;
    
    ShellExecute(GetDesktopWindow, 'open', PChar(nDir), nil, nil, SW_SHOWNORMAL);
    //open dir
  finally
    nPic.Free;
    CloseWaitForm;
    FDM.SqlTemp.Close;
  end;
end;

//Desc: 多车多次查看
procedure TfFramePoundLog.N4Click(Sender: TObject);
var nStr,nDir,nDate: string;
    nInt: Integer;
    nPic: TPicture;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要查看的记录', sHint);
    Exit;
  end;

  nInt := 0;
  nStr := '10';

  while True do
  begin
    nDir := '请输入从本次开始,向前查看的拍照张数(1-50):';
    if not ShowInputBox(nDir, sAsk, nStr) then Exit;
    if not IsNumber(nStr, False) then continue;

    nInt := StrToInt(nStr);
    if (nInt > 0) and (nInt <= 50) then break;
  end;

  nDir := gSysParam.FPicPath + 'MultiView' + '\';
  if DirectoryExists(nDir) then
    DeleteFolder(nDir);
  //xxxxx

  if not DirectoryExists(nDir) then
    ForceDirectories(nDir);
  //xxxxx

  nDate := DateTime2Str(SQLQuery.FieldByName('P_MDate').AsDateTime+2/(24*3600));
  //称重时间延后2秒
  
  nStr := 'Select Top %d * From %s ' +
          'Where P_Date<''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [nInt, sTable_Picture, nDate]);
  //xxxxx

  nPic := nil;
  ShowWaitForm(ParentForm, '读取图片', True);
  try
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('没有满足条件的图片', sHint);
        Exit;
      end;

      nPic := TPicture.Create;
      nInt := 0;
      First;

      While not eof do
      try
        ShowWaitForm(ParentForm, IntToStr(RecordCount - nInt));
        Inc(nInt);

        nStr := nDir + Format('%s_%s_%s_%s.jpg', [FieldByName('P_Name').AsString,
                FieldByName('P_Mate').AsString, FieldByName('P_ID').AsString,
                FieldByName('R_ID').AsString]);
        //xxxxx

        FDM.LoadDBImage(FDM.SqlTemp, 'P_Picture', nPic);
        nPic.SaveToFile(nStr);
      finally
        Next;
      end;
    end;

    ShellExecute(GetDesktopWindow, 'open', PChar(nDir), nil, nil, SW_SHOWNORMAL);
    //open dir
  finally
    nPic.Free;
    CloseWaitForm;
    FDM.SqlTemp.Close;
  end;
end;

procedure TfFramePoundLog.BtnDelClick(Sender: TObject);
var nIdx: Integer;
    nStr,nID,nP: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;
  nStr := Format('确定要删除编号为[ %s ]称重记录吗?', [nID]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := Format('Select * From %s Where 1<>1', [sTable_PoundLog]);
  //only for fields
  nP := '';

  with FDM.QueryTemp(nStr) do
  begin
    for nIdx:=0 to FieldCount - 1 do
    if (Fields[nIdx].DataType <> ftAutoInc) and
       (Pos('P_Del', Fields[nIdx].FieldName) < 1) then
      nP := nP + Fields[nIdx].FieldName + ',';
    //所有字段,不包括删除
    System.Delete(nP, Length(nP), 1);
  end;

  nStr := 'Insert Into $PB($FL,P_DelMan,P_DelDate) ' +
          'Select $FL,''$User'',$Now From $PL Where P_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$PB', sTable_PoundBak),
          MI('$FL', nP), MI('$User', gSysParam.FUserID),
          MI('$Now', sField_SQLServer_Now),
          MI('$PL', sTable_PoundLog), MI('$ID', nID)]);
  FDM.ExecuteSQL(nStr);
                      
  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Delete From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Picture, nID]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('删除成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePoundLog, TfFramePoundLog.FrameID);
end.
