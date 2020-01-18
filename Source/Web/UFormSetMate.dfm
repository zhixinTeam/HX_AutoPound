inherited fFormSetMate: TfFormSetMate
  Caption = #35774#32622#29289#26009
  OnCreate = UnimFormCreate
  OnDestroy = UnimFormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  ScrollPosition = 0
  ScrollHeight = 47
  PlatformData = {}
  object PanelMain: TUnimContainerPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 314
    Height = 474
    Hint = ''
    Align = alClient
    AlignmentControl = uniAlignmentClient
    LayoutConfig.Padding = '1'
    LayoutConfig.Margin = '2'
    object PanelTop: TUnimContainerPanel
      Left = 0
      Top = 0
      Width = 314
      Height = 35
      Hint = ''
      Align = alTop
      Layout = 'hbox'
      object EditTruck: TUnimEdit
        Left = 0
        Top = 0
        Width = 244
        Height = 35
        Hint = ''
        Align = alClient
        Text = ''
        EmptyText = #36755#20837#36710#29260#21495#26597#25214
        ParentFont = False
        TabOrder = 1
        OnChange = EditTruckChange
      end
      object BtnFind: TUnimButton
        Left = 244
        Top = 0
        Width = 70
        Height = 35
        Hint = ''
        Align = alRight
        Caption = #21047#26032
        IconCls = 'search'
        UI = 'confirm'
        OnClick = BtnFindClick
      end
    end
    object DBGrid1: TUnimDBGrid
      Left = 0
      Top = 35
      Width = 314
      Height = 401
      Hint = ''
      Align = alClient
      DataSource = DataSource1
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgRowNumbers]
      WebOptions.PageSize = 100
      OnClick = DBGrid1Click
      Columns = <
        item
          Alignment = taCenter
          Title.Caption = #36873#20013
          FieldName = 'Checked'
          Width = 59
        end
        item
          Title.Caption = #36710#29260#21495#30721
          FieldName = 'T_Truck'
          Width = 100
        end
        item
          Title.Caption = #29289#26009#21517#31216
          FieldName = 'T_MName'
          Width = 150
        end>
    end
    object PanelBottom: TUnimContainerPanel
      Left = 0
      Top = 436
      Width = 314
      Height = 38
      Hint = ''
      Align = alBottom
      Layout = 'hbox'
      object BtnSortTruck: TUnimButton
        Left = 0
        Top = 0
        Width = 110
        Height = 38
        Hint = ''
        ShowHint = True
        ParentShowHint = False
        Align = alLeft
        Caption = #25353#36710#29260#25490#24207
        IconCls = 'locate'
        UI = 'action'
        OnClick = BtnSortTruckClick
      end
      object BtnSortMate: TUnimButton
        Left = 110
        Top = 0
        Width = 110
        Height = 38
        Hint = ''
        ShowHint = True
        ParentShowHint = False
        Align = alLeft
        Caption = #25353#29289#26009#25490#24207
        IconCls = 'locate'
        UI = 'action'
        OnClick = BtnSortMateClick
      end
      object BtnSet: TUnimButton
        Left = 224
        Top = 0
        Width = 90
        Height = 38
        Hint = ''
        Align = alRight
        Caption = #35774#32622
        IconCls = 'settings'
        UI = 'action'
        OnClick = BtnSetClick
      end
    end
  end
  object ClientDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 112
  end
  object DataSource1: TDataSource
    DataSet = ClientDS1
    Left = 144
    Top = 112
  end
end
