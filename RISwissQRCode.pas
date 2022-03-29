unit RISwissQRCode;

interface

uses
  System.SysUtils, 
  System.Classes, 
  Vcl.Controls, 
  Vcl.ExtCtrls,
  uTQRCodeCH
  ;

type
     TRISwissQRCode = class(TImage)
     private
       { Private-Deklarationen }
       fSwissQRCode : TQRCodeCH;

       
       fQRCH_M_IBAN              : string; // !
       fQRCH_M_Adress_Typ        : string; // !
       fQRCH_M_AdressName        : string; // !
       fQRCH_O_AdresseStrasse    : string; // !
       fQRCH_O_AdresseNr         : string; // !
       fQRCH_D_Postleitzahl      : string; // !
       fQRCH_D_Ort               : string; // !
       fQRCH_M_Land              : string; // !
       fQRCH_ZG_Adress_Typ       : string; // !
       fQRCH_ZG_AdressName       : string; // !
       fQRCH_ZG_AdresseStrasse   : string; // !
       fQRCH_ZG_AdresseNr        : string; // !
       fQRCH_ZG_Postleitzahl     : string; // !
       fQRCH_ZG_Ort              : string; // !
       fQRCH_ZG_Land             : string; // !
       fQRCH_O_Betrag            : string; // !
       fQRCH_M_Waehrung          : string; // !
       fQRCH_O_ZD_Adress_Typ     : string; // !
       fQRCH_O_ZD_AdressName     : string; // !
       fQRCH_O_ZD_AdresseStrasse : string; // !
       fQRCH_O_ZD_AdresseNr      : string; // !
       fQRCH_O_ZD_Postleitzahl   : string; // !
       fQRCH_O_ZD_Ort            : string; // !
       fQRCH_O_ZD_Land           : string; // !
       fQRCH_M_ReferenzTyp       : string; // !
       fQRCH_D_Referenz          : string; // !
       fQRCH_O_Mitteilung        : string; // !
       fQRCH_O_RechnungsInfo     : string; // !
       fQRCH_A_1_AlternativParameter  : string;
       fQRCH_A_2_AlternativParameter  : string;    
   protected
      { Protected-Deklarationen }
   public
      { Public-Deklarationen }
   published
      { Published-Deklarationen }
      procedure Create( AOwner: TComponent );
      procedure Paint; 
      procedure Update;     
      
      property QRCH_M_IBAN                         : string read fQRCH_M_IBAN                  write fQRCH_M_IBAN; // !
      property QRCH_M_Adress_Typ                   : string read fQRCH_M_Adress_Typ            write fQRCH_M_Adress_Typ; // !
      property QRCH_M_AdressName                   : string read fQRCH_M_AdressName            write fQRCH_M_AdressName; // !
      property QRCH_O_AdresseStrasse               : string read fQRCH_O_AdresseStrasse        write fQRCH_O_AdresseStrasse; // !
      property QRCH_O_AdresseNr                    : string read fQRCH_O_AdresseNr             write fQRCH_O_AdresseNr; // !
      property QRCH_D_Postleitzahl                 : string read fQRCH_D_Postleitzahl          write fQRCH_D_Postleitzahl; // !
      property QRCH_D_Ort                          : string read fQRCH_D_Ort                   write fQRCH_D_Ort; // !
      property QRCH_M_Land                         : string read fQRCH_M_Land                  write fQRCH_M_Land; // !
      property QRCH_ZG_Adress_Typ                  : string read fQRCH_ZG_Adress_Typ           write fQRCH_ZG_Adress_Typ; // !
      property QRCH_ZG_AdressName                  : string read fQRCH_ZG_AdressName           write fQRCH_ZG_AdressName; // !
      property QRCH_ZG_AdresseStrasse              : string read fQRCH_ZG_AdresseStrasse       write fQRCH_ZG_AdresseStrasse; // !
      property QRCH_ZG_AdresseNr                   : string read fQRCH_ZG_AdresseNr            write fQRCH_ZG_AdresseNr; // !
      property QRCH_ZG_Postleitzahl                : string read fQRCH_ZG_Postleitzahl         write fQRCH_ZG_Postleitzahl; // !
      property QRCH_ZG_Ort                         : string read fQRCH_ZG_Ort                  write fQRCH_ZG_Ort; // !
      property QRCH_ZG_Land                        : string read fQRCH_ZG_Land                 write fQRCH_ZG_Land; // !
      property QRCH_O_Betrag                       : string read fQRCH_O_Betrag                write fQRCH_O_Betrag; // !
      property QRCH_M_Waehrung                     : string read fQRCH_M_Waehrung              write fQRCH_M_Waehrung; // !
      property QRCH_O_ZD_Adress_Typ                : string read fQRCH_O_ZD_Adress_Typ         write fQRCH_O_ZD_Adress_Typ; // !
      property QRCH_O_ZD_AdressName                : string read fQRCH_O_ZD_AdressName         write fQRCH_O_ZD_AdressName; // !
      property QRCH_O_ZD_AdresseStrasse            : string read fQRCH_O_ZD_AdresseStrasse     write fQRCH_O_ZD_AdresseStrasse; // !
      property QRCH_O_ZD_AdresseNr                 : string read fQRCH_O_ZD_AdresseNr          write fQRCH_O_ZD_AdresseNr; // !
      property QRCH_O_ZD_Postleitzahl              : string read fQRCH_O_ZD_Postleitzahl       write fQRCH_O_ZD_Postleitzahl; // !
      property QRCH_O_ZD_Ort                       : string read fQRCH_O_ZD_Ort                write fQRCH_O_ZD_Ort; // !
      property QRCH_O_ZD_Land                      : string read fQRCH_O_ZD_Land               write fQRCH_O_ZD_Land; // !
      property QRCH_M_ReferenzTyp                  : string read fQRCH_M_ReferenzTyp           write fQRCH_M_ReferenzTyp; // !
      property QRCH_D_Referenz                     : string read fQRCH_D_Referenz              write fQRCH_D_Referenz; // !
      property QRCH_O_Mitteilung                   : string read fQRCH_O_Mitteilung            write fQRCH_O_Mitteilung; // !
      property QRCH_O_RechnungsInfo                : string read fQRCH_O_RechnungsInfo         write fQRCH_O_RechnungsInfo; // !
      property QRCH_A_1_AlternativParameter        : string read fQRCH_A_1_AlternativParameter write fQRCH_A_1_AlternativParameter; // !      
      property QRCH_A_2_AlternativParameter        : string read fQRCH_A_2_AlternativParameter write fQRCH_A_2_AlternativParameter; // !      
   end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('ROHRBACH-INFORMATIK', [TRISwissQRCode]);
