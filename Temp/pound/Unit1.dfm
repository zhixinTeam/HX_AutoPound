object Form1: TForm1
  Left = 441
  Top = 243
  Width = 631
  Height = 422
  BorderIcons = [biSystemMenu, biMinimize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 5
    Top = 21
    Width = 30
    Height = 12
    Caption = #35835#25968':'
  end
  object Label2: TLabel
    Left = 5
    Top = 54
    Width = 30
    Height = 12
    Caption = #30917#31449':'
  end
  object Edit1: TEdit
    Left = 38
    Top = 19
    Width = 222
    Height = 20
    ReadOnly = True
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 38
    Top = 51
    Width = 220
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 38
    Top = 75
    Width = 78
    Height = 14
    Caption = #36830#25509
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 100
    Width = 623
    Height = 152
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 120
    Top = 72
    Width = 97
    Height = 17
    Caption = #36830#25509#20840#37096
    TabOrder = 4
    OnClick = CheckBox2Click
  end
  object Memo2: TMemo
    Left = 0
    Top = 252
    Width = 623
    Height = 143
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 5
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
    Left = 272
    Top = 36
  end
end
