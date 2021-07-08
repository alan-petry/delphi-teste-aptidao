unit Controller.Produtos;

interface

uses
  FireDAC.Comp.Client, System.SysUtils,
  Controller.Produtos.Interfaces,
  Data.DB, Entidades.Produtos;

type
  TPRODUTOS = class(TInterfacedObject,iPRODUTOS)
    private
      FConnection : TFDConnection;
      FQuery : TFDQuery;
      FDatasource : TDataSource;
      FEntidade : TPRODUTO;
    public
      constructor Create(aConnection : TFDConnection);
      destructor Destroy; override;
      class function New(aConnection : TFDConnection) : iPRODUTOS;

    function Inserir : iPRODUTOS;
    function Atualizar : iPRODUTOS;
    function Excluir : iPRODUTOS;
    function Datasource(aDatasource : TDatasource) : iPRODUTOS;
    function Buscar : iPRODUTOS; overload;
    function Buscar(filtro : string) : iPRODUTOS; overload;
    function Buscar(codigo : Integer) : iPRODUTOS; overload;
    function PRODUTO : TPRODUTO;
  end;

implementation

{ TPRODUTOS }

function TPRODUTOS.Atualizar: iPRODUTOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'update produtos set DESCRICAO = :DESCRICAO, PRECO_VENDA = :PRECO_VENDA where CODIGO = :CODIGO';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('CODIGO').Value := FEntidade.CODIGO;
    FQuery.ParamByName('DESCRICAO').Value := FEntidade.DESCRICAO;
    FQuery.ParamByName('PRECO_VENDA').Value := FEntidade.PRECO_VENDA;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na atualiza��o');
  end;
end;

function TPRODUTOS.Buscar: iPRODUTOS;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  try
    FQuery.Open('select * from produtos order by DESCRICAO');
  except
    raise Exception.Create('Erro na busca de dados');
  end;
end;

function TPRODUTOS.Buscar(filtro: string): iPRODUTOS;
var sql, ordem : string;
    aux : integer;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'select * from produtos';
  ordem := ' order by DESCRICAO';
  if filtro <> '' then
  begin
    try
      aux := StrToInt(filtro);
      sql := sql + ' where CODIGO = '+(filtro);
    except
      sql := sql + ' where DESCRICAO LIKE '+QuotedStr('%'+filtro+'%');
    end;
  end;

  try
    FQuery.Open(sql + ordem);
  except
    raise Exception.Create('Erro na busca de dados');
  end;
end;

function TPRODUTOS.Buscar(codigo: Integer): iPRODUTOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'select * from produtos';
  try
    sql := sql + ' where CODIGO = '+IntToStr(codigo);
    FQuery.Open(sql);

    if FQuery.RecordCount = 0 then
      raise Exception.Create('Produto n�o encontrado')
    else
    begin
      FEntidade.CODIGO := FQuery.FieldByName('CODIGO').Value;
      FEntidade.DESCRICAO := FQuery.FieldByName('DESCRICAO').Value;
      FEntidade.PRECO_VENDA := FQuery.FieldByName('PRECO_VENDA').Value;
    end;
  except
    raise Exception.Create('Erro na busca de dados');
  end;
end;

constructor TPRODUTOS.Create(aConnection : TFDConnection);
begin
  FConnection := aConnection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
  FEntidade := TPRODUTO.Create;
end;

function TPRODUTOS.Datasource(aDatasource: TDatasource): iPRODUTOS;
begin
  Result := Self;
  FDatasource := aDatasource;
  FDatasource.DataSet := FQuery;
end;

destructor TPRODUTOS.Destroy;
begin
  FreeandNil(FEntidade);
  FreeandNil(FQuery);

  inherited;
end;

function TPRODUTOS.Excluir: iPRODUTOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'delete from produtos where CODIGO = :CODIGO';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('CODIGO').Value := FEntidade.CODIGO;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na exclus�o');
  end;
end;

function TPRODUTOS.Inserir: iPRODUTOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'insert into produtos (DESCRICAO, PRECO_VENDA) values (:DESCRICAO, :PRECO_VENDA)';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('DESCRICAO').Value := FEntidade.DESCRICAO;
    FQuery.ParamByName('PRECO_VENDA').Value := FEntidade.PRECO_VENDA;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na inser��o');
  end;
end;

class function TPRODUTOS.New (aConnection : TFDConnection) : iPRODUTOS;
begin
  Result := Self.Create(aConnection);
end;

function TPRODUTOS.PRODUTO: TPRODUTO;
begin
  Result := FEntidade;
end;

end.
