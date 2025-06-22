unit uPDQSort;

interface

uses
  uInterfaces;

type
  TPDQSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    procedure Swap(var A: Integer; var B: Integer);

    procedure InsertionSmall(
      var AData: TArray<Integer>;
      ALeft: Integer;
      ARight: Integer;
      const AStep: TStepProc
    );

    procedure SortRec(
      var AData: TArray<Integer>;
      ALeft: Integer;
      ARight: Integer;
      ADepth: Integer;
      const AStep: TStepProc
    );
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  System.Math, uSortingRegistry;

function TPDQSort.Name: string;
begin
  Result := 'PDQ Sort';
end;

procedure TPDQSort.InsertionSmall(
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
    key := AData[i];
    j := i - 1;

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

procedure TPDQSort.SortRec(
  var AData: TArray<Integer>;
  ALeft: Integer;
  ARight: Integer;
  ADepth: Integer;
  const AStep: TStepProc
);
var
  i: Integer;
  j: Integer;
  pivot: Integer;

begin
  while ARight - ALeft > 16 do
  begin
    if ADepth = 0 then
      Exit;

    Dec(ADepth);

    pivot := (AData[ALeft] + AData[ARight] + AData[(ALeft + ARight) div 2]) div 3;

    i := ALeft;
    j := ARight;
    repeat
      while AData[i] < pivot do
        Inc(i);

      while AData[j] > pivot do
        Dec(j);

      if i <= j then
      begin
        Swap(AData[i], AData[j]);

        if Assigned(AStep) then
        begin
          AStep(Self, i);
          AStep(Self, j);
        end;

        Inc(i);
        Dec(j);
      end;
    until i > j;

    if (j - ALeft) < (ARight - i) then
    begin
      SortRec(AData, ALeft, j, ADepth, AStep);
      ALeft := i;
    end
    else
    begin
      SortRec(AData, i, ARight, ADepth, AStep);
      ARight := j;
    end;
  end;

  InsertionSmall(AData, ALeft, ARight, AStep);
end;

procedure TPDQSort.Swap(var A, B: Integer);
var
  temp: Integer;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure TPDQSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
begin
  if Length(AData) <= 1 then
    Exit;

  SortRec(AData, 0, High(AData), Floor(Log2(Length(AData))) * 2, AStep);
end;

initialization
  TSortingRegistry.Register<TPDQSort>('PDQ Sort');
end.

