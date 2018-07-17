unit USaida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons;

type
  TFrmSaida = class(TForm)
    PanelClient: TPanel;
    GroupBoxSangue: TGroupBox;
    GroupBoxPaciente: TGroupBox;
    LabelRegistroPaciente: TLabel;
    SearchBoxRegistroPaciente: TSearchBox;
    EdtNomePaciente: TEdit;
    DateTimePickerData: TDateTimePicker;
    EdtAboBolsa: TEdit;
    EdtNumeroBolsa: TEdit;
    EdtOrdemSaida: TEdit;
    EdtOrigem: TEdit;
    EdtTipo: TEdit;
    EdtVolume: TEdit;
    LabelVolume: TLabel;
    LabelAboSangue: TLabel;
    LabelData: TLabel;
    LabelNumeroBolsa: TLabel;
    LabelOrdemSaida: TLabel;
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
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
  public
    class function getSaida(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmSaida: TFrmSaida;

implementation

uses UClassMensagem;

{$R *.dfm}
{ TFrmSaida }

procedure TFrmSaida.BtnGravarClick(Sender: TObject);
begin

  if (Trim(SearchBoxRegistroPaciente.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(2), [LabelRegistroPaciente.Caption]), mtWarning, [mbOK], -1);

    SearchBoxRegistroPaciente.SetFocus;

  end;

  if (Trim(EdtNumeroBolsa.Text).IsEmpty) then
  begin

    MessageDlg(Format(TMensagem.getMensagem(2), [LabelNumeroBolsa.Caption]), mtWarning, [mbOK], -1);

    EdtNumeroBolsa.SetFocus;

  end;

end;

procedure TFrmSaida.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSaida.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    BtnSairClick(Sender);
  end;

end;

class function TFrmSaida.getSaida(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  Application.CreateForm(TFrmSaida, FrmSaida);
  try

    try

      FrmSaida.FForeignFormKey := pFOREIGNFORMKEY;
      FrmSaida.FCodUsu := pCOD_USU;

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

end.
