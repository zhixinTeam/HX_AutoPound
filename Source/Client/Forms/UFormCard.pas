{*******************************************************************************
  作者: dmzn@163.com 2012-4-5
  描述: 关联磁卡
*******************************************************************************}
unit UFormCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, cxContainer,
  cxEdit, cxMaskEdit, cxButtonEdit, cxTextEdit, cxLabel, dxLayoutControl,
  StdCtrls, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBExtLookupComboBox, cxDBLookupComboBox;

type
  TfFormCard = class(TfFormNormal)
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCard2: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditOwner: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditTruckKeyPress(Sender: TObject; var Key: Char);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FParam: PFormCommandParam;
    procedure InitFormData;
    //初始化
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
  ULibFun, UMgrControl, UDataModule, U900Reader, UFormCtrl, USysDB, USysConst;

class function TfFormCard.FormID: integer;
begin
  Result := cFI_FormBindCard;
end;

class function TfFormCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;

  with TfFormCard.Create(Application) do
  try
    FParam := nParam;
    InitFormData;

    FParam.FCommand := cCmd_ModalResult;
    FParam.FParamA := ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormCard.InitFormData;
var nStr: string;
begin
  ActiveControl := EditCard;
  EditCard.Properties.ReadOnly := True;
  EditCard2.Properties.ReadOnly := True;

  if FParam.FParamA = '' then Exit;
  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_Card, FParam.FParamA]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('磁卡信息丢失', sHint);
      BtnOK.Enabled := False;
      Exit;
    end;

    EditCard.Text := FieldByName('C_Card').AsString;
    EditCard2.Text := FieldByName('C_Card2').AsString;
    EditTruck.Text := FieldByName('C_Truck').AsString;
    EditOwner.Text := FieldByName('C_Owner').AsString;
  end;
end;

procedure TfFormCard.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCard then
    EditCard.Text := g900MReader.ReadCard(Self, False, cCard_900);
  //xxxxx

  if Sender = EditCard2 then
    EditCard2.Text := g900MReader.ReadCard(Self, False, cCard_M1);
  SwitchFocusCtrl(Self, True);
end;

procedure TfFormCard.EditTruckKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Click;
  end else

  if Key = #32 then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;
end;

function TfFormCard.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    Result := EditCard.Text <> '';
    nHint := '请输入有效卡号';
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    Result := Length(EditTruck.Text) >= 3;
    nHint := '请输入有效车牌号';
  end;
end;

//Desc: 保存磁卡
procedure TfFormCard.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  if FParam.FParamA = '' then
  begin
    nStr := MakeSQLByStr([SF('C_Card', EditCard.Text),
            SF('C_Card2', EditCard2.Text),
            SF('C_Owner', EditOwner.Text),
            SF('C_Status', sFlag_CardUsed),
            SF('C_Truck', EditTruck.Text),
            SF('C_Man', gSysParam.FUserID),
            SF('C_Date', sField_SQLServer_Now, sfVal)], sTable_Card, '', True);
    FDM.ExecuteSQL(nStr);
  end else
  begin
    nStr := Format('R_ID=%s', [FParam.FParamA]);
    nStr := MakeSQLByStr([SF('C_Card', EditCard.Text),
            SF('C_Card2', EditCard2.Text),
            SF('C_Owner', EditOwner.Text),
            SF('C_Status', sFlag_CardUsed),
            SF('C_Truck', EditTruck.Text)], sTable_Card, nStr, False);
    FDM.ExecuteSQL(nStr);
  end;

  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormCard, TfFormCard.FormID);
end.
