// Demo zur Verwendung des Swiss QR-Code (TQRCodeCH.pas)

unit uSwissQRCodeDemoApp;

{$I Version.INC}

interface

uses
  {$IFDEF XEUP}
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Controls,
  System.Classes,
  {$ELSE}
  SysUtils,
  Graphics,
  Forms,
  ExtCtrls,
  StdCtrls,
  ComCtrls,
  Controls,
  Classes;
  {$ENDIF}

type
   TfrmMain = class(TForm)
      lblQRString: TLabel;
      Memo: TMemo;
      imgQR: TImage;
      btnClose: TButton;
      lblWidth: TLabel;
      lblQRHeightlbl: TLabel;
      lblFormWidthlbl: TLabel;
      lblFormHeightlbl: TLabel;
      lblQRWidth: TLabel;
      lblQRHeight: TLabel;
      lblFormWidth: TLabel;
      lblFormHeight: TLabel;
    StatusBar: TStatusBar;
      procedure FormCreate(Sender: TObject);
      procedure btnCloseClick(Sender: TObject);
   private
   public
   end;

  

  
var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses uTQRCodeCH;
// -------------------------------------------------------------------------- //
procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
   self.Close;
end;
// -------------------------------------------------------------------------- //
procedure TfrmMain.FormCreate(Sender: TObject);
var
   qr : TQRCodeCH;
begin
   qr := TQRCodeCH.create;

//   // Feldbeschreibung siehe: https://www.paymentstandards.ch/dam/downloads/ig-qr-bill-de.pdf
//   // Beispiel für strukturierte Adresse, Adress_Typ = S
//   // 
//   qr.QRCH_M_IBAN              := 'CH4431999123000889012';
//   qr.QRCH_M_Adress_Typ        := 'S';
//   qr.QRCH_M_AdressName        := 'Robert Schneider AG';
//   qr.QRCH_O_AdresseStrasse    := 'Rue du Lac';
//   qr.QRCH_O_AdresseNr         := '1268';
//   qr.QRCH_D_Postleitzahl      := '2501';
//   qr.QRCH_D_Ort               := 'Biel';
//   qr.QRCH_M_Land              := 'CH';
//   qr.QRCH_ZG_Adress_Typ       := '';
//   qr.QRCH_ZG_AdressName       := '';
//   qr.QRCH_ZG_AdresseStrasse   := '';
//   qr.QRCH_ZG_AdresseNr        := '';
//   qr.QRCH_ZG_Postleitzahl     := '';
//   qr.QRCH_ZG_Ort              := '';
//   qr.QRCH_ZG_Land             := '';
//   qr.QRCH_O_Betrag            := '1949.75';
//   qr.QRCH_M_Waehrung          := 'CHF';
//   qr.QRCH_O_ZD_Adress_Typ     := 'S';
//   qr.QRCH_O_ZD_AdressName     := 'Pia-Maria Rutschmann-Schnyder';
//   qr.QRCH_O_ZD_AdresseStrasse := 'Grosse Marktgasse';
//   qr.QRCH_O_ZD_AdresseNr      := '28';
//   qr.QRCH_O_ZD_Postleitzahl   := '9400';
//   qr.QRCH_O_ZD_Ort            := 'Rorschach';
//   qr.QRCH_O_ZD_Land           := 'CH';
//   qr.QRCH_M_ReferenzTyp       := 'QRR';
//   qr.QRCH_D_Referenz          := '210000000003139471430009017';
//   qr.QRCH_O_Mitteilung        := 'Auftrag vom 15.06.2020';
////   qr.QRCH_O_RechnungsInfo     := '//S1/10/10201409/11/200701/20/140.000-53/30/102673831/31/200615/32/7.7/33/7.7:139.40/40/0:30';
////   qr.QRCH_A_1_AlternativParameter := 'Name AV1: UV;UltraPay005;12345';
////   qr.QRCH_A_2_AlternativParameter := 'Name AV2: XY;XYService;54321';

   // Beispiel für kombiniertee Adresse, Adress_Typ = K

   qr.QRCH_M_IBAN              := 'CH9130000001600271844';       // !
   qr.QRCH_M_Adress_Typ        := 'S';                           // !
   qr.QRCH_M_AdressName        := 'Zahnärztekasse AG';           // !
   qr.QRCH_O_AdresseStrasse    := 'Seestrasse 13';               // !
   qr.QRCH_O_AdresseNr         := 'Postfach';                    // !
   qr.QRCH_D_Postleitzahl      := '8820';                        // !
   qr.QRCH_D_Ort               := 'Wädenswil';                   // !
   qr.QRCH_M_Land              := 'CH';                          // !
   qr.QRCH_ZG_Adress_Typ       := '';                            // !
   qr.QRCH_ZG_AdressName       := '';                            // !
   qr.QRCH_ZG_AdresseStrasse   := '';                            // !
   qr.QRCH_ZG_AdresseNr        := '';                            // !
   qr.QRCH_ZG_Postleitzahl     := '';                            // !
   qr.QRCH_ZG_Ort              := '';                            // !
   qr.QRCH_ZG_Land             := '';                            // !
   qr.QRCH_O_Betrag            := '165.25';                      // !
   qr.QRCH_M_Waehrung          := 'CHF';                         // !
   qr.QRCH_O_ZD_Adress_Typ     := 'K';                           // !
   qr.QRCH_O_ZD_AdressName     := 'Fritz Muster';                // !
   qr.QRCH_O_ZD_AdresseStrasse := 'Musterweg 33';                // !
   qr.QRCH_O_ZD_AdresseNr      := '4142 Münchenstein';           // !
   qr.QRCH_O_ZD_Postleitzahl   := '';                            // !
   qr.QRCH_O_ZD_Ort            := '';                            // !
   qr.QRCH_O_ZD_Land           := 'CH';                          // !
   qr.QRCH_M_ReferenzTyp       := 'QRR';                         // !
   qr.QRCH_D_Referenz          := '000000999914593609042961839'; // !
   qr.QRCH_O_Mitteilung        := '';                            // !

   self.Memo.Lines.Clear;
   self.Memo.Lines.Add(qr.QRCH_CodeAsString);

   // Code generieren
   qr.QRCH_GenerateQRCode;
   // Code anzeigen
   self.imgQR.Picture.Bitmap := qr.QRCH_QRCodeSkaliert;

   self.lblQRWidth.Caption   := IntToStr( self.imgQR.Width );
   self.lblQRHeight.Caption  := IntToStr( self.imgQR.Height );
   self.lblFormWidth.Caption := IntToStr( self.Width );
   self.lblFormHeight.Caption:= IntToStr( self.Height );
   
   qr.Free;
end;
// -------------------------------------------------------------------------- //
end.
