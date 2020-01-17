{*******************************************************************************
  作者: dmzn@163.com 2020-01-17
  描述: 设置地磅
*******************************************************************************}
unit UFormSetPound;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFormNormal;

type
  TfFormSetPound = class(TfFormNormal)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TfFormSetPound);
end.
