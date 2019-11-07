inherited fFramePoundAuto: TfFramePoundAuto
  Width = 737
  Height = 548
  object RichEdit1: TRichEdit
    Left = 0
    Top = 283
    Width = 737
    Height = 265
    Align = alBottom
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object WorkPanel: TScrollBox
    Left = 0
    Top = 0
    Width = 737
    Height = 275
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    OnMouseWheel = WorkPanelMouseWheel
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 275
    Width = 737
    Height = 8
    HotZoneClassName = 'TcxXPTaskBarStyle'
    AlignSplitter = salBottom
    Control = RichEdit1
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 16
    Top = 14
  end
end
