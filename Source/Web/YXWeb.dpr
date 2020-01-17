program YXWeb;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  UFormMain in 'UFormMain.pas' {fFormMain: TUnimForm},
  UFormLogin in 'UFormLogin.pas' {fFormLogin: TUnimLoginForm},
  UFormNormal in 'UFormNormal.pas' {fFormNormal: TUnimForm},
  UFormSetMate in 'UFormSetMate.pas' {fFormSetMate: TUnimForm},
  UFormSetPound in 'UFormSetPound.pas' {fFormSetPound: TUnimForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
