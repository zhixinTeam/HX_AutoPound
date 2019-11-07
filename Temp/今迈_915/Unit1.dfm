object Form1: TForm1
  Left = 829
  Top = 633
  Width = 565
  Height = 348
  Caption = 'Form1'
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
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 557
    Height = 288
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 557
    Height = 33
    Align = alTop
    TabOrder = 1
    object CheckBox1: TCheckBox
      Left = 11
      Top = 10
      Width = 78
      Height = 13
      Caption = #33258#21160#35835#21345
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object Button1: TButton
      Left = 138
      Top = 8
      Width = 60
      Height = 20
      Caption = #37325#36733
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
