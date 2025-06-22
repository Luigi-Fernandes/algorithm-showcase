unit uDualPivotQuickSort;

interface

uses
  uInterfaces;

type
  TDualPivotQuickSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    procedure SortRec(
      var AData: TArray<Integer>;
      ALeft: Integer;
      ARight: Integer;
      const AStep: TStepProc
    );
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TDualPivotQuickSort.Name: string;
begin
  Result := 'Dual Pivot QuickSort';
end;

procedure TDualPivotQuickSort.SortRec(
  var AData: TArray<Integer>;
  ALeft: Integer;
  ARight: Integer;
  const AStep: TStepProc
);
var
  p: Integer;
  q: Integer;
  i: Integer;
  lt: Integer;
  gt: Integer;
  temp: Integer;
begin
  if ARight - ALeft < 27 then
  begin
    for i := ALeft + 1 to ARight do
    begin
      temp := AData[i]; p := i - 1;

      while (p >= ALeft) and (AData[p] > temp) do
      begin
        AData[p + 1] := AData[p];
        Dec(p);
      end;

      AData[p + 1] := temp;
      if Assigned(AStep) then
        AStep(Self, p + 1);
    end;

    Exit;
  end;

  if AData[ALeft] > AData[ARight] then
  begin
    temp := AData[ALeft];
    AData[ALeft] := AData[ARight];
    AData[ARight] := temp;

    if Assigned(AStep) then
    begin
      AStep(Self, ALeft);
      AStep(Self, ARight);
    end;
  end;

  p := AData[ALeft];
  q := AData[ARight];
  lt := ALeft + 1;
  gt := ARight - 1;
  i := lt;

  while i <= gt do
  begin
    if AData[i] < p then
    begin
      temp := AData[i];
      AData[i] := AData[lt];
      AData[lt] := temp;

      if Assigned(AStep) then
      begin
        AStep(Self, i);
        AStep(Self, lt);
      end;

      Inc(lt);
    end
    else if AData[i] > q then
    begin
      while (AData[gt] > q) and (i < gt) do
        Dec(gt);

      temp := AData[i];
      AData[i] := AData[gt];
      AData[gt] := temp;

      if Assigned(AStep) then
      begin
        AStep(Self, i);
        AStep(Self, gt);
      end;

      Dec(gt);

      if AData[i] < p then
      begin
        temp := AData[i];
        AData[i] := AData[lt];
        AData[lt] := temp;

        if Assigned(AStep) then
        begin
          AStep(Self, i);
          AStep(Self, lt);
        end;

        Inc(lt);
      end;
    end;

    Inc(i);
  end;

  Dec(lt);
  Inc(gt);
  AData[ALeft] := AData[lt];
  AData[lt] := p;
  AData[ARight] := AData[gt];
  AData[gt] := q;

  if Assigned(AStep) then
  begin
    AStep(Self, ALeft);
    AStep(Self, lt);
    AStep(Self, ARight);
    AStep(Self, gt);
  end;

  SortRec(AData, ALeft, lt - 1, AStep);
  SortRec(AData, lt + 1, gt - 1, AStep);
  SortRec(AData, gt + 1, ARight, AStep);
end;

procedure TDualPivotQuickSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
begin
  if Length(AData) > 1 then
    SortRec(AData, 0, High(AData), AStep);
end;

initialization
  TSortingRegistry.Register<TDualPivotQuickSort>('Dual Pivot QuickSort');
end.

