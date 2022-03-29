program SwissQRCodeDemoApp;

uses
  Vcl.Forms,
  uSwissQRCodeDemoApp in 'uSwissQRCodeDemoApp.pas' {frmMain},
  uTQRCodeCH in 'uTQRCodeCH.pas',
  uTCHKreuz in 'uTCHKreuz.pas',
  uDelphiZXIngQRCodeRoj in 'uDelphiZXIngQRCodeRoj.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
