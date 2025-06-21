unit MainForm;

interface

uses
  System.SysUtils, System.Classes, System.Diagnostics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.Graphics, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.NumberBox, Winapi.Windows,
  Winapi.Messages, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxClasses, cxContainer, cxEdit, cxDropDownEdit, cxTextEdit, cxMaskEdit, cxCalc,
  cxLabel, cxDataStorage, cxVariants, cxGeometry, cxCustomCanvas, dxCoreClasses,
  dxCoreGraphics, dxCustomData, dxChartCore, dxChartData, dxChartLegend,
  dxChartSimpleDiagram, dxChartXYDiagram, dxChartXYSeriesBarView, dxChartXYSeriesLineView,
  dxChartXYSeriesAreaView, dxChartMarkers, dxChartPalette, dxChartControl,
  dxUIAClasses, dxFramedControl, dxPanel, uInterfaces, uSortingRegistry;

type
  TfrmMain = class(TForm)
    pnOptions: TdxPanel;
    pnSort: TdxPanel;
    lbSortingArraySize: TcxLabel;
    cbSortingType: TcxComboBox;
    lbSortingType: TcxLabel;
    btnStart: TButton;
    chartSorting: TdxChartControl;
    chartSortingDiagram: TdxChartXYDiagram;
    eSortingArraySize: TNumberBox;
    gpnTimer: TGridPanel;
    pnTitAlgorithm: TdxPanel;
    pnTimer: TdxPanel;
    lbTimer: TcxLabel;
    lbTitAlgorithm: TcxLabel;
    timerExecute: TTimer;
    btnCancel: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure timerExecuteTimer(Sender: TObject);
  private
    var
      FStop: TStopwatch;
      FData: TArray<Integer>;
      FSortingChartSeries: TdxChartXYSeries;
      FSortingChartSelectedSeries: TdxChartXYSeries;

      FStep: Integer;

    procedure Clear;
    function ValidateSetting: Boolean;

    procedure ConfigureSorting;
    procedure ConfigureSortingChart;
    procedure CreateSeries(const AName: string; out ASeries: TdxChartXYSeries);
    procedure DrawSortingChart(const AIndex: Integer; const AForceRefresh: Boolean = False);
    procedure StepEvent(Sender: TObject; AIndex: Integer);

    procedure ExecuteSorting;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uDataGenerator, System.Threading;

{$R *.dfm}

procedure TfrmMain.btnStartClick(Sender: TObject);

begin
  btnStart.Enabled := False;
  try
    Clear;
    if not ValidateSetting then
      Exit;

    ConfigureSorting;
    ConfigureSortingChart;
    ExecuteSorting;
  finally
    btnStart.Enabled := True;
  end;
end;

procedure TfrmMain.Clear;
begin
  chartSortingDiagram.DeleteAllSeries;
  lbTitAlgorithm.Caption := '';
  lbTimer.Caption := '';
end;

procedure TfrmMain.ConfigureSorting;
var
  arraySize: Integer;
begin
  lbTitAlgorithm.Caption := cbSortingType.Properties.Items[cbSortingType.ItemIndex];
  arraySize := Round(eSortingArraySize.Value);

  FData := TDataGenerator.GenerateRandomIntegerArray(arraySize);
end;

procedure TfrmMain.ConfigureSortingChart;
var
  i: Integer;
begin
  chartSorting.BeginUpdate;
  try
    chartSortingDiagram.DeleteAllSeries;
    CreateSeries('Data', FSortingChartSeries);
    CreateSeries('Selected', FSortingChartSelectedSeries);

    with chartSortingDiagram do
    begin
      Legend.Visible := False;
      Axes.AxisY.Visible := False;
      Axes.AxisY.Gridlines.Visible := False;
      Axes.AxisX.Gridlines.Visible := False;
    end;

    for i := 0 to High(FData) do
      FSortingChartSeries.Points.Add(i, FData[i]);
  finally
    chartSorting.EndUpdate;
  end;
end;

procedure TfrmMain.CreateSeries(const AName: string;
  out ASeries: TdxChartXYSeries);
var
  binding: TdxChartXYSeriesUnboundDataBinding;
begin
  ASeries := chartSortingDiagram.AddSeries(AName);
  ASeries.ViewClass := TdxChartXYSeriesBarView;
  ASeries.ShowInLegend := TdxChartSeriesShowInLegend.None;
  (ASeries.View as TdxChartXYSeriesBarView).BarDistance := 1;
  ASeries.DataBindingClass := TdxChartXYSeriesUnboundDataBinding;
  binding := ASeries.DataBinding as TdxChartXYSeriesUnboundDataBinding;
  binding.ArgumentField.ValueTypeClass := TcxIntegerValueType;
  binding.ValueField.ValueTypeClass := TcxIntegerValueType;
end;

procedure TfrmMain.DrawSortingChart(const AIndex: Integer; const AForceRefresh: Boolean);
const
  cMaxStep = 50;
var
  i: Integer;
  step: Integer;
begin
  step := Round(Length(FData) / 10);
  if step > cMaxStep then
    step := cMaxStep;

  Inc(FStep);
  if (not AForceRefresh) and (step > FStep) then
    Exit;

  FStep := 0;
  chartSorting.BeginUpdate;
  try
    FSortingChartSeries.Points.Clear;
    for i := 0 to High(FData) do
      FSortingChartSeries.Points.Add(i, FData[i]);

    FSortingChartSelectedSeries.Points.Clear;
    if AIndex >= 0 then
      FSortingChartSelectedSeries.Points.Add(AIndex, FData[AIndex]);
  finally
    chartSorting.EndUpdate;
  end;
end;

procedure TfrmMain.ExecuteSorting;
var
  algorithm: ISortingAlgorithm;
begin
  algorithm := TSortingRegistry.CreateInstance(cbSortingType.Properties.Items[cbSortingType.ItemIndex]);

  FStop := TStopWatch.StartNew;
  timerExecute.Enabled := True;
  try
    algorithm.Execute(FData, StepEvent);
    DrawSortingChart(-1, True);
  finally
    FStop.Stop;
    timerExecute.Enabled := False;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  sortName: string;
begin
  cbSortingType.Properties.Items.BeginUpdate;
  try
    cbSortingType.Properties.Items.Clear;
    for sortName in TSortingRegistry.Names do
      cbSortingType.Properties.Items.Add(sortName);
  finally
    cbSortingType.Properties.Items.EndUpdate;
  end;
end;

procedure TfrmMain.StepEvent(Sender: TObject; AIndex: Integer);
begin
  TThread.Queue(nil,
    procedure
    begin
      DrawSortingChart(AIndex);
      Application.ProcessMessages;
    end);
end;

procedure TfrmMain.timerExecuteTimer(Sender: TObject);
begin
  lbTimer.Caption := Format('Time: %.3f s', [FStop.Elapsed.TotalSeconds]);
end;

function TfrmMain.ValidateSetting: Boolean;
begin
  Result := True;

  if Round(eSortingArraySize.Value) < 2 then
  begin
    ShowMessage('Array size is small!');
    Exit(False);
  end;

  if cbSortingType.ItemIndex < 0 then
  begin
    ShowMessage('Sort not found!');
    Exit(False);
  end;
end;

end.
