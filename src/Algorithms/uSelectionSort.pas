unit uSelectionSort;

interface

uses
  uInterfaces;

type
  TSelectionSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TSelectionSort.Name: string;
begin
  Result := 'Selection Sort';
end;

procedure TSelectionSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  i: Integer;
  j: Integer;
  temp: Integer;
  minIndex: Integer;
begin
  for i := 0 to High(AData) - 1 do
  begin
    minIndex := i;
    for j := i + 1 to High(AData) do
    begin
      if AData[j] < AData[minIndex] then
        minIndex := j;
    end;

    if minIndex <> i then
    begin
      temp := AData[i];
      AData[i] := AData[minIndex];
      AData[minIndex] := temp;

      if Assigned(AStep) then
      begin
        AStep(Self, i);
        AStep(Self, minIndex);
      end;
    end;
  end;
end;

initialization
  TSortingRegistry.Register<TSelectionSort>('Selection Sort');
end.

