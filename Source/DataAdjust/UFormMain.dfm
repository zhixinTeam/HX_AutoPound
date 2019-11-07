object fFormMain: TfFormMain
  Left = 384
  Top = 391
  Width = 618
  Height = 438
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Data Adjust'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object MemoLog: TMemo
    Left = 0
    Top = 175
    Width = 602
    Height = 205
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 380
    Width = 602
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 175
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Group1: TGroupBox
      Left = 7
      Top = 12
      Width = 227
      Height = 61
      Caption = '1.'#36830#25509#25968#25454#24211
      TabOrder = 0
      object BtnConn: TButton
        Left = 70
        Top = 22
        Width = 75
        Height = 25
        Caption = #25968#25454#36830#25509
        TabOrder = 0
        OnClick = BtnConnClick
      end
    end
    object Group2: TGroupBox
      Left = 7
      Top = 80
      Width = 227
      Height = 79
      Caption = '2.'#26102#38388#33539#22260
      TabOrder = 1
      object cxLabel1: TcxLabel
        Left = 9
        Top = 24
        Caption = #24320#22987#26085#26399':'
        Transparent = True
      end
      object EditStart: TcxDateEdit
        Left = 70
        Top = 22
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 1
        Width = 143
      end
      object cxLabel2: TcxLabel
        Left = 9
        Top = 52
        Caption = #32467#26463#26085#26399':'
        Transparent = True
      end
      object EditEnd: TcxDateEdit
        Left = 70
        Top = 50
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 3
        Width = 143
      end
    end
    object Group3: TGroupBox
      Left = 245
      Top = 12
      Width = 300
      Height = 61
      Caption = '3.'#35774#32622#21516#19968#36742#36710#21069#21518#20004#27425#27611#37325#35823#24046'('#21333#20301':'#20844#26020')'
      TabOrder = 2
      object Label1: TLabel
        Left = 105
        Top = 29
        Width = 78
        Height = 12
        Caption = #36807#30917#38388#38548'('#31186'):'
      end
      object EditMax: TcxTextEdit
        Left = 12
        Top = 25
        TabOrder = 0
        Text = '100'
        Width = 77
      end
      object EditTime: TcxTextEdit
        Left = 184
        Top = 25
        TabOrder = 1
        Text = '1800'
        Width = 77
      end
    end
    object GroupBox1: TGroupBox
      Left = 247
      Top = 80
      Width = 300
      Height = 79
      Caption = '4.'#25968#25454#22788#29702
      TabOrder = 3
      object BtnTotal: TButton
        Left = 12
        Top = 35
        Width = 75
        Height = 25
        Caption = 'A.'#32479#35745
        TabOrder = 0
        OnClick = BtnTotalClick
      end
    end
  end
end
