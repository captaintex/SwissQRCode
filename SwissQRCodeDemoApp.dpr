program SwissQRCodeDemoApp;

{$I Version.INC}

uses
  {$IFDEF XEUP}Vcl.{$ENDIF}Forms,
  uSwissQRCodeDemoApp in 'uSwissQRCodeDemoApp.pas' {frmMain},
  uTQRCodeCH in 'uTQRCodeCH.pas',
  uTCHKreuz in 'uTCHKreuz.pas',
  uDelphiZXIngQRCodeRoj in 'uDelphiZXIngQRCodeRoj.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF XEUP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
