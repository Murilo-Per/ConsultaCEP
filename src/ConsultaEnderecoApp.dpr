program ConsultaEnderecoApp;

uses
  Vcl.Forms,
  uPrincipal in 'Screen\uPrincipal.pas' {FPrincipal},
  IniConfig in 'Config\IniConfig.pas',
  ConexaoFB in 'Config\ConexaoFB.pas',
  Endereco.Service in 'Service\Endereco.Service.pas',
  Endereco.DAO in 'DAO\Endereco.DAO.pas',
  Endereco.Model in 'Dominio\Endereco.Model.pas',
  Endereco.Utils in 'Components\Endereco.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
