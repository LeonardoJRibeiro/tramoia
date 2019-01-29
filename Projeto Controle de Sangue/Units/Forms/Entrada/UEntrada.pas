unit UEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls,
  UClassBolsaDAO, UClassBiblioteca;

type
  TFrmEntrada = class(TForm)
    PanelClient: TPanel;
    PanelBottom: TPanel;
    EdtDataEntrada: TDateTimePicker;
    LabelData: TLabel;
    LabelNumeroBolsa: TLabel;
    EdtNumeroBolsa: TEdit;
    EdtOrigem: TEdit;
    LabelOrigem: TLabel;
    LabelTipo: TLabel;
    LabelAboSangue: TLabel;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    EdtVolume: TEdit;
    LabelVolume: TLabel;
    EdtOrdemSaida: TEdit;
    LabelOrdemSaida: TLabel;
    BtnNovo: TBitBtn;
    ComboBoxAboBolsa: TComboBox;
    ComboBoxTipo: TComboBox;
    ComboBoxResponsavel: TComboBox;
    LabelResponsavel: TLabel;
    Label1: TLabel;
    RadioGroupPai: TRadioGroup;
    GroupBoxProvaCompatibilidade: TGroupBox;
    RadioGroupSifilis: TRadioGroup;
    RadioGroupChagas: TRadioGroup;
    RadioGroupHepatiteB: TRadioGroup;
    RadioGroupHepatiteC: TRadioGroup;
    RadioGroupHIV: TRadioGroup;
    RadioGroupHTLV: TRadioGroup;
    RadioGroupHemoglobina: TRadioGroup;
    LabelDataDeVencimento: TLabel;
    EdtDataVencimento: TDateTimePicker;
    LabelDtColeta: TLabel;
    EdtDataColeta: TDateTimePicker;
    procedure FormShow(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure ComboBoxAboBolsaEnter(Sender: TObject);
    procedure ComboBoxTipoEnter(Sender: TObject);
    procedure ComboBoxTipoExit(Sender: TObject);
    procedure EdtNumeroBolsaKeyPress(Sender: TObject; var Key: Char);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FId: Integer;
    FIdBolsa: Integer;
    FNumBolsa: string;
    FTipo: string;

    procedure CarregaUsuarios;
    procedure setIndexByIdUsuario(pIdUsuario: Integer);

    function CarregaObjetos: Boolean;
    function CarregaDadosEntrada: Boolean;
    function CarregaDadosBolsa: Boolean;

    function getExisteBolsa: Boolean;

    function SalvaBolsa: Boolean;
    function SalvaEntrada: Boolean;

  public
    class function getEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
      const pID: Integer = -1): Boolean;
  end;

var
  FrmEntrada: TFrmEntrada;

implementation

{$R *.dfm}

{ TFrmEntradaSaida }
uses System.StrUtils, UClassForeignKeyForms, UClassMensagem, UClassEntrada, UClassEntradaDao, UDMConexao,
  UClassSaidaDao, UClassBolsa, UClassBibliotecaDao, System.Generics.Collections, UClassUsuario, UClassUsuarioDao,
  UAutenticacao, System.Math;

procedure TFrmEntrada.BtnGravarClick(Sender: TObject);
var
  lBolsa: TBolsa;
  lBolsaDao: TBolsaDao;

  lEntrada: TEntrada;
  lEntradaDAO: TEntradaDAO;
