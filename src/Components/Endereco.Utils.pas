unit Endereco.Utils;

interface

  function RemoveCharacter(const ACep: string): String; overload;
  function RemoveCharacter(const ACep: Variant): String; overload;
  function RemoverAcentuacao(AStr: WideString): WideString;

implementation

uses System.SysUtils, Variants;

function RemoveCharacter(const ACep: string): String;
begin
  Result := StringReplace(ACep,'.','', [rfReplaceAll]);
  Result := StringReplace(Result,'-','', [rfReplaceAll]);
end;

function RemoveCharacter(const ACep: Variant): String;
begin
  Result := VarToStr(ACep);
  Result := StringReplace(ACep,'.','', [rfReplaceAll]);
  Result := StringReplace(Result,'-','', [rfReplaceAll]);
end;

function RemoverAcentuacao(AStr: WideString): WideString;
var
  x: Integer;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹™∫π≤≥';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU     ';
begin
  for x := 1 to Length(AStr) do
    if (Pos(AStr[x], ComAcento) <> 0) then
      AStr[x] := SemAcento[Pos(AStr[x], ComAcento)];

  Result := AStr;
end;

end.
