unit Controller.Itens_Pedidos.Interfaces;

interface

uses
  Data.DB, Entidades.Itens_Pedidos;

type
  iITENS_PEDIDOS = interface
  ['{CACDFCB1-0CE3-42C0-85C9-518BF57E60D6}']
    function Inserir : iITENS_PEDIDOS;
    function Atualizar : iITENS_PEDIDOS;
    function Excluir : iITENS_PEDIDOS;
    function Datasource(aDatasource : TDatasource) : iITENS_PEDIDOS;
    function Dataset : TDataSet;
    function Buscar(codigo : integer) : iITENS_PEDIDOS;
    function Listar(pedido : integer) : iITENS_PEDIDOS;
    function ITEM : TITEM_PEDIDO;
  end;

implementation

end.

