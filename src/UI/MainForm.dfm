object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Algorithm Showcase'
  ClientHeight = 444
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnOptions: TdxPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 57
    Align = alTop
    Frame.Borders = [bBottom]
    Frame.Visible = False
    TabOrder = 0
    object lbSortingArraySize: TcxLabel
      Left = 8
      Top = 8
      Caption = 'Size'
    end
    object cbSortingType: TcxComboBox
      Left = 109
      Top = 28
      Properties.ReadOnly = False
      Style.ReadOnly = True
      TabOrder = 1
      Width = 171
    end
    object lbSortingType: TcxLabel
      Left = 109
      Top = 8
      Caption = 'Sorting type'
    end
    object btnStart: TButton
      Left = 286
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 3
      OnClick = btnStartClick
    end
    object eSortingArraySize: TNumberBox
      Left = 8
      Top = 28
      Width = 95
      Height = 23
      TabOrder = 4
    end
    object btnCancel: TButton
      Left = 432
      Top = 26
      Width = 75
      Height = 25
      Caption = 'btnCancel'
      TabOrder = 5
    end
  end
  object pnSort: TdxPanel
    Left = 0
    Top = 57
    Width = 584
    Height = 387
    Align = alClient
    Frame.Borders = [bBottom]
    Frame.Visible = False
    TabOrder = 1
    object chartSorting: TdxChartControl
      Left = 0
      Top = 0
      Width = 584
      Height = 353
      Align = alClient
      Titles = <>
      object chartSortingDiagram: TdxChartXYDiagram
        Appearance.FillOptions.Mode = Clear
        Axes.AxisX.Gridlines.Visible = True
        Axes.AxisY.Gridlines.Visible = False
        Axes.AxisY.Visible = False
      end
    end
    object gpnTimer: TGridPanel
      Left = 0
      Top = 353
      Width = 584
      Height = 34
      Align = alBottom
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = pnTitAlgorithm
          Row = 0
        end
        item
          Column = 1
          Control = pnTimer
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      StyleElements = []
      object pnTitAlgorithm: TdxPanel
        Left = 0
        Top = 0
        Width = 292
        Height = 34
        Align = alClient
        AutoSize = True
        Frame.Borders = [bTop]
        Color = clWhite
        TabOrder = 0
        object lbTitAlgorithm: TcxLabel
          Left = 0
          Top = 0
          Align = alClient
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          AnchorX = 146
          AnchorY = 17
        end
      end
      object pnTimer: TdxPanel
        Left = 292
        Top = 0
        Width = 292
        Height = 34
        Align = alClient
        AutoSize = True
        Frame.Borders = [bTop]
        Color = clWhite
        TabOrder = 1
        object lbTimer: TcxLabel
          Left = 0
          Top = 0
          Align = alClient
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          AnchorX = 146
          AnchorY = 17
        end
      end
    end
  end
  object timerExecute: TTimer
    Enabled = False
    Interval = 100
    OnTimer = timerExecuteTimer
    Left = 531
    Top = 12
  end
end
