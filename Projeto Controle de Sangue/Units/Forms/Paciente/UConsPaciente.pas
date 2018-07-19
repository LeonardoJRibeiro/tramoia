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
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FNumProntuario: Integer;

  public
    class function getConsPaciente(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      var pNumProntuario: Integer): Boolean;
  end;

var
  FrmConsPaciente: TFrmConsPaciente;

implementation

uses System.Math, UDMConexao, UClassMensagem, UClassPacienteDAO, UCadPaciente, UClassPersistencia,
  UClassForeignKeyForms;

{$R *.dfm}

procedure TFrmConsPaciente.BtnAlterarClick(Sender: TObject);
begin
  inherited;
  if (TFrmCadPaciente.getCadPaciente(TForeignKeyForms.FIdUConsPaciente, Self.FIdUsuario,
    Self.FClientDataSet.FieldByName('id').AsInteger)) then
  begin
    EdtConsInvokeSearch(Self);
  end;
end;

procedure TFrmConsPaciente.BtnExcluirClick(Sender: TObject);
var
  lPacienteDao: TPacienteDAO;
begin
  inherited;

  case Application.MessageBox(PChar(TMensagem.getMensagem(9)), PChar('Cuidado'), MB_YESNO + MB_ICONQUESTION) of
    IDYES:
      begin

        lPacienteDao := TPacienteDAO.Create(DataModuleConexao.Conexao);
        try

          try

            if (lPacienteDao.excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
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
          lPacienteDao.Destroy;
        end;

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

  EdtCons.NumbersOnly := ComboBoxTipoCons.ItemIndex = 2;

  EdtCons.MaxLength := IfThen(ComboBoxTipoCons.ItemIndex = 2, 9, 100);

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

    Self.FNumProntuario := Self.FClientDataSet.FieldByName('num_prontuario').AsInteger;
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
  lPersistencia: TPersistencia;
begin
  inherited;

  lPersistencia := TPersistencia.Create(DataModuleConexao.Conexao);
  try
    lPacienteDao := TPacienteDAO.Create(DataModuleConexao.Conexao);
    try

      try

        Self.FClientDataSet.Close;
        if (lPacienteDao.getConsulta(EdtCons.Text, ComboBoxTipoCons.ItemIndex, lPersistencia)) then
        begin
          Self.FClientDataSet.SetProvider(lPersistencia.DataSetProvider);
          Self.FClientDataSet.Open;
          Self.FClientDataSet.Active := True;
          DataSource.DataSet := Self.FClientDataSet;

          if (not Self.FClientDataSet.IsEmpty) then
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
          raise Exception.Create(Format(TMensagem.getMensagem(1), ['paciente(s)', E.Message]));
        end;
      end;

    finally
      lPacienteDao.Destroy;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

procedure TFrmConsPaciente.FormShow(Sender: TObject);
begin
  inherited;
  EdtConsInvokeSearch(Self);
end;

class function TFrmConsPaciente.getConsPaciente(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
  var pNumProntuario: Integer): Boolean;
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
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['Consulta de paciente', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmConsPaciente);
  end;

end;

end.
