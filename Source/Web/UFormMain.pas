{*******************************************************************************
  作者: dmzn@163.com 2020-01-15
  描述: 主窗体,负责调取其它模块
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uniGUIClasses,
  uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm, uniGUImJSForm,
  uniGUIBaseClasses, uniTreeView, unimNestedList, System.Actions, Vcl.ActnList,
  Vcl.Menus, uniMainMenu;

type
  TfFormMain = class(TUnimForm)
    MenuMain: TUniMenuItems;
    MenuItemN1: TUniMenuItem;
    MenuItemN2: TUniMenuItem;
    MenuItemN3: TUniMenuItem;
    PanelMain: TUnimContainerPanel;
    Menu1: TUnimNestedList;
    MenuReload: TUniMenuItem;
    MenuS1: TUniMenuItem;
    procedure MenuItemN1Click(Sender: TObject);
    procedure MenuItemN2Click(Sender: TObject);
    procedure UnimFormCreate(Sender: TObject);
    procedure MenuReloadClick(Sender: TObject);
    procedure MenuItemN3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, USysDB, USysBusiness;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

procedure TfFormMain.UnimFormCreate(Sender: TObject);
begin
  MenuReload.Visible := UniMainModule.FUserConfig.FIsAdmin;
  MenuS1.Visible := MenuReload.Visible;

  MenuItemN1.Visible := HasPopedom('MAIN_D01', sPopedom_Read);
  MenuItemN2.Visible := HasPopedom('MAIN_D02', sPopedom_Read);
  MenuItemN3.Visible := HasPopedom('MAIN_D03', sPopedom_Read);
end;

procedure TfFormMain.MenuReloadClick(Sender: TObject);
begin
  ReloadSystemMemory(False);
  ShowMessageN('重新加载成功');
end;

procedure TfFormMain.MenuItemN1Click(Sender: TObject);
var nForm: TUnimForm;
begin
  nForm := SystemGetForm('TfFormSetMate');
  nForm.ShowModal();
end;

procedure TfFormMain.MenuItemN2Click(Sender: TObject);
var nForm: TUnimForm;
begin
  nForm := SystemGetForm('TfFormSetPound');
  nForm.ShowModal();
end;

procedure TfFormMain.MenuItemN3Click(Sender: TObject);
var nForm: TUnimForm;
begin
  nForm := SystemGetForm('TfFormSetBlack');
  nForm.ShowModal();
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
