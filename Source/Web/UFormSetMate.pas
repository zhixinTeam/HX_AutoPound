{*******************************************************************************
  作者: dmzn@163.com 2020-01-17
  描述: 设置物料
*******************************************************************************}
unit UFormSetMate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFormNormal, uniGUIBaseClasses,
  uniGUIClasses, uniGUImJSForm, uniBasicGrid, uniDBGrid, unimDBListGrid,
  unimDBGrid, uniButton, unimButton, Data.DB, Datasnap.DBClient, uniEdit,
  unimEdit, uniLabel, unimLabel;

type
  TfFormSetMate = class(TfFormNormal)
    PanelMain: TUnimContainerPanel;
    DBGrid1: TUnimDBGrid;
    ClientDS1: TClientDataSet;
    DataSource1: TDataSource;
    PanelBottom: TUnimContainerPanel;
    PanelTop: TUnimContainerPanel;
    EditTruck: TUnimEdit;
    BtnFind: TUnimButton;
    BtnSortTruck: TUnimButton;
    BtnSortMate: TUnimButton;
    BtnSet: TUnimButton;
    procedure UnimFormCreate(Sender: TObject);
    procedure UnimFormDestroy(Sender: TObject);
    procedure DBGrid1Click(Sender: TObject);
    procedure BtnFindClick(Sender: TObject);
    procedure BtnSortTruckClick(Sender: TObject);
    procedure BtnSortMateClick(Sender: TObject);
    procedure EditTruckChange(Sender: TObject);
    procedure BtnSetClick(Sender: TObject);
  private
    { Private declarations }
    FSQLWhere,FSQLOrder: string;
    //排序模式
    procedure LoadTruckMateData(const nOrder: string = '');
    //载入车辆物料
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  Data.Win.ADODB, ULibFun, USysBusiness, USysDB, USysConst;

procedure TfFormSetMate.UnimFormCreate(Sender: TObject);
begin
  FSQLWhere := '';
  FSQLOrder := '';
  
  UserDefineMGrid(ClassName, DBGrid1, True);
  LoadTruckMateData;
end;

procedure TfFormSetMate.UnimFormDestroy(Sender: TObject);
begin
  UserDefineMGrid(ClassName, DBGrid1, False);
end;

//Date: 2020-01-18
//Desc: 载入物料
procedure TfFormSetMate.LoadTruckMateData(const nOrder: string);
var nStr: string;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  with TStringHelper do
  try
    nStr := 'Select R_ID,T_Truck,T_MName,'''' as Checked From %s %s';
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
procedure TfFormSetMate.DBGrid1Click(Sender: TObject);
begin
  if (not ClientDS1.Active) or (ClientDS1.RecordCount < 1) then Exit;
  ClientDS1.Edit;
  if ClientDS1.FieldByName('Checked').AsString = sCheckFlag2 then
       ClientDS1.FieldByName('Checked').AsString := ''
  else ClientDS1.FieldByName('Checked').AsString := sCheckFlag2;
  ClientDS1.Post;
end;

procedure TfFormSetMate.EditTruckChange(Sender: TObject);
begin
  if EditTruck.Text = '' then
       BtnFind.Caption := '刷新'
  else BtnFind.Caption := '查找';
end;

//Desc: 查找车牌
procedure TfFormSetMate.BtnFindClick(Sender: TObject);
begin
  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text = '' then
  begin
    FSQLWhere := '';
    LoadTruckMateData();
  end else
  begin  
    FSQLWhere := Format('Where T_Truck Like ''%%%s%%''', [EditTruck.Text]);    
    LoadTruckMateData(FSQLWhere);
  end;
end;

//Desc: 按车牌排序
procedure TfFormSetMate.BtnSortTruckClick(Sender: TObject);
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

  LoadTruckMateData(FSQLWhere + FSQLOrder);
end;

//Desc: 按物料排序
procedure TfFormSetMate.BtnSortMateClick(Sender: TObject);
begin
  if BtnSortMate.Tag = 10 then
  begin
    BtnSortMate.Tag := 0;
    FSQLOrder := 'Order By T_MName ASC';
  end else
  begin
    BtnSortMate.Tag := 10;
    FSQLOrder := 'Order By T_MName DESC';
  end;

  LoadTruckMateData(FSQLWhere + FSQLOrder);
end;

//Desc: 设置
procedure TfFormSetMate.BtnSetClick(Sender: TObject);
var nStr: string;
    nBK: TBookmark; 
begin
  ClientDS1.DisableControls;
  nBK := ClientDS1.GetBookmark;
  try   
    nStr := '';
    ClientDS1.First;
    
    while not ClientDS1.Eof do
    begin
      if ClientDS1.FieldByName('Checked').AsString = sCheckFlag2 then
      begin
        if nStr <> '' then
          nStr := nStr + ',';
        nStr := nStr + ClientDS1.FieldByName('R_ID').AsString;
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
end;

initialization
  RegisterClass(TfFormSetMate);
end.
