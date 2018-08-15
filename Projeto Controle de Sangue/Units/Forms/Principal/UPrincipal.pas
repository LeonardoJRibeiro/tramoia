unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, UClassActiveControl, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ExtCtrls,
  Vcl.Menus, acPNG, Vcl.ComCtrls;

type
  TFrmPrincipal = class(TForm)
    BtnEntrada: TSpeedButton;
    BtnSaida: TSpeedButton;
    BtnPacientes: TSpeedButton;
    BtnSair: TSpeedButton;
    MainMenu: TMainMenu;
    MenuItemPaciente: TMenuItem;
    MenuItemCadPaciente: TMenuItem;
    MenuItemCadHistorico: TMenuItem;
    MenuItemRelatorios: TMenuItem;
    MenuItemRelEntradas: TMenuItem;
    MenuItemRelSaida: TMenuItem;
    MenuItemUsuarios: TMenuItem;
    MenuItemCadastrarUsuario: TMenuItem;
    MenuItemConsultarUsuario: TMenuItem;
    BtnRelatorios: TSpeedButton;
    TimerLogin: TTimer;
    MenuItemLogoff: TMenuItem;
    MenuItemSobre: TMenuItem;
    Panel1: TPanel;
    MenuItemEntradas: TMenuItem;
    MenuItemCadEntrada: TMenuItem;
    MenuItemConsultarEntrada: TMenuItem;
    MenuItemSair: TMenuItem;
    MenuItemSaidas: TMenuItem;
    MenuItemCadastrarSaida: TMenuItem;
    MenuItemConsultarSaida: TMenuItem;
    StatusBar: TStatusBar;
    ImageUEG: TImage;
    MenuItemRelEstoque: TMenuItem;
    BtnConsultas: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPacientesClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure TimerLoginTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItemLogoffClick(Sender: TObject);
    procedure BtnSaidaClick(Sender: TObject);
    procedure BtnEntradaClick(Sender: TObject);
    procedure BtnRelatoriosClick(Sender: TObject);
    procedure MenuItemCadastrarUsuarioClick(Sender: TObject);
    procedure MenuItemCadPacienteClick(Sender: TObject);
    procedure MenuItemRelEntradasClick(Sender: TObject);
    procedure MenuItemRelSaidaClick(Sender: TObject);
    procedure MenuItemConsultarUsuarioClick(Sender: TObject);
    procedure MenuItemSobreClick(Sender: TObject);
    procedure MenuItemConsultarEntradaClick(Sender: TObject);
    procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemConsultarSaidaClick(Sender: TObject);
    procedure MenuItemCadEntradaClick(Sender: TObject);
    procedure MenuItemCadastrarSaidaClick(Sender: TObject);
    procedure MenuItemRelEstoqueClick(Sender: TObject);
  private
    FActiveControl: TActiveControl;
    FIdUsuario: Integer;

    function getAdmin: Boolean;

  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses UEntrada, USaida, UConsPaciente, UClassForeignKeyForms, ULogin, USelRelatorio, UCadUsuario, UCadPaciente,
  URelEntrada, URelSaida, UConsUsuario, UClassUsuarioDao, UDMConexao, UClassMensagem, USobre, UConsEntrada, UConsSaidas,
  UClassBibliotecaDao, URelEstoque;

procedure TFrmPrincipal.BtnEntradaClick(Sender: TObject);
begin

  TFrmEntrada.getEntrada(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.BtnPacientesClick(Sender: TObject);
var
  lRegistro: string;
begin

  TFrmConsPaciente.getConsPaciente(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario, lRegistro);

end;

procedure TFrmPrincipal.BtnRelatoriosClick(Sender: TObject);
begin

  TFrmSelRelatorio.getSelRelatorio(TForeignKeyForms.FIdUSelRelatorio, Self.FIdUsuario);

end;

procedure TFrmPrincipal.BtnSaidaClick(Sender: TObject);
begin

  TFrmSaida.getSaida(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrincipal.MenuItemCadPacienteClick(Sender: TObject);
begin

  TFrmCadPaciente.getCadPaciente(TForeignKeyForms.FIdUConsPaciente, Self.FIdUsuario);

end;

procedure TFrmPrincipal.MenuItemCadastrarSaidaClick(Sender: TObject);
begin
  TFrmSaida.getSaida(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemCadastrarUsuarioClick(Sender: TObject);
begin
  if (Self.getAdmin) then
  begin
    TFrmCadUsuario.getCadUsuario(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
  end
  else
  begin
    Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TFrmPrincipal.MenuItemCadEntradaClick(Sender: TObject);
begin
  TFrmEntrada.getEntrada(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemConsultarEntradaClick(Sender: TObject);
begin
  TFrmConsEntrada.getConsEntrada(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemConsultarSaidaClick(Sender: TObject);
begin
  TFrmConsSaidas.getConsSaida(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemConsultarUsuarioClick(Sender: TObject);
begin
  if (Self.getAdmin) then
  begin
    TFrmConsUsuario.getConsUsuario(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
  end
  else
  begin
    Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
  end;

end;

procedure TFrmPrincipal.MenuItemRelEntradasClick(Sender: TObject);
begin
  TFrmRelEntrada.getRelEntrada(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemRelEstoqueClick(Sender: TObject);
begin
  TFrmRelEstoque.getRelEstoque(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin

  Self.FActiveControl := TActiveControl.Create;

  Application.OnMessage := Self.FActiveControl.OnMessage;

end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin

  Self.FActiveControl.Destroy;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  TimerLogin.Enabled := True;
end;

function TFrmPrincipal.getAdmin: Boolean;
var
  lUsuaioDao: TUsuarioDAO;
begin

  lUsuaioDao := TUsuarioDAO.Create(DataModuleConexao.Conexao);
  try

    try
      Result := lUsuaioDao.getAdmin(Self.FIdUsuario);
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(12), ['inforção do usuário', E.Message])),
          PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuaioDao.Destroy;
  end;

end;

procedure TFrmPrincipal.MenuItemLogoffClick(Sender: TObject);
begin
  TimerLogin.Enabled := True;
end;

procedure TFrmPrincipal.MenuItemSobreClick(Sender: TObject);
begin

  TFrmSobre.getSobre(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.MenuItemRelSaidaClick(Sender: TObject);
begin

  TFrmRelSaida.getRelSaida(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.MenuItemSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrincipal.TimerLoginTimer(Sender: TObject);
begin

  TimerLogin.Enabled := False;

  if (TFrmLogin.getLogin(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario)) then
  begin
    StatusBar.Panels.Items[1].Text := TClassBibliotecaDao.getNomeUsuario(Self.FIdUsuario, DataModuleConexao.Conexao);
    StatusBar.Panels.Items[3].Text := DateToStr(now);
  end
  else
  begin
    Close;
  end;

end;

end.
