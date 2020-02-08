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
    BtnConsultas: TSpeedButton;
    MenuItemRelEstoque: TMenuItem;
    MenuItemBackup: TMenuItem;
    MenuItemGerarBackup: TMenuItem;
    MenuItemConsPaciente: TMenuItem;
    BtnRetiradas: TSpeedButton;
    Descarte1: TMenuItem;
    Cadastro1: TMenuItem;
    Consultar1: TMenuItem;
    Descarte2: TMenuItem;
    SpeedButton1: TSpeedButton;
    Devolues1: TMenuItem;
    Cadastrar1: TMenuItem;
    Consultar2: TMenuItem;
    MenuItemDevolucao: TMenuItem;
    MenuItemConfiguracoes: TMenuItem;
    MenuItemSuporte: TMenuItem;
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
    procedure BtnConsultasClick(Sender: TObject);
    procedure MenuItemRelEstoqueClick(Sender: TObject);
    procedure MenuItemGerarBackupClick(Sender: TObject);
    procedure MenuItemConsPacienteClick(Sender: TObject);
    procedure Cadastro1Click(Sender: TObject);
    procedure Consultar1Click(Sender: TObject);
    procedure Descarte2Click(Sender: TObject);
    procedure BtnRetiradasClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Cadastrar1Click(Sender: TObject);
    procedure Consultar2Click(Sender: TObject);
    procedure MenuItemDevolucaoClick(Sender: TObject);
    procedure MenuItemConfiguracoesClick(Sender: TObject);
    procedure MenuItemSuporteClick(Sender: TObject);
  private
    FActiveControl: TActiveControl;
    FIdUsuario: Integer;

    function getAdmin: Boolean;

    function getQuantDiasAvisoVencimento: Integer;

    procedure RealizaAtualizacoes;

  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses ShellAPI, UEntrada, USaida, UConsPaciente, UClassForeignKeyForms, ULogin, USelRelatorio, UCadUsuario, UCadPaciente,
  URelEntrada, URelSaida, UConsUsuario, UClassUsuarioDao, UDMConexao, UClassMensagem, USobre, UConsEntrada, UConsSaidas,
  USelCons, URelEstoque, UClassBiblioteca, UClassBibliotecaDao, UClassGeraBackup, UDescarte, UConsDescarte,
  URelDescarte, UDevolucao, UConsDevolucao, URelDevolucao, UAvisoVencimento, UConfiguracoes, UClassConfiguracaoDao,
  UClassAtualizaBase;

