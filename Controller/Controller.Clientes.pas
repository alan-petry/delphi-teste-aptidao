unit Controller.Clientes;

interface

uses
  Controller.Clientes.Interfaces, FireDAC.Comp.Client, System.SysUtils,
  Data.DB, Entidades.Clientes;

type
  TCLIENTES = class(TInterfacedObject,iCLIENTES)
    private
      FConnection : TFDConnection;
      FQuery : TFDQuery;
      FDatasource : TDataSource;
      FEntidade : TCLIENTE;
    public
      constructor Create(aConnection : TFDConnection);
      destructor Destroy; override;
      class function New(aConnection : TFDConnection) : iCLIENTES;

    function Inserir : iCLIENTES;
    function Atualizar : iCLIENTES;
    function Excluir : iCLIENTES;
    function Datasource(aDatasource : TDatasource) : iCLIENTES;
    function Buscar : iCLIENTES; overload;
    function Buscar(filtro : string) : iCLIENTES; overload;
    function Buscar(codigo : integer) : iCLIENTES; overload;
    function CLIENTE : TCLIENTE;
  end;

implementation

{ TCLIENTES }

function TCLIENTES.Atualizar: iCLIENTES;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'update clientes set NOME = :NOME, CIDADE = :CIDADE, UF = :UF where CODIGO = :CODIGO';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('CODIGO').Value := FEntidade.CODIGO;
    FQuery.ParamByName('NOME').Value := FEntidade.NOME;
    FQuery.ParamByName('CIDADE').Value := FEntidade.CIDADE;
    FQuery.ParamByName('UF').Value := FEntidade.UF;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na atualiza��o');
  end;
end;

function TCLIENTES.Buscar(filtro: string): iCLIENTES;
var sql, ordem : string;
    aux : integer;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'select * from clientes';
  ordem := ' order by NOME';
  if filtro <> '' then
  begin
    try
      aux := StrToInt(filtro);
      sql := sql + ' where CODIGO = '+(filtro);
    except
      sql := sql + ' where NOME LIKE '+QuotedStr('%'+filtro+'%');
    end;
  end;

  try
    FQuery.Open(sql + ordem);
  except
    raise Exception.Create('Erro na busca de dados');
  end;
end;

function TCLIENTES.Buscar: iCLIENTES;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  try
    FQuery.Open('select * from clientes order by NOME');
  except
    raise Exception.Create('Erro na busca de dados');
  end;
end;

function TCLIENTES.Buscar(codigo: integer): iCLIENTES;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  try
    FQuery.Open('select * from clientes where CODIGO = '+IntToStr(codigo));
    FEntidade.CODIGO := FQuery.FieldByName('CODIGO').Value;
    FEntidade.NOME := FQuery.FieldByName('NOME').Value;
    FEntidade.CIDADE := FQuery.FieldByName('CIDADE').Value;
    FEntidade.UF := FQuery.FieldByName('UF').Value;
  except
    raise Exception.Create('Erro na busca de dados');
  end;
end;

function TCLIENTES.CLIENTE: TCLIENTE;
begin
  Result := FEntidade;
end;

constructor TCLIENTES.Create(aConnection : TFDConnection);
begin
  FConnection := aConnection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
  FEntidade := TCLIENTE.Create;
end;

function TCLIENTES.Datasource(aDatasource: TDatasource): iCLIENTES;
begin
  Result := Self;
  FDataSource := aDataSource;
  FDatasource.DataSet := FQuery;
end;

destructor TCLIENTES.Destroy;
begin
  FreeAndNil(FQuery);
  FreeAndNil(FEntidade);
  inherited;
end;

function TCLIENTES.Excluir: iCLIENTES;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'delete from clientes where CODIGO = :CODIGO';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('CODIGO').Value := FEntidade.CODIGO;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na exclus�o');
  end;
end;

function TCLIENTES.Inserir: iCLIENTES;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'insert into clientes (NOME, CIDADE, UF) values (:NOME, :CIDADE, :UF)';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('NOME').Value := FEntidade.NOME;
    FQuery.ParamByName('CIDADE').Value := FEntidade.CIDADE;
    FQuery.ParamByName('UF').Value := FEntidade.UF;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na inser��o');
  end;
end;

class function TCLIENTES.New(aConnection : TFDConnection) : iCLIENTES;
begin
  Result := Self.Create(aConnection);
end;

end.
