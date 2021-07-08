unit Controller.Pedidos;

interface

uses
  FireDAC.Comp.Client, System.SysUtils,
  Controller.Pedidos.Interfaces,
  Data.DB, Entidades.Pedidos;

type
  TPEDIDOS = class(TInterfacedObject,iPEDIDOS)
    private
      FConnection : TFDConnection;
      FQuery : TFDQuery;
      FDatasource : TDataSource;
      FEntidade : TPEDIDO;
    public
      constructor Create(aConnection : TFDConnection);
      destructor Destroy; override;
      class function New(aConnection : TFDConnection) : iPEDIDOS;

    function Inserir : iPEDIDOS;
    function Atualizar : iPEDIDOS;
    function Excluir : iPEDIDOS;
    function Ultimo : Integer;
    function Datasource(aDatasource : TDatasource) : iPEDIDOS;
    function Buscar(pedido: integer): iPEDIDOS;
    function PEDIDO : TPEDIDO;
  end;

implementation

{ TPEDIDOS }

function TPEDIDOS.Atualizar: iPEDIDOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'update pedidos set CLIENTE = :CLIENTE, DATA = :DATA where ID_PEDIDO = :ID_PEDIDO';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('ID_PEDIDO').Value := FEntidade.ID_PEDIDO;
    FQuery.ParamByName('DATA').Value := FEntidade.DATA;
    FQuery.ParamByName('CLIENTE').Value := FEntidade.CLIENTE;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na atualiza��o');
  end;
end;

function TPEDIDOS.Buscar(pedido: integer): iPEDIDOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'select * from pedidos where ID_PEDIDO = '+pedido.tostring;
  try
    FQuery.Open(sql);
    FEntidade.ID_PEDIDO := FQuery.FieldByName('ID_PEDIDO').Value;
    FEntidade.DATA := FQuery.FieldByName('DATA').Value;
    FEntidade.CLIENTE := FQuery.FieldByName('CLIENTE').Value;
  except
    raise Exception.Create('Pedido n�o localizado');
  end;
end;

constructor TPEDIDOS.Create(aConnection : TFDConnection);
begin
  FConnection := aConnection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
  FEntidade := TPEDIDO.Create;
end;

function TPEDIDOS.Datasource(aDatasource: TDatasource): iPEDIDOS;
begin
  Result := Self;
  FDatasource := aDatasource;
  FDatasource.DataSet := FQuery;
end;

destructor TPEDIDOS.Destroy;
begin
  FreeandNil(FEntidade);
  FreeandNil(FQuery);

  inherited;
end;

function TPEDIDOS.Excluir: iPEDIDOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'delete from pedidos where ID_PEDIDO = :ID_PEDIDO';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('ID_PEDIDO').Value := FEntidade.ID_PEDIDO;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na exclus�o');
  end;
end;

function TPEDIDOS.Inserir: iPEDIDOS;
var sql : string;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'insert into pedidos (DATA, CLIENTE) values (:DATA, :CLIENTE)';
  try
    FQuery.SQL.Add(sql);
    FQuery.ParamByName('DATA').AsDate := FEntidade.DATA;
    FQuery.ParamByName('CLIENTE').Value := FEntidade.CLIENTE;
    FQuery.ExecSQL;
  except
    raise Exception.Create('Erro na inser��o');
  end;
end;

class function TPEDIDOS.New (aConnection : TFDConnection) : iPEDIDOS;
begin
  Result := Self.Create(aConnection);
end;

function TPEDIDOS.PEDIDO: TPEDIDO;
begin
  Result := FEntidade;
end;

function TPEDIDOS.Ultimo: Integer;
var sql : string;
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  sql := 'select MAX(ID_PEDIDO) from pedidos';
  try
    FQuery.Open(sql);
    Result := FQuery.Fieldbyname('MAX(ID_PEDIDO)').asInteger;
  except
    raise Exception.Create('Erro na busca de dados');
    Result := 0;
  end;
end;

end.