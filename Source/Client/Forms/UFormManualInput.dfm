inherited fFormManualInput: TfFormManualInput
  Left = 588
  Top = 382
  Caption = #25163#24037#34917#21333
  ClientHeight = 285
  ClientWidth = 506
  Position = poDesktopCenter
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 506
    Height = 285
    inherited BtnOK: TButton
      Left = 324
      Top = 243
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 411
      Top = 243
      TabOrder = 9
    end
    object cxLabel1: TcxLabel [2]
      Left = 29
      Top = 129
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 25
      Width = 359
    end
    object EditPound: TcxTextEdit [3]
      Left = 310
      Top = 187
      ParentFont = False
      Properties.MaxLength = 10
      TabOrder = 7
      Width = 153
    end
    object EditTruck: TcxButtonEdit [4]
      Left = 87
      Top = 45
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 32
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 122
    end
    object EditFact: TcxTextEdit [5]
      Left = 87
      Top = 187
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 6
      Width = 160
    end
    object EditMID: TcxComboBox [6]
      Left = 87
      Top = 73
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 22
      TabOrder = 1
      Width = 152
    end
    object EditPID: TcxComboBox [7]
      Left = 87
      Top = 101
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 22
      TabOrder = 2
      Width = 152
    end
    object EditPValue: TcxTextEdit [8]
      Left = 87
      Top = 159
      ParentFont = False
      TabOrder = 4
      Width = 160
    end
    object EditMValue: TcxTextEdit [9]
      Left = 310
      Top = 159
      ParentFont = False
      TabOrder = 5
      OnKeyPress = EditMValueKeyPress
      Width = 152
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item7: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #29289#26009#21517#31216':'
          Control = EditMID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #20379' '#24212' '#21830':'
          Control = EditPID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              Caption = #30382#37325'('#21544'):'
              Control = EditPValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #27611#37325'('#21544'):'
              Control = EditMValue
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              Caption = #24037#21378#32534#21495':'
              Control = EditFact
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #30917#31449#32534#21495':'
              Control = EditPound
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end
