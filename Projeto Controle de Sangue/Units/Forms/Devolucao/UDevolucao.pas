unit UDevolucao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Mask;

type
  TFrmDevolucao = class(TForm)
    PanelClient: TPanel;
    GroupBoxSangue: TGroupBox;
    EdtAboBolsa: TEdit;
    EdtNumeroBolsa: TEdit;
    EdtTipo: TEdit;
    LabelVolume: TLabel;
    LabelAboSangue: TLabel;
    LabelNumeroBolsa: TLabel;
    LabelTipo: TLabel;
    PanelBottom: TPanel;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    EdtId: TEdit;
    LabelId: TLabel;
    EdtVolume: TEdit;
    EdtDataDevolucao: TDateTimePicker;
    LabelData: TLabel;
    BtnNovo: TBitBtn;
    LabelResponsavel: TLabel;
    ComboBoxResponsavel: TComboBox;
    Label2: TLabel;
    EdtMotivoDevolucao: TEdit;
    LabelMotivo: TLabel;
    LabelOrigemDevolucao: TLabel;
    EdtOrgiemDevolucao: TEdit;
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtNumeroBolsaExit(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtVolumeExit(Sender: TObject);
    procedure EdtNumeroBolsaKeyPress(Sender: TObject; var Key: Char);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FId: Integer;
    FIdBolsa: Integer;
    FNumBolsa: string;

    procedure CarregaDadosDevolucao;

    procedure CarregaUsuarios;

    procedure setIndexByIdUsuario(const pIdUsuario: Integer);

    procedure CarregaDadosBolsa(const pID_BOLSA: Integer);

    function SalvaDevolucao: Boolean;

    function getBolsaJaVinculada: Boolean;

  public
    class function getDevolucao(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      const pID: Integer = -1): Boolean;
  end;

var
  FrmDevolucao: TFrmDevolucao;

implementation

uses System.Math, UDMConexao, UClassMensagem, UClassBiblioteca, UClassBibliotecaDao,
  UClassForeignKeyForms, UClassBolsa, UClassBolsaDao, System.Generics.Collections, UClassUsuario,
  UClassUsuarioDAO, UAutenticacao, USelBolsa, UClassDescarteDao, System.StrUtils, UClassDevolucao, UClassDevolucaoDao,
  UClassSaidaDao;

{$R *.dfm}
{ TFrmDevolucao }

procedure TFrmDevolucao.BtnGravarClick(Sender: TObject);
begin

  if (ComboBoxResponsavel.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelResponsavel.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxResponsavel.SetFocus;

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

  if (Trim(EdtMotivoDevolucao.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelMotivo.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtVolume.SetFocus;

    exit;

  end;

  if (Trim(EdtOrgiemDevolucao.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelOrigemDevolucao.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtVolume.SetFocus;

    exit;

  end;

  if (TFrmAutenticacao.getAutenticacao(TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items
    [ComboBoxResponsavel.ItemIndex]))) then
  begin

    if (Self.SalvaDevolucao) then
    begin

      EdtId.Text := Self.FId.ToString;

      TBiblioteca.AtivaDesativaCompontes(Self, False);

      Application.MessageBox(PChar(TMensagem.getMensagem(32)), 'Informação', MB_ICONINFORMATION + MB_OK);

      TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'Devolucao', 'FrmDevolucao.EdtMotivoDevolucao',
        Trim(EdtMotivoDevolucao.Text));

      TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'Devolucao', 'FrmDevolucao.EdtOrgiemDevolucao',
        Trim(EdtOrgiemDevolucao.Text));

      BtnGravar.Enabled := False;

      BtnNovo.SetFocus;

    end;

  end;

end;

procedure TFrmDevolucao.BtnNovoClick(Sender: TObject);
var
  lUltimoUsu: Integer;
begin

  TBiblioteca.AtivaDesativaCompontes(Self, true);

  EdtId.Enabled := False;
  EdtAboBolsa.Enabled := False;
  EdtTipo.Enabled := False;
  EdtVolume.Enabled := False;
  EdtId.Clear;
  EdtDataDevolucao.Date := now;
  EdtNumeroBolsa.Clear;
  EdtAboBolsa.Clear;
  EdtTipo.Clear;
  EdtVolume.Clear;
  ComboBoxResponsavel.SetFocus;

  EdtMotivoDevolucao.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Devolucao',
    'FrmDevolucao.EdtMotivoDevolucao', '');

  EdtOrgiemDevolucao.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Devolucao',
    'FrmDevolucao.EdtOrgiemDevolucao', '');

  BtnGravar.Enabled := true;

  Self.FId := -1;
  Self.FIdBolsa := -1;
  Self.FNumBolsa := '-1';

end;

procedure TFrmDevolucao.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmDevolucao.CarregaDadosBolsa(const pID_BOLSA: Integer);
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

          if (lBolsa.NumeroDoacoes > 0) then
          begin
            EdtNumeroBolsa.Text := lBolsa.NumeroBolsa + '-' + lBolsa.NumeroDoacoes.ToString;
          end
          else
          begin
            EdtNumeroBolsa.Text := lBolsa.NumeroBolsa;
          end;

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

procedure TFrmDevolucao.CarregaDadosDevolucao;
var
  lDevolucao: TDevolucao;
  lDevolucaoDAO: TDevolucaoDAO;
begin

  lDevolucao := TDevolucao.Create;
  try

    lDevolucaoDAO := TDevolucaoDAO.Create(DMConexao.Conexao);
    try

      try

        if (lDevolucaoDAO.getObjeto(Self.FId, lDevolucao)) then
        begin

          EdtId.Text := lDevolucao.Id.ToString;
          Self.CarregaDadosBolsa(lDevolucao.Id_Bolsa);
          EdtVolume.Text := lDevolucao.Volume.ToString;
          EdtDataDevolucao.Date := lDevolucao.Data_Devolucao;
          EdtMotivoDevolucao.Text := lDevolucao.Motivo_Devolucao;
          EdtOrgiemDevolucao.Text := lDevolucao.Origem_Devolucao;
          Self.FIdBolsa := lDevolucao.Id_Bolsa;

          setIndexByIdUsuario(lDevolucao.Id_Usuario);

          ComboBoxResponsavel.SetFocus;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(5), ['devolução de sangue', E.Message]));
        end;
      end;

    finally
      lDevolucaoDAO.Destroy;
    end;

  finally
    lDevolucao.Destroy;
  end;

