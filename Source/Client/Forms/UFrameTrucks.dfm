inherited fFrameTrucks: TfFrameTrucks
  Width = 908
  Height = 485
  inherited ToolBar1: TToolBar
    Width = 908
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Caption = #35774#32622
      ImageIndex = 20
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
    inherited BtnRefresh: TToolButton
      Caption = '   '#21047#26032'   '
    end
    inherited BtnExit: TToolButton
      Caption = #20851#38381
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 908
    Height = 280
    inherited cxView1: TcxGridDBTableView
      OptionsSelection.MultiSelect = True
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 908
    Height = 138
    object cxTextEdit1: TcxTextEdit [0]
      Left = 461
      Top = 93
      Hint = 'T.T_PName'
      ParentFont = False
      TabOrder = 6
      Width = 390
    end
    object EditCus: TcxButtonEdit [1]
      Left = 461
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 145
    end
    object EditTruck: TcxButtonEdit [2]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 145
    end
    object EditMate: TcxButtonEdit [3]
      Left = 265
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 145
    end
    object EditDate: TcxButtonEdit [4]
      Left = 669
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 185
    end
    object cxTextEdit3: TcxTextEdit [5]
      Left = 265
      Top = 93
      Hint = 'T.T_MName'
      ParentFont = False
      TabOrder = 5
      Width = 145
    end
    object cxTextEdit4: TcxTextEdit [6]
      Left = 69
      Top = 93
      Hint = 'T.T_Truck'
      ParentFont = False
      TabOrder = 4
      Width = 145
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #29289#26009#21517':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #23458#25143#21517':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #29289#26009#21517':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #23458#25143#21517':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 908
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 908
    inherited TitleBar: TcxLabel
      Caption = #36710#36742#31649#29702
      Style.IsFontAssigned = True
      Width = 908
      AnchorX = 454
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 244
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 244
  end
end
