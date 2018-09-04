unit UConsEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmConsEntrada = class(TFrmCons)
    DataSource: TDataSource;
    EdtDataFinal: TDateTimePicker;
    EdtDataIni: TDateTimePicker;
    LabelAte: TLabel;
    LabelDe: TLabel;
    BtnLocalizar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnAlterarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxTipoConsChange(Sender: TObject);
    procedure BtnLocalizarClick(Sender: TObject);
    procedure EdtDataFinalExit(Sender: TObject);
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

uses System.Math, UEntrada, UClassEntradaDao, UDMConexao, UClassMensagem, UBiblioteca, UClassForeignKeyForms,
  UClassUsuarioDao, UClassBolsaDao;

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
var
  lPosicaoQuery: Integer;
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

    if (Self.getBolsaPossuiEstoque) then
    begin
      TFrmEntrada.getEntrada(TForeignKeyForms.FIdUConsEntrada, Self.FIdUsuario,
        Self.FPersistencia.Query.FieldByName('id').AsInteger);

      lPosicaoQuery := Self.FPersistencia.Query.RecNo;

      EdtConsInvokeSearch(Self);

      Self.FPersistencia.Query.RecNo := lPosicaoQuery;
    end
    else
    begin
      Application.MessageBox(PChar(TMensagem.getMensagem(21)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
    end;

  end;

end;

procedure TFrmConsEntrada.BtnExcluirClick(Sender: TObject);
var
  lEntradaDao: TEntradaDAO;
  lPosicaoQuery: Integer;
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

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

              if (lEntradaDao.Excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
              begin
                lPosicaoQuery := Self.FPersistencia.Query.RecNo;

                EdtConsInvokeSearch(Self);

                Self.FPersistencia.Query.RecNo := lPosicaoQuery - 1;
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

end;

procedure TFrmConsEntrada.BtnLocalizarClick(Sender: TObject);
begin
  inherited;
  EdtConsInvokeSearch(Self);
end;

procedure TFrmConsEntrada.BtnNovoClick(Sender: TObject);
begin
  inherited;

  TFrmEntrada.getEntrada(TForeignKeyForms.FIdUConsEntrada, Self.FIdUsuario);
  EdtConsInvokeSearch(Self);

end;

procedure TFrmConsEntrada.ComboBoxTipoConsChange(Sender: TObject);
begin

  EdtCons.Clear;

  BtnLocalizar.Visible := ComboBoxTipoCons.ItemIndex = 2;

  EdtCons.Visible := ComboBoxTipoCons.ItemIndex <> 2;

  EdtDataIni.Visible := ComboBoxTipoCons.ItemIndex = 2;
  EdtDataFinal.Visible := ComboBoxTipoCons.ItemIndex = 2;

  case (ComboBoxTipoCons.ItemIndex) of

    0, 1: // 0 = C�digo e 1 = N�mero da bolsa.
      begin

        EdtCons.MaxLength := IfThen(ComboBoxTipoCons.ItemIndex = 0, 11, 20);

        EdtCons.SetFocus;

      end;

    2: // Per�odo
      begin

        EdtDataIni.Date := TBiblioteca.getPrimeiroDiaMes(Now);
        EdtDataFinal.Date := TBiblioteca.getUltimoDiaMes(Now);

        EdtDataIni.SetFocus;

      end;

  end;

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

    VK_F2:
      begin

        if (EdtDataIni.CanFocus) then
        begin
          EdtDataIni.SetFocus;
        end;

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

      if (lEntradaDao.getConsulta(EdtCons.Text, EdtDataIni.Date, EdtDataFinal.Date, ComboBoxTipoCons.ItemIndex,
        Self.FPersistencia)) then
      begin

        DataSource.DataSet := Self.FPersistencia.Query;

        if (not Self.FPersistencia.Query.IsEmpty) then
        begin

          DBGrid.SetFocus;

          Self.FPersistencia.Query.Last;

        end
        else
        begin

          if (EdtCons.CanFocus) then
          begin

            EdtCons.SetFocus;
            BtnLocalizar.Visible := False;

          end
          else
          begin

            EdtDataIni.SetFocus;
            BtnLocalizar.Visible := True;

          end;

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

procedure TFrmConsEntrada.EdtDataFinalExit(Sender: TObject);
begin
  inherited;
  BtnLocalizarClick(Self);
end;

procedure TFrmConsEntrada.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox', 'FrmConsEntrada.ComboBoxTipoCons',
    ComboBoxTipoCons.ItemIndex.ToString);
end;

procedure TFrmConsEntrada.FormShow(Sender: TObject);
begin
  inherited;

  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsEntrada.ComboBoxTipoCons', '0').ToInteger;

  ComboBoxTipoConsChange(Self);

  EdtConsInvokeSearch(Self);

  if (EdtCons.CanFocus) then
  begin
    EdtCons.SetFocus;
  end
  else
  begin
    EdtDataIni.SetFocus;
  end;

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
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(12), ['infor��o do usu�rio', E.Message])),
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
