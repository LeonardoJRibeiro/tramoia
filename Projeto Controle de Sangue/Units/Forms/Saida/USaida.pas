unit USaida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Mask;

type
  TFrmSaida = class(TForm)
    PanelClient: TPanel;
    GroupBoxSangue: TGroupBox;
    GroupBoxPaciente: TGroupBox;
    LabelRegistroPaciente: TLabel;
    EdtNomePaciente: TEdit;
    EdtAboBolsa: TEdit;
    EdtNumeroBolsa: TEdit;
    EdtHospital: TEdit;
    EdtTipo: TEdit;
    LabelVolume: TLabel;
    LabelAboSangue: TLabel;
    LabelNumeroBolsa: TLabel;
    LabelHospital: TLabel;
    LabelTipo: TLabel;
    LabelNomePaciente: TLabel;
    RadioGroupPai: TRadioGroup;
    GroupBoxProvaCompatibilidade: TGroupBox;
    RadioGroupTA: TRadioGroup;
    RadioGroupAGH: TRadioGroup;
    RadioGroup37: TRadioGroup;
    PanelBottom: TPanel;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    EdtId: TEdit;
    LabelId: TLabel;
    EdtVolume: TMaskEdit;
    BtnConsPaciente: TSpeedButton;
    EdtRegistroPaciente: TEdit;
    DateTimePickerData: TDateTimePicker;
    LabelData: TLabel;
    BtnNovo: TBitBtn;
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure EdtNumeroBolsaExit(Sender: TObject);
    procedure BtnConsPacienteClick(Sender: TObject);
    procedure EdtRegistroPacienteExit(Sender: TObject);
    procedure EdtRegistroPacienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnNovoClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FId: Integer;
    FIdBolsa: Integer;

    procedure CarregaSaida;

    procedure CarregaDadosBolsa(const pID_BOLSA: Integer);

    function SalvaSaida: Boolean;

  public
    class function getSaida(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      const pID: Integer = -1): Boolean;
  end;

var
  FrmSaida: TFrmSaida;

implementation

uses System.Math, UDMConexao, UClassMensagem, UClassEntrada, UClassEntradaDAO, UClassSaida, UClassSaidaDAO, UBiblioteca,
  UClassBibliotecaDao, UConsPaciente, UClassForeignKeyForms, UClassBolsa, UClassBolsaDao;

{$R *.dfm}
{ TFrmSaida }

procedure TFrmSaida.BtnConsPacienteClick(Sender: TObject);
var
  lRegistro: string;
begin

  if (TFrmConsPaciente.getConsPaciente(TForeignKeyForms.FIdUSaida, Self.FIdUsuario, lRegistro)) then
  begin

    EdtRegistroPaciente.Text := lRegistro;

    // Tratamento para pesquisar o nome do paciente apenas uma vez.
    if (not EdtRegistroPaciente.Focused) then
    begin

      EdtRegistroPacienteExit(Sender);

    end
    else
    begin

      // Se tiver focado no EdtRegistroPaciente, vai disparar o OnExit.
      EdtNumeroBolsa.SetFocus;

    end;

  end
  else
  begin

    EdtRegistroPaciente.SetFocus;

  end;

end;

procedure TFrmSaida.BtnGravarClick(Sender: TObject);
var
  lIdBolsa: Integer;
begin

  if (Trim(EdtRegistroPaciente.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelRegistroPaciente.Caption]), mtWarning, [mbOK], -1);

    EdtRegistroPaciente.SetFocus;

    exit;

  end;

  if (Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelNumeroBolsa.Caption]), mtWarning, [mbOK], -1);

    EdtNumeroBolsa.SetFocus;

    exit;

  end;

  Self.SalvaSaida;

end;

procedure TFrmSaida.BtnNovoClick(Sender: TObject);
begin

  EdtId.Clear;
  DateTimePickerData.Date := now;
  EdtRegistroPaciente.Clear;
  EdtNomePaciente.Clear;
  EdtNumeroBolsa.Clear;
  EdtAboBolsa.Clear;
  EdtTipo.Clear;
  EdtVolume.Clear;
  EdtHospital.Clear;
  RadioGroupPai.ItemIndex := 1;
  RadioGroupTA.ItemIndex := 1;
  RadioGroupAGH.ItemIndex := 1;
  RadioGroup37.ItemIndex := 1;
  EdtRegistroPaciente.SetFocus;

