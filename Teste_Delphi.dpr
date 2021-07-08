program Teste_Delphi;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPedidos},
  uDMDados in 'uDMDados.pas' {dmDados: TDataModule},
  Controller.Clientes in 'Controller\Controller.Clientes.pas',
  Controller.Clientes.Interfaces in 'Controller\Controller.Clientes.Interfaces.pas',
  Entidades.Clientes in 'Entidades\Entidades.Clientes.pas',
  Entidades.Produtos in 'Entidades\Entidades.Produtos.pas',
  Controller.Produtos.Interfaces in 'Controller\Controller.Produtos.Interfaces.pas',
  Controller.Produtos in 'Controller\Controller.Produtos.pas',
  Entidades.Pedidos in 'Entidades\Entidades.Pedidos.pas',
  Entidades.Itens_Pedidos in 'Entidades\Entidades.Itens_Pedidos.pas',
  Controller.Pedidos.Interfaces in 'Controller\Controller.Pedidos.Interfaces.pas',
  Controller.Itens_Pedidos.Interfaces in 'Controller\Controller.Itens_Pedidos.Interfaces.pas',
  Controller.Pedidos in 'Controller\Controller.Pedidos.pas',
  Controller.Itens_Pedidos in 'Controller\Controller.Itens_Pedidos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TfrmPedidos, frmPedidos);
  Application.Run;
end.