procedure TFrmPrincipal.BtnConsultasClick(Sender: TObject);
begin

  TFrmSelCons.getSelCons(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

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

procedure TFrmPrincipal.BtnRetiradasClick(Sender: TObject);
begin
  TFrmDescarte.getDescarte(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.BtnSaidaClick(Sender: TObject);
begin

  TFrmSaida.getSaida(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.BtnSairClick(Sender: TObject);
begin

  if (Application.MessageBox(PChar('Deseja realizar o backup do banco?'), 'Saindo do sistema',
    MB_YESNO + MB_ICONQUESTION) = 6) then
  begin

    MenuItemGerarBackupClick(Sender);

  end;

  Close;

end;

procedure TFrmPrincipal.Cadastrar1Click(Sender: TObject);
begin
  TFrmDevolucao.getDevolucao(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.Cadastro1Click(Sender: TObject);
begin
  TFrmDescarte.getDescarte(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.Consultar1Click(Sender: TObject);
begin
  TFrmConsDescarte.getConsDescarte(TForeignKeyForms.FIdUConsPaciente, Self.FIdUsuario);
end;

procedure TFrmPrincipal.Consultar2Click(Sender: TObject);
begin
  TFrmConsDevolucao.getConsDevolucao(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.Descarte2Click(Sender: TObject);
begin
  TFrmRelDescarte.getRelDescarte(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
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
    TFrmCadUsuario.getCadUsuario(TForeignKeyForms.FIdUPrincipal);
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

procedure TFrmPrincipal.MenuItemConfiguracoesClick(Sender: TObject);
begin
  TFrmConfiguracoes.getConfiguracoes(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemConsPacienteClick(Sender: TObject);
var
  lNumProntuario: string;
begin
  TFrmConsPaciente.getConsPaciente(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario, lNumProntuario);
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

procedure TFrmPrincipal.MenuItemDevolucaoClick(Sender: TObject);
begin
  TFrmRelDevolucao.getRelDevolucao(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.MenuItemGerarBackupClick(Sender: TObject);
var
  lGeraBackup: TGeraBackup;
begin

  lGeraBackup := TGeraBackup.Create;
  try

    try

      if (lGeraBackup.CriaBackup(Application.MessageBox
        (PChar('Deseja subir o backup para o Google Drive?(Recomendado)'), 'Saindo do sistema',
        MB_YESNO + MB_ICONQUESTION) = 6)) then
      begin

        Application.MessageBox(PChar('Backup criado em ' + ExtractFilePath(Application.ExeName) + '\Backup\' +
          ' com sucesso'), 'Sucesso', MB_OK + MB_ICONINFORMATION)

      end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format('Erro ao gerar backup. Motivo : %S', [E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lGeraBackup.Destroy;
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

  Self.RealizaAtualizacoes;

  TimerLogin.Enabled := True;

end;

function TFrmPrincipal.getAdmin: Boolean;
var
  lUsuaioDao: TUsuarioDAO;
begin

  lUsuaioDao := TUsuarioDAO.Create(DMConexao.Conexao);
  try

    try
      Result := lUsuaioDao.getAdmin(Self.FIdUsuario);
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['informação do usuário', E.Message])),
          PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuaioDao.Destroy;
  end;

end;

function TFrmPrincipal.getQuantDiasAvisoVencimento: Integer;
var
  lConfiguracoesDao: TConfiguracaoDAO;
begin

  lConfiguracoesDao := TConfiguracaoDAO.Create(DMConexao.Conexao);
  try

    try

      Result := lConfiguracoesDao.getQuantDiasAvisoVencimento;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['configurações', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lConfiguracoesDao.Destroy;
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

procedure TFrmPrincipal.MenuItemSuporteClick(Sender: TObject);
var
  lCaminhoExe: string;
  lCaminhoAmmy: string;
begin

  try

    lCaminhoExe := ExtractFilePath(Application.ExeName);

    lCaminhoAmmy := Copy(lCaminhoExe, 1, Pos('\exe\', lCaminhoExe) - 1) + '\Ammy.exe';

    TBiblioteca.ExecutaPrograma(lCaminhoAmmy);

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), PChar('Erro'), MB_OK + MB_ICONERROR);
    end;
  end;

end;

procedure TFrmPrincipal.RealizaAtualizacoes;
var
  lAtualizaBase: TAtualizacaoBase;
begin

  lAtualizaBase := TAtualizacaoBase.Create(DMConexao.Conexao);
  try

    try

      lAtualizaBase.AtualizaBaseDados;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['configurações', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lAtualizaBase.Destroy;
  end;

end;

procedure TFrmPrincipal.SpeedButton1Click(Sender: TObject);
begin

  TFrmDevolucao.getDevolucao(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.MenuItemRelSaidaClick(Sender: TObject);
begin

  TFrmRelSaida.getRelSaida(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.MenuItemSairClick(Sender: TObject);
begin

  BtnSairClick(Sender);

end;

procedure TFrmPrincipal.TimerLoginTimer(Sender: TObject);
var
  lQuantDiasAvisoVencimento: Integer;
begin

  TimerLogin.Enabled := False;

  if (TFrmLogin.getLogin(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario)) then
  begin
    StatusBar.Panels.Items[1].Text := TClassBibliotecaDao.getNomeUsuario(Self.FIdUsuario, DMConexao.Conexao);
    StatusBar.Panels.Items[3].Text := DateToStr(now);
    StatusBar.Panels.Items[5].Text := TBiblioteca.getVersaoExe;

    lQuantDiasAvisoVencimento := Self.getQuantDiasAvisoVencimento;

    if (lQuantDiasAvisoVencimento > 0) then
    begin
      TFrmAvisoSistema.getAvisoVencimento(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario, lQuantDiasAvisoVencimento);
    end;

  end
  else
  begin
    Close;
  end;

end;

end.