end;

procedure TFrmSaida.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSaida.CarregaDadosBolsa(const pID_BOLSA: Integer);
var
  lBolsa: TBolsa;
  lBolsaDao: TBolsaDAO;
begin

  lBolsa := TBolsa.Create;
  try

    lBolsaDao := TBolsaDAO.Create(DataModuleConexao.Conexao);
    try

      try

        if (lBolsaDao.getObjeto(pID_BOLSA, lBolsa)) then
        begin

          EdtNumeroBolsa.Text := lBolsa.NumeroBolsa;
          EdtTipo.Text := lBolsa.Tipo;
          EdtVolume.Text := lBolsa.Volume.ToString;
          EdtAboBolsa.Text := lBolsa.Abo + lBolsa.Rh;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(5), ['Dados da bolsa', E.Message]));
        end;
      end;

    finally
      lBolsaDao.Destroy;
    end;

  finally
    lBolsa.Destroy;
  end;

end;

procedure TFrmSaida.CarregaSaida;
var
  lSaida: TSaida;
  lSaidaDAO: TSaidaDAO;
begin

  lSaida := TSaida.Create;
  try

    lSaidaDAO := TSaidaDAO.Create(DataModuleConexao.Conexao);
    try

      try

        if (lSaidaDAO.getObjeto(Self.FId, lSaida)) then
        begin

          EdtId.Text := lSaida.Id.ToString;
          EdtRegistroPaciente.Text := lSaida.Id_Paciente.ToString;
          Self.CarregaDadosBolsa(lSaida.Id_Bolsa);
          DateTimePickerData.Date := lSaida.Data_Saida;
          EdtHospital.Text := lSaida.Hospital;
          RadioGroupPai.ItemIndex := IfThen(lSaida.Pai = 'P', 0, 1);
          RadioGroupTA.ItemIndex := IfThen(lSaida.Prova_Compatibilidade_Ta = 'P', 0, 1);
          RadioGroupAGH.ItemIndex := IfThen(lSaida.Prova_Compatibilidade_Agh = 'P', 0, 1);
          RadioGroup37.ItemIndex := IfThen(lSaida.Prova_Compatibilidade_37 = 'P', 0, 1);

          EdtRegistroPaciente.SetFocus;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(5), ['Saída de sangue', E.Message]));
        end;
      end;

    finally
      lSaidaDAO.Destroy;
    end;

  finally
    lSaida.Destroy;
  end;

end;

procedure TFrmSaida.EdtNumeroBolsaExit(Sender: TObject);
var
  lSaidaDAO: TSaidaDAO;
  lBolsaDao: TBolsaDAO;
