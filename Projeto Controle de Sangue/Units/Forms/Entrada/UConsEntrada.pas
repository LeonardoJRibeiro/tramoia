unit UConsEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFrmConsEntrada = class(TFrmCons)
    DataSource: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnAlterarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    function getBolsaPossuiEstoque: Boolean;

    function getAdmin: Boolean;
    function BolsaPossuiEstoque: Boolean;
  public
    class function getConsEntrada(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
  end;

var
  FrmConsEntrada: TFrmConsEntrada;

implementation

{$R *.dfm}

uses UEntrada, UClassEntradaDao, UDMConexao, UClassMensagem, UBiblioteca, UClassForeignKeyForms, UClassUsuarioDao,
  UClassBolsaDao;

function TFrmConsEntrada.BolsaPossuiEstoque: Boolean;
var
  lBolsaDao: TBolsaDAO;
begin

  lBolsaDao := TBolsaDAO.Create(DataModuleConexao.Conexao);
  try

    Result := lBolsaDao.getPossuiEmEstoque(Self.FPersistencia.Query.FieldByName('id_bolsa').AsInteger);

  finally
    lBolsaDao.Destroy;
  end;

end;

procedure TFrmConsEntrada.BtnAlterarClick(Sender: TObject);
begin
  inherited;

  if (Self.getBolsaPossuiEstoque) then
  begin
    TFrmEntrada.getEntrada(TForeignKeyForms.FIdUConsEntrada, Self.FIdUsuario, Self.FPersistencia.Query.FieldByName('id')
      .AsInteger);
    EdtConsInvokeSearch(Self);
  end
  else
  begin
    Application.MessageBox(PChar(TMensagem.getMensagem(21)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
  end;

end;

procedure TFrmConsEntrada.BtnExcluirClick(Sender: TObject);
var
  lEntradaDao: TEntradaDAO;
begin
  inherited;

  if (Self.getAdmin) then
  begin

    if (Self.getBolsaPossuiEstoque) then
    begin

      if (Application.MessageBox(PChar(Format(TMensagem.getMensagem(9), ['entrada'])), PChar('Cuidado'),
        MB_YESNO + MB_ICONQUESTION) = IDYES) then
      begin

        lEntradaDao := TEntradaDAO.Create(DataModuleConexao.Conexao);
        try

          try

            if (lEntradaDao.excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
            begin
              EdtConsInvokeSearch(Self);
            end;

          except
            on E: Exception do
            begin
              Application.MessageBox(PChar(Format(TMensagem.getMensagem(2), ['paciente', E.Message])), '1',
                MB_OK + MB_ICONSTOP);
            end;
          end;

        finally
          lEntradaDao.Destroy;
        end;

      end;

    end
    else
    begin
      Application.MessageBox(PChar(TMensagem.getMensagem(22)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
    end;

  end
  else
  begin
    Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
  end;

end;

procedure TFrmConsEntrada.BtnNovoClick(Sender: TObject);
begin
  inherited;

  TFrmEntrada.getEntrada(TForeignKeyForms.FIdUConsEntrada, Self.FIdUsuario);
  EdtConsInvokeSearch(Self);

end;

procedure TFrmConsEntrada.DBGridDblClick(Sender: TObject);
begin
  inherited;
  BtnAlterarClick(Self);
end;

procedure TFrmConsEntrada.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  case (Key) of
    VK_RETURN:
      begin
        BtnAlterarClick(Self);
      end;

    VK_DELETE:
      begin
        BtnExcluirClick(Self);
      end;
  end;

end;

procedure TFrmConsEntrada.EdtConsInvokeSearch(Sender: TObject);
var
  lEntradaDao: TEntradaDAO;
begin
  inherited;

  lEntradaDao := TEntradaDAO.Create(DataModuleConexao.Conexao);
  try

    try

      if (lEntradaDao.getConsulta(EdtCons.Text, ComboBoxTipoCons.ItemIndex, Self.FPersistencia)) then
      begin

        Self.FPersistencia.Query.Last;
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
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['entrada(s)', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lEntradaDao.Destroy;
  end;

end;

procedure TFrmConsEntrada.FormShow(Sender: TObject);
begin
  inherited;
  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsEntrada.ComboBoxTipoCons', '0').ToInteger;
  ComboBoxTipoConsChange(Self);

  EdtConsInvokeSearch(Self);

  EdtCons.SetFocus;
end;

function TFrmConsEntrada.getAdmin: Boolean;
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

function TFrmConsEntrada.getBolsaPossuiEstoque: Boolean;
var
  lBolsaDao: TBolsaDAO;
begin

  lBolsaDao := TBolsaDAO.Create(DataModuleConexao.Conexao);
  try

    try

      Result := lBolsaDao.getPossuiEmEstoque(Self.FPersistencia.Query.FieldByName('id_bolsa').AsInteger);

    except
      on E: Exception do
      begin
        Result := False;
      end;
    end;

  finally
    lBolsaDao.Destroy
  end;

end;

class function TFrmConsEntrada.getConsEntrada(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsEntrada, FrmConsEntrada);
  try

    try

      FrmConsEntrada.FForeignFormKey := pFOREIGNFORMKEY;
      FrmConsEntrada.FIdUsuario := pID_USUARIO;

      Result := FrmConsEntrada.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmConsEntrada.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmConsEntrada);
  end;

end;

end.
