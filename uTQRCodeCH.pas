// Data-Container für Swiss QR Code
// QR-Code Generator basierend auf (geringe Anpassungen durch Jakob Rohrbach):
//    ZXing QRCode port to Delphi, by Debenu Pty Ltd
//    www.debenu.com

// 2022-03-22 Jakob K. Rohrbach
// Basierend auf Spez. "Schweizer Implementation Guidelines QR-Rechnung" / SIX Spez. Version 2.2 – 2021
//
// Statuscodes:
// M Mandatory Feld muss zwingend befüllt geliefert werden. In der
//   Tabelle der Datenelemente (vgl. Kap. 4.3.3) wird die Bezeichnung «Obligatorische Datengruppe» verwendet.
// D Dependent Feld muss zwingend befüllt werden, wenn die übergeordnete
//   optionale Datengruppe befüllt ist.
// O Optional Feld muss zwingend geliefert, aber nicht zwingend befüllt werden (kann leer sein).
// A Additional Feld muss nicht geliefert werden.
// X Nicht befüllen Feld darf nicht befüllt, muss aber geliefert werden
//   (konzeptionell vorgesehen «for future use», das Feldtrennzeichen muss geliefert werden).
//
// Der Swiss Payment Code (SPC) ist definiert durch einen QR-Code mit mittig eingefügtem Schweizer Kreuz.
// Die Abmessungen des Kreuzes sind definiert (7mm) und jene des Codes ebenso (46mm). Dadurch ist es 
// nicht möglich die beiden schon beim Berechnen des Codes (dieser wird ja in einer Matrix abgebildet)
// zusammenzufügen, denn würde man dies tun, so würden die unterschiedlichen Abmessungen nicht 
// weiter die Vorgaben erfüllen.
// Daher muss erst der QR skaliert werden und unabhängig davon auch des CH-Kreuz. Danach kann man 
// die beiden Bitmaps zusammenfügen und hat so den korrekten Code bezüglich Abmessungen. Das Zusammenfügen
// und Skalieren benötigt eine entsprechende Basis zum Zeichnen, daher wurde die VCL-Komponente "TPaintbox" genommen.
// Alternativ wäre auch "TImage" möglich gewesen, allerdings ergaben sich mit TImage skalierungsprobleme. TPaintbox 
// funktioniert diesbezüglich besser und einfacher.


// SwissQRCode Unit.
//
// @author   Jakob Rohrbach <jr@rohrbach-informatik.ch>
// @license  MIT
// 
// Copyright (C) 2022 Jakob Rohrbach - ROHRBACH-INFORMATIK.ch
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

unit uTQRCodeCH;

{$I Version.INC}

interface
uses  {$IFDEF XEUP}System.{$ENDIF}Classes, 
      {$IFDEF XEUP}System{$ENDIF}SysUtils, 
      {$IFDEF XEUP}Vcl{$ENDIF}Graphics, 
      {$IFDEF XEUP}Winapi.{$ENDIF}Windows 
      ;

const
      QRCH_FIELD_SEPARATOR    = sLineBreak;
      QRCH_QRCODE_SIZE_IN_MM  = 46;
      QRCH_QRKREUZ_SIZE_IN_MM = 7;
      QRCH_CODE_VERSION       = '1.0';  // initiales Release

type
   TQRCodeCH = class(TObject)
   private
      // Header
      sQRCH_Header_Type            : string;
      sQRCH_Header_Version         : string;
      sQRCH_Header_Coding          : string;
      // Zahlungsempfänger Information
      sQRCH_IBAN                   : string;
      // Zahlungsempfänger
      sQRCH_Adress_Typ             : string;
      sQRCH_AdressName             : string;
      sQRCH_AdresseStrasse         : string;
      sQRCH_AdresseNr              : string;
      sQRCH_Postleitzahl           : string;
      sQRCH_Ort                    : string;
      sQRCH_Land                   : string;
      // Endgültiger Zahlungsempfänger (Zugunsten), Informationen zum endgültigen Zahlungsempfänger
      // Optionale Datengruppe, Die gesamte Datengruppe darf vorerst nicht befüllt werden (for Future Use)
      sQRCH_ZG_Adress_Typ             : string;
      //
      sQRCH_ZG_AdressName             : string;
      sQRCH_ZG_AdresseStrasse         : string;
      sQRCH_ZG_AdresseNr              : string;
      sQRCH_ZG_Postleitzahl           : string;
      sQRCH_ZG_Ort                    : string;
      sQRCH_ZG_Land                   : string;
      // Zahlbetragsinformation
      sQRCH_Betrag                    : string;
      sQRCH_Waehrung                  : string;
      // Endgültiger Zahlungspflichtiger (Zahlbar durch), Informationen zum endgültigen Zahlungsempfänger
      sQRCH_ZD_Adress_Typ             : string;
      sQRCH_ZD_AdressName             : string;
      sQRCH_ZD_AdresseStrasse         : string;
      sQRCH_ZD_AdresseNr              : string;
      sQRCH_ZD_Postleitzahl           : string;
      sQRCH_ZD_Ort                    : string;
      sQRCH_ZD_Land                   : string;
      // Zahlungsreferenz
      sQRCH_ReferenzTyp               : string;
      sQRCH_Referenz                  : string;
      // Zusaetzliche Informationen
      sQRCH_Mitteilung                : string;
      sQRCH_Trailer                   : string;
      sQRCH_RechnungsInfo             : string;
      // Alternative Verfahren
      sQRCH_1AlternativParameter      : string;
      sQRCH_2AlternativParameter      : string;      

      sQRCH_Fehlerkorrekturstufe      : string;
      iQRCH_RuheZoneUmlaufendInMM     : integer;  
      // -------------------------------------------------------------------------- //
      sQRCode              : string;
      QRCodeBitmap         : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap;
      QRCodeCHKreuzBitmap  : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap;
      QRCodeSkaliert       : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap;
