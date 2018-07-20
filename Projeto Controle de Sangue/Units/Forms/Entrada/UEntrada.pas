unit UEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls;

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
  private
    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
  public
    class function getEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmEntrada: TFrmEntrada;

implementation

{$R *.dfm}

{ TFrmEntradaSaida }
uses System.StrUtils, UClassForeignKeyForms, UClassMensagem, UClassEntrada, UClassEntradaDao, UDMConexao,
  UClassSaidaDao;

procedure TFrmEntrada.BtnGravarClick(Sender: TObject);
var
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

  lEntrada := TEntrada.Create;
  try

    lEntrada.Id := StrToIntDef(EdtOrdemSaida.Text, -1);
    lEntrada.Id_Usuario := Self.FCodUsu;
    lEntrada.Data_Entrada := Now;
    lEntrada.Numero_Da_Bolsa := EdtNumeroBolsa.Text;
    lEntrada.Origem := EdtOrigem.Text;
    lEntrada.Tipo := EdtTipo.Text;
    lEntrada.Volume := StrToCurr(EdtVolume.Text);
    lEntrada.Grupo_Sanguineo := ComboBoxAboBolsa.Text;
    lEntrada.Sorologia := 'N';
    lEntrada.Observacao := EdtObservacao.Text;

    lEntradaDAO := TEntradaDAO.Create(DataModuleConexao.Conexao);
    try

      try

        if (lEntradaDAO.Salvar(lEntrada)) then
        begin

          EdtOrdemSaida.Text := lEntrada.Id.ToString;

          BtnGravar.Enabled := False;

          BtnNovo.SetFocus;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(4), ['Entrada', E.Message]));
        end;
      end;

    finally
      lEntradaDAO.Destroy;
    end;

  finally
    lEntrada.Destroy;
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

  DateTimePickerData.SetFocus;

end;

procedure TFrmEntrada.BtnSairClick(Sender: TObject);
begin

  Close;

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
  lSaidaDAO: TSaidaDAO;
begin

  if (not Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    lSaidaDAO := TSaidaDAO.Create(DataModuleConexao.Conexao);
    try

      try

        if (lSaidaDAO.getExisteNumBolsaSaida(EdtNumeroBolsa.Text, 0)) then
        begin

          Application.MessageBox('Número da bolsa já vinculado a uma saída', 'Aviso', MB_ICONWARNING + MB_OK);
          EdtNumeroBolsa.SetFocus;

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao verifica se o número da bolsa já esta vinculado a uma saída. Motivo ' +
            E.Message);
        end;
      end;

    finally
      lSaidaDAO.Destroy;
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

procedure TFrmEntrada.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin

    BtnSairClick(Sender);

  end;

end;

procedure TFrmEntrada.FormShow(Sender: TObject);
begin

  DateTimePickerData.DateTime := Now;

  EdtNumeroBolsa.SetFocus;

end;

class function TFrmEntrada.getEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  Application.CreateForm(TFrmEntrada, FrmEntrada);
  try

    try

      FrmEntrada.FForeignFormKey := pFOREIGNFORMKEY;
      FrmEntrada.FCodUsu := pCOD_USU;

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
