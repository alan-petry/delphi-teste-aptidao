unit Entidades.Clientes;

interface

uses
  System.Generics.Collections, System.Classes, Rest.Json, System.JSON, System.SysUtils;

type
  TCLIENTE = class
    private
    FCODIGO: Integer;
    FNOME: string;
    FCIDADE: string;
    FUF: string;
    public
      constructor Create;
      destructor Destroy; override;

    published
      property CODIGO: Integer read FCODIGO write FCODIGO;
      property NOME: string read FNOME write FNOME;
      property CIDADE: string read FCIDADE write FCIDADE;
      property UF: string read FUF write FUF;

    function Validar : Boolean;

  end;
implementation

{ TCLIENTE }

constructor TCLIENTE.Create;
begin

end;

destructor TCLIENTE.Destroy;
begin

  inherited;
end;

function TCLIENTE.Validar: Boolean;
begin
  Result := False;
  if FNOME = '' then
    raise Exception.Create('Informe corretamente o nome do cliente');
  if FCIDADE = '' then
    raise Exception.Create('Informe corretamente a cidade do cliente');
  if FUF = '' then
    raise Exception.Create('Informe corretamente a UF do cliente');

  Result := True;
end;

end.
