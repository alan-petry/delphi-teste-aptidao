unit Controller.Pedidos.Interfaces;

interface

uses
  Data.DB, Entidades.Pedidos;

type
  iPEDIDOS = interface
    ['{766F2953-C2D3-4A0D-8ED1-5DD66FC5588C}']
    function Inserir : iPEDIDOS;
    function Atualizar : iPEDIDOS;
    function Excluir : iPEDIDOS;
    function Ultimo : Integer;
    function Datasource(aDatasource : TDatasource) : iPEDIDOS;
    function Buscar(pedido: integer): iPEDIDOS;
    function PEDIDO : TPEDIDO;
  end;

implementation

end.

