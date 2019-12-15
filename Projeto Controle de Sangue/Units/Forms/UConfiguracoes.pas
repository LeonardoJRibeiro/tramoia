unit UConfiguracoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmConfiguracoes = class(TForm)
    EdtQuantDiasAvisoVencimento: TLabeledEdit;
    PanelBotoes: TPanel;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    procedure BtnGravarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnSairClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FId: Integer;

    procedure CarregaConfiguracoes;

    function getAdmin: Boolean;

  public
    class function getConfiguracoes(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer = -1): Boolean;

  end;

var
  FrmConfiguracoes: TFrmConfiguracoes;

implementation

{$R *.dfm}

uses UClassMensagem, UClassConfiguracaoDao, UDMConexao, UClassConfiguracao, UClassUsuarioDao, UAutenticacao;
{ TFrmConfiguracoes }

procedure TFrmConfiguracoes.BtnGravarClick(Sender: TObject);
var
  lConfiguracao: TConfiguracao;
  lConfiguracaoDao: TConfiguracaoDAO;
begin

  if (TFrmAutenticacao.getAutenticacao(Self.FIdUsuario)) then
  begin

    lConfiguracao := TConfiguracao.Create;
    try

      lConfiguracao.Id := Self.FId;
      lConfiguracao.Quant_Dias_Aviso_Vencimento := StrToIntDef(EdtQuantDiasAvisoVencimento.Text, 0);

      lConfiguracaoDao := TConfiguracaoDAO.Create(DMConexao.Conexao);
      try

        try

          if (lConfiguracaoDao.Salvar(lConfiguracao)) then
          begin
            Application.MessageBox(pWideChar(TMensagem.getMensagem(33)), 'Informação', MB_ICONINFORMATION + MB_OK);
            ModalResult := mrOk;
          end;

        except
          on E: Exception do
          begin
            Application.MessageBox(pWideChar(Format(TMensagem.getMensagem(4), ['configurações', E.Message])), 'Aviso',
              MB_ICONWARNING + MB_OK);
          end;

        end;

      finally
        lConfiguracaoDao.Destroy;
      end;

    finally
      lConfiguracao.Destroy;
    end;

  end;

end;

procedure TFrmConfiguracoes.BtnSairClick(Sender: TObject);
begin
  close;
end;

procedure TFrmConfiguracoes.CarregaConfiguracoes;
var
  lConfiguracaoDao: TConfiguracaoDAO;
  lConfiguracao: TConfiguracao;
begin

  lConfiguracaoDao := TConfiguracaoDAO.Create(DMConexao.Conexao);
  try

    lConfiguracao := TConfiguracao.Create;
    try

      try

        if (lConfiguracaoDao.getObjeto(lConfiguracao)) then
        begin
          Self.FId := lConfiguracao.Id;
          EdtQuantDiasAvisoVencimento.Text := lConfiguracao.Quant_Dias_Aviso_Vencimento.ToString;
        end;

      except
        on E: Exception do
        begin
          Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['configuracões', E.Message])), 'Erro',
            MB_ICONERROR + MB_OK);
        end;
      end;

    finally
      lConfiguracao.Destroy;
    end;

  finally
    lConfiguracaoDao.Destroy;
  end;

end;

procedure TFrmConfiguracoes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case (Key) of
    VK_F6:
      begin
        BtnGravarClick(Self);
      end;

    VK_ESCAPE:
      begin
        BtnSairClick(Self);
      end;
  end;

end;

function TFrmConfiguracoes.getAdmin: Boolean;
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
        Result := True;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(12), ['inforamções da configuraçao', E.Message])),
          PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuaioDao.Destroy;
  end;

end;

class function TFrmConfiguracoes.getConfiguracoes(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
begin

  Application.CreateForm(TFrmConfiguracoes, FrmConfiguracoes);
  try

    try

      FrmConfiguracoes.FForeignFormKey := pFOREIGNFORMKEY;
      FrmConfiguracoes.FIdUsuario := pID_USUARIO;

      if (FrmConfiguracoes.getAdmin) then
      begin
        FrmConfiguracoes.CarregaConfiguracoes;

        Result := FrmConfiguracoes.ShowModal = mrOk;
      end
      else
      begin
        Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
      end;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmConfiguracoes.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;

    end;

  finally
    FreeAndNil(FrmConfiguracoes);
  end;

end;

end.
