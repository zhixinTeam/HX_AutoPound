object fFormMain: TfFormMain
  Left = 0
  Top = 0
  ClientHeight = 527
  ClientWidth = 320
  Caption = #20027#31383#21475
  ShowTitle = False
  CloseButton.Visible = False
  TitleButtons = <>
  OnCreate = UnimFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  ScrollPosition = 0
  ScrollHeight = 0
  PlatformData = {}
  object PanelMain: TUnimContainerPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 527
    Hint = ''
    Align = alClient
    AlignmentControl = uniAlignmentClient
    object Menu1: TUnimNestedList
      Left = 0
      Top = 0
      Width = 320
      Height = 527
      Hint = ''
      Align = alClient
      Items.FontData = {0100000000}
      Title = #21151#33021#28165#21333
      SourceMenu = MenuMain
    end
  end
  object MenuMain: TUniMenuItems
    Images = UniMainModule.ImageListSmall
    Left = 24
    Top = 16
    object MenuItemN1: TUniMenuItem
      Caption = #35843#25972#36710#36742#29289#26009
      ImageIndex = 10
      OnClick = MenuItemN1Click
    end
    object MenuItemN2: TUniMenuItem
      Caption = #35843#25972#36710#36742#22320#30917
      ImageIndex = 16
      OnClick = MenuItemN2Click
    end
    object MenuItemN3: TUniMenuItem
      Caption = #25163#21160#25289#40657#36710#36742
      ImageIndex = 12
      OnClick = MenuItemN3Click
    end
    object MenuS1: TUniMenuItem
      Caption = '-'
    end
    object MenuReload: TUniMenuItem
      Caption = #37325#36733#31995#32479#21442#25968
      OnClick = MenuReloadClick
    end
  end
end
