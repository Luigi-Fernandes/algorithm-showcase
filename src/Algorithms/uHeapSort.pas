unit uHeapSort;

interface

uses
  uInterfaces;

type
  THeapSort = class(TInterfacedObject, ISortingAlgorithm)
  private
    procedure Heapify(
      var AData: TArray<Integer>;
      const ASize: Integer;
      const AIndex: Integer;
      const AStep: TStepProc
    );
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  uSortingRegistry;

function THeapSort.Name: string;
begin
  Result := 'Heap Sort';
end;

procedure THeapSort.Heapify(
  var AData: TArray<Integer>;
  const ASize: Integer;
  const AIndex: Integer;
  const AStep: TStepProc
);
var
  largest: Integer;
  left: Integer;
  right: Integer;
  temp: Integer;
begin
  largest := AIndex;
  left := 2 * AIndex + 1;
  right := 2 * AIndex + 2;

  if (left < ASize) and (AData[left] > AData[largest]) then
    largest := left;
  if (right < ASize) and (AData[right] > AData[largest]) then
    largest := right;

  if largest <> AIndex then
  begin
    temp := AData[AIndex];
    AData[AIndex] := AData[largest];
    AData[largest] := temp;

    if Assigned(AStep) then
    begin
      AStep(Self, AIndex);
      AStep(Self, largest);
    end;

    Heapify(AData, ASize, largest, AStep);
  end;
end;

procedure THeapSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
var
  i: Integer;
  temp: Integer;

  size: Integer;
begin
  size := Length(AData);
  if size <= 1 then
    Exit;

  for i := (size div 2) - 1 downto 0 do
    Heapify(AData, size, i, AStep);

  for i := size - 1 downto 1 do
  begin
    Temp := AData[0];
    AData[0] := AData[i];
    AData[i] := Temp;

    if Assigned(AStep) then
    begin
      AStep(Self, 0);
      AStep(Self, i);
    end;

    Heapify(AData, i, 0, AStep);
  end;
end;

initialization
  TSortingRegistry.Register<THeapSort>('Heap Sort');
end.

