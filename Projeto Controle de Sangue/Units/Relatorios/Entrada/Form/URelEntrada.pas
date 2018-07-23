unit URelEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmRelEntrada = class(TForm)
    PanelData: TPanel;
    GroupBoxDataEntrada: TGroupBox;
    DateTimePickerDataInicial: TDateTimePicker;
    DateTimePickerDataFinal: TDateTimePicker;
    LabelA: TLabel;
    PanelTipo: TPanel;
    GroupBoxTipo: TGroupBox;
    PanelBotoes: TPanel;
    BtnSair: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnVisualizar: TBitBtn;
    EdtTipo: TEdit;
    BtnAddTipo: TBitBtn;
    RadioGroupFiltroTipo: TRadioGroup;
    ListBoxTipo: TListBox;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupFiltroTipoClick(Sender: TObject);
    procedure BtnAddTipoClick(Sender: TObject);
    procedure RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
    procedure BtnAddGrupoSanguineoClick(Sender: TObject);
    procedure RadioGroupFiltroVolumeClick(Sender: TObject);
    procedure BtnAddVolumeClick(Sender: TObject);
    procedure ListBoxTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxVolumeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnVisualizarClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FCodUsu: Integer;

    procedure ChamaRelatorio(const pSENDER: TObject);

  public
    class function getRelEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmRelEntrada: TFrmRelEntrada;

implementation

uses System.DateUtils, UBiblioteca, UBibliotecaRelatorio, UClassMensagem, UClassRelEntrada, UEnumsRelatorio,
  URlRelEntrada, UClassForeignKeyForms;

{$R *.dfm}
{ TFrmRelEntrada }

procedure TFrmRelEntrada.BtnAddGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, GroupBoxGrupoSanguineo,
    EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelEntrada.BtnAddTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroTipo, ListBoxTipo, GroupBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelEntrada.BtnAddVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroVolume, ListBoxVolume, GroupBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelEntrada.BtnImprimirClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelEntrada.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmRelEntrada.BtnVisualizarClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelEntrada.ChamaRelatorio(const pSENDER: TObject);
var
  lRelEntrada: TRelEntrada;

  // Uso esse objeto auxiliar por que o Delphi da erro de compilação se eu passar a property do StringList.
  lAuxStringList: TStringList;
  lAux: string;
begin

  lRelEntrada := TRelEntrada.Create;
  try

    try

      lRelEntrada.DataIni := DateTimePickerDataInicial.Date;
      lRelEntrada.DataFim := DateTimePickerDataFinal.Date;

      lRelEntrada.FiltroTipo := TTipoFiltro(RadioGroupFiltroTipo.ItemIndex);

      lRelEntrada.FiltroGrupoSanguineo := TTipoFiltro(RadioGroupFiltroGrupoSanguineo.ItemIndex);

      lRelEntrada.FiltroVolume := TTipoFiltro(RadioGroupFiltroVolume.ItemIndex);

      lRelEntrada.Visualizar := pSENDER = BtnVisualizar;

      lAuxStringList := TStringList.Create;
      try

        TBibliotecaRelatorio.PreparaStringList(lRelEntrada.FiltroTipo, ListBoxTipo, lAuxStringList);
        lRelEntrada.ListTipo.Text := lAuxStringList.Text;
        lAuxStringList.Clear;

        TBibliotecaRelatorio.PreparaStringList(lRelEntrada.FiltroGrupoSanguineo, ListBoxGrupoSanguineo,
          lAuxStringList);
        lRelEntrada.ListGrupoSanguineo.Text := lAuxStringList.Text;
        lAuxStringList.Clear;

        TBibliotecaRelatorio.PreparaStringList(lRelEntrada.FiltroVolume, ListBoxVolume, lAuxStringList);
        lRelEntrada.ListVolume.Text := lAuxStringList.Text;

      finally
        lAuxStringList.Destroy;
      end;

      if not (TFrmRlRelEntrada.getRlRelEntrada(TForeignKeyForms.FIdURelEntrada, Self.FCodUsu, lRelEntrada)) then
      begin
        MessageBox(self.Handle, 'Não há registros na sua busca', 'Aviso', MB_OK);
      end;

    except
      on E: Exception do
      begin
        raise Exception.Create(Format(TMensagem.getMensagem(7), ['relatório de entrada', E.Message]));
      end;
    end;

  finally
    lRelEntrada.Destroy;
  end;

end;

procedure TFrmRelEntrada.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEntrada.RadioGroupFiltroTipo',
    RadioGroupFiltroTipo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEntrada.RadioGroupFiltroGrupoSanguineo',
    RadioGroupFiltroGrupoSanguineo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEntrada.RadioGroupFiltroVolume',
    RadioGroupFiltroVolume.ItemIndex.ToString);

  Action := caFree;

end;

procedure TFrmRelEntrada.FormDestroy(Sender: TObject);
begin

  FrmRelEntrada := nil;

end;

procedure TFrmRelEntrada.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    BtnSairClick(Sender);
  end;

end;

procedure TFrmRelEntrada.FormShow(Sender: TObject);
begin

  DateTimePickerDataInicial.DateTime := TBiblioteca.getPrimeiroDiaMes(Now);
  DateTimePickerDataFinal.DateTime := TBiblioteca.getUltimoDiaMes(Now);

  RadioGroupFiltroTipo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelEntrada.RadioGroupFiltroTipo', '3').ToInteger;

  RadioGroupFiltroGrupoSanguineo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelEntrada.RadioGroupFiltroGrupoSanguineo', '3').ToInteger;

  RadioGroupFiltroVolume.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelEntrada.RadioGroupFiltroVolume', '3').ToInteger;

end;

class function TFrmRelEntrada.getRelEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  if (FrmRelEntrada = nil) then
  begin

    Application.CreateForm(TFrmRelEntrada, FrmRelEntrada);

  end;

  try

    FrmRelEntrada.FForeignFormKey := pFOREIGNFORMKEY;
    FrmRelEntrada.FCodUsu := pCOD_USU;

    FrmRelEntrada.WindowState := wsNormal;
    FrmRelEntrada.BringToFront;
    FrmRelEntrada.Show;

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create(Format(TMensagem.getMensagem(0), ['de relatório de entrada', E.Message]));
    end;
  end;

end;

procedure TFrmRelEntrada.ListBoxTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelEntrada.ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxGrupoSanguineo, EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelEntrada.ListBoxVolumeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelEntrada.RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, EdtGrupoSanguineo,
    BtnAddGrupoSanguineo);

end;

procedure TFrmRelEntrada.RadioGroupFiltroTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroTipo, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelEntrada.RadioGroupFiltroVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroVolume, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

end.
