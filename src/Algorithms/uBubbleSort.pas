unit uBubbleSort;

interface

uses uInterfaces;

type
  TBubbleSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses uSortingRegistry;

function TBubbleSort.Name: string;
begin
  Result := 'Bubble Sort';
end;

procedure TBubbleSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  i: Integer;
  j: Integer;
  temp: Integer;
begin
  for i := High(AData) downto 1 do
  begin
    for j := 0 to i - 1 do
    begin
      if AData[j] > AData[j + 1] then
      begin
        temp := AData[j];
        AData[j] := AData[j + 1];
        AData[j + 1] := temp;
      end;

      if Assigned(AStep) then
        AStep(Self, j + 1);
    end;
  end;
end;

initialization
  TSortingRegistry.Register<TBubbleSort>('Bubble Sort');
end.

