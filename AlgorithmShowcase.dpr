program AlgorithmShowcase;

uses
  Vcl.Forms,
  MainForm in 'src\UI\MainForm.pas' {frmMain},
  uBubbleSort in 'src\Algorithms\uBubbleSort.pas',
  uDataGenerator in 'src\Core\uDataGenerator.pas',
  uInterfaces in 'src\Core\uInterfaces.pas',
  uSortingRegistry in 'src\Core\uSortingRegistry.pas',
  uQuickSort in 'src\Algorithms\uQuickSort.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
