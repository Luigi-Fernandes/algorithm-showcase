unit uCombSort;

interface

uses
  uInterfaces;

type
  TCombSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TCombSort.Name: string;
begin
  Result := 'Comb Sort';
end;

procedure TCombSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
const
  SHRINK = 13;
var
  i: Integer;
  temp: Integer;

  gap: Integer;

  swapped: Boolean;
begin
  gap := Length(AData);
  swapped := True;

  while (gap > 1) or swapped do
  begin
    gap := (gap * 10) div SHRINK;
    if gap < 1 then
      gap := 1;

    swapped := False;
    for i := 0 to Length(AData) - gap - 1 do
    begin
      if AData[i] > AData[i + gap] then
      begin
        temp := AData[i];
        AData[i] := AData[i + gap];
        AData[i + gap] := temp;

        if Assigned(AStep) then
        begin
          AStep(Self, i);
          AStep(Self, i + gap);
        end;

        swapped := True;
      end;
    end;
  end;
end;

initialization
  TSortingRegistry.Register<TCombSort>('Comb Sort');
end.

