unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Mask,
  acPNG;

type
  TFrmLogin = class(TForm)
    Image: TImage;
    EdtNome: TEdit;
    EdtSenha: TMaskEdit;
    LabelNovoUsuario: TLabel;
    ImagemLogin: TImage;
    ImagemSair: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LabelNovoUsuarioClick(Sender: TObject);
    procedure LabelNovoUsuarioMouseEnter(Sender: TObject);
    procedure LabelNovoUsuarioMouseLeave(Sender: TObject);
    procedure ImagemLoginClick(Sender: TObject);
    procedure ImagemSairClick(Sender: TObject);
  private
    FIdUsuario: Integer;
    FNumTentativas: Integer;

    function getExisteUsuariosCadastrados: Boolean;
  public
    class function getLogin(const pIDFORMULARIO: SmallInt; var pId_Usuario: Integer): Boolean;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses UDMConexao, UClassUsuarioDao, UClassBiblioteca, UClassMensagem, UCadUsuario, UClassForeignKeyForms;

procedure TFrmLogin.EdtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_RETURN) then
  begin
    ImagemLoginClick(Sender);
  end;

end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if (not Trim(EdtNome.Text).IsEmpty) then
  begin
    TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'USUARIO', 'nome usuario', Trim(EdtNome.Text));
  end;

end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  case (Key) of
    VK_ESCAPE:
      begin
        Close;
      end;
  end;

end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  Self.FNumTentativas := 0;
  EdtNome.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'USUARIO', 'nome usuario', '');
  LabelNovoUsuario.Visible := not Self.getExisteUsuariosCadastrados;
  EdtNome.Top:= 265;
end;

function TFrmLogin.getExisteUsuariosCadastrados: Boolean;
var
  lUsuarioDAO: TUsuarioDAO;
begin

  lUsuarioDAO := TUsuarioDAO.Create(DMConexao.Conexao);
  try

    try
      Result := lUsuarioDAO.getExisteUsuariosCadastrados;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['informações dos usuários', E.Message])),
          PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    FreeAndNil(lUsuarioDAO)
  end;

end;

class function TFrmLogin.getLogin(const pIDFORMULARIO: SmallInt; var pId_Usuario: Integer): Boolean;
begin

  Application.CreateForm(TFrmLogin, FrmLogin);
  try

    try

      Result := FrmLogin.ShowModal = mrOk;
      if (Result) then
      begin
        pId_Usuario := FrmLogin.FIdUsuario;
      end;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), ['de login', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    FreeAndNil(FrmLogin);
  end;

end;

procedure TFrmLogin.ImagemLoginClick(Sender: TObject);
var
  lUsuarioDAO: TUsuarioDAO;
  lId: Integer;
begin

  lUsuarioDAO := TUsuarioDAO.Create(DMConexao.Conexao);
  try

    try

      if (lUsuarioDAO.getLogin(Trim(EdtNome.Text), Trim(EdtSenha.Text), lId)) then
      begin

        Self.FIdUsuario := lId;
        ModalResult := mrOk;

      end
      else
      begin

        Self.FNumTentativas := Self.FNumTentativas + 1;

        Application.MessageBox(PChar(TMensagem.getMensagem(13)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);

        if (Self.FNumTentativas = 3) then
        begin
          Application.Terminate;
        end;

        EdtNome.SetFocus;

      end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(TMensagem.getMensagem(14)), PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuarioDAO.Destroy;
  end;

end;

procedure TFrmLogin.ImagemSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogin.LabelNovoUsuarioClick(Sender: TObject);
begin
  TFrmCadUsuario.getCadUsuario(TForeignKeyForms.FIdULogin, -1);
end;

procedure TFrmLogin.LabelNovoUsuarioMouseEnter(Sender: TObject);
begin
  LabelNovoUsuario.Font.Size := 13;
end;

procedure TFrmLogin.LabelNovoUsuarioMouseLeave(Sender: TObject);
begin
  LabelNovoUsuario.Font.Size := 11;
end;

end.
