object Form1: TForm1
  Left = 451
  Top = 348
  Width = 951
  Height = 676
  Caption = #36710#36742#26816#27979#25511#21046#22120' - HNZX V1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Bevel1: TBevel
    Left = 0
    Top = 294
    Width = 935
    Height = 8
    Align = alBottom
    Shape = bsSpacer
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 935
    Height = 294
    Align = alClient
    Caption = 'IP + MAC'
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 26
      Width = 90
      Height = 12
      Caption = '1.'#36873#25321#36890#35759#31471#21475':'
    end
    object Label2: TLabel
      Left = 143
      Top = 27
      Width = 36
      Height = 12
      Caption = '2.'#36830#25509
    end
    object EditIP: TLabeledEdit
      Left = 216
      Top = 42
      Width = 116
      Height = 20
      EditLabel.Width = 72
      EditLabel.Height = 12
      EditLabel.Caption = '3.'#35774#32622'IP'#22320#22336
      TabOrder = 0
      Text = '192.168.001.001'
    end
    object EditPort: TLabeledEdit
      Left = 334
      Top = 42
      Width = 64
      Height = 20
      EditLabel.Width = 48
      EditLabel.Height = 12
      EditLabel.Caption = #36890#35759#31471#21475
      TabOrder = 1
      Text = '6000'
    end
    object EditMAC: TLabeledEdit
      Left = 400
      Top = 42
      Width = 120
      Height = 20
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = 'MAC'#22320#22336
      TabOrder = 2
      Text = '60-A4-4C-73-2A-20'
    end
    object BtnConn: TButton
      Tag = 10
      Left = 132
      Top = 42
      Width = 60
      Height = 18
      Caption = #30830#23450
      TabOrder = 3
      OnClick = BtnConnClick
    end
    object BtnSetIP: TButton
      Left = 524
      Top = 42
      Width = 60
      Height = 18
      Caption = #30830#23450
      TabOrder = 4
      OnClick = BtnSetIPClick
    end
    object MemoLog: TMemo
      Left = 2
      Top = 60
      Width = 931
      Height = 232
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 5
    end
    object EditCOM: TComboBox
      Tag = 10
      Left = 10
      Top = 42
      Width = 116
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 6
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 302
    Width = 935
    Height = 335
    Align = alBottom
    Caption = #26495#21345#27979#35797
    TabOrder = 1
    object Panel1: TPanel
      Left = 2
      Top = 14
      Width = 931
      Height = 32
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      object Label3: TLabel
        Left = 10
        Top = 11
        Width = 66
        Height = 12
        Caption = '1.'#36873#25321#26495#21345':'
      end
      object ComboBox1: TComboBox
        Left = 83
        Top = 10
        Width = 103
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 0
      end
      object CheckSrv: TCheckBox
        Left = 203
        Top = 11
        Width = 78
        Height = 14
        Caption = #21551#21160#26381#21153
        TabOrder = 1
        OnClick = CheckSrvClick
      end
      object BtnMem: TButton
        Left = 294
        Top = 8
        Width = 60
        Height = 18
        Caption = #20869#23384
        TabOrder = 2
        OnClick = BtnMemClick
      end
      object EditNo: TLabeledEdit
        Left = 424
        Top = 6
        Width = 35
        Height = 20
        EditLabel.Width = 36
        EditLabel.Height = 12
        EditLabel.Caption = #23631#21495#65306
        LabelPosition = lpLeft
        TabOrder = 3
        Text = '1'
      end
      object EditTxt: TLabeledEdit
        Left = 510
        Top = 6
        Width = 160
        Height = 20
        EditLabel.Width = 36
        EditLabel.Height = 12
        EditLabel.Caption = #23631#21495#65306
        LabelPosition = lpLeft
        TabOrder = 4
        Text = '12345'
      end
      object BtnDisplay: TButton
        Left = 675
        Top = 7
        Width = 60
        Height = 18
        Caption = #26174#31034
        TabOrder = 5
        OnClick = BtnDisplayClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 46
      Width = 100
      Height = 287
      Align = alLeft
      Caption = #36755#20837
      TabOrder = 1
      object Check1: TCheckBox
        Left = 10
        Top = 64
        Width = 68
        Height = 14
        Caption = #36890#36947'1'
        TabOrder = 0
      end
      object Check3: TCheckBox
        Left = 10
        Top = 105
        Width = 68
        Height = 13
        Caption = #36890#36947'3'
        TabOrder = 1
      end
      object Check5: TCheckBox
        Left = 10
        Top = 146
        Width = 68
        Height = 14
        Caption = #36890#36947'5'
        TabOrder = 2
      end
      object Check7: TCheckBox
        Left = 10
        Top = 187
        Width = 68
        Height = 14
        Caption = #36890#36947'7'
        TabOrder = 3
      end
      object Check2: TCheckBox
        Left = 10
        Top = 85
        Width = 68
        Height = 13
        Caption = #36890#36947'2'
        TabOrder = 4
      end
      object Check4: TCheckBox
        Left = 10
        Top = 126
        Width = 68
        Height = 13
        Caption = #36890#36947'4'
        TabOrder = 5
      end
      object Check6: TCheckBox
        Left = 10
        Top = 167
        Width = 68
        Height = 14
        Caption = #36890#36947'6'
        TabOrder = 6
      end
      object Check8: TCheckBox
        Left = 10
        Top = 208
        Width = 68
        Height = 14
        Caption = #36890#36947'8'
        TabOrder = 7
      end
      object CheckBox1: TCheckBox
        Left = 10
        Top = 28
        Width = 85
        Height = 14
        Caption = '2.'#24320#22987#30417#25511
        TabOrder = 8
        OnClick = CheckBox1Click
      end
    end
    object GroupBox4: TGroupBox
      Left = 102
      Top = 46
      Width = 100
      Height = 287
      Align = alLeft
      Caption = #36755#20986
      TabOrder = 2
      object CheckBox2: TCheckBox
        Left = 10
        Top = 64
        Width = 68
        Height = 14
        Caption = #36890#36947'1'
        TabOrder = 0
        OnClick = CheckBox2Click
      end
      object CheckBox3: TCheckBox
        Left = 10
        Top = 105
        Width = 68
        Height = 13
        Caption = #36890#36947'3'
        TabOrder = 1
        OnClick = CheckBox2Click
      end
      object CheckBox4: TCheckBox
        Left = 10
        Top = 146
        Width = 68
        Height = 14
        Caption = #36890#36947'5'
        TabOrder = 2
        OnClick = CheckBox2Click
      end
      object CheckBox5: TCheckBox
        Left = 10
        Top = 187
        Width = 68
        Height = 14
        Caption = #36890#36947'7'
        TabOrder = 3
        OnClick = CheckBox2Click
      end
      object CheckBox6: TCheckBox
        Left = 10
        Top = 85
        Width = 68
        Height = 13
        Caption = #36890#36947'2'
        TabOrder = 4
        OnClick = CheckBox2Click
      end
      object CheckBox7: TCheckBox
        Left = 10
        Top = 126
        Width = 68
        Height = 13
        Caption = #36890#36947'4'
        TabOrder = 5
        OnClick = CheckBox2Click
      end
      object CheckBox8: TCheckBox
        Left = 10
        Top = 167
        Width = 68
        Height = 14
        Caption = #36890#36947'6'
        TabOrder = 6
        OnClick = CheckBox2Click
      end
      object CheckBox9: TCheckBox
        Left = 10
        Top = 208
        Width = 68
        Height = 14
        Caption = #36890#36947'8'
        TabOrder = 7
        OnClick = CheckBox2Click
      end
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.ReadTotalConstant = 2000
    OnRxChar = ComPort1RxChar
    Left = 10
    Top = 100
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 234
    Top = 389
  end
end