end;

{ TRISwissQRCode }

procedure TRISwissQRCode.Create( AOwner: TComponent );
begin
   inherited create( AOwner );   
   self.fSwissQRCode := self.fSwissQRCode.create;

   // test
   self.fQRCH_M_IBAN              := 'CH9130000001600271844';  // !
   self.fQRCH_M_Adress_Typ        := 'S';                      // !
   self.fQRCH_M_AdressName        := 'Zahnärztekasse AG';      //
   self.fQRCH_O_AdresseStrasse    := 'Seestrasse 13';          // !
   self.fQRCH_O_AdresseNr         := 'Postfach';               // !
   self.fQRCH_D_Postleitzahl      := '8820';                   // !
   self.fQRCH_D_Ort               := 'Wädenswil';              // !
   self.fQRCH_M_Land              := 'CH';                     // !
   self.fQRCH_ZG_Adress_Typ       := '';                       // !
   self.fQRCH_ZG_AdressName       := '';                       // !
   self.fQRCH_ZG_AdresseStrasse   := '';                       // !
   self.fQRCH_ZG_AdresseNr        := '';                       // !
   self.fQRCH_ZG_Postleitzahl     := '';                       // !
   self.fQRCH_ZG_Ort              := '';                       // !
   self.fQRCH_ZG_Land             := '';                       // !
   self.fQRCH_O_Betrag            := '165.25';                 // !
   self.fQRCH_M_Waehrung          := 'CHF';                    // !
   self.fQRCH_O_ZD_Adress_Typ     := 'K';                      // !
   self.fQRCH_O_ZD_AdressName     := 'Fritz Muster';           // !
   self.fQRCH_O_ZD_AdresseStrasse := 'Musterweg 33';           // !
   self.fQRCH_O_ZD_AdresseNr      := '4142 Münchenstein';      // !
   self.fQRCH_O_ZD_Postleitzahl   := '';                       // !
   self.fQRCH_O_ZD_Ort            := '';                       // !
   self.fQRCH_O_ZD_Land           := 'CH';                     // !
   self.fQRCH_M_ReferenzTyp       := 'QRR';                    // !
   self.fQRCH_D_Referenz          := '000000999914593609042961839'; // !
   self.fQRCH_O_Mitteilung        := '';                       // !

   self.Paint;