//      QRCodeSkaliert : TPaintBox;
//      TempPaintBox   : TPaintBox;
      
      function  F_CheckData: Boolean;
      function  F_Get_QRCodeAsString : string;
//      function  F_Get_QRCodeBitmapOhneRuheZone : Vcl.Graphics.TBitmap;             //  incl. Schweizer Kreuz
//      function  F_Get_QRCodeBitmapMitRuheZone  : Vcl.Graphics.TBitmap;             //  incl. Schweizer Kreuz
      procedure P_Set_QRCH_Adress_Typ ( value : string );
      procedure P_Set_QRCH_ReferenzTyp ( value : string );
      procedure P_GenerateSchweizerkreuz;

   public
      constructor create( );

      function  QRCH_GenerateQRCode : Boolean;


      // ************************************************************************** //
      // Header
      // - Obligatorische Datengruppe
      // -------------------------------------------------------------------------- //
      // QRType
      // - Eindeutiges Kennzeichen für den QR-Code. Fixer Wert «SPC» (Swiss Payments Code)
      // - Feste Länge: 3-stellig, alphanumerisch
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_Header_Type      : string read sQRCH_Header_Type;
      // -------------------------------------------------------------------------- //
      // Version
      // - Beinhaltet die zum Zeitpunkt der QR Code-Erstellung verwendete Version der Spezifikation (IG). Die ersten beiden
      //   Stellen bezeichnen die Hauptversion, die folgenden beiden Stellen die Unterversion. Fester Wert «0200» für Version 2.0
      // - Feste Länge: 4-stellig, numerisch
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_Header_Version   : string read sQRCH_Header_Version;
      // -------------------------------------------------------------------------- //
      // Coding Type
      // - Zeichensatz-Code. Fixer Wert 1 (kennzeichnet UTF-8 eingeschränkt auf das Latin Character Set)
      // - Feste Länge: 1-stellig, numerisch
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_Header_Coding    : string read sQRCH_Header_Coding;
      // -------------------------------------------------------------------------- //

      // ************************************************************************** //
      // Zahlungsempfänger Informationen, Konto / Zahlbar an
      // - Obligatorische Datengruppe
      // -------------------------------------------------------------------------- //
      // IBAN
      // - IBAN bzw. QR-IBAN des Begünstigten.
      // - Feste Länge: 21 alphanumerische Zeichen, nur IBANs mit CH- oder LI-Landescode zulässig.
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_IBAN             : string read sQRCH_IBAN              write sQRCH_IBAN;

      // ************************************************************************** //
      // Zahlungsempfaenger
      // - Obligatorische Datengruppe
      // -------------------------------------------------------------------------- //
      // Adress-Typ
      // - Der Adress-Typ wird mittels eines Codes spezifiziert. Folgende Codes sind definiert:
      //   «S» - Strukturierte Adresse,
      //   «K» - Kombinierte Adressfelder (2 Zeilen)
      // - Feste Länge: 1-stellig, alphanumerisch
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_Adress_Typ       : string read sQRCH_Adress_Typ        write P_Set_QRCH_Adress_Typ;
      // -------------------------------------------------------------------------- //
      // Name
      // - Name bzw. Firma des Zahlungsempfängers gemäss Kontobezeichnung. Anmerkung: entspricht immer dem Kontoinhaber
      // - Maximal 70 Zeichen zulässig, Vorname (optional, Lieferung empfohlen, falls verfügbar) + Name oder Firmenbezeichnung
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_AdressName       : string read sQRCH_AdressName        write sQRCH_AdressName;
      // -------------------------------------------------------------------------- //
      // Strasse oder Adresszeile 1
      // - Strukturierte Adresse: Strasse/Postfach der Zahlungsempfängeradresse. Kombinierte Adressfelder:
      //   Adresszeile 1 mit Strasse und Hausnummer bzw. Postfach
      // - Maximal 70 Zeichen zulässig
      // - Statuscode O, optional
      property QRCH_O_AdresseStrasse    : string read sQRCH_AdresseStrasse   write sQRCH_AdresseStrasse;
      // -------------------------------------------------------------------------- //
      // Hausnummer oder Adresszeile 2
      // - Strukturierte Adresse: Hausnummer der Zahlungsempfängeradresse Kombinierte Adressfelder: Adresszeile2 mit Postleitzahl und
      //   Ort der Zahlungsempfängeradresse
      // - Strukturierte Adresse: maximal 16 Zeichen zulässig, Kombinierte Adressfelder: maximal 70 Zeichen zulässig,
      //   Muss geliefert werden bei Adress-Typ «K».
      // - Statuscode O, optional
      property QRCH_O_AdresseNr         : string read sQRCH_AdresseNr        write sQRCH_AdresseNr;
      // -------------------------------------------------------------------------- //
      // Postleitzahl
      // - Postleitzahl der Zahlungsempfängeradresse
      //   Maximal 16 Zeichen zulässig. Die Postleitzahl ist immer ohne vorangestellten Landescode anzugeben.
      //   Kombinierte Adressfelder: darf nicht verwendet werden
      // - Statuscode D, dependent bzw. abhängig
      property QRCH_D_Postleitzahl      : string read sQRCH_Postleitzahl      write sQRCH_Postleitzahl;
      // -------------------------------------------------------------------------- //
      // Ort
      // - Ort der Zahlungsempfängeradresse
      // - Maximal 35 Zeichen zulässig. Kombinierte Adressfelder: darf nicht verwendet werden
      // - Statuscode D, dependent bzw. abhängig
      property QRCH_D_Ort               : string read sQRCH_Ort               write sQRCH_Ort;
      // -------------------------------------------------------------------------- //
      // Land
      // - Land der Zahlungsempfängeradresse
      // - 2-stelliger Landescode gemäss ISO 3166-1
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_Land               : string read sQRCH_Land             write sQRCH_Land;
      // -------------------------------------------------------------------------- //

      // ************************************************************************** //
      // Endgültiger Zahlungsempfänger (Zugunsten), Informationen zum endgültigen Zahlungsempfänger
      // - Optionale Datengruppe, Die gesamte Datengruppe darf vorerst nicht befüllt werden (for Future Use)
      // -------------------------------------------------------------------------- //
      property QRCH_ZG_Adress_Typ      : string read sQRCH_ZG_Adress_Typ      write sQRCH_ZG_Adress_Typ;
      property QRCH_ZG_AdressName      : string read sQRCH_ZG_AdressName      write sQRCH_ZG_AdressName;
      property QRCH_ZG_AdresseStrasse  : string read sQRCH_ZG_AdresseStrasse  write sQRCH_ZG_AdresseStrasse;
      property QRCH_ZG_AdresseNr       : string read sQRCH_ZG_AdresseNr       write sQRCH_ZG_AdresseNr;
      property QRCH_ZG_Postleitzahl    : string read sQRCH_ZG_Postleitzahl    write sQRCH_ZG_Postleitzahl;
      property QRCH_ZG_Ort             : string read sQRCH_ZG_Ort             write sQRCH_ZG_Ort;
      property QRCH_ZG_Land            : string read sQRCH_ZG_Land            write sQRCH_ZG_Land;

      // ************************************************************************** //
      // Zahlbetragsinformation
      // - Obligatorische Datengruppe
      // -------------------------------------------------------------------------- //
      // Betrag
      // - Betrag der Zahlung
      // - Das Element Betrag ist ohne führende Nullen inklusive Dezimaltrennzeichen und 2 Nachkomastellen anzugeben.
      //   Dezimal, maximal 12 Stellen zulässig, inklusive Dezimaltrennzeichen. Als Dezimaltrennzeichen ist nur das
      //   Punktzeichen (.) zulässig.
      // - Statuscode O, optional
      property QRCH_O_Betrag             : string read sQRCH_Betrag             write sQRCH_Betrag;
      // -------------------------------------------------------------------------- //
      // Waehrung
      // - Waehrung der Zahlung, 3-stelliger alphabetischer Waehrungscode gemäss ISO 4217
      // - Nur CHF und EUR zugelassen.
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_Waehrung           : string read sQRCH_Waehrung           write sQRCH_Waehrung;
      // -------------------------------------------------------------------------- //

      // ************************************************************************** //
      // Endgültiger Zahlungspflichtiger, (Zahlbar durch)
      // - Optionale Datengruppe
      // -------------------------------------------------------------------------- //
      // Adress-Typ
      // - Der Adress-Typ wird mittels eines Codes spezifiziert. Folgende Codes sind definiert:
      //   «S» - Strukturierte Adresse,
      //   «K» - Kombinierte Adressfelder (2 Zeilen)
      // - Feste Länge: 1-stellig, alphanumerisch
      // - Statuscode M, obligatorisch bzw. mandatory      
      property QRCH_O_ZD_Adress_Typ      : string read sQRCH_ZD_Adress_Typ      write sQRCH_ZD_Adress_Typ;
      // -------------------------------------------------------------------------- //
      // Name
      // - Name bzw. Firma des Zahlungsempfängers gemäss Kontobezeichnung. Anmerkung: entspricht immer dem Kontoinhaber
      // - Maximal 70 Zeichen zulässig, Vorname (optional, Lieferung empfohlen, falls verfügbar) + Name oder Firmenbezeichnung
      // - Statuscode M, obligatorisch bzw. mandatory      
      property QRCH_O_ZD_AdressName      : string read sQRCH_ZD_AdressName      write sQRCH_ZD_AdressName;
      // -------------------------------------------------------------------------- //
      // Strasse oder Adresszeile 1
      // - Strukturierte Adresse: Strasse/Postfach der Zahlungsempfängeradresse. Kombinierte Adressfelder:
      //   Adresszeile 1 mit Strasse und Hausnummer bzw. Postfach
      // - Maximal 70 Zeichen zulässig
      // - Statuscode O, optional
      property QRCH_O_ZD_AdresseStrasse  : string read sQRCH_ZD_AdresseStrasse  write sQRCH_ZD_AdresseStrasse;
      // -------------------------------------------------------------------------- //
      // Hausnummer oder Adresszeile 2
      // - Strukturierte Adresse: Hausnummer der Zahlungsempfängeradresse Kombinierte Adressfelder: Adresszeile2 mit Postleitzahl und
      //   Ort der Zahlungsempfängeradresse
      // - Strukturierte Adresse: maximal 16 Zeichen zulässig, Kombinierte Adressfelder: maximal 70 Zeichen zulässig,
      //   Muss geliefert werden bei Adress-Typ «K».
      // - Statuscode O, optional
      property QRCH_O_ZD_AdresseNr       : string read sQRCH_ZD_AdresseNr       write sQRCH_ZD_AdresseNr;
      // -------------------------------------------------------------------------- //
      // Postleitzahl
      // - Postleitzahl der Zahlungsempfängeradresse
      //   Maximal 16 Zeichen zulässig. Die Postleitzahl ist immer ohne vorangestellten Landescode anzugeben.
      //   Kombinierte Adressfelder: darf nicht verwendet werden
      // - Statuscode D, dependent bzw. abhängig
      property QRCH_O_ZD_Postleitzahl    : string read sQRCH_ZD_Postleitzahl    write sQRCH_ZD_Postleitzahl;
      // -------------------------------------------------------------------------- //
      // Ort
      // - Ort der Zahlungsempfängeradresse
      // - Maximal 35 Zeichen zulässig. Kombinierte Adressfelder: darf nicht verwendet werden
      // - Statuscode D, dependent bzw. abhängig
      property QRCH_O_ZD_Ort             : string read sQRCH_ZD_Ort             write sQRCH_ZD_Ort;
      // -------------------------------------------------------------------------- //
      // Land
      // - Land der Zahlungsempfängeradresse
      // - 2-stelliger Landescode gemäss ISO 3166-1
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_O_ZD_Land            : string read sQRCH_ZD_Land            write sQRCH_ZD_Land;
      // -------------------------------------------------------------------------- //

      // ************************************************************************** //
      // Zahlungsreferenz
      // - Obligatorische Datengruppe
      // -------------------------------------------------------------------------- //
      // Referenztyp
      // - Referenztyp (QR, ISO)
      //   Die folgenden Codes sind zugelassen:
      //   QRR – QR-Referenz
      //   SCOR – Creditor Reference (ISO 11649)
      //   NON – ohne Referenz
      // - Maximal 4 Zeichen, alphanumerisch. Muss bei Verwendung einer QR-IBAN den Code QRR
      //   enthalten; bei Verwendung der IBAN kann entweder der Code SCOR oder NON angegeben werden
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_ReferenzTyp        : string read sQRCH_ReferenzTyp        write P_Set_QRCH_ReferenzTyp;
      // -------------------------------------------------------------------------- //
      // Referenz
      // - Anmerkung: Die strukturierte Referenz ist entweder eine QR-Referenz oder eine Creditor Reference (ISO 11649)
      // - Maximal 27 Zeichen, alphanumerisch. Muss bei Verwendung einer QR-IBAN befüllt werden. QR-Referenz: 27 Zeichen, numerisch,
      //   Prüfzifferberechnung nach Modulo 10 rekursiv (27. Stelle der Referenz) Creditor Reference (ISO 11649): bis 25 Zeichen,
      //   alphanumerisch. Für den Referenztyp NON darf das Element nicht befüllt werden.
      //   Bei den Banken wird in der Verarbeitung zwischen Grossund Kleinschreibung nicht unterschieden.
      // - Statuscode D, dependent bzw. abhängig
      property QRCH_D_Referenz           : string read sQRCH_Referenz           write sQRCH_Referenz;
      // -------------------------------------------------------------------------- //

      // ************************************************************************** //
      // Zusätzliche Informationen
      // - Zusätzliche Informationen können beim Verfahren mit Mitteilung und beim Verfahren mit strukturierter Referenz
      //   verwendet werden.
      // - Unstrukturierte Mitteilung und Rechnungsinformationen dürfen zusammen maximal 140 Zeichen enthalten
      // -------------------------------------------------------------------------- //
      // Unstrukturierte Mitteilung
      // - Unstrukturierte Informationen können zur Angabe eines Zahlungszwecks oder für ergänzende textuelle
      //   Informationen zu Zahlungen mit strukturierter Referenz verwendet werden.
      // - Maximal 140 Zeichen zulässig
      // - Statuscode O, optional
      property QRCH_O_Mitteilung         : string read sQRCH_Mitteilung         write sQRCH_Mitteilung;
      // -------------------------------------------------------------------------- //
      // Trailer
      // - Eindeutiges Kennzeichen für Ende der Zahlungsdaten. Fixer Wert «EPD» (End Payment Data).
      // - Feste Länge: 3-stellig, alphanumerisch
      // - Statuscode M, obligatorisch bzw. mandatory
      property QRCH_M_Trailer            : string read sQRCH_Trailer            write sQRCH_Trailer;
      // -------------------------------------------------------------------------- //
      // Rechnungsinformationen
      // - Rechnungsinformationen enthalten codierte Informationen für die automatisierte Verbuchung der Zahlung. Die Daten
      //   werden nicht mit der Zahlung weitergeleitet.
      // - Maximal 140 Zeichen zulässig. Die Verwendung der Information ist nicht Bestandteil der Standardisierung.
      //   Im Anhang ist die zum Zeitpunkt der Veröffentlichung dieser Implementation Guidelines aktuelle
      //   «Strukturempfehlung von Rechnungstellerdaten bei der QR-Rechnung» der Swico zu finden.
      // - Statuscode O, optional
      property QRCH_O_RechnungsInfo      : string read sQRCH_RechnungsInfo      write sQRCH_RechnungsInfo;
      // -------------------------------------------------------------------------- //

      // ************************************************************************** //
      // Alternative Verfahren
      // - Parameter und Daten weiterer unterstützter Verfahren
      // - Optionale Datengruppe mit variabler Anzahl von Elementen
      // -------------------------------------------------------------------------- //
      // Alternatives Verfahren Parameter.
      // - Parameter-Zeichenkette des alternativen Verfahren gemäss Syntaxdefinition in Kapitel «Alternative Verfahren»
      // - Kann aktuell maximal zweimal geliefert werden. Maximal je 100 Zeichen zulässig
      // - Statuscode A, optional
      property QRCH_A_1_AlternativParameter  : string read sQRCH_1AlternativParameter      write sQRCH_1AlternativParameter;
      property QRCH_A_2_AlternativParameter  : string read sQRCH_2AlternativParameter      write sQRCH_2AlternativParameter;

      // -------------------------------------------------------------------------- //
      // Ruhezone, Umlaufend in mm. Empfohlen sind pro Seite je 5mm
      property QRCH_RuheZoneUmlaufendInMM : integer read iQRCH_RuheZoneUmlaufendInMM;
      property QRCH_Fehlerkorrekturstufe  : string  read sQRCH_Fehlerkorrekturstufe;
      property QRCH_CodeAsString          : string  read F_Get_QRCodeAsString;

      property QRCH_CHKreuzBitmap         : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap     read QRCodeCHKreuzBitmap;          
      property QRCH_CodeBitmap            : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap     read QRCodeBitmap;
      property QRCH_QRCodeSkaliert        : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap     read QRCodeSkaliert;  
      

   end;

   procedure Get_PixelsPerMM( canvas: TCanvas; var x, y: single);
   function  F_SkalierungsFaktorQRCode(aCanvas : TCanvas) : integer;
   function  F_SkalierungsFaktorCHKreuz(aCanvas : TCanvas) : integer;      
   

