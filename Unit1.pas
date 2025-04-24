unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, Vcl.StdCtrls, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, System.Net.HttpClient, JSON, uCEP,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Button1: TButton;
    edtCEP: TEdit;
    edtCEPretorno: TEdit;
    edtLogradouro: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtLocalidade: TEdit;
    edtUF: TEdit;
    edtIBGE: TEdit;
    edtDDD: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtSLAFI: TEdit;
    Label9: TLabel;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDQuery1: TFDQuery;
    procedure Button1Click(Sender: TObject);
  private
    procedure SalvarOuAtualizarCep(ACep: TCep);
  public
  end;

const
  _URL_CONSULTAR_CEP = 'https://viacep.com.br/ws/%s/json/';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SalvarOuAtualizarCep(ACep: TCep);
begin
  FDQuery1.Connection := FDConnection1;

  // Verifica se o CEP já existe
  FDQuery1.SQL.Text := 'SELECT COUNT(*) FROM TspdCep WHERE cep = :cep';
  FDQuery1.ParamByName('cep').AsString := ACep.cep;
  FDQuery1.Open;

  if FDQuery1.Fields[0].AsInteger = 0 then
  begin
    // Inserir novo
    FDQuery1.SQL.Text :=
      'INSERT INTO TspdCep (cep, logradouro, complemento, bairro, localidade, uf, ibge, ddd) ' +
      'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :ibge, :ddd)';
  end
  else
  begin
    // Atualizar existente
    FDQuery1.SQL.Text :=
      'UPDATE TspdCep SET ' +
      'logradouro = :logradouro, ' +
      'complemento = :complemento, ' +
      'bairro = :bairro, ' +
      'localidade = :localidade, ' +
      'uf = :uf, ' +
      'ibge = :ibge, ' +
      'ddd = :ddd ' +
      'WHERE cep = :cep';
  end;

  // Atribui os parâmetros
  FDQuery1.ParamByName('cep').AsString := ACep.cep;
  FDQuery1.ParamByName('logradouro').AsString := ACep.logradouro;
  FDQuery1.ParamByName('complemento').AsString := ACep.complemento;
  FDQuery1.ParamByName('bairro').AsString := ACep.bairro;
  FDQuery1.ParamByName('localidade').AsString := ACep.localidade;
  FDQuery1.ParamByName('uf').AsString := ACep.uf;
  FDQuery1.ParamByName('ibge').AsString := ACep.ibge;
  FDQuery1.ParamByName('ddd').AsString := ACep.ddd;

  FDQuery1.ExecSQL;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  LCEP: String;
  LJSONObject: TJSONObject;
  CepObj: TCep;
begin
  LCEP := Trim(edtCEP.Text);
  RESTClient1.BaseURL := Format(_URL_CONSULTAR_CEP, [LCEP]);
  RESTClient1.SecureProtocols := [THTTPSecureProtocol.TLS12];

  RESTRequest1.Method := rmGET;
  RESTRequest1.Execute;

  LJSONObject := RESTRequest1.Response.JSONValue AS TJSONObject;

  // Preenche campos visuais
  edtCEPretorno.Text := LJSONObject.Values['cep'].Value;
  edtLogradouro.Text := LJSONObject.Values['logradouro'].Value;
  edtComplemento.Text := LJSONObject.Values['complemento'].Value;
  edtBairro.Text := LJSONObject.Values['bairro'].Value;
  edtLocalidade.Text := LJSONObject.Values['localidade'].Value;
  edtUF.Text := LJSONObject.Values['uf'].Value;
  edtIBGE.Text := LJSONObject.Values['ibge'].Value;
  edtDDD.Text := LJSONObject.Values['ddd'].Value;
  edtSLAFI.Text := LJSONObject.Values['siafi'].Value;

  // Preenche objeto
  CepObj := TCep.Create;
  try
    CepObj.cep := LJSONObject.Values['cep'].Value;
    CepObj.logradouro := LJSONObject.Values['logradouro'].Value;
    CepObj.complemento := LJSONObject.Values['complemento'].Value;
    CepObj.bairro := LJSONObject.Values['bairro'].Value;
    CepObj.localidade := LJSONObject.Values['localidade'].Value;
    CepObj.uf := LJSONObject.Values['uf'].Value;
    CepObj.ibge := LJSONObject.Values['ibge'].Value;
    CepObj.gia := LJSONObject.Values['gia'].Value;
    CepObj.ddd := LJSONObject.Values['ddd'].Value;
    CepObj.siafi := LJSONObject.Values['siafi'].Value;

    // Persiste no banco
    SalvarOuAtualizarCep(CepObj);
  finally
    CepObj.Free;
  end;
end;

end.

