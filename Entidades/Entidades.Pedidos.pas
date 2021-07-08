unit Entidades.Pedidos;

interface

uses
  System.sysutils;

type
  TPEDIDO = class
    private
    FID_PEDIDO: Integer;
    FDATA: TDate;
    FTOTAL: Real;
    FCLIENTE: Integer;
    public
      constructor Create;
      destructor Destroy; override;
    published
      property ID_PEDIDO: Integer read FID_PEDIDO write FID_PEDIDO;
      property DATA: TDate read FDATA write FDATA;
      property TOTAL: Real read FTOTAL write FTOTAL;
      property CLIENTE: Integer read FCLIENTE write FCLIENTE;

      function Validar : Boolean;
  end;
implementation

{ TPEDIDO }

constructor TPEDIDO.Create;
begin

end;

destructor TPEDIDO.Destroy;
begin

  inherited;
end;

function TPEDIDO.Validar: Boolean;
begin
  Result := False;
  if FCLIENTE <= 0 then
    raise Exception.Create('Informe o cliente.');

  Result := True;
end;

end.
