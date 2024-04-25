unit Endereco.Model;

interface

uses
  FireDAC.Comp.Client,DB, System.SysUtils, Variants;

type
  TEndereco = class(TFDMemTable)
  private
    function ObterValorInteger(pIndex: Integer): Integer;
    function ObterValorWideString(pIndex: Integer): WideString;
    procedure ReceberValorInteger(pIndex:Integer; pValue: Integer);
    procedure ReceberValorWideString(pIndex:Integer; pValue: WideString);
    function Validar(pIndex: Integer; pValor: WideString): Boolean;
    function ValidarCEP(pValor: WideString): boolean;
    function ValidarUF(pValor: WideString): boolean;
    function ValidarLocalidadeLogradouro(pValor: WideString): boolean;
  public
    constructor Create;
    property Codigo: Integer index 0 read ObterValorInteger write ReceberValorInteger;
    property CEP: WideString index 1 read ObterValorWideString write ReceberValorWideString;
    property Logradouro: WideString index 2 read ObterValorWideString write ReceberValorWideString;
    property Complemento: WideString index 3 read ObterValorWideString write ReceberValorWideString;
    property Bairro: WideString index 4 read ObterValorWideString write ReceberValorWideString;
    property Localidade: WideString index 5 read ObterValorWideString write ReceberValorWideString;
    property UF: WideString index 6 read ObterValorWideString write ReceberValorWideString;
  end;

implementation

uses Endereco.Utils;

{ TEndereco }

constructor TEndereco.Create;
begin
  inherited Create(nil);

  Self.FieldDefs.Add('Codigo', ftInteger);
  Self.FieldDefs.Add('CEP', ftWideString, 8);
  Self.FieldDefs.Add('Logradouro', ftWideString, 255);
  Self.FieldDefs.Add('Complemento', ftWideString, 255);
  Self.FieldDefs.Add('Bairro', ftWideString, 255);
  Self.FieldDefs.Add('Localidade', ftWideString, 255);
  Self.FieldDefs.Add('UF', ftWideString, 2);
  Self.LogChanges := False;
  Self.CreateDataSet;
end;

function TEndereco.ObterValorInteger(pIndex: Integer): Integer;
begin
    Result := Self.Fields.Fields[pIndex].AsInteger;
end;

function TEndereco.ObterValorWideString(pIndex: Integer): WideString;
begin
  Result := Self.Fields.Fields[pIndex].AsWideString;
end;

procedure TEndereco.ReceberValorWideString(pIndex: Integer; pValue: WideString);
begin
  if Validar(pIndex, pValue) then
    Self.Fields.Fields[pIndex].AsWideString := pValue;
end;

procedure TEndereco.ReceberValorInteger(pIndex,pValue: Integer);
begin
  Self.Fields.Fields[pIndex].AsInteger := pValue;
end;

function TEndereco.Validar(pIndex: Integer; pValor: WideString): Boolean;
begin
  Result := True;
  case pIndex of
    1: if not ValidarCEP(pValor) then raise Exception.Create('CEP Inválido!');
    2: if not ValidarLocalidadeLogradouro(pValor) then raise Exception.Create('Logradouro informado é inválido!');
    5: if not ValidarLocalidadeLogradouro(pValor) then raise Exception.Create('Cidade informado é inválido!');
    6: if not ValidarUF(pValor) then raise Exception.Create('UF informado é inválido!');
  end;
end;

function TEndereco.ValidarCEP(pValor: WideString): boolean;
const
  INVALID_CHARACTER = -1;
begin
   Result := True;

  if (StringReplace(StringReplace(pValor, '-','',[rfReplaceAll]),'.','',[rfReplaceAll]).Trim.Length <> 8) then
    Exit(False);

  if StrToIntDef(pValor, INVALID_CHARACTER) = INVALID_CHARACTER then
    Exit(False);

end;

function TEndereco.ValidarUF(pValor: WideString): boolean;
begin
  Result := True;

  if Trim(pValor).Length < 2 then
    Exit(False);
end;

function TEndereco.ValidarLocalidadeLogradouro(pValor: WideString): boolean;
begin
  Result := True;

  if Trim(pValor).Length < 3 then
    Exit(False);
end;


end.
