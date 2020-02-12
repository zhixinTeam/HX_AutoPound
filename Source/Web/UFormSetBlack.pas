{*******************************************************************************
  作者: dmzn@163.com 2020-02-11
  描述: 设置车辆黑名单
*******************************************************************************}
unit UFormSetBlack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UFormNormal, uniGUIBaseClasses, uniGUIClasses, uniGUImJSForm, uniDBGrid,
  unimDBGrid, unimButton, Data.DB, Datasnap.DBClient, uniEdit,
  unimEdit, unimMenu, uniBasicGrid, unimDBListGrid, uniButton;

type
  TfFormSetBlack = class(TfFormNormal)
    PanelMain: TUnimContainerPanel;
    DBGrid1: TUnimDBGrid;
    ClientDS1: TClientDataSet;
    DataSource1: TDataSource;
    PanelBottom: TUnimContainerPanel;
    PanelTop: TUnimContainerPanel;
    EditTruck: TUnimEdit;
    BtnFind: TUnimButton;
    BtnSortTruck: TUnimButton;
    BtnSortCus: TUnimButton;
    BtnSet: TUnimButton;
    MenuBottom: TUnimMenu;
    procedure UnimFormCreate(Sender: TObject);
    procedure UnimFormDestroy(Sender: TObject);
    procedure DBGrid1Click(Sender: TObject);
    procedure BtnFindClick(Sender: TObject);
    procedure BtnSortTruckClick(Sender: TObject);
    procedure BtnSortCusClick(Sender: TObject);
    procedure EditTruckChange(Sender: TObject);
    procedure BtnSetClick(Sender: TObject);
    procedure MenuBottomClick(Sender: TUnimMenuItem);
  private
    { Private declarations }
    FSQLWhere,FSQLOrder: string;
    //排序模式
    procedure LoadTruckBlackData(const nOrder: string = '');
    //载入车辆状态
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  Data.Win.ADODB, UFormGetData, ULibFun, USysBusiness, USysDB, USysConst;

procedure TfFormSetBlack.UnimFormCreate(Sender: TObject);
begin
  FSQLWhere := '';
  FSQLOrder := '';
  FEntityName := 'MAIN_D03';

  BtnSet.Enabled := HasPopedom(FEntityName, sPopedom_Edit);
  UserDefineMGrid(ClassName, DBGrid1, True);
  LoadTruckBlackData;
end;

procedure TfFormSetBlack.UnimFormDestroy(Sender: TObject);
begin
  UserDefineMGrid(ClassName, DBGrid1, False);
end;

