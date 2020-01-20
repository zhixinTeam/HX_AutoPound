{*******************************************************************************
  作者: dmzn@163.com 2020-01-18
  描述: 选择数据项
*******************************************************************************}
unit UFormGetData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFormNormal, uniGUIClasses,
  uniMultiItem, unimList, uniGUIBaseClasses, uniGUImJSForm, uniGUIDialogs,
  unimButton, uniButton;

type
  TListItem = record
    FID: string;
    FName: string;
  end;
  TListItems = array of TListItem;

  TGetDataCallBack = reference to procedure (const nData: TListItem);

  TfFormGetData = class(TfFormNormal)
    PanelMain: TUnimContainerPanel;
    List1: TUnimList;
    BtnOK: TUnimButton;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FItems: TListItems;
    //列表项
    procedure LoadMateList;
    procedure LoadPoundList;
    //载入数据
  public
    { Public declarations }
  end;

procedure ShowGetMateForm(const CallBack: TGetDataCallBack);
procedure ShowGetPoundForm(const CallBack: TGetDataCallBack);
//入口函数

implementation

{$R *.dfm}
uses
  Data.Win.ADODB, MainModule, uniGUImForm, ULibFun, UManagerGroup, USysBusiness,
  USysDB, USysConst;

procedure ShowGetMateForm(const CallBack: TGetDataCallBack);
var nIdx: Integer;
begin
  with TfFormGetData(UniMainModule.GetFormInstance(TfFormGetData)) do
  begin
    Caption := '选择物料';
    LoadMateList();
    ShowModal(procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrOk then
      begin
        nIdx := Integer(List1.Items.Objects[List1.ItemIndex]);
        CallBack(FItems[nIdx]);
      end;
    end);
  end;
end;

procedure ShowGetPoundForm(const CallBack: TGetDataCallBack);
var nIdx: Integer;
begin
  with TfFormGetData(UniMainModule.GetFormInstance(TfFormGetData)) do
  begin
    Caption := '选择磅站';
    LoadPoundList();
    ShowModal(procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrOk then
      begin
        nIdx := Integer(List1.Items.Objects[List1.ItemIndex]);
        CallBack(FItems[nIdx]);
      end;
    end);
  end;
end;

//Desc: 载入物料
procedure TfFormGetData.LoadMateList;
var nStr: string;
    nIdx: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  with TStringHelper do
  try
    List1.Items.BeginUpdate;
    //lock first
    List1.Clear;

    nStr := 'Select M_ID,M_Name From %s';
    nStr := Format(nStr, [sTable_Materails]);

    nQuery := LockDBQuery(ctMain);
    DBQuery(nStr, nQuery);

    if nQuery.RecordCount > 0 then
    with nQuery do
    begin
      SetLength(FItems, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID := FieldByName('M_ID').AsString;
          FName := FieldByName('M_Name').AsString;
          List1.Items.AddObject(FName, Pointer(nIdx));
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    List1.Items.EndUpdate;
    ReleaseDBQuery(nQuery);
  end;
end;

//Desc: 载入磅站
procedure TfFormGetData.LoadPoundList;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  nList := nil;
  try
    List1.Items.BeginUpdate;
    //lock first
    List1.Clear;
    SetLength(FItems, 0);

    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_PoundList]);

    nQuery := LockDBQuery(ctMain);
    DBQuery(nStr, nQuery);

    if nQuery.RecordCount > 0 then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nStr := nQuery.Fields[0].AsString;
      TStringHelper.Split(nStr, nList, 0, ';');

      SetLength(FItems, nList.Count);
      for nIdx := 0 to nList.Count - 1 do
      begin
        FItems[nIdx].FName := nList[nIdx];
        List1.Items.AddObject(FItems[nIdx].FName, Pointer(nIdx));
      end;
    end;
  finally
    gMG.FObjectPool.Release(nList);
    List1.Items.EndUpdate;
    ReleaseDBQuery(nQuery);
  end;

  if Length(FItems) < 1 then
  begin
    List1.Items.Add('B1');
    List1.Items.Add('B2');
  end;
end;

procedure TfFormGetData.BtnOKClick(Sender: TObject);
begin
  if List1.ItemIndex < 0 then
  begin
    ShowMessageN('请在列表中选择一项内容');
    Exit;
  end;

  ModalResult := mrOk;
end;

end.
