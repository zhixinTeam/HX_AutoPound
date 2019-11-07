inherited fFormCard: TfFormCard
  Left = 743
  Top = 410
  Caption = #21150#29702#30913#21345
  ClientHeight = 255
  ClientWidth = 414
  Position = poMainFormCenter
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 414
    Height = 255
    inherited BtnOK: TButton
      Left = 232
      Top = 213
      Caption = #30830#23450
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 319
      Top = 213
      TabOrder = 6
    end
    object cxLabel1: TcxLabel [2]
      Left = 29
      Top = 101
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 25
      Width = 359
    end
    object EditTruck: TcxTextEdit [3]
      Left = 75
      Top = 131
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 3
      OnKeyPress = EditTruckKeyPress
      Width = 152
    end
    object EditCard: TcxButtonEdit [4]
      Left = 75
      Top = 45
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 32
      Properties.OnButtonClick = EditCardPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditCard2: TcxButtonEdit [5]
      Left = 75
      Top = 73
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 32
      Properties.OnButtonClick = EditCardPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditOwner: TcxTextEdit [6]
      Left = 75
      Top = 159
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20027#30913#21345':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #21103#30913#21345':'
          Control = EditCard2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25345#21345#20154':'
          Control = EditOwner
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
