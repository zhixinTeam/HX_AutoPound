inherited fFormGetData: TfFormGetData
  Caption = 'fFormGetData'
  PixelsPerInch = 96
  TextHeight = 13
  ScrollPosition = 0
  ScrollHeight = 47
  PlatformData = {}
  object PanelMain: TUnimContainerPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 480
    Hint = ''
    Align = alClient
    AlignmentControl = uniAlignmentClient
    object List1: TUnimList
      Left = 0
      Top = 0
      Width = 320
      Height = 427
      Hint = ''
      Align = alClient
    end
    object BtnOK: TUnimButton
      AlignWithMargins = True
      Left = 3
      Top = 430
      Width = 314
      Height = 47
      Hint = ''
      Align = alBottom
      Caption = #30830#23450
      OnClick = BtnOKClick
    end
  end
end
