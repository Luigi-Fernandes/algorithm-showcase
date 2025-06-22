unit uFlashSort;

interface

uses
  uInterfaces;

type
  TFlashSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    procedure Swap(var A, B: Integer);
    procedure InsertionPass(var AData: TArray<Integer>; const AStep: TStepProc);
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

procedure TFlashSort.Swap(var A, B: Integer);
var
  temp: Integer;
begin
  temp := A;
  A := B;
  B := temp;
end;

function TFlashSort.Name: string;
begin
  Result := 'Flash Sort';
end;

procedure TFlashSort.InsertionPass(var AData: TArray<Integer>; const AStep: TStepProc);
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

procedure TFlashSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
const
  cFlashFactor = 0.45;
var
  n, m, i, j, k, cidx, moveCnt, maxIdx, minVal, maxVal, range: Integer;
  L: TArray<Integer>;
  temp: Integer;
begin
  n := Length(AData);
  if n <= 1 then
    Exit;

  minVal := AData[0];
  maxVal := AData[0];
  maxIdx := 0;

  for i := 1 to n - 1 do
  begin
    if AData[i] < minVal then
      minVal := AData[i];

    if AData[i] > maxVal then
    begin
      maxVal := AData[i];
      maxIdx := i;
    end;
  end;

  if minVal = maxVal then
    Exit;

  m := Trunc(cFlashFactor * n);

  if m < 2 then
    m := 2;

  SetLength(L, m);
  FillChar(L[0], m * SizeOf(Integer), 0);

  range := maxVal - minVal;
  for i := 0 to n - 1 do
  begin
    cidx := (m - 1) * (AData[i] - minVal) div range;
    Inc(L[cidx]);
  end;

  for i := 1 to m - 1 do
    Inc(L[i], L[i - 1]);

  Swap(AData[maxIdx], AData[0]);
  if Assigned(AStep) then
  begin
    AStep(Self, maxIdx);
    AStep(Self, 0);
  end;

  moveCnt := 0;
  i := 0;
  k := m - 1;
  while moveCnt < n - 1 do
  begin
    while i > L[k] - 1 do
    begin
      Inc(i);
      k := (m - 1) * (AData[i] - minVal) div range;
    end;

    temp := AData[i];
    while i <> L[k] do
    begin
      k := (m - 1) * (temp - minVal) div range;
      j := L[k] - 1;
      Swap(temp, AData[j]);
      Dec(L[k]);
      Inc(moveCnt);

      if Assigned(AStep) then
        AStep(Self, j);
    end;

    AData[i] := temp;
  end;

  InsertionPass(AData, AStep);
end;

initialization
  TSortingRegistry.Register<TFlashSort>('Flash Sort');
end.

