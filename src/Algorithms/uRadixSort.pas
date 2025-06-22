unit uRadixSort;

interface

uses
  uInterfaces;

type
  TRadixSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

{ TRadixSort }

procedure TRadixSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
const
  cBase = 256;
  cPasses = SizeOf(Integer);

var
  i: Integer;
  pass: Integer;
  byteValue: Integer;
  p: Integer;

  buffer: TArray<Integer>;

  count: array [0..cBase - 1] of Integer;
  pos: array [0..cBase - 1] of Integer;
begin
  if Length(AData) <= 1 then
    Exit;

  SetLength(buffer, Length(AData));

  for pass := 0 to (cPasses - 1) do
  begin
    FillChar(count, SizeOf(Count), 0);

    for i := 0 to High(AData) do
    begin
      byteValue := (AData[i] shr (pass * 8)) and $FF;
      Inc(count[byteValue]);
    end;

    pos[0] := 0;
    for i := 1 to (cBase - 1) do
      pos[i] := pos[i - 1] + count[i -1];


    for i := 0 to High(AData) do
    begin
      byteValue := (AData[i] shr (pass * 8)) and $FF;
      p := pos[byteValue];
      buffer[p] := AData[i];
      Inc(pos[byteValue]);
    end;

    for i := 0 to High(AData) do
    begin
      AData[i] := buffer[i];

      if Assigned(AStep) then
        AStep(Self, i);
    end;
  end;
end;

function TRadixSort.Name: string;
begin
  Result := 'Radix Sort (LSD-256)';
end;

initialization
  TSortingRegistry.Register<TRadixSort>('Radix Sort');
end.
