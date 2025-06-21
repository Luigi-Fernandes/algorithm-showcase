unit uMergeSort;

interface

uses
  uInterfaces;

type
  TMergeSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    procedure DoMergeSort(
      var AData: TArray<Integer>;
      var ABuffer: TArray<Integer>;
      const ALeft: Integer;
      const ARight: Integer;
      const AStep: TStepProc
    );
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function TMergeSort.Name: string;
begin
  Result := 'Merge Sort';
end;

procedure TMergeSort.DoMergeSort(
  var AData: TArray<Integer>;
  var ABuffer: TArray<Integer>;
  const ALeft: Integer;
  const ARight: Integer;
  const AStep: TStepProc
);
var
  i: Integer;
  j: Integer;
  k: Integer;
  mid: Integer;

begin
  if ALeft >= ARight then
    Exit;

  mid := (ALeft + ARight) div 2;

  DoMergeSort(AData, ABuffer, ALeft, mid, AStep);
  DoMergeSort(AData, ABuffer, mid + 1, ARight, AStep);

  i := ALeft;
  j := mid + 1;
  k := ALeft;

  while (i <= mid) and (j <= ARight) do
  begin
    if AData[i] <= AData[j] then
    begin
      ABuffer[k] := AData[i];
      Inc(i);
    end
    else
    begin
      ABuffer[k] := AData[j];
      Inc(j);
    end;

    Inc(k);
  end;

  while i <= mid do
  begin
    ABuffer[k] := AData[i];
    Inc(i); Inc(k);
  end;

  while j <= ARight do
  begin
    ABuffer[k] := AData[j];
    Inc(j); Inc(k);
  end;

  for k := ALeft to ARight do
  begin
    AData[k] := ABuffer[k];

    if Assigned(AStep) then
      AStep(Self, k);
  end;
end;

procedure TMergeSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  buffer: TArray<Integer>;
begin
  if Length(AData) <= 1 then
    Exit;

  SetLength(buffer, Length(AData));
  DoMergeSort(AData, buffer, 0, High(AData), AStep);
end;

initialization
  TSortingRegistry.Register<TMergeSort>('Merge Sort');
end.

