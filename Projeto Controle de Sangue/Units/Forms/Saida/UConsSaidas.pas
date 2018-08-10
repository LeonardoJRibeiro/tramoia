unit UConsSaidas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFrmConsSaidas = class(TFrmCons)
    DataSource: TDataSource;
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    function getAdmin: Boolean;
  public
    class function getConsSaida(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
  end;

var
  FrmConsSaidas: TFrmConsSaidas;

implementation

{$R *.dfm}

uses UClassMensagem, UClassUsuarioDao, UDMConexao, UClassSaidaDao, UBiblioteca, USaida, UClassForeignKeyForms;
{ TFrmConsSaidas }

procedure TFrmConsSaidas.BtnExcluirClick(Sender: TObject);
var
  lSaidaDao: TSaidaDAO;
begin
  inherited;

  if (Self.getAdmin) then
  begin

    if (Application.MessageBox(PChar(Format(TMensagem.getMensagem(9), ['saída'])), PChar('Cuidado'),
      MB_YESNO + MB_ICONQUESTION) = IDYES) then
    begin

      lSaidaDao := TSaidaDAO.Create(DataModuleConexao.Conexao);
      try

        try

          if (lSaidaDao.excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
          begin
            EdtConsInvokeSearch(Self);
          end;

        except
          on E: Exception do
          begin
            Application.MessageBox(PChar(Format(TMensagem.getMensagem(2), ['saída', E.Message])), '1',
              MB_OK + MB_ICONSTOP);
          end;
        end;

      finally
        lSaidaDao.Destroy;
      end;

    end;

  end
  else
  begin
    Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
  end;

end;

procedure TFrmConsSaidas.BtnNovoClick(Sender: TObject);
begin
  inherited;
  TFrmSaida.getSaida(TForeignKeyForms.FIdUConsSaida, Self.FIdUsuario);
  EdtConsInvokeSearch(Self);
end;

procedure TFrmConsSaidas.EdtConsInvokeSearch(Sender: TObject);
var
  lSaidaDao: TSaidaDAO;
begin
  inherited;

  lSaidaDao := TSaidaDAO.Create(DataModuleConexao.Conexao);
  try

    try

      if (lSaidaDao.getConsulta(EdtCons.Text, ComboBoxTipoCons.ItemIndex, Self.FPersistencia)) then
      begin

        DataSource.DataSet := Self.FPersistencia.Query;
        if (not Self.FPersistencia.Query.IsEmpty) then
        begin
          DBGrid.SetFocus;
        end
        else
        begin
          EdtCons.SetFocus;
        end

      end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['saídas(s)', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lSaidaDao.Destroy;
  end;

end;

procedure TFrmConsSaidas.FormShow(Sender: TObject);
begin
  inherited;
  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsSaidas.ComboBoxTipoCons', '0').ToInteger;
  ComboBoxTipoConsChange(Self);

  EdtConsInvokeSearch(Self);

  EdtCons.SetFocus;
end;

function TFrmConsSaidas.getAdmin: Boolean;
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
        Result := True;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(12), ['inforção do usuário', E.Message])),
          PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuaioDao.Destroy;
  end;

end;

class function TFrmConsSaidas.getConsSaida(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsSaidas, FrmConsSaidas);
  try

    try

      FrmConsSaidas.FForeignFormKey := pFOREIGNFORMKEY;
      FrmConsSaidas.FIdUsuario := pID_USUARIO;

      Result := FrmConsSaidas.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmConsSaidas.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmConsSaidas);
  end;

end;

end.