implementation
// -------------------------------------------------------------------------- //
uses uDelphiZXIngQRCodeRoj, uTCHKreuz;

constructor TQRCodeCH.create( );
begin
   inherited;

   self.sQRCH_Header_Type          := 'SPC';    // Fixer Wert, SwissPaymentCode
   self.sQRCH_Header_Version       := '0200';   // Fixer Wert, Version 2.00
   self.sQRCH_Header_Coding        := '1';      // Fixer Wert, UTF-8 Latin CharSet
   self.sQRCH_Trailer              := 'EPD';    // Fixer Wert, EndPaymentData
   self.sQRCH_Fehlerkorrekturstufe := 'M';      // 'M' = 15%
   self.iQRCH_RuheZoneUmlaufendInMM:= 5;        // Ruhezone von 5mm umlaufend
end;
// -------------------------------------------------------------------------- //
function TQRCodeCH.F_Get_QRCodeAsString : string;
begin
   self.F_CheckData;
   result := trim(self.sQRCode);   
end;
// -------------------------------------------------------------------------- //
procedure TQRCodeCH.P_Set_QRCH_Adress_Typ( value : string );
begin
   self.sQRCH_Adress_Typ := UpperCase( value );
end;
// -------------------------------------------------------------------------- //
procedure TQRCodeCH.P_Set_QRCH_ReferenzTyp( value : string );
begin
   self.sQRCH_ReferenzTyp := UpperCase( value );   
