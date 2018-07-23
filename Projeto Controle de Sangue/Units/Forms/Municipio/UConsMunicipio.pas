unit UConsMunicipio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.WinXCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFrmConsMunicipio = class(TFrmCons)
    DataSource: TDataSource;
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtConsExit(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FForeignFormKey: SmallInt;
  public
    class function getConsMunicpio(const pFOREIGNFORMKEY: SmallInt; var pID: Integer): Boolean;
  end;

var
  FrmConsMunicipio: TFrmConsMunicipio;

implementation

{$R *.dfm}

uses UClassMunicipioDao, UClassPersistencia, UDMConexao, UClassMensagem, UBiblioteca;
{ TFrmConsMunicpio }

procedure TFrmConsMunicipio.DBGridDblClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TFrmConsMunicipio.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  if (Key = VK_RETURN) then
  begin
    DBGridDblClick(Self);
  end;

end;

procedure TFrmConsMunicipio.EdtConsExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_RETURN) < 0) then
  begin
    EdtConsInvokeSearch(Self);
  end;
end;

procedure TFrmConsMunicipio.EdtConsInvokeSearch(Sender: TObject);
var
  lMunicipioDao: TMunicipioDAO;
  lPersistencia: TPersistencia;
begin
  inherited;

  lPersistencia := TPersistencia.Create(DataModuleConexao.Conexao);
  try
    lMunicipioDao := TMunicipioDAO.Create(DataModuleConexao.Conexao);
    try

      try

        Self.FClientDataSet.Close;
        if (lMunicipioDao.getConsulta(EdtCons.Text, ComboBoxTipoCons.ItemIndex, lPersistencia)) then
        begin
          Self.FClientDataSet.SetProvider(lPersistencia.DataSetProvider);
          Self.FClientDataSet.Open;
          Self.FClientDataSet.Active := True;
          DataSource.DataSet := Self.FClientDataSet;

          if (not Self.FClientDataSet.IsEmpty) then
          begin
            DBGrid.SetFocus;
          end
          else
          begin
            EdtCons.SetFocus;
          end

        end;

      except
        on E: Exception do
        begin
          raise Exception.Create(Format(TMensagem.getMensagem(1), ['municípios(s)', E.Message]));
        end;
      end;

    finally
      lMunicipioDao.Destroy;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

procedure TFrmConsMunicipio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox', 'FrmConsMunicipio.ComboBoxTipoCons',
    ComboBoxTipoCons.ItemIndex.ToString);
end;

procedure TFrmConsMunicipio.FormShow(Sender: TObject);
begin
  inherited;
  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsMunicipio.ComboBoxTipoCons', '0').ToInteger;
  ComboBoxTipoConsChange(Self);

  EdtConsInvokeSearch(Self);

  EdtCons.SetFocus;
end;

class function TFrmConsMunicipio.getConsMunicpio(const pFOREIGNFORMKEY: SmallInt; var pID: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsMunicipio, FrmConsMunicipio);
  try

    try
      FrmConsMunicipio.FForeignFormKey := pFOREIGNFORMKEY;

      Result := FrmConsMunicipio.ShowModal = mrOk;
      if (Result) then
      begin
        pID := FrmConsMunicipio.FClientDataSet.FieldByName('codigo_ibge').AsInteger;
      end
      else
      begin
        pID := -1;
      end;

    except
      on E: Exception do
      begin
        Result := False;

      end;
    end;

  finally
    FreeAndNil(FrmConsMunicipio);
  end;

end;

end.