end;

procedure TFrmDevolucao.EdtNumeroBolsaExit(Sender: TObject);
var
  lBolsaDao: TBolsaDAO;
  lVerificaNumBolsa: Boolean;
  lPos: Integer;
  lNumeroBolsa: string;
begin

  if (not Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    lPos := Pos('-', Trim(EdtNumeroBolsa.Text));

    if (lPos <> 0) then
    begin

      if (Copy(Trim(EdtNumeroBolsa.Text), lPos + 1, Trim(EdtNumeroBolsa.Text).Length).Trim = '') then
      begin
        lNumeroBolsa := Copy(Trim(EdtNumeroBolsa.Text), 0, Trim(EdtNumeroBolsa.Text).Length - 1).Trim;
      end
      else
      begin
        lNumeroBolsa := Copy(Trim(EdtNumeroBolsa.Text), 0, lPos - 1).Trim;
      end;

    end
    else
    begin
      lNumeroBolsa := Trim(EdtNumeroBolsa.Text);
    end;

    if (Self.FId > 0) then
    begin
      lVerificaNumBolsa := ((Trim(Self.FNumBolsa) <> (lNumeroBolsa)))
    end
    else
    begin
      lVerificaNumBolsa := true;
    end;

    if (lVerificaNumBolsa) then
    begin

      if (not TFrmSelBolsa.getSelBolsa(TForeignKeyForms.FIdUDevolucao, Self.FIdUsuario, lNumeroBolsa, Self.FIdBolsa))
      then
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
              Application.MessageBox('Bolsa de sangue já vinculado a alguma movimentação.', 'Aviso',
                MB_ICONWARNING + MB_OK);
              EdtNumeroBolsa.SetFocus;

            end;

          except
            on E: Exception do
            begin
              Self.FIdBolsa := -1;
              EdtNumeroBolsa.SetFocus;
              raise Exception.Create('Erro ao verificar se o número da bolsa já esta vinculado a uma saída. Motivo ' +
                E.Message);
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
          Application.MessageBox('Bolsa já vinculada a uma saída, descarte ou devolução.', 'Aviso',
            MB_ICONWARNING + MB_OK);
          EdtNumeroBolsa.SetFocus;
        end
        else
        begin
          Application.MessageBox('Número da bolsa não cadastrado', 'Aviso', MB_ICONWARNING + MB_OK);
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

procedure TFrmDevolucao.EdtNumeroBolsaKeyPress(Sender: TObject; var Key: Char);
begin

  if (Key in ['-']) then
  begin

    if (Pos('-', Trim(EdtNumeroBolsa.Text)) > 0) then
    begin
      Key := #0;
    end;

  end
  else if (not(Key in ['0' .. '9', #8])) then
  begin
    Key := #0;
  end;

end;

procedure TFrmDevolucao.EdtVolumeExit(Sender: TObject);
var
  lVolumeAtual: Integer;
begin

  try

    lVolumeAtual := TClassBibliotecaDao.getValorAtributo('bolsa', 'volume_atual', 'id', Self.FIdBolsa,
      DMConexao.Conexao);

    if (StrToIntDef(EdtVolume.Text, 0) > lVolumeAtual) then
    begin
      Application.MessageBox(pWideChar('Você ultrapassou o volume máximo da bolsa de ' + lVolumeAtual.ToString + 'mL.'),
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

procedure TFrmDevolucao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmDevolucao.FormShow(Sender: TObject);
begin

  Self.CarregaUsuarios;

  if (Self.FId > 0) then
  begin
    Self.CarregaDadosDevolucao;
  end
  else
  begin

    BtnNovoClick(Self);

    setIndexByIdUsuario(Self.FIdUsuario);
    ComboBoxResponsavel.SetFocus;

  end;

end;

procedure TFrmDevolucao.CarregaUsuarios;
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
        Application.MessageBox('Não há usuários cadastrados. Cadastre antes de efetuar uma saída.', 'Aviso',
          MB_ICONWARNING + MB_OK);
      end;

    finally
      lUsuarioDAO.Destroy;
    end;

  finally
    lListaUsuario.Free;
  end;
end;

procedure TFrmDevolucao.setIndexByIdUsuario(const pIdUsuario: Integer);
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

function TFrmDevolucao.getBolsaJaVinculada: Boolean;
var
  lVinculadaASaida: Boolean;
  lVinculadaADescarte: Boolean;
  lVinculadaADevolucao: Boolean;

  lSaidaDAO: TSaidaDAO;
  lDescarteDAO: TDescarteDAO;
  lDevolucaoDAO: TDevolucaoDAO;
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

  lDevolucaoDAO := TDevolucaoDAO.Create(DMConexao.Conexao);
  try
    lVinculadaADevolucao := lDevolucaoDAO.getBolsaJaVinculada(Trim(EdtNumeroBolsa.Text));
  finally
    lDevolucaoDAO.Destroy;
  end;

  Result := lVinculadaASaida or lVinculadaADescarte or lVinculadaADevolucao;

end;

class function TFrmDevolucao.getDevolucao(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
  const pID: Integer = -1): Boolean;
begin

  Application.CreateForm(TFrmDevolucao, FrmDevolucao);
  try

    try

      FrmDevolucao.FForeignFormKey := pFOREIGNFORMKEY;
      FrmDevolucao.FIdUsuario := pID_USUARIO;

      FrmDevolucao.FId := pID;

      Result := FrmDevolucao.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de devolução de sangue', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmDevolucao);
  end;

end;

function TFrmDevolucao.SalvaDevolucao: Boolean;
var
  lDevolucao: TDevolucao;
  lDevolucaoDAO: TDevolucaoDAO;
begin

  lDevolucao := TDevolucao.Create;
  try

    lDevolucao.Id := StrToIntDef(EdtId.Text, -1);
    lDevolucao.Id_Usuario := TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items[ComboBoxResponsavel.ItemIndex]);
    lDevolucao.Id_Bolsa := Self.FIdBolsa;
    lDevolucao.Data_Devolucao := EdtDataDevolucao.Date;
    lDevolucao.Origem_Devolucao := EdtOrgiemDevolucao.Text;
    lDevolucao.Motivo_Devolucao := EdtMotivoDevolucao.Text;
    lDevolucao.Volume := StrToInt(EdtVolume.Text);

    lDevolucaoDAO := TDevolucaoDAO.Create(DMConexao.Conexao);
    try

      try

        Result := lDevolucaoDAO.Salvar(lDevolucao);
        if (Result) then
        begin
          Self.FId := lDevolucao.Id;
        end;

      except
        on E: Exception do
        begin
          Result := False;
          raise Exception.Create(Format(TMensagem.getMensagem(4), ['devolução de sangue', E.Message]));
        end;
      end;

    finally
      lDevolucaoDAO.Destroy;
    end;

  finally
    lDevolucao.Destroy;
  end;

end;

end.
