object FPrincipal: TFPrincipal
  Left = 562
  Top = 294
  BorderStyle = bsSingle
  Caption = 'Consulta de Endere'#231'o'
  ClientHeight = 361
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  TextHeight = 15
  object rgTipoRetorno: TRadioGroup
    Left = 0
    Top = 3
    Width = 106
    Height = 132
    Caption = 'Tipo de Retorno'
    ItemIndex = 0
    Items.Strings = (
      'JSON'
      'XML')
    TabOrder = 0
  end
  object grpCEP: TGroupBox
    Left = 107
    Top = 3
    Width = 154
    Height = 132
    Caption = 'Consulta por CEP'
    TabOrder = 1
    object edtPesqCEP: TLabeledEdit
      Left = 16
      Top = 46
      Width = 120
      Height = 23
      EditLabel.Width = 21
      EditLabel.Height = 15
      EditLabel.Caption = 'CEP'
      MaxLength = 9
      TabOrder = 0
      Text = ''
    end
    object btnConsultarCEP: TButton
      Left = 22
      Top = 83
      Width = 120
      Height = 34
      Caption = 'Consultar CEP'
      TabOrder = 1
      OnClick = btnConsultarCEPClick
    end
  end
  object grpEndereco: TGroupBox
    Left = 262
    Top = 3
    Width = 333
    Height = 132
    Caption = 'Consulta por Endere'#231'o'
    TabOrder = 2
    object edtPesqLogradouro: TLabeledEdit
      Left = 16
      Top = 46
      Width = 280
      Height = 23
      EditLabel.Width = 62
      EditLabel.Height = 15
      EditLabel.Caption = 'Logradouro'
      TabOrder = 0
      Text = ''
    end
    object edtPesqLocalidade: TLabeledEdit
      Left = 16
      Top = 94
      Width = 120
      Height = 23
      EditLabel.Width = 37
      EditLabel.Height = 15
      EditLabel.Caption = 'Cidade'
      TabOrder = 1
      Text = ''
    end
    object edtPesqUF: TLabeledEdit
      Left = 150
      Top = 94
      Width = 35
      Height = 23
      EditLabel.Width = 14
      EditLabel.Height = 15
      EditLabel.Caption = 'UF'
      MaxLength = 2
      TabOrder = 2
      Text = ''
    end
    object btnConsultarEndereco: TButton
      Left = 198
      Top = 83
      Width = 120
      Height = 34
      Caption = 'Consultar Endere'#231'o'
      TabOrder = 3
      OnClick = btnConsultarEnderecoClick
    end
  end
  object grdEndereco: TDBGrid
    Left = 0
    Top = 136
    Width = 600
    Height = 225
    Align = alBottom
    DataSource = dsGrid
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CEP'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Logradouro'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Bairro'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Localidade'
        Title.Caption = 'Cidade'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UF'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Complemento'
        Width = 120
        Visible = True
      end>
  end
  object dsGrid: TDataSource
    Left = 136
    Top = 200
  end
  object ConsultaCEP1: TConsultaCEP
    Left = 280
    Top = 192
  end
end
