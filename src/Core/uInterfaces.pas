unit uInterfaces;

interface

uses
  System.SysUtils, System.Threading;

type
  TStepProc = procedure(Sender: TObject; AIndex: Integer) of object;

  ISortingAlgorithm = interface
    ['{5FDF1D9F-61E7-4F60-8813-25163B2D5D1B}']
    function Name: string;
    procedure Execute(var AData: TArray<Integer>; const AStep: TStepProc);
  end;

implementation

end.

