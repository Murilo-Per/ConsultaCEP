# Resumo
Buscador de endereços por CEP ou Endereço(Logradouro,Localidade, UF).

![ConsultaEnderecoAPP](img/appimg.png) 

## Conceitos utilizados
* Arquitetura em Camadas (ou Layered Architecture)
* Pattern Singleton - Conexão com base de dados

## Requisitos
* [**Firebird**](https://firebirdsql.org/en/firebird-5-0-0/) - 5.0.0 ou superior
* [**DBeaver**](https://dbeaver.io/download/) - *Opcional* - Ferramenta para interação com banco de dados;
* [**ConsultaCEP**](https://github.com/Murilo-Per/ViaCEP-Component) - Componente utilizado para consultas na API ViaCEP

* `[Opcional]` Para facilitar o gerenciamento de dependências, eu recomendo utilizar o Boss.
   * [**Boss**](https://github.com/HashLoad/boss) - Gerenciador de dependências para Delphi
* Possuir as dlls **libeay32.dll** e **ssleay32.dll** na pasta do projeto junto ao executável.


# Instalação do App

### Banco de Dados
* 1 - Baixe e Instale o FireBird (*Instalação Padrão: Next, next, install...*);
* 2 - Execute o **isql.exe** na pasta do FireBird e cole esse comando substituindo "Seu Diretorio" com um diretório válido;
```
SET SQL DIALECT 3;

SET NAMES UTF8; 

SET CLIENTLIB 'C:\Windows\SysWOW64\FBCLIENT.DLL'; 

CREATE DATABASE '*Seu Diretorio*\App\Database\BD.FDB' USER 'SYSDBA' PASSWORD 'masterkey' PAGE_SIZE 16384 DEFAULT CHARACTER SET UTF8 COLLATION UTF8;

CREATE TABLE ENDERECO (
	CODIGO  	INTEGER NOT NULL,
	CEP			VARCHAR(8),
	LOGRADOURO	VARCHAR(255),
	COMPLEMENTO VARCHAR(255),
	BAIRRO 		VARCHAR(255),
	LOCALIDADE  VARCHAR(255),
	UF			VARCHAR(2)
);

ALTER TABLE ENDERECO ADD CONSTRAINT PK_CODIGO PRIMARY KEY (CODIGO);

CREATE GENERATOR GEN_ENDERECO_CODIGO START WITH 1 INCREMENT BY 1;

```

### Configurando INI
* No diretorio *src/app* edite o *IniConf.INI* para apontar para a base de dados
```
[BANCO_DADOS]
BASE=..\src\App\Database\BD.FDB
```