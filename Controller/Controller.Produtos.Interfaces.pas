unit Controller.Produtos.Interfaces;

interface

uses
  Data.DB, Entidades.Produtos;

type
  iPRODUTOS = interface
    ['{65AC4BE7-B36D-437C-A32C-54FA7EC41A33}']
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

end.

