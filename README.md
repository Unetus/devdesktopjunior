# devdesktopjunior
Desafio consulta CEP - Delphi
# 🚀 ConsultaCEP - Projeto Desktop para Consulta e Persistência de CEPs

![Delphi](https://img.shields.io/badge/Delphi-12_Community_Editon-%23EE1F35?logo=delphi)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-%23336791?logo=postgresql)
![GitHub](https://img.shields.io/badge/GitHub-DevDesktopJunior-%23181717?logo=github)

Aplicação desktop desenvolvida em Delphi para consultar CEPs via API ViaCEP e persistir os dados em um banco PostgreSQL.  
**Funcionalidades**: Consulta em tempo real, histórico de CEPs, integração com banco de dados e testes unitários.

---

## 📋 Funcionalidades Principais
- **Consulta de CEP**: Busca automática de logradouro, bairro, cidade, UF, etc.
- **Persistência em Banco de Dados**: Salva os dados localmente (PostgreSQL) para acesso offline.
- **Atualização de Registros**: Se o CEP já existir, atualiza as informações.
- **Exemplo de Consulta SQL**: Filtra CEPs por estado (ex: PR).

---

## 🛠️ Pré-requisitos
- **Delphi 12** (Community Edition ou superior).
- **PostgreSQL 17** instalado localmente ou em servidor.
- **Conta no GitHub** para versionamento do código.
- **Postman/Insomnia** para testar a API.

---

## 🚀 Como Executar o Projeto

### 1. Configurar o Banco de Dados
- Execute o script [`Tabela_TspdCep.sql`](sql/Tabela_TspdCep.sql) no PostgreSQL:
  ```sql
  CREATE TABLE TspdCep (
      cep VARCHAR(9) PRIMARY KEY,
      logradouro VARCHAR(100),
      -- ... (demais campos)
  );

### 2. Clonar o Repositório

git clone https://github.com/seu-usuario/devdesktopjunior.git
cd devdesktopjunior
git checkout devjunior

### 3. Configurar a Conexão com o PostgreSQL
No Delphi, ajuste as propriedades do FDConnection no arquivo Unit1.pas:
FDConnection1.Params.Database := 'devdesktopjunior';
FDConnection1.Params.UserName := 'postgres';
FDConnection1.Params.Password := 'sua_senha';

### 4. Compilar e Executar
Abra o projeto ConsultaCEP.dproj no Delphi.

Pressione F9 para compilar e executar.

🧩 Estrutura do Projeto
devdesktopjunior/
├── src/                   # Código-fonte Delphi
│   ├── Unit1.pas          # Formulário principal
│   └── uCEP.pas           # Classe TCEP
├── sql/
│   └── Tabela_TspdCep.sql # Script da tabela
├── postman/
│   └── ConsultaCEP.json   # Collection da API
└── README.md              # Documentação

📚 Tecnologias Utilizadas
Delphi 12 Community Edition: Interface gráfica e lógica de negócio.

FireDAC: Conexão com PostgreSQL.

REST Client: Consumo da API ViaCEP.

🔍 Exemplo de Uso
Consultando um CEP
procedure TForm1.ConsultarCEP(CEP: string);
var
  RespostaJSON: TJSONObject;
begin
  RespostaJSON := RESTRequest1.Response.JSONValue as TJSONObject;
  // Preenche os campos do formulário...
end;

Query para CEPs do Paraná (PR)
SELECT * FROM TspdCep WHERE uf = 'PR';

🛑 Testes Unitários
Os testes verificam a integridade da consulta à API e a persistência no banco:
procedure TestTConsultaCEP.TestConsultaValida;
begin
  // Simula uma consulta e verifica se o objeto TCEP é preenchido
  Assert.AreEqual('PR', CEP.Uf, 'UF incorreta');
end;

### Conclusão

Esse projeto foi realizado unicamente para o desafio do Grupo Tecnospeed, confesso que me aventurei por Delphi pela primeira vez e tive que rever muitos conceitos mas graças ao vasto conteúdo na internet, depois de longas horas, consegui chegar num resultado satisfatório (para o meu  nível). Agradeço a oportunidade!