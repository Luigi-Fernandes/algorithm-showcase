unit uCountingSort;

interface

uses
  uInterfaces;

type
  TCountingSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  System.Math, uSortingRegistry;

function TCountingSort.Name: string;
begin
  Result := 'Counting Sort';
end;

procedure TCountingSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  i: Integer;
  k: Integer;

  value: Integer;
  minValue: Integer;
  maxValue: Integer;

  range: Integer;

  counts: TArray<Integer>;
begin
  if Length(AData) <= 1 then
    Exit;

  minValue := AData[0];
  maxValue := AData[0];

  for value in AData do
  begin
    if value < minValue then
      minValue := value;

    if value > maxValue then
      maxValue := value;
  end;

  Range := maxValue - minValue + 1;

  SetLength(counts, range);

  for value in AData do
    Inc(counts[value - minValue]);

  k := 0;
  for i := 0 to High(counts) do
  begin
    while counts[i] > 0 do
    begin
      AData[k] := i + minValue;
      if Assigned(AStep) then
        AStep(Self, k);

      Inc(k);
      Dec(counts[i]);
    end;
  end;
end;

initialization
  TSortingRegistry.Register<TCountingSort>('Counting Sort');
end.

