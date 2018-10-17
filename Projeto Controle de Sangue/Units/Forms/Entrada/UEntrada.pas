unit UEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls,
  UClassBolsaDAO, UBiblioteca;

type
  TFrmEntrada = class(TForm)
    PanelClient: TPanel;
    PanelBottom: TPanel;
    DateTimePickerData: TDateTimePicker;
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
    procedure FormShow(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnGravarClick(Sender: TObject);
    procedure EdtNumeroBolsaExit(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure ComboBoxAboBolsaEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxTipoEnter(Sender: TObject);
  private

    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;
    FId: Integer;
    FIdBolsa: Integer;
    FNumBolsa: string;

    FBolsaDAO: TBolsaDAO;

    procedure CarregaUsuarios;
    procedure setIndexByIdUsuario(pIdUsuario: Integer);

    function CarregaObjetos: Boolean;
    function CarregaEntrada: Boolean;
    function CarregaBolsa(const pID_BOLSA: Integer): Boolean;

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
  UAutenticacao;

procedure TFrmEntrada.BtnGravarClick(Sender: TObject);
var
  lBolsa: TBolsa;

  lEntrada: TEntrada;
  lEntradaDAO: TEntradaDAO;
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

  if (ComboBoxTipo.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelTipo.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxTipo.SetFocus;

    exit;

  end;

  if (Trim(EdtVolume.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelVolume.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtVolume.SetFocus;

    exit;

  end;

  if (ComboBoxAboBolsa.ItemIndex = -1) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelAboSangue.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    ComboBoxAboBolsa.SetFocus;

    exit;

  end;

  if (Trim(EdtOrigem.Text).IsEmpty) then
  begin

    Application.MessageBox(PChar(Format(TMensagem.getMensagem(3), [LabelOrigem.Caption])), 'Aviso',
      MB_OK + MB_ICONINFORMATION);

    EdtOrigem.SetFocus;

    exit;

  end;

  if TFrmAutenticacao.getAutenticacao(TBiblioteca.getIdUsuarioOnString(ComboBoxResponsavel.Items
    [ComboBoxResponsavel.ItemIndex])) then
  begin

    lBolsa := TBolsa.Create;
    try

      lBolsa.Id := Self.FIdBolsa;
      lBolsa.NumeroBolsa := EdtNumeroBolsa.Text;
      lBolsa.Tipo := ComboBoxTipo.Text;
      lBolsa.Abo := Copy(ComboBoxAboBolsa.Text, 0, string(ComboBoxAboBolsa.Text).Length - 1);
      lBolsa.Rh := Copy(ComboBoxAboBolsa.Text, string(ComboBoxAboBolsa.Text).Length,
        string(ComboBoxAboBolsa.Text).Length);
      lBolsa.Origem := EdtOrigem.Text;
      lBolsa.Volume := StrToInt(EdtVolume.Text);
      lBolsa.Sorologia := 'N';
      lBolsa.PossuiEstoque := 'S';

      try

        if (Self.FBolsaDAO.Salvar(lBolsa)) then
        begin

          Self.FIdBolsa := TClassBibliotecaDao.getValorAtributo('bolsa', 'id', 'numero_da_bolsa', lBolsa.NumeroBolsa,
            DataModuleConexao.Conexao);

          lEntrada := TEntrada.Create;
          try

            lEntrada.Id := StrToIntDef(EdtOrdemSaida.Text, -1);
            lEntrada.IdUsuario := TBiblioteca.getIdUsuarioOnString
              (ComboBoxResponsavel.Items[ComboBoxResponsavel.ItemIndex]);
            lEntrada.IdBolsa := Self.FIdBolsa;
            lEntrada.DataEntrada := Now;

            lEntradaDAO := TEntradaDAO.Create(DataModuleConexao.Conexao);
            try

              if (lEntradaDAO.Salvar(lEntrada)) then
              begin

                EdtOrdemSaida.Text := lEntrada.Id.ToString;

                BtnGravar.Enabled := False;

                TBiblioteca.AtivaDesativaCompontes(FrmEntrada, False);

                Application.MessageBox(PChar(TMensagem.getMensagem(23)), 'Aviso', MB_OK + MB_ICONINFORMATION);

                BtnNovo.SetFocus;

                TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'Origem', 'FrmEntrada.EdtOrigem',
                  Trim(EdtOrigem.Text));

              end;

            finally
              lEntradaDAO.Destroy;
            end;

          finally
            lEntrada.Destroy;
          end;

        end;

      except
        on E: Exception do
        begin
          Application.MessageBox(PChar(Format(TMensagem.getMensagem(4), ['Entrada', E.Message])), 'Erro',
            MB_OK + MB_ICONERROR);
        end;
      end;

    finally
      lBolsa.Destroy;
    end;

  end;

end;

procedure TFrmEntrada.BtnNovoClick(Sender: TObject);
begin
  EdtOrigem.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Origem', 'FrmEntrada.EdtOrigem', '');
  DateTimePickerData.DateTime := Now;

  TBiblioteca.AtivaDesativaCompontes(Self, True);

  BtnGravar.Enabled := True;
  EdtOrdemSaida.Enabled := False;
  EdtOrdemSaida.Clear;
  EdtNumeroBolsa.Clear;
  ComboBoxTipo.ItemIndex := 0;
  EdtVolume.Clear;
  ComboBoxAboBolsa.ItemIndex := -1;

  Self.FId := -1;
  Self.FIdBolsa := -1;
  Self.FNumBolsa := '-1';

  ComboBoxResponsavel.SetFocus;
end;

procedure TFrmEntrada.BtnSairClick(Sender: TObject);
begin

  Close;

end;

function TFrmEntrada.CarregaBolsa(const pID_BOLSA: Integer): Boolean;
var
  lBolsaDao: TBolsaDAO;
  lBolsa: TBolsa;
begin

  lBolsaDao := TBolsaDAO.Create(DataModuleConexao.Conexao);
  try

    lBolsa := TBolsa.Create;
    try

      try

        Result := lBolsaDao.getObjeto(pID_BOLSA, lBolsa);
        if (Result) then
        begin
          EdtNumeroBolsa.Text := lBolsa.NumeroBolsa;
          Self.FNumBolsa := lBolsa.NumeroBolsa;
          ComboBoxTipo.ItemIndex := (ComboBoxTipo.Items.IndexOf(Trim(lBolsa.Tipo)));
          EdtVolume.Text := lBolsa.Volume.ToString;
          EdtOrigem.Text := lBolsa.Origem;
          ComboBoxAboBolsa.ItemIndex := (ComboBoxAboBolsa.Items.IndexOf(Trim(lBolsa.Abo + lBolsa.Rh)));
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

function TFrmEntrada.CarregaEntrada: Boolean;
var
  lEntradaDAO: TEntradaDAO;
  lEntrada: TEntrada;
begin

  lEntradaDAO := TEntradaDAO.Create(DataModuleConexao.Conexao);
  try

    lEntrada := TEntrada.Create;
    try

      try

        Result := lEntradaDAO.getObjeto(Self.FId, lEntrada);
        if (Result) then
        begin
          EdtOrdemSaida.Text := lEntrada.Id.ToString;
          DateTimePickerData.DateTime := lEntrada.DataEntrada;

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

  if (Self.CarregaEntrada) then
  begin
    Self.CarregaBolsa(Self.FIdBolsa);
  end;
  ComboBoxResponsavel.SetFocus;

end;

procedure TFrmEntrada.CarregaUsuarios;
var
  lListaUsuario: TObjectList<TUsuario>;
  lUsuarioDAO: TUsuarioDAO;
  I: Integer;
begin
  ComboBoxResponsavel.Clear;

  lListaUsuario := TObjectList<TUsuario>.Create();
  try

    lUsuarioDAO := TUsuarioDAO.Create(DataModuleConexao.Conexao);
    try

      if (lUsuarioDAO.getListaObjeto(lListaUsuario)) then
      begin

        for I := 0 to lListaUsuario.Count - 1 do
        begin
          ComboBoxResponsavel.Items.Add(lListaUsuario.Items[I].Id.ToString + ' - ' + lListaUsuario.Items[I].Nome);
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

procedure TFrmEntrada.EdtNumeroBolsaExit(Sender: TObject);
var
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
      lVerificaNumBolsa := True;
    end;

    if (lVerificaNumBolsa) then
    begin

      if (Self.FBolsaDAO.getExiste(EdtNumeroBolsa.Text)) then
      begin

        Application.MessageBox('N�mero da bolsa j� cadastrado', 'Aviso', MB_ICONWARNING + MB_OK);

        EdtNumeroBolsa.SetFocus;

      end;

    end;

  end;

end;

procedure TFrmEntrada.FormCreate(Sender: TObject);
begin

  Self.FBolsaDAO := TBolsaDAO.Create(DataModuleConexao.Conexao);

end;

procedure TFrmEntrada.FormDestroy(Sender: TObject);
begin

  Self.FBolsaDAO.Destroy;

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
    Self.FNumBolsa := '1';

    EdtOrigem.Text := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Origem', 'FrmEntrada.EdtOrigem', '');

    DateTimePickerData.DateTime := Now;

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

end.
