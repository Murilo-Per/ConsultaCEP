unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Endereco.Service,
  Data.DB, Vcl.Grids, Vcl.DBGrids, ViaCEP;

type
  TFPrincipal = class(TForm)
    rgTipoRetorno: TRadioGroup;
    grpCEP: TGroupBox;
    edtPesqCEP: TLabeledEdit;
    grpEndereco: TGroupBox;
    edtPesqLogradouro: TLabeledEdit;
    edtPesqLocalidade: TLabeledEdit;
    edtPesqUF: TLabeledEdit;
    btnConsultarEndereco: TButton;
    btnConsultarCEP: TButton;
    grdEndereco: TDBGrid;
    dsGrid: TDataSource;
    ConsultaCEP1: TConsultaCEP;
    procedure btnConsultarEnderecoClick(Sender: TObject);
    procedure btnConsultarCEPClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    oEndereco: TEnderecoService;
    procedure LimparPesq();
    procedure CarregarComponents(const pObj: TEnderecoService);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

procedure TFPrincipal.btnConsultarCEPClick(Sender: TObject);
begin
  try
    oEndereco.TipoRetorno := TTipoRetorno(rgTipoRetorno.ItemIndex);
    oEndereco.ConsultarCEP(edtPesqCEP.Text);

    if oEndereco.Endereco.Active then
      CarregarComponents(oEndereco);
  finally
    LimparPesq;
  end;
end;

procedure TFPrincipal.btnConsultarEnderecoClick(Sender: TObject);
begin
  try
    oEndereco.TipoRetorno := TTipoRetorno(rgTipoRetorno.ItemIndex);
    oEndereco.ConsultarEndereco(edtPesqUF.Text, edtPesqLocalidade.Text, edtPesqLogradouro.Text);

    if oEndereco.Endereco.Active then
      CarregarComponents(oEndereco);
  finally
    LimparPesq;
  end;
end;

procedure TFPrincipal.CarregarComponents(const pObj: TEnderecoService);
begin
  pObj.Selecionar(dsGrid);
end;

procedure TFPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CanClose then
  begin
    FreeAndNil(oEndereco);
    Application.Terminate;
  end;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  oEndereco := TEnderecoService.Create;
  oEndereco.ConsultaCEP := ConsultaCEP1;
  oEndereco.Selecionar(dsGrid);
end;

procedure TFPrincipal.LimparPesq;
begin
  edtPesqCEP.Clear;
  edtPesqLogradouro.Clear;
  edtPesqLocalidade.Clear;
  edtPesqUF.Clear;
end;

end.