end;
// -------------------------------------------------------------------------- //
//function TQRCodeCH.F_Get_QRCodeBitmapOhneRuheZone : Vcl.ExtCtrls.TPaintBox;
//begin
//   result := self.QRCodeSkaliert;
//end;
// -------------------------------------------------------------------------- //
//function TQRCodeCH.F_Get_QRCodeBitmapMitRuheZone: Vcl.ExtCtrls.TPaintBox;
//begin
//   // ToDo
//   // - Paintbox vergrössern um 5mm Umrandung
//   // - QRCodeskaliert mittig einfügen.
//   
//   result := self.QRCodeSkaliert;
//end;
// -------------------------------------------------------------------------- //
// Erzeugt dynamisch eine Bitmap mit dem Schweizerkreuz gemäss Vorgabe.
procedure TQRCodeCH.P_GenerateSchweizerkreuz;
var
   Row, Column : integer;
begin
   if self.QRCodeCHKreuzBitmap = nil then 
      self.QRCodeCHKreuzBitmap := {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap.Create;
            
  {$IFDEF XEUP}
   self.QRCodeCHKreuzBitmap.SetSize(uTCHKreuz.ArraySize, uTCHKreuz.ArraySize);
  {$ELSE}
  self.QRCodeCHKreuzBitmap.Width := uTCHKreuz.ArraySize;
  self.QRCodeCHKreuzBitmap.Height := uTCHKreuz.ArraySize;
  {$ENDIF}
   for Row := 0 to uTCHKreuz.ArraySize - 1 do begin
      for Column := 0 to uTCHKreuz.ArraySize - 1 do begin
         if uTCHKreuz.chkreuz[Row, Column] = 1 then begin
            self.QRCodeCHKreuzBitmap.Canvas.Pixels[Column, Row] := clBlack;
         end else begin
            self.QRCodeCHKreuzBitmap.Canvas.Pixels[Column, Row] := clWhite;
         end;
      end;
   end; 
end;
// -------------------------------------------------------------------------- //
function TQRCodeCH.F_CheckData: Boolean;
var
   bCheck : Boolean;
begin
   self.sQRCode := '';

   bCheck := ( trim(self.sQRCH_IBAN)        <> '' ) and
             ( trim(self.sQRCH_Adress_Typ)  <> '' ) and
             ( trim(self.sQRCH_AdressName)  <> '' ) and
             ( trim(self.sQRCH_Header_Type) <> '' ) and
             ( trim(self.sQRCH_Waehrung)    <> '' ) and
             ( trim(self.sQRCH_ReferenzTyp) <> '' ) and
             (( trim(self.sQRCH_Adress_Typ) <> 'S' )   or  (trim(self.sQRCH_Adress_Typ) <> 'K' )) and
             (( trim(self.sQRCH_ReferenzTyp)<> 'QRR' ) or ( trim(self.sQRCH_ReferenzTyp) <> 'SCOR' ) 
                                                       or ( trim(self.sQRCH_ReferenzTyp) <> 'NON' ));

   // Falls Adresse strukturiert
   if self.sQRCH_Adress_Typ = 'S' then begin
      //
   end;

   // Falls Adresse kombiniert
   if self.sQRCH_Adress_Typ   = 'K' then begin
      self.sQRCH_Postleitzahl := '';
      self.sQRCH_Ort          := '';
      bCheck := bCheck and ( trim(self.sQRCH_AdresseNr) <> '' );
   end;

   // Den QR-Code zusammensetzen und dann eine Bitmap erzeugen.
   if bCheck then begin
      self.sQRCode := self.sQRCH_Header_Type           + sLineBreak +      //  1
                      self.sQRCH_Header_Version        + sLineBreak +      //  2
                      self.sQRCH_Header_Coding         + sLineBreak +      //  3
                      self.sQRCH_IBAN                  + sLineBreak +      //  4
                      self.sQRCH_Adress_Typ            + sLineBreak +      //  5
                      self.sQRCH_AdressName            + sLineBreak +      //  6
                      self.sQRCH_AdresseStrasse        + sLineBreak +      //  7
                      self.sQRCH_AdresseNr             + sLineBreak +      //  8
                      self.sQRCH_Postleitzahl          + sLineBreak +      //  9
                      self.sQRCH_Ort                   + sLineBreak +      // 10 
                      self.sQRCH_Land                  + sLineBreak +      // 11 
                      self.sQRCH_ZG_Adress_Typ         + sLineBreak +      // 12
                      self.sQRCH_ZG_AdressName         + sLineBreak +      // 13
                      self.sQRCH_ZG_AdresseStrasse     + sLineBreak +      // 14
                      self.sQRCH_ZG_AdresseNr          + sLineBreak +      // 15
                      self.sQRCH_ZG_Postleitzahl       + sLineBreak +      // 16
                      self.sQRCH_ZG_Ort                + sLineBreak +      // 17
                      self.sQRCH_ZG_Land               + sLineBreak +      // 18
                      self.sQRCH_Betrag                + sLineBreak +      // 19
                      self.sQRCH_Waehrung              + sLineBreak +      // 20
                      self.sQRCH_ZD_Adress_Typ         + sLineBreak +      // 21
                      self.sQRCH_ZD_AdressName         + sLineBreak +      // 22
                      self.sQRCH_ZD_AdresseStrasse     + sLineBreak +      // 23
                      self.sQRCH_ZD_AdresseNr          + sLineBreak +      // 24
                      self.sQRCH_ZD_Postleitzahl       + sLineBreak +      // 25
                      self.sQRCH_ZD_Ort                + sLineBreak +      // 26
                      self.sQRCH_ZD_Land               + sLineBreak +      // 27
                      self.sQRCH_ReferenzTyp           + sLineBreak +      // 28
                      self.sQRCH_Referenz              + sLineBreak +      // 29
                      self.sQRCH_Mitteilung            + sLineBreak +      // 30
                      self.sQRCH_Trailer               + sLineBreak +      // 31
                      self.sQRCH_RechnungsInfo         + sLineBreak +      // 32
                      self.sQRCH_1AlternativParameter  + sLineBreak +      // 33
                      self.sQRCH_2AlternativParameter  ;                   // 34         
   end;                                                        
   result := bCheck;
end;
// -------------------------------------------------------------------------- //
function TQRCodeCH.QRCH_GenerateQRCode : Boolean;
var
  qr_Matrix: TDelphiZXingQRCode;
  Row, Column: Integer;
  sidelength : integer;
  tempCode, tempKreuz : {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap;
begin
   result := false;
   // QR Code als String zusammensetzen, nach Test ob alle Daten vorhanden sind
   if self.F_CheckData then begin
      // Bitmap mit QRCode-String erzeugen
      qr_Matrix := TDelphiZXingQRCode.Create;

      try
         // Daten in QR abfüllen
         qr_Matrix.Data := self.QRCH_CodeAsString;
         // Codierungstyp festlegen (UTF-8 etc)
         qr_Matrix.Encoding := {$IFDEF XEUP}TQRCodeEncoding.{$ENDIF}qrUTF8NoBOM;
         // Fehlerlevel definieren : 0 (M) 1 (L) 2 (H) 3 (Q)
         qr_Matrix.ErrorCorrectionLevel := 1; // self.sQRCH_Fehlerkorrekturstufe; // 1 entspricht M
         // Ruhezone festlegen
         // 5mm ist empfohlen -> Umrechnen mit den Bildschirmpixel
         qr_Matrix.QuietZone := 0; //StrToIntDef(edtQuietZone.Text, 4);
         // Grösse der Anzeige bzw. Bitmap aufgrund der Grösse des Codes definieren
         if self.QRCodeBitmap = nil then self.QRCodeBitmap := {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap.Create;
         {$IFDEF XEUP}
         self.QRCodeBitmap.SetSize(qr_Matrix.Rows, qr_Matrix.Columns);
         {$ELSE}
         self.QRCodeBitmap.Width := qr_Matrix.Columns;
         self.QRCodeBitmap.Height := qr_Matrix.Rows;
         {$ENDIF}
         for Row := 0 to qr_Matrix.Rows - 1 do begin
            for Column := 0 to qr_Matrix.Columns - 1 do begin
               if (qr_Matrix.IsBlack[Row, Column]) then begin
                  self.QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
               end else begin
                  self.QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
               end;
            end;
         end;
         // Erzeugt das mittige Schweizerkreuz aufgrund der Definition in uTCHKreuz
         self.P_GenerateSchweizerkreuz;    // erzeugt self.QRCodeCHKreuz

         // -------------------------------------------------------------------------- //
         // Seitenlänge bestimmen (auf 46mm setzen)
         sidelength := uTQRCodeCH.F_SkalierungsFaktorQRCode(self.QRCodeBitmap.Canvas);
   
         // Code zeichnen
         tempCode := {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap.Create;
         tempCode.Width := sidelength;
         tempCode.Height:= sidelength;
         tempCode.Canvas.StretchDraw(Rect( 0, 0, sidelength, sidelength ), self.QRCodeBitmap);
   

         //Seitenlaenge für CH-Kreuz bestimmt (auf 7mm setzen)
         tempKreuz  := {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap.Create;
         sidelength := uTQRCodeCH.F_SkalierungsFaktorCHKreuz(self.QRCodeCHKreuzBitmap.Canvas);
         //CH-Kreuz in Code kopieren
         tempKreuz.Width  := sidelength; 
         tempKreuz.Height := sidelength;
         tempKreuz.Canvas.StretchDraw(Rect( 0, 0, sidelength, sidelength ), self.QRCodeCHKreuzBitmap);

         
//         // Kreuz in Code einbauen (mittig einzeichnen)
         tempCode.Canvas.CopyMode := cmMergeCopy;  // TCopyMode
   
         tempCode.Canvas.CopyRect( Rect(  (tempCode.Width  DIV 2) - (sidelength DIV 2), (tempCode.Width  DIV 2) - (sidelength DIV 2),
                                          (tempCode.Height DIV 2) + (sidelength DIV 2), (tempCode.Height DIV 2) + (sidelength DIV 2)), 
                                   tempKreuz.Canvas,
                                   Rect(  0, 0, sidelength, sidelength ) 
                                 );

         if self.QRCodeSkaliert = nil then self.QRCodeSkaliert := {$IFDEF XEUP}Vcl.{$ENDIF}Graphics.TBitmap.Create;
         self.QRCodeSkaliert := tempCode;

         result := ( self.QRCodeBitmap <> nil ) and ( self.QRCodeCHKreuzBitmap <> nil );
      finally
         qr_Matrix.Free;
      end;
   end;
end;
// -------------------------------------------------------------------------- //
procedure Get_PixelsPerMM( canvas: TCanvas; var x, y: single) ;
var
    H:HDC;
    hres,vres,
    hsiz,vsiz:integer;
begin
    //H:=canvas.handle;
    H := GetDC(GetDesktopWindow);
    hres := GetDeviceCaps(H,HORZRES) ;   {display width in pixels}
    vres := GetDeviceCaps(H,VERTRES) ;   {display height in pixels}
    hsiz := GetDeviceCaps(H,HORZSIZE) ;  {display width in mm}
    vsiz := GetDeviceCaps(H,VERTSIZE) ;  {display height in mm}
    x := hres/hsiz;
    y := vres/vsiz;

    ReleaseDC(0, H);
end;
// -------------------------------------------------------------------------- //
// aCanvas muss ein TWinControl als Parent haben
// Die Funktion liefert die Seitenlänge in Pixel, damit das Kreuz am Bildschirm 7mm Kantenlänge hat.
function F_SkalierungsFaktorQRCode(aCanvas : TCanvas) : integer;
var 
   scaleX, scaleY, scale : double;
   x,y: single;
begin

   // Skalierung bestimmen
   Get_PixelsPerMM( aCanvas, x, y );
   scaleX := (x * QRCH_QRCODE_SIZE_IN_MM);
   scaleY := (Y * QRCH_QRCODE_SIZE_IN_MM);   
   scale := (scaleX + scaleY) / 2; // Mittelwert nehmen

   result := trunc(scale);
end;
// -------------------------------------------------------------------------- //
// aCanvas muss ein TWinControl als Parent haben
// Die Funktion liefert die Seitenlänge in Pixel, damit das Kreuz am Bildschirm 7mm Kantenlänge hat.
function F_SkalierungsFaktorCHKreuz(aCanvas : TCanvas) : integer;
var 
   scaleX, scaleY, scale : double;
   x,y: single;
begin

   // Skalierung bestimmen
   Get_PixelsPerMM( aCanvas, x, y );
   scaleX := (x * QRCH_QRKREUZ_SIZE_IN_MM);
   scaleY := (Y * QRCH_QRKREUZ_SIZE_IN_MM);
   scale := (scaleX + scaleY) / 2; // Mittelwert nehmen

   result := trunc(scale);
end;
// -------------------------------------------------------------------------- //
end.
