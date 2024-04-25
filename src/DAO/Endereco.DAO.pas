unit Endereco.DAO;

interface

uses FireDAC.Comp.Client, ConexaoFB, DB, System.Generics.Collections, Endereco.Model;

const
  TABELA = 'ENDERECO';

type
  TEnderecoDAO = class(TFDQuery)
  private
    procedure AddCamposSQL(); overload;
    procedure AddCamposSQL(pPrefix: String); overload;
    procedure AddCamposUPDATE(pIgnore: TArray<String>);

    procedure AddParametrosSQL(pObj: TDataSet);
    procedure CopiarFields(pObj: TDataSet);
    function ValorAsString(const pValue: Variant): String;

    procedure QrySelecionar();
    procedure QryInserir();
    procedure QryUpdate();

    function DefinirOperacao(const obj: TEndereco): Boolean;
    procedure Inserir(const obj: TEndereco);
    procedure Update(const obj: TEndereco);

    function ObterValorID(): Integer;

  public
    constructor Create(pObj: TDataSet);
    destructor Destroy; override;
    procedure Selecionar(); overload;
    procedure Selecionar(const pdParametros: TDictionary<String, Variant>); overload;

    procedure Salvar(const pObj: TEndereco);
  end;

implementation

uses System.SysUtils, Variants, Endereco.Utils;

{ TEnderecoDAO }

constructor TEnderecoDAO.Create(pObj: TDataSet);
begin
  inherited Create(nil);
  Self.Connection := TConexaoFB.ObterInstancia.Conexao;
  CopiarFields(pObj);
end;

destructor TEnderecoDAO.Destroy;
begin
  FreeAndNil(Self.Connection);
  inherited;
end;

procedure TEnderecoDAO.Selecionar;
begin
  QrySelecionar();
  Self.Open;
end;

procedure TEnderecoDAO.Selecionar(const pdParametros: TDictionary<String, Variant>);
var
  Par: TPair<String, Variant>;
begin
  QrySelecionar();
  for Par in pdParametros do
    Self.SQL.Add(' AND ' +  Par.Key + ' = ' + ValorAsString(Par.Value));

  Self.Open;
end;

procedure TEnderecoDAO.Inserir(const obj: TEndereco);
begin
  QryInserir();
  AddParametrosSQL(obj);
  Self.ParamByName('Codigo').Value  := ObterValorID;

  Self.ExecSQL;
end;

procedure TEnderecoDAO.Update(const obj: TEndereco);
begin
  QryUpdate();
  AddParametrosSQL(obj);

  Self.ExecSQL;
end;

procedure TEnderecoDAO.Salvar(const pObj: TEndereco);
var
  LField: TField;
  EhInserir: Boolean;
begin
  Self.Close;
  EhInserir := DefinirOperacao(pObj);

  if EhInserir then
    Inserir(pObj)
  else
    Update(pObj);
end;

procedure TEnderecoDAO.QryInserir();
begin
  Self.Close;
  Self.SQL.Clear;
  Self.SQL.Append(Format('INSERT INTO %s (', [TABELA]));
  AddCamposSQL();
  Self.SQL.Append(') VALUES (');
  AddCamposSQL(':');
  Self.SQL.Append(')');
end;

procedure TEnderecoDAO.QryUpdate();
begin
  Self.Close;
  Self.SQL.Clear;
  Self.SQL.Append(Format('UPDATE %s SET ', [TABELA]));
  AddCamposUPDATE(['Codigo']);
  Self.SQL.Add(' WHERE Codigo = :Codigo');
end;

procedure TEnderecoDAO.QrySelecionar;
begin
  Self.Close;
  Self.SQL.Clear;
  Self.SQL.Append('SELECT ');
  AddCamposSQL();
  Self.SQL.Append(' FROM '+ TABELA);
  Self.SQL.Append(' WHERE 1=1 ');
end;

function TEnderecoDAO.DefinirOperacao(const obj: TEndereco): Boolean;
var
  dParam: TDictionary<String, Variant>;