begin

  if (not Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    lBolsaDao := TBolsaDAO.Create(DataModuleConexao.Conexao);
    try

      Self.FIdBolsa := lBolsaDao.getIdBolsa(EdtNumeroBolsa.Text);

    finally
      lBolsaDao.Destroy;
    end;

    if (Self.FIdBolsa > 0) then
    begin

      lSaidaDAO := TSaidaDAO.Create(DataModuleConexao.Conexao);
      try

        try

          if (not lSaidaDAO.getExisteBolsaVinculada(Self.FIdBolsa)) then
          begin

            Self.CarregaDadosBolsa(Self.FIdBolsa);

          end
          else
          begin

            Self.FIdBolsa := -1;
            Application.MessageBox('Número da bolsa já vinculado a uma saída', 'Aviso', MB_ICONWARNING + MB_OK);
            EdtNumeroBolsa.SetFocus;

          end;

        except
          on E: Exception do
          begin
            raise Exception.Create('Erro ao verificar se o número da bolsa já esta vinculado a uma saída. Motivo ' +
              E.Message);
            Self.FIdBolsa := -1;
            EdtNumeroBolsa.SetFocus;
          end;
        end;

      finally
        lSaidaDAO.Destroy;
      end;

    end
    else
    begin

      Application.MessageBox('Número da bolsa não cadastrado', 'Aviso', MB_ICONWARNING + MB_OK);
      EdtNumeroBolsa.SetFocus;

    end;

  end;

end;

procedure TFrmSaida.EdtRegistroPacienteExit(Sender: TObject);
var
  lNomePaciente: string;
begin

  if (not Trim(EdtRegistroPaciente.Text).IsEmpty) then
  begin

    lNomePaciente := TClassBibliotecaDao.getValorAtributo('paciente', 'nome', 'num_prontuario',
      EdtRegistroPaciente.Text, DataModuleConexao.Conexao);

    if (lNomePaciente <> '-1') then
    begin

      EdtNomePaciente.Text := lNomePaciente;

    end
    else
    begin

      MessageDlg(Format(TMensagem.getMensagem(6), ['Paciente']), mtWarning, [mbOK], -1);
      EdtRegistroPaciente.SetFocus;

    end;

  end
  else
  begin
    EdtRegistroPaciente.Clear;
    EdtNomePaciente.Clear;

    if (GetKeyState(VK_RETURN) < 0) then
    begin
      BtnConsPacienteClick(Self);
    end;

  end;

end;

procedure TFrmSaida.EdtRegistroPacienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F2) then
  begin
    BtnConsPacienteClick(Self);
  end;
end;

procedure TFrmSaida.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    BtnSairClick(Sender);
  end;

end;

procedure TFrmSaida.FormShow(Sender: TObject);
begin

  if (Self.FId <> -1) then
  begin
    Self.CarregaSaida;
  end
  else
  begin
    DateTimePickerData.Date := now;
    EdtRegistroPaciente.SetFocus;
  end;

end;

class function TFrmSaida.getSaida(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
  const pID: Integer = -1): Boolean;
begin

  Application.CreateForm(TFrmSaida, FrmSaida);
  try

    try

      FrmSaida.FForeignFormKey := pFOREIGNFORMKEY;
      FrmSaida.FIdUsuario := pID_USUARIO;

      FrmSaida.FId := pID;

      Result := FrmSaida.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de saída de sangue', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmSaida);
  end;

end;

function TFrmSaida.SalvaSaida: Boolean;
var
  lSaida: TSaida;
  lSaidaDAO: TSaidaDAO;
begin

  lSaida := TSaida.Create;
  try

    lSaida.Id := StrToIntDef(EdtId.Text, -1);
    lSaida.Id_Paciente := TClassBibliotecaDao.getValorAtributo('paciente', 'id', 'num_prontuario',
      EdtRegistroPaciente.Text, DataModuleConexao.Conexao);
    lSaida.Id_Usuario := Self.FIdUsuario;
    lSaida.Id_Bolsa := Self.FIdBolsa;
    lSaida.Data_Saida := now;
    lSaida.Hospital := EdtHospital.Text;
    lSaida.Pai := Copy(RadioGroupPai.Items[RadioGroupPai.ItemIndex], 1, 1);
    lSaida.Prova_Compatibilidade_Ta := Copy(RadioGroupTA.Items[RadioGroupTA.ItemIndex], 1, 1);
    lSaida.Prova_Compatibilidade_Agh := Copy(RadioGroupAGH.Items[RadioGroupAGH.ItemIndex], 1, 1);
    lSaida.Prova_Compatibilidade_37 := Copy(RadioGroup37.Items[RadioGroup37.ItemIndex], 1, 1);

    lSaidaDAO := TSaidaDAO.Create(DataModuleConexao.Conexao);
    try

      try

        if (lSaidaDAO.Salvar(lSaida)) then
        begin

          EdtId.Text := lSaida.Id.ToString;

          BtnGravar.Enabled := False;

          BtnNovo.SetFocus;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(4), ['Saída de sangue', E.Message]));
        end;
      end;

    finally
      lSaidaDAO.Destroy;
    end;

  finally
    lSaida.Destroy;
  end;

end;

end.
