unit UEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls,
  UClassBolsaDAO;

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
    EdtTipo: TEdit;
    LabelTipo: TLabel;
    LabelAboSangue: TLabel;
    LabelObservacao: TLabel;
    EdtObservacao: TEdit;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    EdtVolume: TEdit;
    LabelVolume: TLabel;
    EdtOrdemSaida: TEdit;
    LabelOrdemSaida: TLabel;
    BtnNovo: TBitBtn;
    ComboBoxAboBolsa: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtOrigemEnter(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure EdtNumeroBolsaExit(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure EdtTipoEnter(Sender: TObject);
    procedure ComboBoxAboBolsaKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBoxAboBolsaEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
    FId: Integer;
    FIdBolsa: Integer;
    FNumBolsa: string;

    FBolsaDAO: TBolsaDAO;

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
  UClassSaidaDao, UClassBolsa, UClassBibliotecaDao;

procedure TFrmEntrada.BtnGravarClick(Sender: TObject);
var
  lBolsa: TBolsa;

  lEntrada: TEntrada;
  lEntradaDAO: TEntradaDAO;
begin

  if (Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelNumeroBolsa.Caption]), mtWarning, [mbOK], -1);

    EdtNumeroBolsa.SetFocus;

    Exit;

  end;

  if (Trim(EdtTipo.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelTipo.Caption]), mtWarning, [mbOK], -1);

    EdtTipo.SetFocus;

    Exit;

  end;

  if (Trim(EdtVolume.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelVolume.Caption]), mtWarning, [mbOK], -1);

    EdtVolume.SetFocus;

    Exit;

  end;

  if (ComboBoxAboBolsa.ItemIndex = -1) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelAboSangue.Caption]), mtWarning, [mbOK], -1);

    ComboBoxAboBolsa.SetFocus;

    Exit;

  end;

  if (Trim(EdtOrigem.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(3), [LabelOrigem.Caption]), mtWarning, [mbOK], -1);

    EdtOrigem.SetFocus;

    Exit;

  end;

  lBolsa := TBolsa.Create;
  try

    lBolsa.Id := Self.FIdBolsa;
    lBolsa.NumeroBolsa := EdtNumeroBolsa.Text;
    lBolsa.Tipo := EdtTipo.Text;
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
          lEntrada.IdUsuario := Self.FCodUsu;
          lEntrada.IdBolsa := Self.FIdBolsa;
          lEntrada.DataEntrada := Now;
          lEntrada.Observacao := EdtObservacao.Text;

          lEntradaDAO := TEntradaDAO.Create(DataModuleConexao.Conexao);
          try

            if (lEntradaDAO.Salvar(lEntrada)) then
            begin

              EdtOrdemSaida.Text := lEntrada.Id.ToString;

              BtnGravar.Enabled := False;

              BtnNovo.SetFocus;

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
        raise Exception.Create(Format(TMensagem.getMensagem(4), ['Entrada', E.Message]));
      end;
    end;

  finally
    lBolsa.Destroy;
  end;

end;

procedure TFrmEntrada.BtnNovoClick(Sender: TObject);
begin

  DateTimePickerData.DateTime := Now;

  BtnGravar.Enabled := True;
  EdtOrdemSaida.Clear;
  EdtNumeroBolsa.Clear;
  EdtTipo.Clear;
  EdtVolume.Clear;
  ComboBoxAboBolsa.ItemIndex := -1;
  EdtOrigem.Clear;
  EdtObservacao.Clear;

  EdtNumeroBolsa.SetFocus;

  Self.FId := -1;
  Self.FIdBolsa := -1;
  Self.FNumBolsa := '-1';

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
          EdtTipo.Text := lBolsa.Tipo;
          EdtVolume.Text := lBolsa.Volume.ToString;
          EdtOrigem.Text := lBolsa.Origem;
          ComboBoxAboBolsa.ItemIndex := (ComboBoxAboBolsa.Items.IndexOf(Trim(lBolsa.Abo + lBolsa.Rh)));
        end;

      except

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
          EdtObservacao.Text := lEntrada.Observacao;
          Self.FIdBolsa := lEntrada.IdBolsa;
        end;

      except

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

end;

procedure TFrmEntrada.ComboBoxAboBolsaEnter(Sender: TObject);
begin

  ComboBoxAboBolsa.DroppedDown := ComboBoxAboBolsa.ItemIndex = -1;

end;

procedure TFrmEntrada.ComboBoxAboBolsaKeyPress(Sender: TObject; var Key: Char);
begin

  // Se for diferente da tecla da barra de espaço.
  if (Key <> #08) then
  begin

    Key := UpCase(Key);

    if not(Key in ['A', 'B', 'O', '+', '-']) then
    begin
      Key := #0;
    end;

  end;

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

        Application.MessageBox('Número da bolsa já cadastrado', 'Aviso', MB_ICONWARNING + MB_OK);

        EdtNumeroBolsa.SetFocus;

      end;

    end;

  end;

end;

procedure TFrmEntrada.EdtOrigemEnter(Sender: TObject);
begin

  if (Trim(EdtOrigem.Text).IsEmpty) then
  begin

    EdtOrigem.Text := 'HEMOGO';

  end;

end;

procedure TFrmEntrada.EdtTipoEnter(Sender: TObject);
begin

  if (Trim(EdtTipo.Text).IsEmpty) then
  begin

    EdtTipo.Text := 'CH';

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

  if (Key = VK_ESCAPE) then
  begin

    BtnSairClick(Sender);

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

    DateTimePickerData.DateTime := Now;

    EdtNumeroBolsa.SetFocus;

  end;

end;

class function TFrmEntrada.getEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
  const pID: Integer = -1): Boolean;
begin

  Application.CreateForm(TFrmEntrada, FrmEntrada);
  try

    try

      FrmEntrada.FForeignFormKey := pFOREIGNFORMKEY;
      FrmEntrada.FCodUsu := pCOD_USU;
      FrmEntrada.FId := pID;

      Result := FrmEntrada.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de Entrada de sangue', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmEntrada);
  end;

end;

end.
