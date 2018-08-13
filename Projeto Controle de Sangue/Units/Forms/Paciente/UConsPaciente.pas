unit UConsPaciente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.WinXCtrls;

type
  TFrmConsPaciente = class(TFrmCons)
    DataSource: TDataSource;
    procedure ComboBoxTipoConsChange(Sender: TObject);
    procedure ComboBoxTipoConsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBoxTipoConsCloseUp(Sender: TObject);
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDblClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure EdtConsExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FNumProntuario: string;

    function getAdmin: Boolean;

    function getExisteRelacionamento: Boolean;

  public
    class function getConsPaciente(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      var pNumProntuario: string): Boolean;
  end;

var
  FrmConsPaciente: TFrmConsPaciente;

implementation

uses System.Math, UDMConexao, UClassMensagem, UClassPacienteDAO, UCadPaciente, UClassPersistencia,
  UClassForeignKeyForms, UBiblioteca, UClassUsuarioDao, UClassSaidaDao;

{$R *.dfm}

procedure TFrmConsPaciente.BtnAlterarClick(Sender: TObject);
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

    if (Self.getAdmin) then
    begin

      if (TFrmCadPaciente.getCadPaciente(TForeignKeyForms.FIdUConsPaciente, Self.FIdUsuario,
        Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
      begin

        EdtConsInvokeSearch(Self);

      end;

    end
    else
    begin
      Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
    end;

  end;

end;

procedure TFrmConsPaciente.BtnExcluirClick(Sender: TObject);
var
  lPacienteDao: TPacienteDAO;
begin
  inherited;
  if (not Self.FPersistencia.Query.IsEmpty) then
  begin
    if (Self.getAdmin) then
    begin

      if (Application.MessageBox(PChar(Format(TMensagem.getMensagem(9), ['paciente'])), PChar('Cuidado'),
        MB_YESNO + MB_ICONQUESTION) = IDYES) then
      begin

        lPacienteDao := TPacienteDAO.Create(DataModuleConexao.Conexao);
        try

          try

            if (not Self.getExisteRelacionamento) then
            begin

              if (lPacienteDao.excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
              begin
                EdtConsInvokeSearch(Self);
              end;

            end
            else
            begin
              Application.MessageBox(PChar(TMensagem.getMensagem(19)), 'Aviso', MB_OK + MB_ICONWARNING);
            end;

          except
            on E: Exception do
            begin
              Application.MessageBox(PChar(Format(TMensagem.getMensagem(2), ['paciente', E.Message])), '1',
                MB_OK + MB_ICONSTOP);
            end;
          end;

        finally
          lPacienteDao.Destroy;
        end;

      end;

    end
    else
    begin
      Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
    end;

  end;

end;

procedure TFrmConsPaciente.BtnNovoClick(Sender: TObject);
begin
  inherited;

  if (TFrmCadPaciente.getCadPaciente(TForeignKeyForms.FIdUConsPaciente, Self.FIdUsuario)) then
  begin
    EdtConsInvokeSearch(Self);
  end;

end;

procedure TFrmConsPaciente.ComboBoxTipoConsChange(Sender: TObject);
begin
  inherited;

  EdtCons.MaxLength := IfThen(ComboBoxTipoCons.ItemIndex = 2, 20, 100);

end;

procedure TFrmConsPaciente.ComboBoxTipoConsCloseUp(Sender: TObject);
begin
  inherited;

  EdtCons.SetFocus;

end;

procedure TFrmConsPaciente.ComboBoxTipoConsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  if (Key = VK_SPACE) then
  begin

    ComboBoxTipoCons.DroppedDown := not ComboBoxTipoCons.DroppedDown;

  end;

end;

procedure TFrmConsPaciente.DBGridDblClick(Sender: TObject);
begin
  inherited;

  if (Self.FForeignFormKey = TForeignKeyForms.FIdUPrincipal) then
  begin

    BtnAlterarClick(Self);

  end
  else
  begin

    Self.FNumProntuario := Self.FPersistencia.Query.FieldByName('num_prontuario').AsString;
    ModalResult := mrOk;

  end;

end;

procedure TFrmConsPaciente.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmConsPaciente.EdtConsExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_RETURN) < 0) then
  begin
    EdtConsInvokeSearch(Self);
  end;
end;

procedure TFrmConsPaciente.EdtConsInvokeSearch(Sender: TObject);
var
  lPacienteDao: TPacienteDAO;
begin
  inherited;

  lPacienteDao := TPacienteDAO.Create(DataModuleConexao.Conexao);
  try

    try

      if (lPacienteDao.getConsulta(EdtCons.Text, ComboBoxTipoCons.ItemIndex, Self.FPersistencia)) then
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
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['paciente(s)', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lPacienteDao.Destroy;
  end;

end;

procedure TFrmConsPaciente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox', 'FrmConsPaciente.ComboBoxTipoCons',
    ComboBoxTipoCons.ItemIndex.ToString);
end;

procedure TFrmConsPaciente.FormShow(Sender: TObject);
begin
  inherited;
  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsPaciente.ComboBoxTipoCons', '0').ToInteger;
  ComboBoxTipoConsChange(Self);

  EdtConsInvokeSearch(Self);

  EdtCons.SetFocus;
end;

function TFrmConsPaciente.getAdmin: Boolean;
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

class function TFrmConsPaciente.getConsPaciente(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
  var pNumProntuario: string): Boolean;
begin

  Application.CreateForm(TFrmConsPaciente, FrmConsPaciente);
  try

    try

      FrmConsPaciente.FForeignFormKey := pFOREIGNFORMKEY;
      FrmConsPaciente.FIdUsuario := pID_USUARIO;

      Result := FrmConsPaciente.ShowModal = mrOk;

      if (Result) then
      begin

        pNumProntuario := FrmConsPaciente.FNumProntuario;

      end;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmConsPaciente.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmConsPaciente);
  end;

end;

function TFrmConsPaciente.getExisteRelacionamento: Boolean;
var
  lSaidaDao: TSaidaDAO;
begin

  lSaidaDao := TSaidaDAO.Create(DataModuleConexao.Conexao);
  try

    try
      Result := lSaidaDao.getExisteSaidaPaciente(Self.FPersistencia.Query.FieldByName('id').AsInteger);
    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lSaidaDao.Destroy
  end;

end;

end.
