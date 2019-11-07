{*******************************************************************************
  作者: dmzn@163.com 2014-6-21
  描述: 手动补单
*******************************************************************************}
unit UFormManualInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, cxContainer,
  cxEdit, cxMaskEdit, cxButtonEdit, cxTextEdit, cxLabel, dxLayoutControl,
  StdCtrls, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBExtLookupComboBox, cxDBLookupComboBox;

type
  TfFormManualInput = class(TfFormNormal)
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditPound: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditFact: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMID: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditPID: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditPValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditMValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FModalResual: TModalResult;
    //处理结果
    procedure InitFormData;
    procedure ReleaseFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UMgrPoundTunnels, UAdjustForm, USysDB,
  USysBusiness, USysConst, UDataModule;

var
  gPoundItem: TPoundItem;
  gPoundTunnel: TPTTunnelItem;
  //称重数据

class function TfFormManualInput.FormID: integer;
begin
  Result := cFI_FormManualInput;
end;

class function TfFormManualInput.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  with TfFormManualInput.Create(Application) do
  try
    FModalResual := mrNone;
    InitFormData;
    ShowModal;

    if Assigned(nP) then
    begin
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := FModalResual;
    end; 
    ReleaseFormData;
  finally
    Free;
  end;
end;

procedure TfFormManualInput.InitFormData;
var nIni: TIniFile;
begin
  LoadMaterails(EditMID.Properties.Items);
  LoadProviders(EditPID.Properties.Items);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    EditFact.Text := nIni.ReadString(Name, 'FactID', '');
    EditPound.Text := nIni.ReadString(Name, 'PoundID', '');
  finally
    nIni.Free;
  end;
end;

procedure TfFormManualInput.ReleaseFormData;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteString(Name, 'FactID', EditFact.Text);
    nIni.WriteString(Name, 'PoundID', EditPound.Text);
  finally
    nIni.Free;
  end;

  AdjustStringsItem(EditMID.Properties.Items, True);
  AdjustStringsItem(EditPID.Properties.Items, True);
end;

procedure TfFormManualInput.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nCard: string;
    nItem: TPoundItem;
begin
  EditTruck.Text := EditTruck.Text;
  if EditTruck.Text = '' then Exit;

  nStr := GetTruckCard(EditTruck.Text, nCard);
  if nStr <> '' then
  begin
    ShowMsg(nStr, sHint);
    Exit;
  end;
  
  ReadPoundItem(nCard, nItem, nStr);
  if nStr <> '' then
  begin
    ShowDlg(nStr, sHint);
    Exit;
  end;

  gPoundItem := nItem;
  with gPoundItem do
  begin
    EditTruck.Text := FTruck;
    EditMID.Text := FMName;
    EditPID.Text := FPName;

    EditPValue.Text := Format('%.2f', [FPValue]);
    EditMValue.Text := Format('%.2f', [FMValue]);
    ActiveControl := EditMValue;
  end;
end;

procedure TfFormManualInput.EditMValueKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Click;
  end;
end;

function TfFormManualInput.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditMID then
  begin
    nHint := '请选择物料';
    Result := EditMID.ItemIndex >= 0;

    if Result then
    with gPoundItem do
    begin
      FMate := GetStringsItemData(EditMID.Properties.Items, EditMID.ItemIndex);
      FMName := EditMID.Text;
    end;
  end else

  if Sender = EditPID then
  begin
    nHint := '请选择供应商';
    Result := EditPID.ItemIndex >= 0;

    if Result then
    with gPoundItem do
    begin
      FProvider := GetStringsItemData(EditPID.Properties.Items, EditPID.ItemIndex);
      FPName := EditPID.Text;
    end;
  end;

  if Sender = EditPValue then
  begin
    nHint := '皮重为数值';
    Result := IsNumber(EditPValue.Text, True);
                          
    if Result then
      gPoundItem.FPValue := StrToFloat(EditPValue.Text);
    //xxxxx
  end else

  if Sender = EditMValue then
  begin
    nHint := '毛重为数值';
    Result := IsNumber(EditMValue.Text, True);
                          
    if Result then
      gPoundItem.FMValue := StrToFloat(EditMValue.Text);
    //xxxxx
  end else

  if Sender = EditFact then
  begin
    nHint := '请输入工厂编号';
    EditFact.Text :=  Trim(EditFact.Text);
    Result := EditFact.Text <> '';
                              
    if Result then
      gPoundTunnel.FFactoryID := EditFact.Text;
    //xxxxx
  end else

  if Sender = EditPound then
  begin
    nHint := '请输入磅站编号';
    EditPound.Text :=  Trim(EditPound.Text);
    Result := EditPound.Text <> '';
                              
    if Result then
      gPoundTunnel.FID := EditPound.Text;
    //xxxxx
  end;
end;

procedure TfFormManualInput.BtnOKClick(Sender: TObject);
begin
  if IsDataValid and SavePoundWeight(gPoundItem, @gPoundTunnel, True) then
  begin
    EditMValue.Text := '';
    ActiveControl := EditMValue;

    FModalResual := mrOk;
    ShowMsg('补单成功', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormManualInput, TfFormManualInput.FormID);
end.
