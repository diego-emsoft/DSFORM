unit DSFORM.Utils.Enum;

interface

uses
{(*}
  System.Classes;
{*)}

type
  TGenerico = 0..255;

  TConvert<T: record> = class
  private
  public
    class procedure PopulateListEnum(AList: TStrings);
    class function StrToEnum(const AStr: string): T;
    class function EnumToStr(const eEnum: T): string;
  end;

implementation

uses
{(*}
  System.SysUtils,
  System.TypInfo;
{*)}
{ TConvert<T> }

class function TConvert<T>.EnumToStr(const eEnum: T): string;
var
  P: PInteger;
  Num: integer;
begin
  try
    P := @eEnum;
    Num := integer(TGenerico((P^)));
    Result := GetEnumName(TypeInfo(T), Num);
  except
    raise EConvertError.Create('O Par�metro passado n�o corresponde a ' + sLineBreak + 'um inteiro Ou a um Tipo Enumerado');
  end;
end;

class procedure TConvert<T>.PopulateListEnum(AList: TStrings);
var
  i: integer;
  StrTexto: string;
  Enum: Integer;
begin
  i := 0;
  try
    repeat
      StrTexto := trim(GetEnumName(TypeInfo(T), i));
      Enum := GetEnumValue(TypeInfo(T), StrTexto);
      AList.Add(StrTexto);
      inc(i);
    until Enum < 0;
    AList.Delete(pred(AList.Count));
  except
    raise EConvertError.Create('O Par�metro passado n�o corresponde a um Tipo ENUM');
  end;
end;

class function TConvert<T>.StrToEnum(const AStr: string): T;
var
  P: ^T;
  num: Integer;
begin
  try
    num := GetEnumValue(TypeInfo(T), AStr);
    if num = -1 then
      abort;
    P := @num;
    result := P^;
  except
    raise EConvertError.Create('O Par�metro "' + AStr + '" passado n�o ' + sLineBreak + ' corresponde a um Tipo Enumerado');
  end;
end;

end.

