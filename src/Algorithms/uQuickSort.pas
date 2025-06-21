unit uQuickSort;

interface

uses
  uInterfaces;

type
  TQuickSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TQuickSort.Name: string;
begin
  Result := 'Quick Sort';
end;

procedure TQuickSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);

  procedure DoQuick(ALeft, ARight: Integer);
  var
    i: Integer;
    j: Integer;
    temp: Integer;
    pivotIndex: Integer;
    pivotValue: Integer;
  begin
    i := ALeft;
    j := ARight;
    pivotIndex := (ALeft + ARight) div 2;
    pivotValue := AData[pivotIndex];

    while i <= j do
    begin
      while AData[i] < pivotValue do
        Inc(i);
      while AData[j] > pivotValue do
        Dec(j);

      if i <= j then
      begin
        temp := AData[i];
        AData[i] := AData[j];
        AData[j] := temp;

        if Assigned(AStep) then
        begin
          AStep(Self, i);
          AStep(Self, j);
        end;

        Inc(i);
        Dec(j);
      end;
    end;

    if ALeft < j then
      DoQuick(ALeft, j);

    if i < ARight then
      DoQuick(i, ARight);
  end;

begin
  if Length(AData) > 1 then
    DoQuick(0, High(AData));
end;

initialization
  TSortingRegistry.Register<TQuickSort>('Quick Sort');
end.

