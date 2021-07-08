unit Entidades.Itens_Pedidos;

interface

uses
  System.SysUtils;

type
  TITEM_PEDIDO = class
    private
    FID_ITEM: Integer;
    FPEDIDO: Integer;
    FPRODUTO: Integer;
    FQUANTIDADE: Real;
    FUNITARIO: Real;
    FTOTAL: Real;
    public
      constructor Create;
      destructor Destroy; override;
    published
      property ID_ITEM: Integer read FID_ITEM write FID_ITEM;
      property PEDIDO: Integer read FPEDIDO write FPEDIDO;
      property PRODUTO: Integer read FPRODUTO write FPRODUTO;
      property QUANTIDADE: Real read FQUANTIDADE write FQUANTIDADE;
      property UNITARIO: Real read FUNITARIO write FUNITARIO;
      property TOTAL: Real read FTOTAL write FTOTAL;

      function Validar : Boolean;
  end;
implementation

{ TITEM_PEDIDO }

constructor TITEM_PEDIDO.Create;
begin

end;

destructor TITEM_PEDIDO.Destroy;
begin

  inherited;
end;

function TITEM_PEDIDO.Validar: Boolean;
begin
  Result := False;
  if FPRODUTO <= 0 then
    raise Exception.Create('Informe o produto');
  if FQUANTIDADE <= 0 then
    raise Exception.Create('Informe corretamente a quantidade');
  if FUNITARIO <= 0 then
    raise Exception.Create('Informe o valor unitário');

  Result := True;
end;

end.
