unit Entidades.Produtos;

interface

uses
  System.SysUtils;

type
  TPRODUTO = class
    private
    FCODIGO: Integer;
    FDESCRICAO: string;
    FPRECO_VENDA: Real;
    public
      constructor Create;
      destructor Destroy; override;
    published
    property CODIGO: Integer read FCODIGO write FCODIGO;
    property DESCRICAO: string read FDESCRICAO write FDESCRICAO;
    property PRECO_VENDA: Real read FPRECO_VENDA write FPRECO_VENDA;

    function Validar : Boolean;
  end;
implementation

{ TPRODUTO }

constructor TPRODUTO.Create;
begin

end;

destructor TPRODUTO.Destroy;
begin

  inherited;
end;

function TPRODUTO.Validar: Boolean;
begin
  Result := False;
  if FDESCRICAO = '' then
    raise Exception.Create('Informe a descri��o do produto');
  if FPRECO_VENDA <= 0 then
    raise Exception.Create('Informe o pre�o de venda');


  Result := True;
end;

end.
