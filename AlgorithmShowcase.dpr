program AlgorithmShowcase;

uses
  Vcl.Forms,
  MainForm in 'src\UI\MainForm.pas' {frmMain},
  uBubbleSort in 'src\Algorithms\uBubbleSort.pas',
  uDataGenerator in 'src\Core\uDataGenerator.pas',
  uInterfaces in 'src\Core\uInterfaces.pas',
  uSortingRegistry in 'src\Core\uSortingRegistry.pas',
  uQuickSort in 'src\Algorithms\uQuickSort.pas',
  uSelectionSort in 'src\Algorithms\uSelectionSort.pas',
  uInsertionSort in 'src\Algorithms\uInsertionSort.pas',
  uShellSort in 'src\Algorithms\uShellSort.pas',
  uMergeSort in 'src\Algorithms\uMergeSort.pas',
  uHeapSort in 'src\Algorithms\uHeapSort.pas',
  uIntroSort in 'src\Algorithms\uIntroSort.pas',
  uCountingSort in 'src\Algorithms\uCountingSort.pas',
  uRadixSort in 'src\Algorithms\uRadixSort.pas',
  uBucketSort in 'src\Algorithms\uBucketSort.pas',
  uTimSort in 'src\Algorithms\uTimSort.pas',
  uDualPivotQuickSort in 'src\Algorithms\uDualPivotQuickSort.pas',
  uPDQSort in 'src\Algorithms\uPDQSort.pas',
  uFlashSort in 'src\Algorithms\uFlashSort.pas',
  uCombSort in 'src\Algorithms\uCombSort.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
