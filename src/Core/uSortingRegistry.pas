unit uSortingRegistry;

interface

uses
  System.Generics.Collections, uInterfaces;

type
  TSortingRegistry = class
  strict private
    class var FMap: TObjectDictionary<string, TClass>;
    class constructor Create;
  public
    class procedure Register<T: class, constructor>(const AName: string);
    class function CreateInstance(const AName: string): ISortingAlgorithm;
    class function Names: TArray<string>;
  end;

implementation

uses
  System.SysUtils, System.Rtti;

{ TSortingRegistry }

class constructor TSortingRegistry.Create;
begin
  FMap := TObjectDictionary<string, TClass>.Create;
end;

class procedure TSortingRegistry.Register<T>(const AName: string);
begin
  FMap.AddOrSetValue(AName, TClass(T));
end;

class function TSortingRegistry.CreateInstance(const AName: string): ISortingAlgorithm;
var
  cls: TClass;
  obj: TObject;
begin
  if not FMap.TryGetValue(AName, cls) then
    raise Exception.CreateFmt('"%s" algorithm is not registered', [AName]);

  obj := cls.Create;
  if not Supports(obj, ISortingAlgorithm, Result) then
  begin
    obj.Free;
    raise Exception.CreateFmt('%s class do not supports ISortingAlgorithm', [cls.ClassName]);
  end;
end;

class function TSortingRegistry.Names: TArray<string>;
begin
  Result := FMap.Keys.ToArray;
end;

end.

