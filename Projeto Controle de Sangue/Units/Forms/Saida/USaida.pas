unit USaida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Mask,
  UCadPaciente, UClassPacienteDao;

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
    EdtVolume: TEdit;
    BtnConsPaciente: TSpeedButton;
    EdtRegistroPaciente: TEdit;
    DateTimePickerData: TDateTimePicker;
    LabelData: TLabel;
    BtnNovo: TBitBtn;
    LabelResponsavel: TLabel;
    btnCadPaciente: TSpeedButton;
    Label1: TLabel;
    EdtAboPaciente: TEdit;
    ComboBoxResponsavel: TComboBox;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    RadioGroupIrradiada: TRadioGroup;
    RadioGroupFiltrada: TRadioGroup;
    RadioGroupFracionada: TRadioGroup;
    RadioGroupFenotipada: TRadioGroup;
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtNumeroBolsaExit(Sender: TObject);
    procedure BtnConsPacienteClick(Sender: TObject);
    procedure EdtRegistroPacienteExit(Sender: TObject);
    procedure EdtRegistroPacienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnNovoClick(Sender: TObject);
    procedure btnCadPacienteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtVolumeExit(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FId: Integer;
    FIdBolsa: Integer;
    FIdProcedimentosEspeciais: Integer;
    FNumBolsa: string;

    procedure CarregaDadosSaida;

    procedure CarregaUsuarios;

    procedure setIndexByIdUsuario(const pIdUsuario: Integer);

    procedure CarregaDadosBolsa(const pID_BOLSA: Integer);

    procedure CarregaDadosProcedEspeciais;

    function SalvaSaida: Boolean;

    function SalvaProcedimentoEspeciais: Boolean;

    function getBolsaJaVinculada: Boolean;

    function getSangueCompativel: Boolean;

  public
    class function getSaida(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      const pID: Integer = -1): Boolean;
  end;

var
  FrmSaida: TFrmSaida;

implementation

uses System.Math, UDMConexao, UClassMensagem, UClassEntrada, UClassEntradaDAO, UClassSaida, UClassSaidaDAO,
  UClassBiblioteca, UClassBibliotecaDao, UConsPaciente, UClassForeignKeyForms, UClassBolsa, UClassBolsaDao,
  System.Generics.Collections, UClassUsuario, UClassUsuarioDAO, UAutenticacao, USelBolsa, UClassProcedimento_Especial,
  UClassProcedimento_EspecialDao, UClassDescarteDao, System.StrUtils;

{$R *.dfm}
{ TFrmSaida }

procedure TFrmSaida.btnCadPacienteClick(Sender: TObject);
begin
  TFrmCadPaciente.getCadPaciente(TForeignKeyForms.FIdUSaida, Self.FIdUsuario);
end;

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
begin

  if (ComboBoxResponsavel.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelResponsavel.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxResponsavel.SetFocus;

    exit;

  end;

  if (Trim(EdtRegistroPaciente.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelRegistroPaciente.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtRegistroPaciente.SetFocus;

    exit;

  end;

  if (Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelNumeroBolsa.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtNumeroBolsa.SetFocus;

    exit;

  end;

  if (Trim(EdtVolume.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelVolume.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtVolume.SetFocus;

    exit;

  end;

  if (Trim(EdtHospital.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelHospital.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtHospital.SetFocus;

    exit;

  end;

  if (not getSangueCompativel) then
  begin

    if (Application.MessageBox(PChar(TMensagem.getMensagem(31)), PChar('Quest�o'), MB_YESNO + MB_ICONQUESTION) = IDNO)
    then
    begin
      EdtNumeroBolsa.SetFocus;
      exit;
    end;

  end;

  if (TFrmAutenticacao.getAutenticacao(TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items
    [ComboBoxResponsavel.ItemIndex]))) then
  begin

    if (Self.SalvaSaida) then
    begin

      if (Self.SalvaProcedimentoEspeciais) then
      begin
        EdtId.Text := Self.FId.ToString;

        TBiblioteca.AtivaDesativaCompontes(Self, False);

        Application.MessageBox(PChar(TMensagem.getMensagem(24)), 'Informa��o', MB_ICONINFORMATION + MB_OK);

        BtnGravar.Enabled := False;

        BtnNovo.SetFocus;

        TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'Hospital', 'FrmConsSaidas.EdtHospital',
          Trim(EdtHospital.Text));
      end;

    end;

  end;

end;

procedure TFrmSaida.BtnNovoClick(Sender: TObject);
var
  lUltimoUsu: Integer;
begin
  TBiblioteca.AtivaDesativaCompontes(Self, true);

  EdtHospital.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Hospital', 'FrmConsSaidas.EdtHospital', '');

  EdtId.Enabled := False;
  EdtNomePaciente.Enabled := False;
  EdtAboPaciente.Enabled := False;
  EdtAboBolsa.Enabled := False;
  EdtTipo.Enabled := False;
  EdtVolume.Enabled := False;
  EdtId.Clear;
  DateTimePickerData.Date := now;
  EdtRegistroPaciente.Clear;
  EdtNomePaciente.Clear;
  EdtNumeroBolsa.Clear;
  EdtAboBolsa.Clear;
  EdtTipo.Clear;
  EdtVolume.Clear;
  RadioGroupPai.ItemIndex := 1;
  RadioGroupTA.ItemIndex := 0;
  RadioGroupAGH.ItemIndex := 0;
  RadioGroup37.ItemIndex := 0;
  ComboBoxResponsavel.SetFocus;

  BtnGravar.Enabled := true;

  Self.FId := -1;
  Self.FIdBolsa := -1;
  Self.FIdProcedimentosEspeciais := -1;
  Self.FNumBolsa := '-1';

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

    lBolsaDao := TBolsaDAO.Create(DMConexao.Conexao);
    try

      try

        if (lBolsaDao.getObjeto(pID_BOLSA, lBolsa)) then
        begin

          EdtNumeroBolsa.Text := lBolsa.NumeroBolsa;
          Self.FNumBolsa := lBolsa.NumeroBolsa;
          EdtTipo.Text := lBolsa.Tipo;
          EdtVolume.Text := lBolsa.VolumeAtual.ToString;
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

procedure TFrmSaida.CarregaDadosProcedEspeciais;
var
  lProcedimentoEspecial: TProcedimento_Especial;
  lProcedimentoEspecialDao: TProcedimento_EspecialDao;
begin

  Self.FIdProcedimentosEspeciais := TClassBibliotecaDao.getValorAtributo('procedimento_especial', 'id', 'id_saida',
    Self.FId, DMConexao.Conexao);

  lProcedimentoEspecial := TProcedimento_Especial.Create;
  try

    lProcedimentoEspecialDao := TProcedimento_EspecialDao.Create(DMConexao.Conexao);
    try

      if (lProcedimentoEspecialDao.getObjeto(Self.FIdProcedimentosEspeciais, lProcedimentoEspecial)) then
      begin
        RadioGroupIrradiada.ItemIndex := IfThen(lProcedimentoEspecial.Irradiacao = 'S', 0, 1);
        RadioGroupFiltrada.ItemIndex := IfThen(lProcedimentoEspecial.Filtracao = 'S', 0, 1);
        RadioGroupFracionada.ItemIndex := IfThen(lProcedimentoEspecial.Fracionamento = 'S', 0, 1);
        RadioGroupFenotipada.ItemIndex := IfThen(lProcedimentoEspecial.Fenotipagem = 'S', 0, 1);
      end;

    finally
      lProcedimentoEspecialDao.Destroy;
    end;

  finally
    lProcedimentoEspecial.Destroy;
  end;

end;

procedure TFrmSaida.CarregaDadosSaida;
var
  lSaida: TSaida;
  lSaidaDAO: TSaidaDAO;
begin

  lSaida := TSaida.Create;
  try

    lSaidaDAO := TSaidaDAO.Create(DMConexao.Conexao);
    try

      try

        if (lSaidaDAO.getObjeto(Self.FId, lSaida)) then
        begin

          EdtId.Text := lSaida.Id.ToString;
          EdtRegistroPaciente.Text := TClassBibliotecaDao.getValorAtributo('paciente', 'num_prontuario', 'id',
            lSaida.Id_Paciente, DMConexao.Conexao);
          EdtRegistroPacienteExit(Self);
          Self.CarregaDadosBolsa(lSaida.Id_Bolsa);
          EdtVolume.Text := lSaida.Volume.ToString;
          DateTimePickerData.Date := lSaida.Data_Saida;
          EdtHospital.Text := lSaida.Hospital;
          RadioGroupPai.ItemIndex := IfThen(lSaida.Pai = 'P', 0, 1);
          RadioGroupTA.ItemIndex := IfThen(lSaida.Prova_Compatibilidade_Ta = 'C', 0, 1);
          RadioGroupAGH.ItemIndex := IfThen(lSaida.Prova_Compatibilidade_Agh = 'C', 0, 1);
          RadioGroup37.ItemIndex := IfThen(lSaida.Prova_Compatibilidade_37 = 'C', 0, 1);
          Self.FIdBolsa := lSaida.Id_Bolsa;

          Self.CarregaDadosProcedEspeciais;

          setIndexByIdUsuario(lSaida.Id_Usuario);

          ComboBoxResponsavel.SetFocus;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(5), ['Sa�da de sangue', E.Message]));
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
  lBolsaDao: TBolsaDAO;
  lVerificaNumBolsa: Boolean;
begin

  if (not Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    if (Self.FId > 0) then
    begin
      lVerificaNumBolsa := ((Trim(Self.FNumBolsa) <> (EdtNumeroBolsa.Text)))
    end
    else
    begin
      lVerificaNumBolsa := true;
    end;

    if (lVerificaNumBolsa) then
    begin

      if (not TFrmSelBolsa.getSelBolsa(TForeignKeyForms.FIdUSaida, Self.FIdUsuario, Trim(EdtNumeroBolsa.Text),
        Self.FIdBolsa)) then
      begin
        EdtNumeroBolsa.SetFocus;
        exit;
      end;

      if (Self.FIdBolsa > 0) then
      begin

        lBolsaDao := TBolsaDAO.Create(DMConexao.Conexao);
        try

          try

            if (lBolsaDao.getPermiteMovimentacao(Self.FIdBolsa)) then
            begin

              Self.CarregaDadosBolsa(Self.FIdBolsa);
              EdtVolume.Enabled := true;
              EdtVolume.SetFocus;

            end
            else
            begin

              Self.FIdBolsa := -1;
              Application.MessageBox('Bolsa j� vinculado a uma sa�da', 'Aviso', MB_ICONWARNING + MB_OK);
              EdtNumeroBolsa.SetFocus;

            end;

          except
            on E: Exception do
            begin
              raise Exception.Create('Erro ao verificar se o n�mero da bolsa j� esta vinculado a uma sa�da. Motivo ' +
                E.Message);
              Self.FIdBolsa := -1;
              EdtNumeroBolsa.SetFocus;
            end;
          end;

        finally
          lBolsaDao.Destroy;
        end;

      end
      else
      begin

        if (Self.getBolsaJaVinculada) then
        begin
          Application.MessageBox('Bolsa j� vinculada a uma sa�da ou a um descarte.', 'Aviso', MB_ICONWARNING + MB_OK);
          EdtNumeroBolsa.SetFocus;
        end
        else
        begin
          Application.MessageBox('N�mero da bolsa n�o cadastrado', 'Aviso', MB_ICONWARNING + MB_OK);
          EdtNumeroBolsa.SetFocus;
        end;

      end;

    end;

  end
  else
  begin
    EdtVolume.Enabled := False;
  end;

end;

procedure TFrmSaida.EdtRegistroPacienteExit(Sender: TObject);
var
  lNomePaciente: string;
  lAboPaciente: string;
  lPacienteDao: TPacienteDAO;
begin

  if (not Trim(EdtRegistroPaciente.Text).IsEmpty) then
  begin

    lPacienteDao := TPacienteDAO.Create(DMConexao.Conexao);
    try

      if (lPacienteDao.getNomeEABO(Trim(EdtRegistroPaciente.Text), lNomePaciente, lAboPaciente)) then
      begin

        if (lNomePaciente <> '') then
        begin

          EdtNomePaciente.Text := lNomePaciente;
          EdtAboPaciente.Text := lAboPaciente;

        end
        else
        begin

          Application.MessageBox(PChar(Format(TMensagem.getMensagem(6), ['Paciente'])), 'Aviso',
            MB_OK + MB_ICONINFORMATION);

          EdtRegistroPaciente.SetFocus;

        end;

      end;

    finally
      lPacienteDao.Destroy;
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

  case (Key) of
    VK_F2:
      begin
        BtnConsPacienteClick(Self);
      end;

    VK_F3:
      begin
        btnCadPacienteClick(Self);
      end;
  end;

end;

procedure TFrmSaida.EdtVolumeExit(Sender: TObject);
var
  lVolumeAtual: Integer;
begin

  try
    lVolumeAtual := TClassBibliotecaDao.getValorAtributo('bolsa', 'volume_atual', 'id', Self.FIdBolsa,
      DMConexao.Conexao);

    if (StrToIntDef(EdtVolume.Text, 0) > lVolumeAtual) then
    begin
      Application.MessageBox(pWideChar('Voc� ultrapassou o volume m�ximo da bolsa de ' + lVolumeAtual.ToString + 'mL.'),
        'Aviso', MB_ICONWARNING + MB_OK);
      EdtVolume.SetFocus;
    end;

  except
    on E: Exception do
    begin
      Application.MessageBox(pWideChar(Format(TMensagem.getMensagem(1), ['volume da bolsa', E.Message])), 'Erro',
        MB_ICONERROR + MB_OK);
    end;
  end;

end;

procedure TFrmSaida.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  case (Key) of
    VK_F6:
      begin
        BtnGravarClick(Self);
      end;

    VK_F7:
      begin
        BtnNovoClick(Self);
      end;

    VK_ESCAPE:
      begin
        BtnSairClick(Self);
      end;
  end;

end;

procedure TFrmSaida.FormShow(Sender: TObject);
begin
  Self.CarregaUsuarios;

  if (Self.FId <> -1) then
  begin
    Self.CarregaDadosSaida;
  end
  else
  begin
    EdtHospital.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Hospital', 'FrmConsSaidas.EdtHospital', '');
    DateTimePickerData.Date := now;

    setIndexByIdUsuario(Self.FIdUsuario);
    ComboBoxResponsavel.SetFocus;

    Self.FIdBolsa := -1;
    Self.FIdProcedimentosEspeciais := -1;
    Self.FNumBolsa := '1';
  end;

end;

procedure TFrmSaida.CarregaUsuarios;
var
  lListaUsuario: TObjectList<TUsuario>;
  lUsuarioDAO: TUsuarioDAO;
  lCount: Integer;
begin
  ComboBoxResponsavel.Clear;

  lListaUsuario := TObjectList<TUsuario>.Create();
  try

    lUsuarioDAO := TUsuarioDAO.Create(DMConexao.Conexao);
    try

      if (lUsuarioDAO.getListaObjeto(lListaUsuario)) then
      begin

        for lCount := 0 to lListaUsuario.Count - 1 do
        begin
          ComboBoxResponsavel.Items.Add(lListaUsuario.Items[lCount].Id.ToString + ' - ' + lListaUsuario.Items
            [lCount].Nome);
        end;

      end
      else
      begin
        Application.MessageBox('N�o h� usu�rios cadastrados. Cadastre antes de efetuar uma sa�da.', 'Aviso',
          MB_ICONWARNING + MB_OK);
      end;

    finally
      lUsuarioDAO.Destroy;
    end;

  finally
    lListaUsuario.Free;
  end;
end;

procedure TFrmSaida.setIndexByIdUsuario(const pIdUsuario: Integer);
var
  lCount: SmallInt;
begin

  ComboBoxResponsavel.ItemIndex := -1;
  for lCount := 0 to ComboBoxResponsavel.Items.Count - 1 do
  begin

    if (TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items[lCount]) = pIdUsuario) then
    begin
      ComboBoxResponsavel.ItemIndex := lCount;
    end;

  end;

end;

function TFrmSaida.getBolsaJaVinculada: Boolean;
var
  lVinculadaASaida: Boolean;
  lVinculadaADescarte: Boolean;

  lSaidaDAO: TSaidaDAO;
  lDescarteDAO: TDescarteDAO;
begin
  Result := False;

  lSaidaDAO := TSaidaDAO.Create(DMConexao.Conexao);
  try
    lVinculadaASaida := lSaidaDAO.getBolsaJaVinculada(Trim(EdtNumeroBolsa.Text));
  finally
    lSaidaDAO.Destroy;
  end;

  lDescarteDAO := TDescarteDAO.Create(DMConexao.Conexao);
  try
    lVinculadaADescarte := lDescarteDAO.getBolsaJaVinculada(Trim(EdtNumeroBolsa.Text));
  finally
    lDescarteDAO.Destroy;
  end;

  Result := lVinculadaASaida or lVinculadaADescarte;

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
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de sa�da de sangue', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmSaida);
  end;

end;

function TFrmSaida.getSangueCompativel: Boolean;
const
  lDoacaoTipoAPositivo: array [0 .. 3] of string = ('A+', 'A-', 'O+', 'O-');
  lDoacaoTipoANegativo: array [0 .. 1] of string = ('A-', 'O-');

  lDoacaoTipoBPositivo: array [0 .. 3] of string = ('B+', 'B-', 'O+', 'O-');
  lDoacaoTipoBNegativo: array [0 .. 1] of string = ('B-', 'O-');

  lDoacaoTipoABPositivo: array [0 .. 7] of string = ('A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-');
  lDoacaoTipoABNegativo: array [0 .. 3] of string = ('A-', 'B-', 'O-', 'AB-');

  lDoacaoTipoOPositivo: array [0 .. 1] of string = ('O+', 'O-');
  lDoacaoTipoONegativo: array [0 .. 0] of string = ('O-');

var
  lCount: Integer;

begin

  Result := False;

  case (AnsiIndexStr(UpperCase(EdtAboPaciente.Text), ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'])) of
    0: // A+
      begin

        for lCount := 0 to 3 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoAPositivo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;

      end;

    1: // A-
      begin

        for lCount := 0 to 1 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoANegativo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;

      end;

    2: // B+
      begin
        for lCount := 0 to 3 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoBPositivo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;
      end;

    3: // B-
      begin

        for lCount := 0 to 1 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoBNegativo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;

      end;

    4: // AB+
      begin

        for lCount := 0 to 7 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoABPositivo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;

      end;

    5: // AB-
      begin

        for lCount := 0 to 3 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoABNegativo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;

      end;

    6: // O+
      begin

        for lCount := 0 to 1 do
        begin

          if (EdtAboBolsa.Text = lDoacaoTipoOPositivo[lCount]) then
          begin
            Result := true;
            Break;
          end;

        end;

      end;

    7: // O-
      begin

        if (EdtAboBolsa.Text = lDoacaoTipoONegativo[0]) then
        begin
          Result := true;
        end;

      end;
  end;

end;

function TFrmSaida.SalvaProcedimentoEspeciais: Boolean;
var
  lProcedimetoEspecialDao: TProcedimento_EspecialDao;
  lProcedimetoEspecial: TProcedimento_Especial;
begin

  lProcedimetoEspecial := TProcedimento_Especial.Create;
  try

    lProcedimetoEspecial.Id := Self.FIdProcedimentosEspeciais;
    lProcedimetoEspecial.Id_Saida := Self.FId;
    lProcedimetoEspecial.Id_Descarte := -1;
    lProcedimetoEspecial.Irradiacao := Copy(RadioGroupIrradiada.Items[RadioGroupIrradiada.ItemIndex], 1, 1);
    lProcedimetoEspecial.Filtracao := Copy(RadioGroupFiltrada.Items[RadioGroupFiltrada.ItemIndex], 1, 1);
    lProcedimetoEspecial.Fracionamento := Copy(RadioGroupFracionada.Items[RadioGroupFracionada.ItemIndex], 1, 1);
    lProcedimetoEspecial.Fenotipagem := Copy(RadioGroupFenotipada.Items[RadioGroupFenotipada.ItemIndex], 1, 1);

    lProcedimetoEspecialDao := TProcedimento_EspecialDao.Create(DMConexao.Conexao);
    try

      try
        Result := lProcedimetoEspecialDao.Salvar(lProcedimetoEspecial);
      except
        on E: Exception do
        begin
          Result := False;
          raise Exception.Create(Format(TMensagem.getMensagem(4), ['procedimentos especias', E.Message]));
        end;
      end;

    finally
      lProcedimetoEspecialDao.Destroy;
    end;

  finally
    lProcedimetoEspecial.Destroy;
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
      EdtRegistroPaciente.Text, DMConexao.Conexao);

    lSaida.Id_Usuario := TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items[ComboBoxResponsavel.ItemIndex]);

    lSaida.Id_Bolsa := Self.FIdBolsa;
    lSaida.Data_Saida := now;
    lSaida.Hospital := EdtHospital.Text;
    lSaida.Pai := Copy(RadioGroupPai.Items[RadioGroupPai.ItemIndex], 1, 1);
    lSaida.Prova_Compatibilidade_Ta := Copy(RadioGroupTA.Items[RadioGroupTA.ItemIndex], 1, 1);
    lSaida.Prova_Compatibilidade_Agh := Copy(RadioGroupAGH.Items[RadioGroupAGH.ItemIndex], 1, 1);
    lSaida.Prova_Compatibilidade_37 := Copy(RadioGroup37.Items[RadioGroup37.ItemIndex], 1, 1);
    lSaida.Volume := StrToInt(EdtVolume.Text);

    lSaidaDAO := TSaidaDAO.Create(DMConexao.Conexao);
    try

      try

        Result := lSaidaDAO.Salvar(lSaida);
        if (Result) then
        begin
          Self.FId := lSaida.Id;
        end;

      except
        on E: Exception do
        begin
          Result := False;
          raise Exception.Create(Format(TMensagem.getMensagem(4), ['Sa�da de sangue', E.Message]));
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
