unit uBucketSort;

interface

uses
  uInterfaces;

type
  TBucketSort = class(TInterfacedObject, ISortingAlgorithm)
  public
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

uses
  System.Classes, System.Generics.Collections, Math, uSortingRegistry;

function TBucketSort.Name: string;
begin
  Result := 'Bucket Sort';
end;

procedure InsertionSort(var Arr: TArray<Integer>; const AStep: TStepProc);
var
  i, j, key: Integer;
begin
  for i := 1 to High(Arr) do
  begin
    key := Arr[i]; j := i - 1;
    while (j >= 0) and (Arr[j] > key) do
    begin
      Arr[j + 1] := Arr[j]; Dec(j);
    end;
    Arr[j + 1] := key;
    if Assigned(AStep) then AStep(nil, j + 1);
  end;
end;

procedure TBucketSort.Execute(var AData: TArray<Integer>; const AStep: TStepProc);
const
  cBuckets = 10;
var
  i: integer;
  k: Integer;
  index: Integer;
  range: Integer;
  minValue: Integer;
  maxValue: Integer;

  bucketArray: TArray<Integer>;
  buckets: array[0..cBuckets - 1] of TList<Integer>;
begin
  if Length(AData) <= 1 then
    Exit;

  minValue := MinIntValue(AData);
  maxValue := MaxIntValue(AData);

  range := maxValue - minValue + 1;
  for i := 0 to cBuckets - 1 do
    buckets[i] := TList<Integer>.Create;

  try
    for i := 0 to High(AData) do
    begin
      index := (AData[i] - minValue) * cBuckets div range;

      if index = cBuckets then
        index := cBuckets - 1;

      buckets[index].Add(AData[i]);
    end;

    k := 0;
    for i := 0 to cBuckets - 1 do
    begin
      bucketArray := buckets[i].ToArray;
      if Length(bucketArray) > 1 then
        InsertionSort(bucketArray, AStep);

      for index := 0 to High(bucketArray) do
      begin
        AData[k] := bucketArray[index];
        if Assigned(AStep) then
          AStep(Self, k);

        Inc(k);
      end;
    end;
  finally
    for i := 0 to cBuckets - 1 do
      buckets[i].Free;
  end;
end;

initialization
  TSortingRegistry.Register<TBucketSort>('Bucket Sort');
end.

