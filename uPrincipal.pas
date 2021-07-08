unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Controller.Clientes, Controller.Clientes.Interfaces,
  Controller.Produtos.Interfaces, Controller.Produtos,
  Controller.Itens_Pedidos.Interfaces, Controller.Pedidos.Interfaces, Controller.Itens_Pedidos, Controller.Pedidos;

type
  TfrmPedidos = class(TForm)
    DBGrid1: TDBGrid;
    dtsItens: TDataSource;
    edtPedido: TLabeledEdit;
    Panel2: TPanel;
    panelTopo: TPanel;
    pnlPedidos: TPanel;
    pnlItens: TPanel;
    dtsClientes: TDataSource;
    dtData: TDateTimePicker;
    Label2: TLabel;
    pnlProdutos: TPanel;
    edtProduto: TLabeledEdit;
    edtQuantidade: TLabeledEdit;
    edtUnitario: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    dtsProdutos: TDataSource;
    edtTotal: TLabeledEdit;
    FDMTItens: TFDMemTable;
    FDMTItensITEM: TIntegerField;
    FDMTItensPRODUTO: TIntegerField;
    FDMTItensDESCRICAO: TStringField;
    FDMTItensQUANTIDADE: TFloatField;
    FDMTItensUNITARIO: TFloatField;
    FDMTItensTOTAL: TFloatField;
    FDMTItensID_ITEM: TIntegerField;
    pnlBotoes: TPanel;
    btnInserirItem: TButton;
    Button1: TButton;
    Panel1: TPanel;
    edtTotalPedido: TLabeledEdit;
    btnGravarPedido: TButton;
    edtCliente: TLabeledEdit;
    edtNome: TLabeledEdit;
    btnBuscarPedido: TButton;
    btnExcluirPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure edtProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure btnInserirItemClick(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure edtClienteKeyPress(Sender: TObject; var Key: Char);
    procedure btnBuscarPedidoClick(Sender: TObject);
    procedure btnExcluirPedidoClick(Sender: TObject);
    procedure edtClienteChange(Sender: TObject);
    procedure panelTopoDblClick(Sender: TObject);
    procedure edtPedidoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure CadastroTestes;
    procedure InserirItem(item, produto, id_item :integer; descricao : string; qtd, unitario, total : Real);
    procedure EditarItem;
    procedure ExcluirItem;
    procedure CalculaTotal;

    procedure GravarPedido;
  public
    { Public declarations }
  end;

var
  frmPedidos: TfrmPedidos;
  FCLIENTES : iCLIENTES;
  FPRODUTOS : iPRODUTOS;
  FPEDIDOS : iPEDIDOS;
  FITENS : iITENS_PEDIDOS;
  sequencial : Integer;
  editando : Boolean;

implementation

uses
  uDMDados;

{$R *.dfm}

procedure TfrmPedidos.FormCreate(Sender: TObject);
begin
  FCLIENTES := TCLIENTES.New(dmDados.FDConnection1).Datasource(dtsClientes);
  FPRODUTOS := TPRODUTOS.New(dmDados.FDConnection1).Datasource(dtsProdutos);
  FPEDIDOS := TPEDIDOS.New(dmDados.FDConnection1);
  FITENS := TITENS_PEDIDOS.New(dmDados.FDConnection1);
  FDMTItens.Open;
  sequencial := 0;
  editando := False;
end;

procedure TfrmPedidos.GravarPedido;
begin
  dmDados.FDConnection1.StartTransaction;
  try
    if FPEDIDOS.PEDIDO.ID_PEDIDO <= 0 then
    begin
      FPEDIDOS.PEDIDO.DATA := dtData.Date;
      FPEDIDOS.PEDIDO.CLIENTE := FCLIENTES.CLIENTE.CODIGO;
      FPEDIDOS.Inserir;
      FPEDIDOS.PEDIDO.ID_PEDIDO := FPEDIDOS.Ultimo;
    end;

    FDMTItens.First;
    while not FDMTItens.Eof do
    begin
      FITENS.ITEM.PEDIDO := FPEDIDOS.PEDIDO.ID_PEDIDO;
      FITENS.ITEM.PRODUTO := FDMTItensPRODUTO.Value;
      FITENS.ITEM.QUANTIDADE := FDMTItensQUANTIDADE.Value;
      FITENS.ITEM.UNITARIO := FDMTItensUNITARIO.Value;
      FITENS.ITEM.TOTAL := FDMTItensTOTAL.Value;
      FITENS.ITEM.ID_ITEM := FDMTItensID_ITEM.Value;
      if FDMTItensID_ITEM.Value > 0 then
        FITENS.Atualizar
      else
        FITENS.Inserir;
      FDMTItens.Next;
    end;

    dmDados.FDConnection1.Commit;

    ShowMessage('Pedido gravado com sucesso sob número: '+FPEDIDOS.PEDIDO.ID_PEDIDO.ToString);
    FPEDIDOS.PEDIDO.ID_PEDIDO := 0;
    edtPedido.Text := '';
    edtCliente.Text := '';
    edtNome.Text := '';

    FDMTItens.Close;
    FDMTItens.Open;
  except on e:Exception do
  begin
    ShowMessage(e.Message);
    dmDados.FDConnection1.Rollback;
  end;
  end;
end;

procedure TfrmPedidos.InserirItem(item, produto, id_item :integer; descricao : string; qtd, unitario, total : Real);
begin
  FDMTItens.Append;
  FDMTItensID_ITEM.Value := id_item;
  FDMTItensITEM.Value := item;
  FDMTItensPRODUTO.Value := produto;
  FDMTItensDESCRICAO.Value := descricao;
  FDMTItensQUANTIDADE.Value := qtd;
  FDMTItensUNITARIO.Value := unitario;
  FDMTItensTOTAL.Value := total;
  FDMTItens.Post;
end;

procedure TfrmPedidos.panelTopoDblClick(Sender: TObject);
begin
  CadastroTestes;
end;

procedure TfrmPedidos.btnBuscarPedidoClick(Sender: TObject);
begin
  if edtPedido.Text <> '' then
  begin
    FPEDIDOS.Buscar(StrToInt(edtPedido.Text));
    FCLIENTES.Buscar(FPEDIDOS.PEDIDO.CLIENTE);
    FITENS.Listar(FPEDIDOS.PEDIDO.ID_PEDIDO);

    edtCliente.Text := FPEDIDOS.PEDIDO.CLIENTE.ToString;
    edtNome.Text := FCLIENTES.CLIENTE.NOME;
    dtData.Date := FPEDIDOS.PEDIDO.DATA;
    FDMTItens.Close;
    FDMTItens.Open;
//    FDMTItens.CloneCursor(TFDDataset(FITENS.DataSet), True, True);

    while not FITENS.Dataset.Eof do
    begin
      FPRODUTOS.Buscar(FITENS.Dataset.FieldByName('PRODUTO').AsInteger);
      InserirItem(sequencial + 1,
                  FITENS.Dataset.FieldByName('PRODUTO').AsInteger,
                  FITENS.Dataset.FieldByName('ID_ITEM').AsInteger,
                  FPRODUTOS.PRODUTO.DESCRICAO,
                  FITENS.Dataset.FieldByName('QUANTIDADE').AsFloat,
                  FITENS.Dataset.FieldByName('UNITARIO').AsFloat,
                  FITENS.Dataset.FieldByName('TOTAL').AsFloat
                  );
      FITENS.Dataset.Next;
      sequencial := sequencial + 1;
    end;
    CalculaTotal;
  end
  else
  begin
    ShowMessage('Informe um pedido');
    edtPedido.SetFocus;
  end;
end;

procedure TfrmPedidos.btnExcluirPedidoClick(Sender: TObject);
begin
  if edtPedido.Text <> '' then
  begin
    if MessageDlg('Confirma a exclusão do pedido?',mtConfirmation,[mbyes,mbno],0) = mryes then
    begin
      FPEDIDOS.PEDIDO.ID_PEDIDO := StrToInt(edtPedido.Text);
      FPEDIDOS.Excluir;
    end;
  end
  else
  begin
    ShowMessage('Informe um pedido');
    edtPedido.SetFocus;
  end;
end;

procedure TfrmPedidos.btnGravarPedidoClick(Sender: TObject);
begin
  GravarPedido;
end;

procedure TfrmPedidos.btnInserirItemClick(Sender: TObject);
begin
  if editando = false then
  begin
    if FPRODUTOS.PRODUTO.CODIGO > 0 then
    begin
      try
        FITENS.ITEM.PRODUTO := FPRODUTOS.PRODUTO.CODIGO;
        FITENS.ITEM.QUANTIDADE := StrToFloat(edtQuantidade.Text);
        FITENS.ITEM.UNITARIO := StrToFloat(edtUnitario.Text);
        FITENS.ITEM.TOTAL := FITENS.ITEM.QUANTIDADE * FITENS.ITEM.UNITARIO;

        InserirItem(sequencial + 1,
                    FPRODUTOS.PRODUTO.CODIGO,
                    0, //id no servidor
                    FPRODUTOS.PRODUTO.DESCRICAO,
                    FITENS.ITEM.QUANTIDADE,
                    FITENS.ITEM.UNITARIO,
                    FITENS.ITEM.TOTAL
                    );

        sequencial := sequencial + 1;
        CalculaTotal;
        ShowMessage('Produto inserido com sucesso');
        edtProduto.Text := '';
        edtDescricao.Text := '';
        edtQuantidade.Text := '';
        edtProduto.SetFocus;
      except
        ShowMessage('Informe corretamente a quantidade e o valor unitário do produto');
        Abort;
      end;
    end
    else
      ShowMessage('Informe corretametne o produto');
  end
  else
    EditarItem;
end;

procedure TfrmPedidos.Button1Click(Sender: TObject);
begin
  ExcluirItem;
end;

procedure TfrmPedidos.CadastroTestes;
var aux : Integer;
begin
  aux := 1;
  while aux < 20 do
  begin
    FPRODUTOS.PRODUTO.DESCRICAO := 'PRODUTO ' + IntToStr(aux);
    FPRODUTOS.PRODUTO.PRECO_VENDA := aux * 10;
    FPRODUTOS.Inserir;

    FCLIENTES.CLIENTE.NOME := 'CLIENTE ' + IntToStr(aux);
    FCLIENTES.CLIENTE.CIDADE := 'COQUEIROS DO SUL';
    FCLIENTES.CLIENTE.UF := 'RS';
    FCLIENTES.Inserir;

    aux := aux + 1;
  end;

end;

procedure TfrmPedidos.CalculaTotal;
var total : Real;
begin
  try
    total := 0;
    FDMTItens.First;
    while not FDMTItens.Eof do
    begin
      total := total + FDMTItensTOTAL.Value;
      FDMTItens.Next;
    end;
    edtTotalPedido.Text := FloatToStr(total);
  except
    edtTotalPedido.Text := '0';
  end;
end;

procedure TfrmPedidos.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_DELETE then
  begin
    ExcluirItem;
  end;
end;

procedure TfrmPedidos.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    editando := True;
    edtProduto.Text := FDMTItensPRODUTO.Text;
    edtDescricao.Text := FDMTItensDESCRICAO.Text;
    edtQuantidade.Text := FDMTItensQUANTIDADE.Text;
    edtUnitario.Text := FDMTItensUNITARIO.Text;
    edtQuantidade.SetFocus;
  end;
end;

procedure TfrmPedidos.EditarItem;
begin
  try
    FDMTItens.Edit;
    FITENS.ITEM.QUANTIDADE := StrToFloat(edtQuantidade.Text);
    FITENS.ITEM.UNITARIO := StrToFloat(edtUnitario.Text);
    FITENS.ITEM.TOTAL := FITENS.ITEM.QUANTIDADE * FITENS.ITEM.UNITARIO;

    FDMTItensQUANTIDADE.Value := FITENS.ITEM.QUANTIDADE;
    FDMTItensUNITARIO.Value := FITENS.ITEM.UNITARIO;
    FDMTItensTOTAL.Value := FITENS.ITEM.TOTAL;
    FDMTItens.Post;
    editando := False;
    CalculaTotal;

    ShowMessage('Produto alterado com sucesso');
    edtProduto.Text := '';
    edtDescricao.Text := '';
    edtQuantidade.Text := '';
    edtProduto.SetFocus;
  except
    ShowMessage('Informe corretamente a quantidade e o valor unitário do produto');
    Abort;
  end;
end;

procedure TfrmPedidos.edtClienteChange(Sender: TObject);
begin
  if edtCliente.Text = '' then
  begin
    btnBuscarPedido.Visible := True;
    btnExcluirPedido.Visible := True;
  end
  else
  begin
    btnBuscarPedido.Visible := False;
    btnExcluirPedido.Visible := False;
  end;
end;

procedure TfrmPedidos.edtClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (edtCliente.Text <> '') then
  begin
    FCLIENTES.Buscar(strtoint(edtCliente.Text));
    edtNome.Text := FCLIENTES.CLIENTE.NOME;
    dtData.SetFocus;
  end;
end;

procedure TfrmPedidos.edtPedidoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btnBuscarPedido.Click;
end;

procedure TfrmPedidos.edtProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and (edtProduto.Text <> '') then
  begin
    FPRODUTOS.Buscar(strtoint(edtProduto.Text));
    edtDescricao.Text := FPRODUTOS.PRODUTO.DESCRICAO;
    edtUnitario.Text := FloatToStr(FPRODUTOS.PRODUTO.PRECO_VENDA);

    edtQuantidade.SetFocus;
  end;
end;

procedure TfrmPedidos.edtQuantidadeChange(Sender: TObject);
var total : Real;
begin
  try
    total := StrToFloat(edtQuantidade.Text) * StrToFloat(edtUnitario.Text);
    edtTotal.Text := FloatToStr(total);
  except
  end;
end;

procedure TfrmPedidos.edtQuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btnInserirItem.Click;
end;

procedure TfrmPedidos.ExcluirItem;
begin
  if MessageDlg('Confirma a exclusão do registro?',mtConfirmation,[mbyes,mbno],0) = mryes then
  begin
    FDMTItens.Delete;
    CalculaTotal;
  end;
end;

initialization
ReportMemoryLeaksOnShutdown := True;

end.
