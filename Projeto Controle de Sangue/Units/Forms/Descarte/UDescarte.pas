unit UDescarte;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmDescarte = class(TForm)
    PanelBottom: TPanel;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    BtnNovo: TBitBtn;
    PanelClient: TPanel;
    LabelId: TLabel;
    LabelData: TLabel;
    LabelResponsavel: TLabel;
    GroupBoxSangue: TGroupBox;
    LabelVolume: TLabel;
    LabelAboSangue: TLabel;
    LabelNumeroBolsa: TLabel;
    LabelTipo: TLabel;
    Label2: TLabel;
    EdtAboBolsa: TEdit;
    EdtNumeroBolsa: TEdit;
    EdtTipo: TEdit;
    EdtVolume: TEdit;
    EdtId: TEdit;
    EdtDataDescarte: TDateTimePicker;
    ComboBoxResponsavel: TComboBox;
    LabelMotivo: TLabel;
    GroupBox1: TGroupBox;
    RadioGroupIrradiada: TRadioGroup;
    RadioGroupFiltrada: TRadioGroup;
    RadioGroupFracionada: TRadioGroup;
    RadioGroupFenotipada: TRadioGroup;
    EdtMotivoDescarte: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure EdtNumeroBolsaExit(Sender: TObject);
    procedure EdtVolumeExit(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FId: Integer;
    FIdBolsa: Integer;
    FIdProcedimentosEspeciais: Integer;
    FNumBolsa: string;

    procedure CarregaUsuarios;

    procedure setIndexByIdUsuario(const pIDUSUARIO: Integer);

    function CarregaDadosDoDescarte: Boolean;

    procedure CarregaDadosBolsa(const pID_BOLSA: Integer);

    procedure CarregaDadosProcedEspeciais;

    function SalvaDescarte: Boolean;

    function SalvaProcedimentoEspeciais: Boolean;

    function getBolsaJaVinculada: Boolean;
  public
    class function getDescarte(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      const pID: Integer = -1): Boolean;

  end;

var
  FrmDescarte: TFrmDescarte;

implementation

{$R *.dfm}
{ TForm2 }

uses System.Generics.Collections, UClassUsuario, UClassUsuarioDao, UDMConexao, UClassBiblioteca, UClassMensagem,
  UClassSaida, UClassSaidaDao, UClassBolsaDao, UClassBolsa, System.Math, UClassDescarte, UClassDescarteDao, USelBolsa,
  UClassForeignKeyForms, UClassProcedimento_Especial, UClassProcedimento_EspecialDao, UAutenticacao,
  UClassBibliotecaDao;

procedure TFrmDescarte.BtnGravarClick(Sender: TObject);
begin
  if (ComboBoxResponsavel.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelResponsavel.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxResponsavel.SetFocus;

    exit;

  end;

  if (Trim(EdtMotivoDescarte.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelMotivo.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtMotivoDescarte.SetFocus;

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

  if (TFrmAutenticacao.getAutenticacao(TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items
    [ComboBoxResponsavel.ItemIndex]))) then
  begin

    if (Self.SalvaDescarte) then
    begin

      if (Self.SalvaProcedimentoEspeciais) then
      begin
        EdtId.Text := Self.FId.ToString;

        TBiblioteca.AtivaDesativaCompontes(Self, False);

        Application.MessageBox(PChar(TMensagem.getMensagem(28)), 'Informa��o', MB_ICONINFORMATION + MB_OK);

        BtnGravar.Enabled := False;

        TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'Descarte', 'FrmDescarte.EdtMotivoDescarte',
          Trim(EdtMotivoDescarte.Text));

        BtnNovo.SetFocus;
      end;

    end;

  end;
end;

procedure TFrmDescarte.BtnNovoClick(Sender: TObject);
begin
  TBiblioteca.AtivaDesativaCompontes(Self, true);

  EdtId.Enabled := False;
  EdtAboBolsa.Enabled := False;
  EdtTipo.Enabled := False;
  EdtVolume.Enabled := False;
  EdtId.Clear;
  EdtDataDescarte.Date := now;
  EdtNumeroBolsa.Clear;
  EdtAboBolsa.Clear;
  EdtTipo.Clear;
  EdtVolume.Clear;
  RadioGroupIrradiada.ItemIndex := 1;
  RadioGroupFiltrada.ItemIndex := 1;
  RadioGroupFracionada.ItemIndex := 1;
  RadioGroupFenotipada.ItemIndex := 1;
  EdtMotivoDescarte.Clear;
  ComboBoxResponsavel.SetFocus;

  EdtMotivoDescarte.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Descarte',
    'FrmDescarte.EdtMotivoDescarte', '');

  BtnGravar.Enabled := true;

  Self.FId := -1;
  Self.FIdBolsa := -1;
  Self.FNumBolsa := '-1';
  Self.FIdProcedimentosEspeciais := -1;

end;

procedure TFrmDescarte.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmDescarte.CarregaDadosBolsa(const pID_BOLSA: Integer);
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

procedure TFrmDescarte.CarregaDadosProcedEspeciais;
var
  lProcedimentoEspecial: TProcedimento_Especial;
  lProcedimentoEspecialDao: TProcedimento_EspecialDao;
begin

  Self.FIdProcedimentosEspeciais := TClassBibliotecaDao.getValorAtributo('procedimento_especial', 'id', 'id_descarte',
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

procedure TFrmDescarte.CarregaUsuarios;
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

procedure TFrmDescarte.EdtNumeroBolsaExit(Sender: TObject);
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

procedure TFrmDescarte.EdtVolumeExit(Sender: TObject);
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

procedure TFrmDescarte.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmDescarte.FormShow(Sender: TObject);
begin

  Self.CarregaUsuarios;

  if (Self.FId <> -1) then
  begin
    Self.CarregaDadosDoDescarte;
  end
  else
  begin

    EdtDataDescarte.Date := now;

    EdtMotivoDescarte.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Descarte',
      'FrmDescarte.EdtMotivoDescarte', '');

    setIndexByIdUsuario(Self.FIdUsuario);
    ComboBoxResponsavel.SetFocus;

    Self.FIdBolsa := -1;
    Self.FIdProcedimentosEspeciais := -1;
    Self.FNumBolsa := '-1';
  end;

end;

function TFrmDescarte.getBolsaJaVinculada: Boolean;
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

class function TFrmDescarte.getDescarte(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO, pID: Integer): Boolean;
begin

  Application.CreateForm(TFrmDescarte, FrmDescarte);
  try

    try

      FrmDescarte.FForeignFormKey := pFOREIGNFORMKEY;
      FrmDescarte.FIdUsuario := pID_USUARIO;

      FrmDescarte.FId := pID;

      Result := FrmDescarte.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de descarte de sangue', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmDescarte);
  end;

end;

function TFrmDescarte.CarregaDadosDoDescarte: Boolean;
var
  lDescarte: TDescarte;
  lDescarteDAO: TDescarteDAO;
begin

  lDescarte := TDescarte.Create;
  try

    lDescarteDAO := TDescarteDAO.Create(DMConexao.Conexao);
    try

      try

        Result := lDescarteDAO.getObjeto(Self.FId, lDescarte);
        if (Result) then
        begin
          EdtId.Text := lDescarte.Id.ToString;
          Self.CarregaDadosBolsa(lDescarte.Id_Bolsa);

          EdtMotivoDescarte.Text := lDescarte.Motivo;
          EdtVolume.Text := lDescarte.Volume.ToString;
          EdtDataDescarte.Date := lDescarte.Data_Descarte;
          Self.FIdBolsa := lDescarte.Id_Bolsa;

          Self.CarregaDadosProcedEspeciais;

          setIndexByIdUsuario(lDescarte.Id_Usuario);

          ComboBoxResponsavel.SetFocus;
        end;

      except
        on E: Exception do
        begin
          Result := False;
          Application.MessageBox(pWideChar(Format(TMensagem.getMensagem(30), [E.Message])), 'Erro',
            MB_ICONERROR + MB_OK);
        end;
      end;

    finally
      lDescarteDAO.Destroy;
    end;

  finally
    lDescarte.Destroy;
  end;

end;

function TFrmDescarte.SalvaDescarte: Boolean;
var
  lDescarte: TDescarte;
  lDescarteDAO: TDescarteDAO;
begin

  lDescarte := TDescarte.Create;
  try

    lDescarte.Id := Self.FId;
    lDescarte.Id_Bolsa := Self.FIdBolsa;
    lDescarte.Id_Usuario := TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items[ComboBoxResponsavel.ItemIndex]);
    lDescarte.Data_Coleta := TClassBibliotecaDao.getValorAtributo('bolsa', 'data_coleta', 'id', Self.FIdBolsa,
      DMConexao.Conexao);
    lDescarte.Motivo := EdtMotivoDescarte.Text;
    lDescarte.Volume := StrToInt(EdtVolume.Text);
    lDescarte.Data_Descarte := EdtDataDescarte.Date;

    lDescarteDAO := TDescarteDAO.Create(DMConexao.Conexao);
    try

      try

        Result := lDescarteDAO.Salvar(lDescarte);
        if (Result) then
        begin
          Self.FId := lDescarte.Id;
        end;

      except
        on E: Exception do
        begin
          Result := False;
          Application.MessageBox(pWideChar(Format(TMensagem.getMensagem(4), ['retirada de sangue', E.Message])),
            'Aviso', MB_ICONWARNING + MB_OK);
        end;
      end;

    finally
      lDescarteDAO.Destroy;
    end;

  finally
    lDescarte.Destroy;
  end;

end;

function TFrmDescarte.SalvaProcedimentoEspeciais: Boolean;
var
  lProcedimetoEspecialDao: TProcedimento_EspecialDao;
  lProcedimetoEspecial: TProcedimento_Especial;
begin

  lProcedimetoEspecial := TProcedimento_Especial.Create;
  try

    lProcedimetoEspecial.Id := Self.FIdProcedimentosEspeciais;
    lProcedimetoEspecial.Id_Saida := -1;
    lProcedimetoEspecial.Id_Descarte := Self.FId;
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

procedure TFrmDescarte.setIndexByIdUsuario(const pIDUSUARIO: Integer);
var
  lCount: SmallInt;
begin

  ComboBoxResponsavel.ItemIndex := -1;
  for lCount := 0 to ComboBoxResponsavel.Items.Count - 1 do
  begin

    if (TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items[lCount]) = pIDUSUARIO) then
    begin
      ComboBoxResponsavel.ItemIndex := lCount;
    end;

  end;

end;

end.