begin
  dParam := TDictionary<String, Variant>.Create;
  try
    if Assigned(obj) then
    begin
      if obj.Fields.FieldByName('Codigo').IsNull then
      begin
        dParam.Add('Upper(CEP)', obj.Fields.FieldByName('CEP').AsWideString);
        dParam.Add('Upper(LOCALIDADE)', obj.Fields.FieldByName('LOCALIDADE').AsWideString);
        dParam.Add('Upper(UF)', obj.Fields.FieldByName('UF').AsWideString);
      end
      else
        dParam.Add('Codigo', obj.Fields.FieldByName('Codigo').AsInteger);

      Selecionar(dParam);

      if Self.IsEmpty then
      begin
        Result := True;
      end else
      begin
        obj.Edit;
        obj.Codigo := Self.Fields.FieldByName('Codigo').AsInteger;
        obj.Post;

        Result := False;
      end;
    end;
  finally
    FreeAndNil(dParam);
  end;
end;

function TEnderecoDAO.ValorAsString(const pValue: Variant): String;
begin
  if VarIsStr(pValue) then
    Result := QuotedStr(VarToStr(pValue).ToUpper)
  else
    Result := VarToStr(pValue)
end;

procedure TEnderecoDAO.AddCamposSQL;
var
  iContador: Integer;
begin
  for iContador := 0 to Self.Fields.Count-1 do
  begin
    if (iContador = (Self.Fields.Count - 1)) then
      Self.SQL.Append(Self.Fields[iContador].FieldName)
    else
      Self.SQL.Append(Self.Fields[iContador].FieldName + ', ');
  end;
end;

procedure TEnderecoDAO.AddCamposSQL(pPrefix: String);
var
  iContador: Integer;
begin
  for iContador := 0 to Self.Fields.Count-1 do
  begin
    if (iContador = (Self.Fields.Count - 1)) then
      Self.SQL.Append(pPrefix + Self.Fields[iContador].FieldName)
    else
      Self.SQL.Append(pPrefix + Self.Fields[iContador].FieldName + ', ');
  end;
end;

procedure TEnderecoDAO.AddCamposUPDATE(pIgnore: TArray<String>);
const
  MODEL = '%s = :%s';
var
  iContador, iIndex: Integer;
  EhCampoChave: Boolean;
begin
  for iContador := 0 to Self.Fields.Count-1 do
  begin
    EhCampoChave := False;
    for iIndex:= Low(pIgnore) to High(pIgnore) do
    begin
      if UpperCase(Self.Fields[iContador].FieldName) = UpperCase(pIgnore[iIndex]) then
      begin
        EhCampoChave := True;
        break
      end;
    end;

    if not EhCampoChave then
    begin
      if (iContador = (Self.Fields.Count - 1)) then
        Self.SQL.Append(Format(MODEL, [Self.Fields[iContador].FieldName, Self.Fields[iContador].FieldName]))
      else
        Self.SQL.Append(Format(MODEL, [Self.Fields[iContador].FieldName, Self.Fields[iContador].FieldName]) + ', ');
    end;
  end;
end;

procedure TEnderecoDAO.AddParametrosSQL(pObj: TDataSet);
var
  LField: TField;
begin
  for LField in pObj.Fields do
    if Assigned(Self.FindParam(LField.FieldName)) then
      case LField.DataType of
        ftWideString: Self.ParamByName(LField.FieldName).AsWideString := RemoverAcentuacao(LField.AsWideString);
        ftInteger:Self.ParamByName(LField.FieldName).AsInteger := LField.AsInteger;
      end;
end;

procedure TEnderecoDAO.CopiarFields(pObj: TDataSet);
var
  I: Integer;
  NovoCampo: TField;
begin
  Self.Fields.Clear;

  for I := 0 to pObj.FieldCount - 1 do
  begin
    case pObj.Fields[I].DataType of
      ftWideString: NovoCampo := TWideStringField.Create(Self);
      ftInteger: NovoCampo := TIntegerField.Create(Self);
    else
      NovoCampo := TField.Create(Self);
    end;

    NovoCampo.FieldName := pObj.Fields[I].FieldName;
    NovoCampo.FieldKind := pObj.Fields[I].FieldKind;
    NovoCampo.Size := pObj.Fields[I].Size;
    NovoCampo.DataSet := Self;
  end;
end;

function TEnderecoDAO.ObterValorID: Integer;
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  vQuery.Connection := Self.Connection;
  try
    vQuery.SQL.Text := Format('SELECT gen_id(%s, 1) FROM rdb$database', ['GEN_ENDERECO_CODIGO']);
    vQuery.Open;
    Result := vQuery.Fields[0].AsInteger;
  finally
    FreeAndNil(vQuery);
  end;
end;

end.
