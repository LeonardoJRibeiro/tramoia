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
    EdtAboBolsa: TEdit;
    LabelAboSangue: TLabel;
    LabelObservacao: TLabel;
    EdtObservacao: TEdit;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    EdtVolume: TEdit;
    Label1: TLabel;
    EdtOrdemSaida: TEdit;
    LabelOrdemSaida: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtAboBolsaEnter(Sender: TObject);
    procedure EdtOrigemEnter(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
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
uses System.StrUtils, UClassForeignKeyForms, UClassMensagem;

procedure TFrmEntrada.BtnGravarClick(Sender: TObject);
begin

 // if () then


end;

procedure TFrmEntrada.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntrada.EdtAboBolsaEnter(Sender: TObject);
begin

  if ( Trim(EdtAboBolsa.Text).IsEmpty) then
  begin

    EdtAboBolsa.Text := 'CH';

  end;

end;

procedure TFrmEntrada.EdtOrigemEnter(Sender: TObject);
begin

  if (Trim(EdtOrigem.Text).IsEmpty) then
  begin

    EdtOrigem.Text := 'HEMOGO';

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
        raise Exception.Create(Format(TMensagem.getMensagem(0), [ 'de Entrada de sangue', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmEntrada);
  end;

end;

end.
