unit IniConfig;

interface

uses
  System.SysUtils, System.IniFiles;

const
  ARQ_INI = 'IniConf.INI';

type
  TIniConfig = class
    FBASE: String;
    FLOGIN: String;
    FSENHA: String;
    FPATHIMG: String;
    FINICONFIG: TIniFile;
  private
    procedure CriarIniPadrao();
    procedure VerificaCriaIni();
    procedure CarregarDados();
  public
    constructor Create;
    property CONST_BASE: String read FBASE;
    property CONST_LOGIN: String read FLOGIN;
    property CONST_SENHA: String read FSENHA;
end;


implementation

constructor TIniConfig.Create;
begin
  inherited;
  VerificaCriaIni();
  CarregarDados();
end;

procedure TIniConfig.CriarIniPadrao;
begin
  FINICONFIG := TIniFile.Create(ExtractFilePath(ParamStr(0)) + ARQ_INI);
  FINICONFIG.WriteString('BANCO_DADOS', 'BASE', (ExtractFilePath(ParamStr(0))+'Database\BD.FDB'));
  FINICONFIG.WriteString('BANCO_DADOS', 'LOGIN', 'SYSDBA');
  FINICONFIG.WriteString('BANCO_DADOS', 'SENHA', 'masterkey');
end;

procedure TIniConfig.VerificaCriaIni;
begin
  if not (FileExists(ExtractFilePath(ParamStr(0)) + ARQ_INI)) then
    CriarIniPadrao()
  else
    FINICONFIG := TIniFile.Create(ExtractFilePath(ParamStr(0)) + ARQ_INI);
end;

procedure TIniConfig.CarregarDados;
begin
  try
    FBASE := FINICONFIG.ReadString('BANCO_DADOS', 'BASE', '');
    FLOGIN := FINICONFIG.ReadString('BANCO_DADOS', 'LOGIN','' );
    FSENHA := FINICONFIG.ReadString('BANCO_DADOS', 'SENHA', '');
  finally
    FreeAndNil(FINICONFIG);
  end;
end;


end.
