unit DSFORM.Classes.Generator;

interface

uses
  System.Classes, System.SysUtils;

type
  TClassesGenerator = class
  private
    FFilePath: string;
    FUnitName: string;
    FClassName: string;
    FProperties: TStrings;
    FUnitText: TStringList;
    FPrefix: string;
    FUseDTONomenclature: Boolean;
    procedure SetClassName(const Value: string);
    procedure SetFilePath(const Value: string);
    procedure SetProperties(const Value: TStrings);
    procedure SetPrefix(const Value: string);
    procedure SetUseDTONomenclature(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function GenerateUnit: string;
    procedure SaveUnit;
    function Display: TStringList;
  published
    property UseDTONomenclature: Boolean read FUseDTONomenclature write SetUseDTONomenclature;
    property Prefix: string read FPrefix write SetPrefix;
    property ClassName: string read FClassName write SetClassName;
    property Properties: TStrings read FProperties write SetProperties;
    property FilePath: string read FFilePath write SetFilePath;
  end;

implementation

{ TClassesGenerator }

constructor TClassesGenerator.Create;
begin
  FProperties := TStrings.Create;
  FUnitText := TStringList.Create;
end;

destructor TClassesGenerator.Destroy;
begin
  inherited;
end;

function TClassesGenerator.Display: TStringList;
begin
  Result := FUnitText;
end;

function TClassesGenerator.GenerateUnit: string;
var
  aProp, aNameUnit: string;
begin

  aNameUnit := FUnitName;

  if FUseDTONomenclature then
    aNameUnit := 'DTO.' + aNameUnit;

  if not FPrefix.IsEmpty then
    aNameUnit := FPrefix + '.' + aNameUnit;

  FUnitText.Add('unit ' + aNameUnit.ToUpper + ';' + FUnitText.LineBreak);

  FUnitText.Add('interface ' + FUnitText.LineBreak);

  FUnitText.Add('type');

  if ((FUnitName[1] = 'T') and (FUnitName[2] <> 'T')) or (FUnitName[1] <> 'T') then
    FUnitText.Add('  T' + FUnitName.ToUpper + ' = class')
  else
    FUnitText.Add('  ' + FUnitName.ToUpper + ' = class');

  FUnitText.Add('  private');

  for aProp in FProperties do
  begin
    FUnitText.Add('    F' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + ': ' + copy(aProp, Pos(':', aProp) + 1, Length(aProp)).ToLower + ';');
  end;

  for aProp in FProperties do
  begin
    FUnitText.Add('    procedure Set' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + '(const aValue: ' + copy(aProp, Pos(':', aProp) + 1, Length(aProp)).ToLower + ');');
  end;

  FUnitText.Add('  public');
  FUnitText.Add('    constructor Create;');
  FUnitText.Add('    destructor Destroy; override;');

  for aProp in FProperties do
  begin
    FUnitText.Add('    property ' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + ': ' + copy(aProp, Pos(':', aProp) + 1, Length(aProp)).ToLower + ' read F' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + ' write Set' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + ';');
  end;

  FUnitText.Add('  end;' + FUnitText.LineBreak);
  FUnitText.Add('implementation' + FUnitText.LineBreak);
  FUnitText.Add('{  T' + FUnitName.ToUpper + '  }' + FUnitText.LineBreak);

  FUnitText.Add('constructor T' + FUnitName.ToUpper + '.Create;');
  FUnitText.Add('begin');
  FUnitText.Add('');
  FUnitText.Add('end;' + FUnitText.LineBreak);

  FUnitText.Add('destructor T' + FUnitName.ToUpper + '.Destroy;');
  FUnitText.Add('begin');
  FUnitText.Add('');
  FUnitText.Add('  inherited;');
  FUnitText.Add('end;' + FUnitText.LineBreak);

  for aProp in FProperties do
  begin
    FUnitText.Add('procedure T' + FUnitName.ToUpper + '.Set' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + '(const aValue: ' + copy(aProp, Pos(':', aProp) + 1, Length(aProp)).ToLower + ');');
    FUnitText.Add('begin');
    FUnitText.Add('  F' + copy(aProp, 1, Pos(':', aProp) - 1).ToUpper + ' := aValue;');
    FUnitText.Add('end;' + FUnitText.LineBreak);
  end;

  FUnitText.Add('end.');
  Result := aNameUnit + '.pas';
end;

procedure TClassesGenerator.SaveUnit;
var
  pFileData: UTF8String;
  pFile: TFileStream;
  aNameUnit: string;
begin

  aNameUnit := FUnitName;

  if FUseDTONomenclature then
    aNameUnit := 'DTO.' + aNameUnit;

  if not FPrefix.IsEmpty then
    aNameUnit := FPrefix + '.' + aNameUnit;

  try
    if FFilePath.IsEmpty then
      FFilePath := GetCurrentDir + PathDelim;

    pFile := TFileStream.Create(FFilePath + aNameUnit + '.pas', fmCreate);
    pFileData := UTF8String(Display.Text);
    pFile.WriteBuffer(pFileData[1], Length(pFileData));
  finally
    pFile.Free;
  end;

end;

procedure TClassesGenerator.SetClassName(const Value: string);
begin
  FClassName := Value;
  FUnitName := FClassName;
end;

procedure TClassesGenerator.SetFilePath(const Value: string);
begin
  FFilePath := Value;
end;

procedure TClassesGenerator.SetProperties(const Value: TStrings);
begin
  FProperties := Value;
end;

procedure TClassesGenerator.SetUseDTONomenclature(const Value: Boolean);
begin
  FUseDTONomenclature := Value;
end;

procedure TClassesGenerator.SetPrefix(const Value: string);
begin
  FPrefix := Trim(Value);
end;

end.

