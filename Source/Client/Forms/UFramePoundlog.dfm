inherited fFramePoundLog: TfFramePoundLog
  Width = 971
  Height = 485
  inherited ToolBar1: TToolBar
    Width = 971
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
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
    Width = 971
    Height = 280
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 971
    Height = 138
    object cxTextEdit1: TcxTextEdit [0]
      Left = 461
      Top = 97
      Hint = 'T.P_CusName'
      ParentFont = False
      TabOrder = 7
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
      Top = 97
      Hint = 'T.P_MName'
      ParentFont = False
      TabOrder = 6
      Width = 145
    end
    object cxTextEdit4: TcxTextEdit [6]
      Left = 69
      Top = 97
      Hint = 'T.P_Truck'
      ParentFont = False
      TabOrder = 5
      Width = 145
    end
    object Check1: TcxCheckBox [7]
      Left = 859
      Top = 36
      Caption = #26597#21024#38500
      ParentFont = False
      TabOrder = 4
      Transparent = True
      OnClick = Check1Click
      Width = 80
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
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
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
    Width = 971
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 971
    inherited TitleBar: TcxLabel
      Caption = #31216#37325#35760#24405#26597#35810
      Style.IsFontAssigned = True
      Width = 971
      AnchorX = 486
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
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 272
    object N1: TMenuItem
      Caption = #26597#30475#25235#25293
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = #26597#30475#22810#27425
      OnClick = N3Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #26597#30475#22810#36710
      OnClick = N4Click
    end
  end
end
