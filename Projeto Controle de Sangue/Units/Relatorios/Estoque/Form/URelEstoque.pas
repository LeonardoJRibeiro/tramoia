unit URelEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmRelEstoque = class(TForm)
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
    PanelTipo: TPanel;
    GroupBoxTipo: TGroupBox;
    EdtTipo: TEdit;
    BtnAddTipo: TBitBtn;
    RadioGroupFiltroTipo: TRadioGroup;
    ListBoxTipo: TListBox;
    PanelVolume: TPanel;
    GroupBoxVolume: TGroupBox;
    EdtVolume: TEdit;
    BtnAddVolume: TBitBtn;
    RadioGroupFiltroVolume: TRadioGroup;
    ListBoxVolume: TListBox;
    procedure BtnAddTipoClick(Sender: TObject);
    procedure BtnAddGrupoSanguineoClick(Sender: TObject);
    procedure BtnAddVolumeClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnVisualizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxTipoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxVolumeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
    procedure RadioGroupFiltroTipoClick(Sender: TObject);
    procedure RadioGroupFiltroVolumeClick(Sender: TObject);
  private
    FForeignFormKey: Smallint;
    FCodUsu: Integer;

    procedure ChamaRelatorio(const pSENDER: TObject);

  public

    class function getRelEstoque(const pFOREIGNFORMKEY: SmallInt;
      const pCOD_USU: Integer): Boolean;

  end;

var
  FrmRelEstoque: TFrmRelEstoque;

implementation

uses System.DateUtils, UBiblioteca, UBibliotecaRelatorio, UClassMensagem, UClassRelEstoque, URlRelEstoque,
  UEnumsRelatorio, UClassForeignKeyForms;

{$R *.dfm}

procedure TFrmRelEstoque.BtnAddGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, GroupBoxGrupoSanguineo,
    EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelEstoque.BtnAddTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroTipo, ListBoxTipo, GroupBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelEstoque.BtnAddVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.BtnAddClickGeral(RadioGroupFiltroVolume, ListBoxVolume, GroupBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelEstoque.BtnImprimirClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelEstoque.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmRelEstoque.BtnVisualizarClick(Sender: TObject);
begin

  Self.ChamaRelatorio(Sender);

end;

procedure TFrmRelEstoque.ChamaRelatorio(const pSENDER: TObject);
var
  lRelEstoque: TRelEstoque;

  // Uso esse objeto auxiliar por que o Delphi da erro de compilação se eu passar a property do StringList.
  lAuxStringList: TStringList;
begin

  lRelEstoque := TRelEstoque.Create;
  try

    try

      lRelEstoque.FiltroTipo := TTipoFiltro(RadioGroupFiltroTipo.ItemIndex);

      lRelEstoque.FiltroGrupoSanguineo := TTipoFiltro(RadioGroupFiltroGrupoSanguineo.ItemIndex);

      lRelEstoque.FiltroVolume := TTipoFiltro(RadioGroupFiltroVolume.ItemIndex);

      lRelEstoque.Visualizar := pSENDER = BtnVisualizar;

      lAuxStringList := TStringList.Create;
      try

        TBibliotecaRelatorio.PreparaStringList(lRelEstoque.FiltroTipo, ListBoxTipo, lAuxStringList);
        lRelEstoque.ListTipo.Text := lAuxStringList.Text;
        lAuxStringList.Clear;

        TBibliotecaRelatorio.PreparaStringList(lRelEstoque.FiltroGrupoSanguineo, ListBoxGrupoSanguineo,
          lAuxStringList);
        lRelEstoque.ListGrupoSanguineo.Text := lAuxStringList.Text;
        lAuxStringList.Clear;

        TBibliotecaRelatorio.PreparaStringList(lRelEstoque.FiltroVolume, ListBoxVolume, lAuxStringList);
        lRelEstoque.ListVolume.Text := lAuxStringList.Text;

      finally
        lAuxStringList.Destroy;
      end;

      if not (TFrmRlRelEstoque.getRlRelEstoque(TForeignKeyForms.FIdURelEstoque, Self.FCodUsu, lRelEstoque)) then
      begin
        MessageBox(self.Handle, 'Não há registros na sua busca', 'Aviso', MB_OK);
      end;

    except
      on E: Exception do
      begin
        raise Exception.Create(Format(TMensagem.getMensagem(7), ['relatório de estoque', E.Message]));
      end;
    end;

  finally
    lRelEstoque.Destroy;
  end;

end;

procedure TFrmRelEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEstoque.RadioGroupFiltroTipo',
    RadioGroupFiltroTipo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEstoque.RadioGroupFiltroGrupoSanguineo',
    RadioGroupFiltroGrupoSanguineo.ItemIndex.ToString);

  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup', 'FrmRelEstoque.RadioGroupFiltroVolume',
    RadioGroupFiltroVolume.ItemIndex.ToString);

  Action := caFree;

end;

procedure TFrmRelEstoque.FormDestroy(Sender: TObject);
begin

  FrmRelEstoque := nil;

end;

procedure TFrmRelEstoque.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    BtnSairClick(Sender);
  end;

end;

procedure TFrmRelEstoque.FormShow(Sender: TObject);
begin

  RadioGroupFiltroTipo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelEstoque.RadioGroupFiltroTipo', '3').ToInteger;

  RadioGroupFiltroGrupoSanguineo.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelEstoque.RadioGroupFiltroGrupoSanguineo', '3').ToInteger;

  RadioGroupFiltroVolume.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexRadioGroup',
    'FrmRelEstoque.RadioGroupFiltroVolume', '3').ToInteger;

end;

class function TFrmRelEstoque.getRelEstoque(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  if (FrmRelEstoque = nil) then
  begin

    Application.CreateForm(TFrmRelEstoque, FrmRelEstoque);

  end;

  try

    FrmRelEstoque.FForeignFormKey := pFOREIGNFORMKEY;
    FrmRelEstoque.FCodUsu := pCOD_USU;

    FrmRelEstoque.WindowState := wsNormal;
    FrmRelEstoque.BringToFront;
    FrmRelEstoque.Show;

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create(Format(TMensagem.getMensagem(0), ['de relatório de estoque', E.Message]));
    end;
  end;

end;

procedure TFrmRelEstoque.ListBoxTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelEstoque.ListBoxGrupoSanguineoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxGrupoSanguineo, EdtGrupoSanguineo, BtnAddGrupoSanguineo);

end;

procedure TFrmRelEstoque.ListBoxVolumeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  TBibliotecaRelatorio.ListBoxKeyDownGeral(Key, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

procedure TFrmRelEstoque.RadioGroupFiltroGrupoSanguineoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroGrupoSanguineo, ListBoxGrupoSanguineo, EdtGrupoSanguineo,
    BtnAddGrupoSanguineo);

end;

procedure TFrmRelEstoque.RadioGroupFiltroTipoClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroTipo, ListBoxTipo, EdtTipo, BtnAddTipo);

end;

procedure TFrmRelEstoque.RadioGroupFiltroVolumeClick(Sender: TObject);
begin

  TBibliotecaRelatorio.RadioGroupClickGeral(RadioGroupFiltroVolume, ListBoxVolume, EdtVolume, BtnAddVolume);

end;

end.
