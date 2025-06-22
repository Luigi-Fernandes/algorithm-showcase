unit uTimSort;

interface

uses
  uInterfaces;

type
  TTimSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    const MIN_RUN = 32;

    procedure InsertionSortRange(
      var AData: TArray<Integer>;
      ALeft: Integer;
      ARight: Integer;
      const AStep: TStepProc
    );

    procedure Merge(
      var AData: TArray<Integer>;
      ABuffer: TArray<Integer>;
      ALeft: Integer;
      AMid: Integer;
      ARight: Integer;
      const AStep: TStepProc
    );
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  System.Math, uSortingRegistry;

function TTimSort.Name: string;
begin
  Result := 'Tim Sort';
end;

procedure TTimSort.InsertionSortRange(
  var AData: TArray<Integer>;
  ALeft: Integer;
  ARight: Integer;
  const AStep: TStepProc
);
var
  i: Integer;
  j: Integer;
  key: Integer;

begin
  for i := ALeft + 1 to ARight do
  begin
    key := AData[i]; j := i - 1;

    while (j >= ALeft) and (AData[j] > key) do
    begin
      AData[j + 1] := AData[j];
      Dec(j);
    end;

    AData[j + 1] := key;
    if Assigned(AStep) then
      AStep(Self, j + 1);
  end;
end;

procedure TTimSort.Merge(
  var AData: TArray<Integer>;
  ABuffer: TArray<Integer>;
  ALeft: Integer;
  AMid: Integer;
  ARight: Integer;
  const AStep: TStepProc
);
var
  i: Integer;
  j: Integer;
  k: Integer;

begin
  Move(
    AData[ALeft],
    ABuffer[ALeft],
    (ARight - ALeft + 1) * SizeOf(Integer)
  );

  i := ALeft;
  j := AMid + 1;
  k := ALeft;

  while (i <= AMid) and (j <= ARight) do
  begin
    if ABuffer[i] <= ABuffer[j] then
      AData[k] := ABuffer[i]
    else
      AData[k] := ABuffer[j];

    if Assigned(AStep) then
      AStep(Self, k);

    Inc(k);
    if ABuffer[i] <= ABuffer[j] then
      Inc(i)
    else
      Inc(j);
  end;

  while i <= AMid do
  begin
    AData[k] := ABuffer[i];

    if Assigned(AStep) then
      AStep(Self, k);

    Inc(k); Inc(i);
  end;

  while j <= ARight do
  begin
    AData[k] := ABuffer[j];

    if Assigned(AStep) then
      AStep(Self, k);

    Inc(k); Inc(j);
  end;
end;

procedure TTimSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  lengthData: Integer;
  size: Integer;
  left: Integer;
  right: Integer;
  mid: Integer;

  buffer: TArray<Integer>;
begin
  lengthData := Length(AData);
  if lengthData <= 1 then
    Exit;

  SetLength(buffer, lengthData);

  left := 0;
  while left < lengthData do
  begin
    right := Min(left + MIN_RUN - 1, lengthData - 1);
    InsertionSortRange(AData, left, right, AStep);
    left := right + 1;
  end;

  size := MIN_RUN;
  while size < lengthData do
  begin
    left := 0;
    while left < lengthData - size do
    begin
      mid := left + size - 1;
      right := Min(left + 2 * size - 1, lengthData - 1);

      Merge(AData, buffer, left, mid, right, AStep);

      left := right + 1;
    end;

    size := size * 2;
  end;
end;

initialization
  TSortingRegistry.Register<TTimSort>('Tim Sort');
end.

