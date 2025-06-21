unit uInsertionSort;

interface

uses
  uInterfaces;

type
  TInsertionSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TInsertionSort.Name: string;
begin
  Result := 'Insertion Sort';
end;

procedure TInsertionSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  i: Integer;
  j: Integer;
  key: Integer;
begin
  for i := 1 to High(AData) do
  begin
    key := AData[i];
    j := i - 1;

    while (j >= 0) and (AData[j] > key) do
    begin
      AData[j + 1] := AData[j];
      Dec(j);
    end;

    AData[j + 1] := key;

    if Assigned(AStep) then
      AStep(Self, j + 1);
  end;
end;

initialization
  TSortingRegistry.Register<TInsertionSort>('Insertion Sort');
end.

