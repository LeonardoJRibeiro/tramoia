unit URelSaida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.ComCtrls;

type
  TFrmRelSaida = class(TForm)
    PanelData: TPanel;
    GroupBoxDataSaida: TGroupBox;
    LabelA: TLabel;
    DateTimePickerDataInicial: TDateTimePicker;
    DateTimePickerDataFinal: TDateTimePicker;
    PanelTipo: TPanel;
    GroupBoxTipo: TGroupBox;
    EdtTipo: TEdit;
    BtnAddTipo: TBitBtn;
    RadioGroupFiltroTipo: TRadioGroup;
    ListBoxTipo: TListBox;
    PanelBotoes: TPanel;
    BtnSair: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnVisualizar: TBitBtn;
    PanelGrupoSanguineo: TPanel;
    GroupBoxGrupoSanguineo: TGroupBox;
    EdtGrupoSanguineo: TEdit;
    BtnAddGrupoSanguineo: TBitBtn;
    RadioGroupFiltroGrupoSanguineo: TRadioGroup;
    ListBoxGrupoSanguineo: TListBox;
    PanelVolume: TPanel;
    GroupBoxVolume: TGroupBox;
    EdtVolume: TEdit;
    BtnAddVolume: TBitBtn;
    RadioGroupFiltroVolume: TRadioGroup;
    ListBoxVolume: TListBox;
    procedure BtnAddGrupoSanguineoClick(Sender: TObject);
    procedure BtnAddTipoClick(Sender: TObject);
    procedure BtnAddVolumeClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnVisualizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxVolumeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
    procedure RadioGroupFiltroTipoClick(Sender: TObject);
    procedure RadioGroupFiltroVolumeClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FCodUsu: Integer;

    procedure ChamaRelatorio(const pSENDER: TObject);

  public
    class function getRelSaida(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmRelSaida: TFrmRelSaida;

implementation

uses System.DateUtils, UBiblioteca, UBibliotecaRelatorio, UClassMensagem, UClassRelSaida, URlRelSaida,
  UEnumsRelatorio, UClassForeignKeyForms;

{$R *.dfm}

{ TFrmRelSaida }

procedure TFrmRelSaida.BtnAddGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, GroupBoxGrupoSanguineo,
    EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelSaida.BtnAddTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroTipo, ListBoxTipo, GroupBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelSaida.BtnAddVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroVolume, ListBoxVolume, GroupBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelSaida.BtnImprimirClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelSaida.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmRelSaida.BtnVisualizarClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelSaida.ChamaRelatorio(const pSENDER: TObject);
var
  lRelSaida: TRelSaida;

  // Uso esse objeto auxiliar por que o Delphi da erro de compilação se eu passar a property do StringList.
  lAuxStringList: TStringList;
begin

  lRelSaida := TRelSaida.Create;
  try

    try

      lRelSaida.DataIni := DateTimePickerDataInicial.Date;
      lRelSaida.DataFim := DateTimePickerDataFinal.Date;

      lRelSaida.FiltroTipo := TTipoFiltro(RadioGroupFiltroTipo.ItemIndex);

      lRelSaida.FiltroGrupoSanguineo := TTipoFiltro(RadioGroupFiltroGrupoSanguineo.ItemIndex);

      lRelSaida.FiltroVolume := TTipoFiltro(RadioGroupFiltroVolume.ItemIndex);

      lRelSaida.Visualizar := pSENDER = BtnVisualizar;

      lAuxStringList := TStringList.Create;
      try

        TBibliotecaRelatorio.PreparaStringList(TTipoFiltro(RadioGroupFiltroTipo), ListBoxTipo, lAuxStringList);
        lRelSaida.ListTipo.Text := lAuxStringList.Text;

        TBibliotecaRelatorio.PreparaStringList(TTipoFiltro(RadioGroupFiltroGrupoSanguineo), ListBoxGrupoSanguineo,
          lAuxStringList);
        lRelSaida.ListGrupoSanguineo.Text := lAuxStringList.Text;

        TBibliotecaRelatorio.PreparaStringList(TTipoFiltro(RadioGroupFiltroVolume), ListBoxVolume, lAuxStringList);
        lRelSaida.ListVolume.Text := lAuxStringList.Text;

      finally
        lAuxStringList.Destroy;
      end;

      TFrmRlRelSaida.getRlRelSaida(TForeignKeyForms.FIdURelEntrada, Self.FCodUsu, lRelSaida);

    except
      on E: Exception do
      begin
        raise Exception.Create(Format(TMensagem.getMensagem(7), ['relatório de entrada', E.Message]));
      end;
    end;

  finally
    lRelSaida.Destroy;
  end;

end;

procedure TFrmRelSaida.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEntrada.RadioGroupFiltroTipo',
    RadioGroupFiltroTipo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEntrada.RadioGroupFiltroGrupoSanguineo',
    RadioGroupFiltroGrupoSanguineo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEntrada.RadioGroupFiltroVolume',
    RadioGroupFiltroVolume.ItemIndex.ToString);

  Action := caFree;

end;

procedure TFrmRelSaida.FormDestroy(Sender: TObject);
begin

  FrmRelSaida := nil;

end;

procedure TFrmRelSaida.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    BtnSairClick(Sender);
  end;

end;

procedure TFrmRelSaida.FormShow(Sender: TObject);
begin

  DateTimePickerDataInicial.DateTime := TBiblioteca.getPrimeiroDiaMes(Now);
  DateTimePickerDataFinal.DateTime := TBiblioteca.getUltimoDiaMes(Now);

  RadioGroupFiltroTipo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelSaida.RadioGroupFiltroTipo', '3').ToInteger;

  RadioGroupFiltroGrupoSanguineo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelSaida.RadioGroupFiltroGrupoSanguineo', '3').ToInteger;

  RadioGroupFiltroVolume.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelSaida.RadioGroupFiltroVolume', '3').ToInteger;

end;

class function TFrmRelSaida.getRelSaida(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  if (FrmRelSaida = nil) then
  begin

    Application.CreateForm(TFrmRelSaida, FrmRelSaida);

  end;

  try

    FrmRelSaida.FForeignFormKey := pFOREIGNFORMKEY;
    FrmRelSaida.FCodUsu := pCOD_USU;

    FrmRelSaida.WindowState := wsNormal;
    FrmRelSaida.BringToFront;
    FrmRelSaida.Show;

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create(Format(TMensagem.getMensagem(0), ['de relatório de saída', E.Message]));
    end;
  end;

end;

procedure TFrmRelSaida.ListBoxTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelSaida.ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxGrupoSanguineo, EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelSaida.ListBoxVolumeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelSaida.RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, EdtGrupoSanguineo,
    BtnAddGrupoSanguineo);

end;

procedure TFrmRelSaida.RadioGroupFiltroTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroTipo, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelSaida.RadioGroupFiltroVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroVolume, ListBoxVolume, EdtVolume, BtnAddVolume);

end;


end.