end;

procedure TRISwissQRCode.Update;
begin
   self.fSwissQRCode.QRCH_M_IBAN                    := self.fQRCH_M_IBAN;                                // 1
   self.fSwissQRCode.QRCH_M_Adress_Typ              := self.fQRCH_M_Adress_Typ;                          // 2
   self.fSwissQRCode.QRCH_M_AdressName              := self.fQRCH_M_AdressName;                          // 3
   self.fSwissQRCode.QRCH_O_AdresseStrasse          := self.fQRCH_O_AdresseStrasse;                      // 4
   self.fSwissQRCode.QRCH_O_AdresseNr               := self.fQRCH_O_AdresseNr;                           // 5
   self.fSwissQRCode.QRCH_D_Postleitzahl            := self.fQRCH_D_Postleitzahl;   
   self.fSwissQRCode.QRCH_D_Ort                     := self.fQRCH_D_Ort;   
   self.fSwissQRCode.QRCH_M_Land                    := self.fQRCH_M_Land;   
   self.fSwissQRCode.QRCH_ZG_Adress_Typ             := self.fQRCH_ZG_Adress_Typ;       // Zugunsten
   self.fSwissQRCode.QRCH_ZG_AdressName             := self.fQRCH_ZG_AdressName;   
   self.fSwissQRCode.QRCH_ZG_AdresseStrasse         := self.fQRCH_ZG_AdresseStrasse;   
   self.fSwissQRCode.QRCH_ZG_AdresseNr              := self.fQRCH_ZG_AdresseNr;   
   self.fSwissQRCode.QRCH_ZG_Postleitzahl           := self.fQRCH_ZG_Postleitzahl;      
   self.fSwissQRCode.QRCH_ZG_Ort                    := self.fQRCH_ZG_Ort;      
   self.fSwissQRCode.QRCH_ZG_Land                   := self.fQRCH_ZG_Land;      
   self.fSwissQRCode.QRCH_O_Betrag                  := self.fQRCH_O_Betrag;      
   self.fSwissQRCode.QRCH_M_Waehrung                := self.fQRCH_M_Waehrung;      
   self.fSwissQRCode.QRCH_O_ZD_Adress_Typ           := self.fQRCH_O_ZD_Adress_Typ;      // Zahlbar Durch
   self.fSwissQRCode.QRCH_O_ZD_AdressName           := self.fQRCH_O_ZD_AdressName;      
   self.fSwissQRCode.QRCH_O_ZD_AdresseStrasse       := self.fQRCH_O_ZD_AdresseStrasse;         
   self.fSwissQRCode.QRCH_O_ZD_AdresseNr            := self.fQRCH_O_ZD_AdresseNr;         
   self.fSwissQRCode.QRCH_O_ZD_Postleitzahl         := self.fQRCH_O_ZD_Postleitzahl;         
   self.fSwissQRCode.QRCH_O_ZD_Ort                  := self.fQRCH_O_ZD_Ort;         
   self.fSwissQRCode.QRCH_O_ZD_Land                 := self.fQRCH_O_ZD_Land;         
   self.fSwissQRCode.QRCH_M_ReferenzTyp             := self.fQRCH_M_ReferenzTyp;         
   self.fSwissQRCode.QRCH_D_Referenz                := self.fQRCH_D_Referenz;         
   self.fSwissQRCode.QRCH_O_Mitteilung              := self.fQRCH_O_Mitteilung;         
   self.fSwissQRCode.QRCH_O_RechnungsInfo           := self.fQRCH_O_RechnungsInfo;         
   self.fSwissQRCode.QRCH_A_1_AlternativParameter   := self.fQRCH_A_1_AlternativParameter;         
   self.fSwissQRCode.QRCH_A_2_AlternativParameter   := self.fQRCH_A_2_AlternativParameter;            
   
   self.fSwissQRCode.QRCH_GenerateQRCode;
   self.Picture.Bitmap := self.fSwissQRCode.QRCH_QRCodeSkaliert;
   inherited;                               
end;

procedure TRISwissQRCode.Paint;
begin
   self.Update;
   inherited;
end;



end.
