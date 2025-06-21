unit uShellSort;

interface

uses
  uInterfaces;

type
  TShellSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TShellSort.Name: string;
begin
  Result := 'Shell Sort';
end;

procedure TShellSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  i: Integer;
  j: Integer;
  temp: Integer;

  gap: Integer;
begin
  gap := Length(AData) div 2;
  while gap > 0 do
  begin
    for i := gap to High(AData) do
    begin
      temp := AData[i];
      j := i;

      while (j >= gap) and (AData[j - gap] > temp) do
      begin
        AData[j] := AData[j - gap];
        Dec(j, gap);
      end;

      AData[j] := temp;

      if Assigned(AStep) then
        AStep(Self, j);
    end;

    gap := gap div 2;
  end;
end;

initialization
  TSortingRegistry.Register<TShellSort>('Shell Sort');
end.

