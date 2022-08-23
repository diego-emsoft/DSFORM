unit DSFORM.View.Main;

interface

uses
{(*}
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ListBox,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Layouts,
  FMX.Edit,
  DSFORM.Classes.Generator;
{*)}

type
  tpCaixa = (TODOS, ENTRADA, SAIDA);

type
  tpUser = (ADMIN, OPERADOR, SOLICITANTE);

type
  tpDiasSemana = (SEGUNDA, TERCA, QUARTA, QUINTA, SEXTA, SABADO, DOMINGO);

type
  TFrmDSFORMViewMain = class(TForm)
    MmUnit: TMemo;
    Button1: TButton;
    EdtProps: TEdit;
    BtnProps: TButton;
    LstBxProps: TListBox;
    Button3: TButton;
    SaveDialog: TSaveDialog;
    CkBDTO: TCheckBox;
    EdtClassName: TEdit;
    Label1: TLabel;
    EdtPrefix: TEdit;
    Label2: TLabel;
    GpType: TGroupBox;
    RdoString: TRadioButton;
    RdoInteger: TRadioButton;
    RdoFloat: TRadioButton;
    RdoCurrency: TRadioButton;
    RdoBoolean: TRadioButton;
    RdoDate: TRadioButton;
    Label3: TLabel;
    Button2: TButton;
    RdoDateTime: TRadioButton;
    RdoTime: TRadioButton;
    RdoDouble: TRadioButton;
    RdoCustom: TRadioButton;
    EdtRdoCustom: TEdit;
    procedure BtnPropsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EdtPropsKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RdoCustomChange(Sender: TObject);
  private
    aPropType, aFileName: string;
    aGen: TClassesGenerator;
    procedure AddToPropsList;
    procedure ResetFields;
    procedure SaveUnit;
    procedure GenerateUnit;
  public
    { Public declarations }
  end;

var
  FrmDSFORMViewMain: TFrmDSFORMViewMain;

implementation


{$R *.fmx}

procedure TFrmDSFORMViewMain.Button1Click(Sender: TObject);
begin
  GenerateUnit;
end;

procedure TFrmDSFORMViewMain.Button2Click(Sender: TObject);
begin
  ResetFields;
end;

procedure TFrmDSFORMViewMain.BtnPropsClick(Sender: TObject);
begin
  AddToPropsList;
end;

procedure TFrmDSFORMViewMain.Button3Click(Sender: TObject);
begin
  SaveUnit;
end;

procedure TFrmDSFORMViewMain.EdtPropsKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    AddToPropsList;
end;

procedure TFrmDSFORMViewMain.AddToPropsList;
var
  I: Integer;
begin
  for I := 0 to GpType.ControlsCount - 1 do
  begin
    if TRadioButton(GpType.Controls[I]).IsChecked then
    begin
      if TRadioButton(GpType.Controls[I]).Text = 'CUSTOM' then
        aPropType := EdtRdoCustom.Text
      else
        aPropType := TRadioButton(GpType.Controls[I]).Text;
      TRadioButton(GpType.Controls[I]).IsChecked := False;
      EdtRdoCustom.Text.Empty;
      Break;
    end
    else if I = GpType.ControlsCount - 1 then
    begin
      ShowMessage('Please select a property type!');
      Exit;
    end;
  end;

  if EdtProps.Text <> '' then
    LstBxProps.Items.Add(EdtProps.Text + ':' + aPropType);
  EdtProps.Text := '';
  EdtProps.SetFocus;
end;

procedure TFrmDSFORMViewMain.FormCreate(Sender: TObject);
begin
  aGen := TClassesGenerator.create;
end;

procedure TFrmDSFORMViewMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(aGen);
  FreeAndNil(LstBxProps);
//  ReportMemoryLeaksOnShutdown := True;
end;

procedure TFrmDSFORMViewMain.FormShow(Sender: TObject);
begin
  EdtClassName.SetFocus;
  EdtRdoCustom.Visible := False;
end;

procedure TFrmDSFORMViewMain.RdoCustomChange(Sender: TObject);
begin
  EdtRdoCustom.Visible := RdoCustom.IsChecked;
end;

procedure TFrmDSFORMViewMain.ResetFields;
var
  I: Integer;
begin
  EdtClassName.Text := '';
  EdtPrefix.Text := '';
  LstBxProps.Items.Clear;
  CkBDTO.IsChecked := False;

  for I := 0 to GpType.ControlsCount - 1 do
  begin
    if TRadioButton(GpType.Controls[I]).IsChecked then
    begin
      TRadioButton(GpType.Controls[I]).IsChecked := False;
    end;
  end;

  MmUnit.Lines.BeginUpdate;
  MmUnit.Lines.Clear;
  MmUnit.Lines.EndUpdate;
  EdtClassName.SetFocus;
end;

procedure TFrmDSFORMViewMain.SaveUnit;
begin
  SaveDialog.FileName := aFileName;
  if SaveDialog.Execute then
  begin
    aGen.FilePath := Copy(SaveDialog.FileName, 1, Length(SaveDialog.FileName) - Length(aFileName));
    aGen.SaveUnit;
    ShowMessage('Classe salva com sucesso!');
    ResetFields;
  end;
end;

procedure TFrmDSFORMViewMain.GenerateUnit;
begin
  aGen.ClassName := EdtClassName.Text;
  aGen.Prefix := EdtPrefix.Text;
  aGen.UseDTONomenclature := CkBDTO.IsChecked;
  aGen.Properties := LstBxProps.Items;
  aFileName := aGen.GenerateUnit;
  MmUnit.Lines := aGen.Display;
end;

end.