//Date: 2020-01-18
//Desc: 载入物料
procedure TfFormSetBlack.LoadTruckBlackData(const nOrder: string);
var nStr: string;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  with TStringHelper do
  try
    nStr := 'Select case T_Valid when ''N'' then ''禁用'' else ''正常'' end ' +
            'as T_Valid,R_ID,T_Truck,T_PName,'''' as Checked From %s %s';
    nStr := Format(nStr, [sTable_Truck, nOrder]);

    nQuery := LockDBQuery(ctMain);
    DBQuery(nStr, nQuery);
    nQuery.FieldByName('Checked').ReadOnly := False;

    DSClientDS(nQuery, ClientDS1);
    ActiveControl := DBGrid1;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2020-01-18
//Desc: 切换记录选中状态
procedure TfFormSetBlack.DBGrid1Click(Sender: TObject);
begin
  if (not ClientDS1.Active) or (ClientDS1.RecordCount < 1) then Exit;
  ClientDS1.Edit;
  if ClientDS1.FieldByName('Checked').AsString = sCheckFlag2 then
       ClientDS1.FieldByName('Checked').AsString := ''
  else ClientDS1.FieldByName('Checked').AsString := sCheckFlag2;
  ClientDS1.Post;
end;

procedure TfFormSetBlack.MenuBottomClick(Sender: TUnimMenuItem);
var nBK: TBookmark;
begin
  if (not ClientDS1.Active) or (ClientDS1.RecordCount < 1) then Exit;
  //invalid data

  ClientDS1.DisableControls;
  nBK := ClientDS1.GetBookmark;
  try
    ClientDS1.First;
    while not ClientDS1.Eof do
    begin
      ClientDS1.Edit;
      case Sender.MenuId of
       0: ClientDS1.FieldByName('Checked').AsString := sCheckFlag2;
       1: ClientDS1.FieldByName('Checked').AsString := '';
       2: //反选
        begin
          if ClientDS1.FieldByName('Checked').AsString = sCheckFlag2 then
               ClientDS1.FieldByName('Checked').AsString := ''
          else ClientDS1.FieldByName('Checked').AsString := sCheckFlag2;
        end;
      end;

      ClientDS1.Post;
      ClientDS1.Next;
    end;

    if ClientDS1.BookmarkValid(nBK) then
      ClientDS1.GotoBookmark(nBK);
    //xxxxx
  finally
    ClientDS1.FreeBookmark(nBK);
    ClientDS1.EnableControls;
  end;

  MenuBottom.Visible := False;
  DBGrid1.Refresh;
end;

procedure TfFormSetBlack.EditTruckChange(Sender: TObject);
begin
  if EditTruck.Text = '' then
       BtnFind.Caption := '刷新'
  else BtnFind.Caption := '查找';
end;

//Desc: 查找车牌
procedure TfFormSetBlack.BtnFindClick(Sender: TObject);
begin
  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text = '' then
  begin
    FSQLWhere := '';
    LoadTruckBlackData();
  end else
  begin  
    FSQLWhere := Format('Where T_Truck Like ''%%%s%%''', [EditTruck.Text]);    
    LoadTruckBlackData(FSQLWhere);
  end;
end;

//Desc: 按车牌排序
procedure TfFormSetBlack.BtnSortTruckClick(Sender: TObject);
begin
  if BtnSortTruck.Tag = 10 then
  begin
    BtnSortTruck.Tag := 0;
    FSQLOrder := 'Order By T_Truck ASC';    
  end else
  begin
    BtnSortTruck.Tag := 10;
    FSQLOrder := 'Order By T_Truck DESC';
  end;

  LoadTruckBlackData(FSQLWhere + FSQLOrder);
end;

//Desc: 按客户排序
procedure TfFormSetBlack.BtnSortCusClick(Sender: TObject);
begin
  if BtnSortCus.Tag = 10 then
  begin
    BtnSortCus.Tag := 0;
    FSQLOrder := 'Order By T_PName ASC';
  end else
  begin
    BtnSortCus.Tag := 10;
    FSQLOrder := 'Order By T_PName DESC';
  end;

  LoadTruckBlackData(FSQLWhere + FSQLOrder);
end;

//Desc: 设置
procedure TfFormSetBlack.BtnSetClick(Sender: TObject);
var nStr,nIDs: string;
    nBK: TBookmark;
begin
  ClientDS1.DisableControls;
  nBK := ClientDS1.GetBookmark;
  try   
    nIDs := '';
    ClientDS1.First;
    
    while not ClientDS1.Eof do
    begin
      if ClientDS1.FieldByName('Checked').AsString = sCheckFlag2 then
      begin
        if nIDs <> '' then
          nIDs := nIDs + ',';
        nIDs := nIDs + ClientDS1.FieldByName('R_ID').AsString;
      end;
      
      ClientDS1.Next;
    end;

    if ClientDS1.BookmarkValid(nBK) then
      ClientDS1.GotoBookmark(nBK);
    //xxxxx
  finally
    ClientDS1.FreeBookmark(nBK);
    ClientDS1.EnableControls;
  end;

  if nIDs = '' then Exit;
  //no selected

  ShowGetBlackForm(
    procedure (const nData: TListItem)
    begin
      nStr := 'Update %s Set T_Valid=''%s'' Where R_ID In(%s)';
      nStr := Format(nStr, [sTable_Truck, nData.FID, nIDs]);

      DBExecute(nStr);
      LoadTruckBlackData(FSQLWhere + FSQLOrder);
    end
  );
end;

initialization
  RegisterClass(TfFormSetBlack);
end.
