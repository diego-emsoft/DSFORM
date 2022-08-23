program DSFORM;

uses
  System.StartUpCopy,
  FMX.Forms,
  DSFORM.View.Main in 'View\DSFORM.View.Main.pas' {FrmDSFORMViewMain},
  DSFORM.Utils.Enum in 'Utils\DSFORM.Utils.Enum.pas',
  DSFORM.Classes.Generator in 'src\DSFORM.Classes.Generator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDSFORMViewMain, FrmDSFORMViewMain);
  Application.Run;
end.