begin

  if (ComboBoxResponsavel.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelResponsavel.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxResponsavel.SetFocus;

    Exit;

  end;

  if (Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelNumeroBolsa.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtNumeroBolsa.SetFocus;

    Exit;

  end;

  if (ComboBoxTipo.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelTipo.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxTipo.SetFocus;

    Exit;

  end;

  if (getExisteBolsa) then
  begin
    Exit;
  end;

  if (Trim(EdtVolume.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelVolume.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtVolume.SetFocus;

    Exit;

  end;

  if (ComboBoxAboBolsa.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelAboSangue.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxAboBolsa.SetFocus;

    Exit;

  end;

  if (Trim(EdtOrigem.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelOrigem.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtOrigem.SetFocus;

    Exit;

  end;

  if (TFrmAutenticacao.getAutenticacao(TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items
    [ComboBoxResponsavel.ItemIndex]))) then
  begin

    if (Self.SalvaBolsa) then
    begin

      if (Self.SalvaEntrada) then
      begin

        EdtOrdemSaida.Text := Self.FId.ToString;

        BtnGravar.Enabled := False;

        TBiblioteca.AtivaDesativaCompontes(FrmEntrada, False);

        Application.MessageBox(PChar(TMensagem.getMensagem(23)), 'Aviso', MB_OK + MB_ICONINFORMATION);

        BtnNovo.SetFocus;

        TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'Origem', 'FrmEntrada.EdtOrigem', Trim(EdtOrigem.Text));

      end;

    end;

  end;

end;

procedure TFrmEntrada.BtnNovoClick(Sender: TObject);
begin
  EdtOrigem.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Origem', 'FrmEntrada.EdtOrigem', '');

  EdtDataEntrada.Date := Now;
  EdtDataVencimento.Date := Now;
  EdtDataColeta.Date := Now;

  TBiblioteca.AtivaDesativaCompontes(Self, True);

  BtnGravar.Enabled := True;
  EdtOrdemSaida.Enabled := False;
  EdtOrdemSaida.Clear;
  EdtNumeroBolsa.Clear;
  ComboBoxTipo.ItemIndex := 0;
  EdtVolume.Clear;
  ComboBoxAboBolsa.ItemIndex := -1;
  RadioGroupPai.ItemIndex := 1;
  RadioGroupSifilis.ItemIndex := 1;
  RadioGroupChagas.ItemIndex := 1;
  RadioGroupHepatiteB.ItemIndex := 1;
  RadioGroupHepatiteC.ItemIndex := 1;
  RadioGroupHIV.ItemIndex := 1;
  RadioGroupHTLV.ItemIndex := 1;
  RadioGroupHemoglobina.ItemIndex := 1;

  Self.FId := -1;
  Self.FIdBolsa := -1;
  Self.FNumBolsa := '-1';
  Self.FTipo := '-1';

  ComboBoxResponsavel.SetFocus;
end;

procedure TFrmEntrada.BtnSairClick(Sender: TObject);
begin
  Close;
end;

function TFrmEntrada.CarregaDadosBolsa: Boolean;
var
  lBolsaDao: TBolsaDao;
  lBolsa: TBolsa;
begin

  lBolsaDao := TBolsaDao.Create(DMConexao.Conexao);
  try

    lBolsa := TBolsa.Create;
    try

      try

        Result := lBolsaDao.getObjeto(Self.FIdBolsa, lBolsa);
        if (Result) then
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
          Self.FTipo := lBolsa.Tipo;
          ComboBoxTipo.ItemIndex := (ComboBoxTipo.Items.IndexOf(Trim(lBolsa.Tipo)));
          EdtVolume.Text := lBolsa.Volume.ToString;
          EdtOrigem.Text := lBolsa.Origem;
          ComboBoxAboBolsa.ItemIndex := (ComboBoxAboBolsa.Items.IndexOf(Trim(lBolsa.Abo + lBolsa.Rh)));
          RadioGroupPai.ItemIndex := IfThen(lBolsa.Pai = 'P', 0, 1);
          RadioGroupSifilis.ItemIndex := IfThen(lBolsa.Sifilis = 'P', 0, 1);
          RadioGroupChagas.ItemIndex := IfThen(lBolsa.Chagas = 'P', 0, 1);
          RadioGroupHepatiteB.ItemIndex := IfThen(lBolsa.HepatiteB = 'P', 0, 1);
          RadioGroupHepatiteC.ItemIndex := IfThen(lBolsa.HepatiteC = 'P', 0, 1);
          RadioGroupHIV.ItemIndex := IfThen(lBolsa.Hiv = 'P', 0, 1);
          RadioGroupHTLV.ItemIndex := IfThen(lBolsa.Htlv = 'P', 0, 1);
          RadioGroupHemoglobina.ItemIndex := IfThen(lBolsa.Hemoglobinas = 'P', 0, 1);
          EdtDataVencimento.Date := lBolsa.DataVencimento;
          EdtDataColeta.Date := lBolsa.DataColeta;

        end;

      except
        on E: Exception do
        begin
          Result := False;
          Application.MessageBox(PChar(Format(TMensagem.getMensagem(26), [E.Message])), 'Erro', MB_OK + MB_ICONERROR);
        end;
      end;

    finally
      lBolsa.Destroy;
    end;

  finally
    lBolsaDao.Destroy;
  end;

end;

function TFrmEntrada.CarregaDadosEntrada: Boolean;
var
  lEntradaDAO: TEntradaDAO;
  lEntrada: TEntrada;
begin

  lEntradaDAO := TEntradaDAO.Create(DMConexao.Conexao);
  try

    lEntrada := TEntrada.Create;
    try

      try

        Result := lEntradaDAO.getObjeto(Self.FId, lEntrada);
        if (Result) then
        begin
          EdtOrdemSaida.Text := lEntrada.Id.ToString;
          EdtDataEntrada.Date := lEntrada.DataEntrada;

          CarregaUsuarios;
          setIndexByIdUsuario(lEntrada.IdUsuario);

          Self.FIdBolsa := lEntrada.IdBolsa;
        end;

      except
        on E: Exception do
        begin
          Result := False;
          Application.MessageBox(PChar(Format(TMensagem.getMensagem(25), [E.Message])), 'Erro', MB_OK + MB_ICONERROR);
        end;

      end;

    finally
      lEntrada.Destroy;
    end;

  finally
    lEntradaDAO.Destroy;
  end;

end;

function TFrmEntrada.CarregaObjetos: Boolean;
begin

  if (Self.CarregaDadosEntrada) then
  begin
    Self.CarregaDadosBolsa;
  end;

  ComboBoxResponsavel.SetFocus;

end;

procedure TFrmEntrada.CarregaUsuarios;
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

procedure TFrmEntrada.setIndexByIdUsuario(pIdUsuario: Integer);
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

procedure TFrmEntrada.ComboBoxAboBolsaEnter(Sender: TObject);
begin

  ComboBoxAboBolsa.DroppedDown := ComboBoxAboBolsa.ItemIndex = -1;

end;

procedure TFrmEntrada.ComboBoxTipoEnter(Sender: TObject);
begin
  ComboBoxTipo.DroppedDown := True;
end;

procedure TFrmEntrada.ComboBoxTipoExit(Sender: TObject);
begin

  Self.getExisteBolsa;

end;

procedure TFrmEntrada.EdtNumeroBolsaKeyPress(Sender: TObject; var Key: Char);
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

procedure TFrmEntrada.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmEntrada.FormShow(Sender: TObject);
begin

  if (Self.FId > 0) then
  begin
    Self.CarregaObjetos;
  end
  else
  begin

    Self.FIdBolsa := -1;
    Self.FNumBolsa := '-1';
    Self.FTipo := '-1';

    EdtOrigem.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Origem', 'FrmEntrada.EdtOrigem', '');

    EdtDataEntrada.Date := Now;
    EdtDataVencimento.Date := Now;
    EdtDataColeta.Date := Now;

    CarregaUsuarios;

    setIndexByIdUsuario(Self.FIdUsuario);

    ComboBoxResponsavel.SetFocus;

  end;

end;

class function TFrmEntrada.getEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
  const pID: Integer = -1): Boolean;
begin

  Application.CreateForm(TFrmEntrada, FrmEntrada);
  try

    try

      FrmEntrada.FForeignFormKey := pFOREIGNFORMKEY;
      FrmEntrada.FIdUsuario := pCOD_USU;
      FrmEntrada.FId := pID;

      Result := FrmEntrada.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), ['de Entrada de sangue', E.Message])), 'Erro',
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    FreeAndNil(FrmEntrada);
  end;

end;

function TFrmEntrada.getExisteBolsa: Boolean;
var
  lVerificaNumBolsa: Boolean;
  lBolsaDao: TBolsaDao;
  lPos: Integer;
  lNumeroBolsa: string;
begin

  Result := False;

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

    lVerificaNumBolsa := True;
    if (Self.FId > 0) then
    begin
      lVerificaNumBolsa := ((Trim(Self.FNumBolsa) <> Trim(lNumeroBolsa)) or
        (Trim(Self.FTipo) <> Trim(ComboBoxTipo.Text)));
    end;

    if (lVerificaNumBolsa) then
    begin

      lBolsaDao := TBolsaDao.Create(DMConexao.Conexao);
      try

        Result := lBolsaDao.getExiste(lNumeroBolsa, ComboBoxTipo.Text);
        if (Result) then
        begin
          Application.MessageBox(pWideChar('Bolsa de n� ' + lNumeroBolsa + ' e tipo ' + ComboBoxTipo.Text +
            ' j� cadastrada.'), 'Aviso', MB_ICONWARNING + MB_OK);

          EdtNumeroBolsa.SetFocus;
        end;

      finally
        lBolsaDao.Destroy;
      end;

    end;

  end;

end;

function TFrmEntrada.SalvaBolsa: Boolean;
var
  lBolsaDao: TBolsaDao;
  lBolsa: TBolsa;
  lPos: Integer;
begin

  lBolsa := TBolsa.Create;
  try

    lBolsa.Id := Self.FIdBolsa;

    lPos := Pos('-', Trim(EdtNumeroBolsa.Text));

    if (lPos <> 0) then
    begin

      if (Copy(Trim(EdtNumeroBolsa.Text), lPos, Trim(EdtNumeroBolsa.Text).Length).Trim = '') then
      begin
        lBolsa.NumeroBolsa := Copy(Trim(EdtNumeroBolsa.Text), 0, Trim(EdtNumeroBolsa.Text).Length - 1).Trim;
        lBolsa.NumeroDoacoes := -1;
      end
      else
      begin
        lBolsa.NumeroBolsa := Copy(Trim(EdtNumeroBolsa.Text), 0, lPos - 1).Trim;
        lBolsa.NumeroDoacoes := Copy(Trim(EdtNumeroBolsa.Text), lPos + 1, Trim(EdtNumeroBolsa.Text).Length)
          .Trim.ToInteger;
      end;

    end
    else
    begin
      lBolsa.NumeroBolsa := Trim(EdtNumeroBolsa.Text);
      lBolsa.NumeroDoacoes := -1;
    end;

    lBolsa.Tipo := ComboBoxTipo.Text;
    lBolsa.Abo := Copy(ComboBoxAboBolsa.Text, 0, string(ComboBoxAboBolsa.Text).Length - 1);
    lBolsa.Rh := Copy(ComboBoxAboBolsa.Text, string(ComboBoxAboBolsa.Text).Length,
      string(ComboBoxAboBolsa.Text).Length);
    lBolsa.Origem := EdtOrigem.Text;
    lBolsa.Volume := StrToInt(EdtVolume.Text);
    lBolsa.Pai := Copy(RadioGroupPai.Items[RadioGroupPai.ItemIndex], 1, 1);
    lBolsa.Sifilis := Copy(RadioGroupSifilis.Items[RadioGroupSifilis.ItemIndex], 1, 1);
    lBolsa.Chagas := Copy(RadioGroupChagas.Items[RadioGroupChagas.ItemIndex], 1, 1);
    lBolsa.HepatiteB := Copy(RadioGroupHepatiteB.Items[RadioGroupHepatiteB.ItemIndex], 1, 1);
    lBolsa.HepatiteC := Copy(RadioGroupHepatiteC.Items[RadioGroupHepatiteC.ItemIndex], 1, 1);
    lBolsa.Hiv := Copy(RadioGroupHIV.Items[RadioGroupHIV.ItemIndex], 1, 1);
    lBolsa.Htlv := Copy(RadioGroupHTLV.Items[RadioGroupHTLV.ItemIndex], 1, 1);
    lBolsa.Hemoglobinas := Copy(RadioGroupHemoglobina.Items[RadioGroupHemoglobina.ItemIndex], 1, 1);
    lBolsa.DataVencimento := EdtDataVencimento.Date;
    lBolsa.VolumeAtual := StrToInt(EdtVolume.Text);
    lBolsa.DataColeta := EdtDataColeta.Date;

    try

      lBolsaDao := TBolsaDao.Create(DMConexao.Conexao);
      try

        Result := lBolsaDao.Salvar(lBolsa);
        if (Result) then
        begin
          Self.FIdBolsa := lBolsaDao.getId(lBolsa.NumeroBolsa, lBolsa.Tipo);
        end;

      except
        on E: Exception do
        begin
          Result := False;
          Application.MessageBox(PChar(Format(TMensagem.getMensagem(4), ['bolsa', E.Message])), 'Erro',
            MB_OK + MB_ICONERROR);
        end;
      end;

    finally
      lBolsaDao.Destroy;
    end;

  finally
    lBolsa.Destroy;
  end;

end;

function TFrmEntrada.SalvaEntrada: Boolean;
var
  lEntrada: TEntrada;
  lEntradaDAO: TEntradaDAO;
begin

  lEntrada := TEntrada.Create;
  try

    lEntrada.Id := StrToIntDef(EdtOrdemSaida.Text, -1);
    lEntrada.IdUsuario := TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items[ComboBoxResponsavel.ItemIndex]);
    lEntrada.IdBolsa := Self.FIdBolsa;
    lEntrada.DataEntrada := EdtDataEntrada.Date;

    lEntradaDAO := TEntradaDAO.Create(DMConexao.Conexao);
    try

      try

        Result := lEntradaDAO.Salvar(lEntrada);
        if (Result) then
        begin
          Self.FId := lEntrada.Id;
        end;

      except
        on E: Exception do
        begin
          Result := False;
          Application.MessageBox(PChar(Format(TMensagem.getMensagem(4), ['Entrada', E.Message])), 'Erro',
            MB_OK + MB_ICONERROR);
        end;
      end;

    finally
      lEntradaDAO.Destroy;
    end;

  finally
    lEntrada.Destroy;
  end;

end;

end.
