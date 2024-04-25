unit ConexaoFB;

interface

uses
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, IniConfig;

type
  TConexaoFB = class
  private
    class var FInstancia: TConexaoFB;
    FConexao: TFDConnection;
    FDadosConfig: TIniConfig;
    FMsgErro: String;
    constructor Create;
    constructor CreatePrivado;
    destructor Destroy; override;
    function Conectar: Boolean;
  public
    class function ObterInstancia: TConexaoFB;
    class procedure LiberarInstancia();

    class property Conexao: TFDConnection read FConexao;
  end;

implementation

constructor TConexaoFB.Create;
begin
  raise Exception.Create('Para obter uma instância utilize TConexaoFB.GetInstance !');
end;

destructor TConexaoFB.Destroy;
begin
  FreeAndNil(FDadosConfig);
  FreeAndNil(FConexao);
  inherited;
end;

constructor TConexaoFB.CreatePrivado;
begin
  inherited Create;
  FDadosConfig := TIniConfig.Create;

  FConexao := TFDConnection.Create(nil);
  FConexao.Params.DriverID := 'FB';
  FConexao.Params.Values['Charset'] := 'UTF8';
  FConexao.Params.Database := FDadosConfig.CONST_BASE;
  FConexao.Params.UserName := FDadosConfig.CONST_LOGIN;
  FConexao.Params.Password := FDadosConfig.CONST_SENHA;
  FConexao.LoginPrompt := False;

  Conectar;
end;

function TConexaoFB.Conectar: Boolean;
begin
  Result := True;
  try
    FConexao.Connected := True;
  except
    on E: EDatabaseError do
    begin
      FMsgErro := E.Message;
      Result := False;
    end;
  end;
end;

class function TConexaoFB.ObterInstancia: TConexaoFB;
begin
  if not Assigned(FInstancia) then
    FInstancia := TConexaoFB.CreatePrivado;

  Result := FInstancia;
end;

class procedure TConexaoFB.LiberarInstancia;
begin
  if Assigned(FInstancia) then
    FreeAndNil(FInstancia);
end;

initialization
finalization
  TConexaoFB.LiberarInstancia();

end.

