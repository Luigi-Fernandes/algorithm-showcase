unit uIntroSort;

interface

uses
  uInterfaces;

type
  TIntroSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    procedure Swap(var A: Integer; var B: Integer);
    procedure InsertionSortRange(
      var AData: TArray<Integer>;
      const ALeft: Integer;
      const ARight: Integer;
      const AStep: TStepProc
    );

    procedure HeapSortRange(
      var AData: TArray<Integer>;
      const ALeft: Integer;
      const ARight: Integer;
      const AStep: TStepProc
    );

    procedure IntroSortRec(
      var AData: TArray<Integer>;
      ALeft: Integer;
      ARight: Integer;
      ADepthLimit: Integer;
      const AStep: TStepProc
    );
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  Math, uSortingRegistry;

procedure TIntroSort.InsertionSortRange(
  var AData: TArray<Integer>;
  const ALeft: Integer;
  const ARight: Integer;
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

procedure TIntroSort.HeapSortRange(
  var AData: TArray<Integer>;
  const ALeft: Integer;
  const ARight: Integer;
  const AStep: TStepProc
);
var
  i: Integer;
  size: Integer;

  {$REGION 'Heapify'}
  procedure Heapify(ASize, AIndex: Integer);
  var
    left: Integer;
    right: Integer;
    largest: Integer;
  begin
    largest := AIndex;
    left := 2 * AIndex + 1;
    right := 2 * AIndex + 2;

    if (left < ASize) and (AData[ALeft + left] > AData[ALeft + largest]) then
      largest := left;
    if (right < ASize) and (AData[ALeft + right] > AData[ALeft + largest]) then
      largest := right;

    if largest <> AIndex then
    begin
      Swap(AData[ALeft + AIndex], AData[ALeft + largest]);
      if Assigned(AStep) then
      begin
        AStep(Self, ALeft + AIndex);
        AStep(Self, ALeft + largest);
      end;
      Heapify(ASize, largest);
    end;
  end;
  {$ENDREGION}

begin
  size := ARight - ALeft + 1;

  for i := (size div 2) - 1 downto 0 do
    Heapify(size, i);

  for i := size - 1 downto 1 do
  begin
    Swap(AData[ALeft], AData[ALeft + i]);
    if Assigned(AStep) then
    begin
      AStep(Self, ALeft);
      AStep(Self, ALeft + i);
    end;

    Heapify(i, 0);
  end;
end;

procedure TIntroSort.IntroSortRec(
  var AData: TArray<Integer>;
  ALeft: Integer;
  ARight: Integer;
  ADepthLimit: Integer;
  const AStep: TStepProc
);
var
  i: Integer;
  j: Integer;
  pivot: Integer;
  temp: Integer;
begin
  while (ARight - ALeft) > 16 do
  begin
    if ADepthLimit = 0 then
    begin
      HeapSortRange(AData, ALeft, ARight, AStep);
      Exit;
    end;

    Dec(ADepthLimit);

    pivot := AData[ALeft + (ARight - ALeft) div 2];
    i := ALeft;
    j := ARight;

    repeat
      while AData[i] < pivot do
        Inc(i);

      while AData[j] > pivot do
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
    until i > j;

    if (j - ALeft) < (ARight - i) then
    begin
      IntroSortRec(AData, ALeft, j, ADepthLimit, AStep);
      ALeft := i;
    end
    else
    begin
      IntroSortRec(AData, i, ARight, ADepthLimit, AStep);
      ARight := j;
    end;
  end;

  InsertionSortRange(AData, ALeft, ARight, AStep);
end;

function TIntroSort.Name: string;
begin
  Result := 'Intro Sort';
end;

procedure TIntroSort.Swap(var A, B: Integer);
var
  temp: Integer;
begin
  temp := A;
  A := B;
  B := temp;
end;

procedure TIntroSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  limit: Integer;
begin
  if Length(AData) <= 1 then
    Exit;

  limit := 2 * Floor(Log2(Length(AData)));

  IntroSortRec(AData, 0, High(AData), limit, AStep);
end;

initialization
  TSortingRegistry.Register<TIntroSort>('Intro Sort');
end.

