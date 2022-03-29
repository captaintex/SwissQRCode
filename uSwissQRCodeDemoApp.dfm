object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'SwissQRCode DemoApp'
  ClientHeight = 549
  ClientWidth = 619
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 550
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblQRString: TLabel
    Left = 16
    Top = 13
    Width = 46
    Height = 13
    Caption = 'QR String'
  end
  object imgQR: TImage
    Left = 287
    Top = 32
    Width = 298
    Height = 265
    AutoSize = True
  end
  object lblWidth: TLabel
    Left = 409
    Top = 320
    Width = 79
    Height = 13
    Caption = 'QR Width [pixel]'
  end
  object lblQRHeightlbl: TLabel
    Left = 409
    Top = 339
    Width = 82
    Height = 13
    Caption = 'QR Height [pixel]'
  end
  object lblFormWidthlbl: TLabel
    Left = 409
    Top = 381
    Width = 88
    Height = 13
    Caption = 'Form Width [pixel]'
  end
  object lblFormHeightlbl: TLabel
    Left = 409
    Top = 400
    Width = 91
    Height = 13
    Caption = 'Form Height [pixel]'
  end
  object lblQRWidth: TLabel
    Left = 529
    Top = 320
    Width = 3
    Height = 13
  end
  object lblQRHeight: TLabel
    Left = 529
    Top = 339
    Width = 3
    Height = 13
  end
  object lblFormWidth: TLabel
    Left = 529
    Top = 381
    Width = 3
    Height = 13
  end
  object lblFormHeight: TLabel
    Left = 529
    Top = 400
    Width = 3
    Height = 13
  end
  object Memo: TMemo
    Left = 16
    Top = 32
    Width = 265
    Height = 481
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object btnClose: TButton
    Left = 409
    Top = 432
    Width = 176
    Height = 81
    Caption = 'Exit'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 530
    Width = 619
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Please see Code how to use the it.'
  end
end
