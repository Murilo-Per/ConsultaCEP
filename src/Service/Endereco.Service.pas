unit Endereco.Service;

interface

uses ViaCEP, Endereco.Model, Endereco.DAO, System.Generics.Collections, DB;

type
  TTipoRetorno = (trJSON, trXML);

  TEnderecoService = class
  private
    FEnderecoClass: TEndereco;
    FEnderecoDAO: TEnderecoDAO;
    FConsultaCEP: TConsultaCEP;
    FParams: TDictionary<String, Variant>;
    FTipoRetorno: TTipoRetorno;
    procedure CarregarObjEndereco(const pObjEndereco: TConsultaCEP); overload;
    procedure CarregarObjEndereco(const pObj: TDataSet) overload;
    procedure ConsultarEnderecoPrivate(pUF, pCidade, pLogradouro: String);  overload;
    procedure ConsultarEnderecoPrivate(pCEP: String); overload;
    procedure VerificarRetornouCEP();
  public
    constructor Create;
    destructor Destroy; override;
    procedure ConsultarCEP(pCEP: String);
    procedure ConsultarEndereco(pUF, pCidade, pLogradouro: String);
    procedure Salvar();
    procedure Selecionar(var pDsObj: TDataSource);

    property TipoRetorno: TTipoRetorno write FTipoRetorno default trJSON;
    property Endereco: TEndereco read FEnderecoClass;
    property ConsultaCEP: TConsultaCEP write FConsultaCEP;
  end;

implementation

uses System.SysUtils, FireDAC.DApt, Endereco.Utils, Dialogs, Controls;

{ TEnderecoService }

constructor TEnderecoService.Create;
begin
  FEnderecoClass := TEndereco.Create;
  FEnderecoDAO := TEnderecoDAO.Create(FEnderecoClass);
end;

destructor TEnderecoService.Destroy;
begin
  FreeAndNil(FEnderecoClass);
  FreeAndNil(FEnderecoDAO);
  FreeAndNil(FConsultaCEP);
  inherited;
end;

procedure TEnderecoService.Salvar;
begin
  if (FEnderecoClass.Active) and (FEnderecoClass.RecordCount > 0) then
    FEnderecoDAO.Salvar(FEnderecoClass);
end;

procedure TEnderecoService.Selecionar(var pDsObj: TDataSource);
begin
  FEnderecoDAO.Selecionar();
  pDsObj.DataSet := FEnderecoDAO;
end;

procedure TEnderecoService.CarregarObjEndereco(const pObjEndereco: TConsultaCEP);
begin
  FEnderecoClass.EmptyDataSet;

  with pObjEndereco.ViaCEP.Endereco do
  begin
    FEnderecoClass.Insert;

    if (FEnderecoDAO.Active) and (FEnderecoDAO.RecordCount > 0) then
      FEnderecoClass.Codigo := FEnderecoDAO.FieldByName('Codigo').AsInteger;

    FEnderecoClass.CEP := RemoveCharacter(CEP);
    FEnderecoClass.Logradouro := Logradouro;
    FEnderecoClass.Complemento := Complemento;
    FEnderecoClass.Bairro := Bairro;
    FEnderecoClass.Localidade := Localidade;
    FEnderecoClass.UF := UF;
    FEnderecoClass.Post;
  end;
end;

procedure TEnderecoService.CarregarObjEndereco(const pObj: TDataSet);
begin
  FEnderecoClass.EmptyDataSet;
  if pObj.Active then
  begin
    FEnderecoClass.Insert;
    FEnderecoClass.Codigo := pObj.Fields.FieldByName('Codigo').AsInteger;
    FEnderecoClass.CEP := pObj.Fields.FieldByName('CEP').AsString;
    FEnderecoClass.Logradouro := pObj.Fields.FieldByName('Logradouro').AsString;
    FEnderecoClass.Complemento := pObj.Fields.FieldByName('Complemento').AsString;
    FEnderecoClass.Bairro := pObj.Fields.FieldByName('Bairro').AsString;
    FEnderecoClass.Localidade := pObj.Fields.FieldByName('Localidade').AsString;
    FEnderecoClass.UF := pObj.Fields.FieldByName('UF').AsString;
    FEnderecoClass.Post;
  end;
