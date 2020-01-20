{*******************************************************************************
  作者: dmzn@163.com 2020-01-15
  描述: 用户登录
*******************************************************************************}
unit UFormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uniGUIClasses,
  uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm, uniGUImJSForm,
  uniGUIBaseClasses, unimImage, uniEdit, unimEdit, unimToggle,
  unimButton, unimLabel, uniLabel, uniButton, uniImage;

type
  TfFormLogin = class(TUnimLoginForm)
    PanelMain: TUnimContainerPanel;
    PanelLogin: TUnimContainerPanel;
    PanelR: TUnimContainerPanel;
    PanelL: TUnimContainerPanel;
    PanelM: TUnimContainerPanel;
    EditUser: TUnimEdit;
    EditPwd: TUnimEdit;
    BtnLogin: TUnimButton;
    CheckPassword: TUnimToggle;
    ImageLogo: TUnimImage;
    UnimLabel1: TUnimLabel;
    procedure BtnLoginClick(Sender: TObject);
    procedure UnimLoginFormCreate(Sender: TObject);
    procedure UnimLoginFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure UpdateCookies(const nClear: Boolean);
    //更新cookies
  public
    { Public declarations }
  end;

function fFormLogin: TfFormLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, Data.Win.ADODB,
  USysBusiness, USysConst, USysDB;

function fFormLogin: TfFormLogin;
begin
  Result := TfFormLogin(UniMainModule.GetFormInstance(TfFormLogin));
end;

procedure TfFormLogin.UnimLoginFormCreate(Sender: TObject);
var nStr: string;
begin
  with UniApplication.Cookies do
  begin
    nStr := Trim(GetCookie('UserName'));
    CheckPassword.Toggled := nStr <> '';

    if CheckPassword.Toggled then
    begin
      CheckPassword.Tag := 10;
      EditUser.Text := nStr;
      EditPwd.Text := GetCookie('UserPassword');
    end;
  end;
end;

procedure TfFormLogin.UnimLoginFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (not CheckPassword.Toggled) and (CheckPassword.Tag = 10) then
    UpdateCookies(True);
  //xxxxx
end;

//Desc: 登录
procedure TfFormLogin.BtnLoginClick(Sender: TObject);
var nStr: string;
    nQuery: TADOQuery;
begin
  EditUser.Text := Trim(EditUser.Text);
  if EditUser.Text = '' then
  begin
    ShowMessage('请输入用户名');
    Exit;
  end;

  nQuery := nil;
  with ULibFun.TStringHelper do
  try
    nStr := 'Select U_NAME,U_PASSWORD,U_GROUP,U_Identity from $a ' +
            'Where U_NAME=''$b'' and U_State=1';

    nStr := MacroValue(nStr, [MI('$a',sTable_User),
                              MI('$b',EditUser.Text)]);
    //xxxxx

    nQuery := LockDBQuery(ctMain);
    DBQuery(nStr, nQuery);

    if (nQuery.RecordCount <> 1) or
       (nQuery.FieldByName('U_PASSWORD').AsString <> EditPwd.Text) then
    begin
      ShowMessage('错误的用户名或密码,请重新输入');
      Exit;
    end;

    with UniMainModule.FUserConfig do
    begin
      FUserID := EditUser.Text;
      FUserName := nQuery.FieldByName('U_NAME').AsString;
      FUserPwd := EditPwd.Text;
      FGroupID := nQuery.FieldByName('U_GROUP').AsString;
      FIsAdmin := nQuery.FieldByName('U_Identity').AsString = '0';
    end;

    UpdateCookies(not CheckPassword.Toggled);
    ModalResult := mrOk;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

procedure TfFormLogin.UpdateCookies(const nClear: Boolean);
begin
  with UniApplication.Cookies do
  begin
    if nClear then
    begin
      SetCookie('UserName', '');
      SetCookie('UserPassword', '');
    end else
    begin
      SetCookie('UserName', EditUser.Text, Date() + 1);
      SetCookie('UserPassword', EditPwd.Text, Date() + 1);
    end;
  end;
end;

initialization
  RegisterAppFormClass(TfFormLogin);

end.
