unit UCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmCadUsuario = class(TForm)
    PanelBotoes: TPanel;
    Panel1: TPanel;
    EdtNome: TLabeledEdit;
    EdtSenha: TMaskEdit;
    Label1: TLabel;
    CheckBoxAdministrador: TCheckBox;
    BtnGravar: TBitBtn;
    BtnNovo: TBitBtn;
    BtnSair: TBitBtn;
    procedure BtnSairClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FNomeUsuario: string;

    procedure CarregaUsuario;

  public
    class function getCadUsuario(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer = -1): Boolean;
  end;

var
  FrmCadUsuario: TFrmCadUsuario;

implementation

uses
  UClassUsuario, UClassUsuarioDao, UDMConexao, UBiblioteca, System.StrUtils, UClassMensagem;

{$R *.dfm}
{ TFrmCadUsuario }

procedure TFrmCadUsuario.BtnNovoClick(Sender: TObject);
begin

  Self.FIdUsuario := -1;
  Self.FNomeUsuario := '';
  EdtNome.Clear;
  EdtSenha.Clear;
  CheckBoxAdministrador.Checked := False;

end;

procedure TFrmCadUsuario.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadUsuario.BtnGravarClick(Sender: TObject);
var
  lUsuario: TUsuario;
  lUsuarioDao: TUsuarioDao;

  lUsuarioCadastrado: Boolean;
begin

  lUsuarioCadastrado := False;

  lUsuario := TUsuario.Create;
  try

    try

      lUsuario.Id := Self.FIdUsuario;
      lUsuario.Nome := Trim(EdtNome.Text);
      lUsuario.Senha := TBiblioteca.Crypt('C', Trim(EdtSenha.Text));
      lUsuario.Admin := IfThen(CheckBoxAdministrador.Checked, 'S', 'N');

      lUsuarioDao := TUsuarioDao.Create(DataModuleConexao.Conexao);
      try

        if (Trim(EdtNome.Text) <> Trim(Self.FNomeUsuario)) then
        begin

          if (lUsuarioDao.getExiste(lUsuario.Nome)) then
          begin

            Application.MessageBox(PChar(TMensagem.getMensagem(20)), PChar('Aviso'), MB_OK + MB_ICONWARNING);
            EdtNome.SetFocus;

          end;

          lUsuarioCadastrado := lUsuarioDao.Salvar(lUsuario);

        end
        else
        begin

          lUsuarioCadastrado := lUsuarioDao.Salvar(lUsuario);

        end;

        if (lUsuarioCadastrado) then
        begin

          Application.MessageBox(PChar(Format(TMensagem.getMensagem(8), ['Usuário'])), PChar('Informação'),
            MB_OK + MB_ICONINFORMATION);

          ModalResult := mrOk;

        end;

      finally
        lUsuarioDao.Destroy;
      end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(4), ['', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuario.Destroy;
  end;

end;

procedure TFrmCadUsuario.CarregaUsuario;
var
  lUsuarioDao: TUsuarioDao;
  lUsuario: TUsuario;
begin

  lUsuario := TUsuario.Create;
  try

    lUsuarioDao := TUsuarioDao.Create(DataModuleConexao.Conexao);
    try

      if (lUsuarioDao.getObjeto(Self.FIdUsuario, lUsuario)) then
      begin

        Self.FNomeUsuario := lUsuario.Nome;
        EdtNome.Text := lUsuario.Nome;
        EdtSenha.Text := TBiblioteca.Crypt('D', Trim(lUsuario.Senha));

        CheckBoxAdministrador.Checked := lUsuario.Admin = 'S';

      end;

    finally
      lUsuarioDao.Destroy;
    end;

  finally
    lUsuario.Destroy;
  end;

end;

procedure TFrmCadUsuario.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin

    BtnSairClick(Sender);

  end;

end;

procedure TFrmCadUsuario.FormShow(Sender: TObject);
begin
  EdtNome.SetFocus;
end;

class function TFrmCadUsuario.getCadUsuario(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer = -1): Boolean;
begin

  Application.CreateForm(TFrmCadUsuario, FrmCadUsuario);
  try

    try

      FrmCadUsuario.FForeignFormKey := pFOREIGNFORMKEY;
      FrmCadUsuario.FIdUsuario := pID_USUARIO;

      if (FrmCadUsuario.FIdUsuario <> -1) then
      begin
        FrmCadUsuario.CarregaUsuario;
      end;

      Result := FrmCadUsuario.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmCadUsuario.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;

    end;

  finally
    FreeAndNil(FrmCadUsuario);
  end;

end;

end.
