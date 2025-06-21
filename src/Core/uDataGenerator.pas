unit uDataGenerator;

interface

uses
  uInterfaces, System.SysUtils, System.Math;

type
  TDataGenerator = class
  public
    class function GenerateRandomIntegerArray(const ASize: Integer): TArray<Integer>;
  end;

implementation

class function TDataGenerator.GenerateRandomIntegerArray(const ASize: Integer): TArray<Integer>;
var
  i: Integer;
begin
  SetLength(Result, Max(1, ASize));
  Randomize;
  for i := 0 to High(Result) do
    Result[i] := Random(ASize);
end;

end.

