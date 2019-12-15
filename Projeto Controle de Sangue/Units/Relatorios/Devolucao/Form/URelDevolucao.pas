unit URelDevolucao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmRelDevolucao = class(TForm)
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
    class function getRelDevolucao(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmRelDevolucao: TFrmRelDevolucao;

implementation

uses System.DateUtils, UClassBiblioteca, UBibliotecaRelatorio, UClassMensagem, UClassRelDevolucao, UEnumsRelatorio,
  UClassForeignKeyForms, URlRelDevolucao;

{$R *.dfm}
{ TFrmRelDevolucao }

procedure TFrmRelDevolucao.BtnAddGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, GroupBoxGrupoSanguineo,
    EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelDevolucao.BtnAddTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroTipo, ListBoxTipo, GroupBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelDevolucao.BtnAddVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroVolume, ListBoxVolume, GroupBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelDevolucao.BtnImprimirClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelDevolucao.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmRelDevolucao.BtnVisualizarClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelDevolucao.ChamaRelatorio(const pSENDER: TObject);
var
  lRelDevolucao: TRelDevolucao;

  // Uso esse objeto auxiliar por que o Delphi da erro de compilação se eu passar a property do StringList.
  lAuxStringList: TStringList;
  lMensagem: string;

begin

  if (not TBibliotecaRelatorio.ValidaFiltro(TTipoFiltro(RadioGroupFiltroTipo.ItemIndex), ListBoxTipo, EdtTipo,
    lMensagem)) then
  begin

    Application.MessageBox(PWideChar(lMensagem), 'Aviso', mb_Ok + mb_IconExclamation);

    Exit;

  end;

  if (not TBibliotecaRelatorio.ValidaFiltro(TTipoFiltro(RadioGroupFiltroGrupoSanguineo.ItemIndex),
    ListBoxGrupoSanguineo, EdtGrupoSanguineo, lMensagem)) then
  begin

    Application.MessageBox(PWideChar(lMensagem), 'Aviso', mb_Ok + mb_IconExclamation);

    Exit;

  end;

  if (not TBibliotecaRelatorio.ValidaFiltro(TTipoFiltro(RadioGroupFiltroVolume.ItemIndex), ListBoxVolume, EdtVolume,
    lMensagem)) then
  begin

    Application.MessageBox(PWideChar(lMensagem), 'Aviso', mb_Ok + mb_IconExclamation);

    Exit;

  end;

  lRelDevolucao := TRelDevolucao.Create;
  try

    try

      lRelDevolucao.DataIni := DateTimePickerDataInicial.Date;
      lRelDevolucao.DataFim := DateTimePickerDataFinal.Date;

      lRelDevolucao.FiltroTipo := TTipoFiltro(RadioGroupFiltroTipo.ItemIndex);

      lRelDevolucao.FiltroGrupoSanguineo := TTipoFiltro(RadioGroupFiltroGrupoSanguineo.ItemIndex);

      lRelDevolucao.FiltroVolume := TTipoFiltro(RadioGroupFiltroVolume.ItemIndex);

      lRelDevolucao.Visualizar := pSENDER = BtnVisualizar;

      lAuxStringList := TStringList.Create;

      try

        TBibliotecaRelatorio.PreparaStringList(lRelDevolucao.FiltroTipo, ListBoxTipo, lAuxStringList);
        lRelDevolucao.ListTipo.Text := lAuxStringList.Text;
        lAuxStringList.Clear;

        TBibliotecaRelatorio.PreparaStringList(lRelDevolucao.FiltroGrupoSanguineo, ListBoxGrupoSanguineo,
          lAuxStringList);
        lRelDevolucao.ListGrupoSanguineo.Text := lAuxStringList.Text;
        lAuxStringList.Clear;

        TBibliotecaRelatorio.PreparaStringList(lRelDevolucao.FiltroVolume, ListBoxVolume, lAuxStringList);
        lRelDevolucao.ListVolume.Text := lAuxStringList.Text;

      finally
        lAuxStringList.Destroy;
      end;

      TFrmRlRelDevolucao.getRlRelDevolucao(TForeignKeyForms.FIdURelEntrada, Self.FCodUsu, lRelDevolucao);

    except
      on E: Exception do
      begin
        raise Exception.Create(Format(TMensagem.getMensagem(7), ['relatório de entrada', E.Message]));
      end;
    end;

  finally
    lRelDevolucao.Destroy;
  end;

end;

procedure TFrmRelDevolucao.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelDevolucao.RadioGroupFiltroTipo',
    RadioGroupFiltroTipo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelDevolucao.RadioGroupFiltroGrupoSanguineo', RadioGroupFiltroGrupoSanguineo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelDevolucao.RadioGroupFiltroVolume',
    RadioGroupFiltroVolume.ItemIndex.ToString);

  Action := caFree;

end;

procedure TFrmRelDevolucao.FormDestroy(Sender: TObject);
begin

  FrmRelDevolucao := nil;

end;

procedure TFrmRelDevolucao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    BtnSairClick(Sender);
  end;

end;

procedure TFrmRelDevolucao.FormShow(Sender: TObject);
begin

  DateTimePickerDataInicial.DateTime := TBiblioteca.getPrimeiroDiaMes(Now);
  DateTimePickerDataFinal.DateTime := TBiblioteca.getUltimoDiaMes(Now);

  RadioGroupFiltroTipo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelDevolucao.RadioGroupFiltroTipo', '3').ToInteger;

  RadioGroupFiltroGrupoSanguineo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelDevolucao.RadioGroupFiltroGrupoSanguineo', '3').ToInteger;

  RadioGroupFiltroVolume.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelDevolucao.RadioGroupFiltroVolume', '3').ToInteger;

end;

class function TFrmRelDevolucao.getRelDevolucao(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  if (FrmRelDevolucao = nil) then
  begin

    Application.CreateForm(TFrmRelDevolucao, FrmRelDevolucao);

  end;

  try

    FrmRelDevolucao.FForeignFormKey := pFOREIGNFORMKEY;
    FrmRelDevolucao.FCodUsu := pCOD_USU;

    FrmRelDevolucao.WindowState := wsNormal;
    FrmRelDevolucao.BringToFront;
    FrmRelDevolucao.Show;

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create(Format(TMensagem.getMensagem(0), ['de relatório de devolução', E.Message]));
    end;
  end;

end;

procedure TFrmRelDevolucao.ListBoxTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelDevolucao.ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxGrupoSanguineo, EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelDevolucao.ListBoxVolumeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelDevolucao.RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, EdtGrupoSanguineo,
    BtnAddGrupoSanguineo);

end;

procedure TFrmRelDevolucao.RadioGroupFiltroTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroTipo, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelDevolucao.RadioGroupFiltroVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroVolume, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

end.