end;

procedure TEnderecoService.ConsultarCEP(pCEP: String);
var
  FParams: TDictionary<String, Variant>;
  bNovaPesquisa: Boolean;
begin
  pCEP := RemoveCharacter(pCEP);

  if not FConsultaCEP.ViaCEP.Validate(pCEP) then
    raise Exception.Create('CEP Inválido!');

  FParams := TDictionary<String, Variant>.Create;
  try
    FParams.Add('CEP', pCEP);

    FEnderecoDAO.Selecionar(FParams);

    if not FEnderecoDAO.IsEmpty then
      bNovaPesquisa := (MessageDlg('Endereco já existe na base de dados, deseja atualizar com uma nova consulta ?', TMsgDlgType.mtConfirmation, [mbOK, mbCancel], 0) = mrOk)
    else bNovaPesquisa := True;

    if bNovaPesquisa then
    begin
      ConsultarEnderecoPrivate(pCEP);
      CarregarObjEndereco(FConsultaCEP);
      FEnderecoDAO.Salvar(FEnderecoClass);
    end
    else
      CarregarObjEndereco(FEnderecoDAO);

  finally
    FreeAndNil(FParams);
  end;
end;

procedure TEnderecoService.ConsultarEndereco(pUF, pCidade, pLogradouro: String);
var
  FParams: TDictionary<String, Variant>;
  bNovaPesquisa: Boolean;
begin
  pUF := RemoverAcentuacao(pUF);
  pCidade := RemoverAcentuacao(pCidade);
  pLogradouro := RemoverAcentuacao(pLogradouro);

  if not FConsultaCEP.ViaCEP.Validate(pUF, pCidade, pLogradouro) then
    raise Exception.Create('UF, Localidade ou Logradouro Inválido!');

  FParams := TDictionary<String, Variant>.Create;
  try
    FParams.Add('UPPER(UF)', pUF);
    FParams.Add('UPPER(Localidade)', pCidade);
    FParams.Add('UPPER(Logradouro)', pLogradouro);

    FEnderecoDAO.Selecionar(FParams);

    if not FEnderecoDAO.IsEmpty then
      bNovaPesquisa := (MessageDlg('Endereco já existe na base de dados, deseja atualizar com uma nova consulta ?', TMsgDlgType.mtConfirmation, [mbOK, mbCancel], 0) = mrOk)
    else bNovaPesquisa := True;

    if bNovaPesquisa then
    begin
      ConsultarEnderecoPrivate(pUF, pCidade, pLogradouro);
      CarregarObjEndereco(FConsultaCEP);
      FEnderecoDAO.Salvar(FEnderecoClass);
    end
    else
      CarregarObjEndereco(FEnderecoDAO);

  finally
    FreeAndNil(FParams);
  end;
end;

procedure TEnderecoService.ConsultarEnderecoPrivate(pCEP: String);
begin
  with FConsultaCEP do
  begin
    case FTipoRetorno of
      trJSON: ViaCEP.GetJson(pCEP);
      trXML: ViaCEP.GetXml(pCEP);
    end;

    VerificarRetornouCEP();
  end;
end;

procedure TEnderecoService.ConsultarEnderecoPrivate(pUF, pCidade,
  pLogradouro: String);
begin
  with FConsultaCEP do
  begin
    case FTipoRetorno of
      trJSON: ViaCEP.GetJson(pUF, pCidade, pLogradouro);
      trXML: ViaCEP.GetXml(pUF, pCidade, pLogradouro);
    end;

    VerificarRetornouCEP();
  end;
end;

procedure TEnderecoService.VerificarRetornouCEP();
begin
  if (FConsultaCEP.ViaCEP.Endereco.CEP = EmptyStr) then
    raise Exception.Create('Endereço não encontrado!');
end;


end.
