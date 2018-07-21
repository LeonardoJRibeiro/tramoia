unit UConsMunicipio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.WinXCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFrmConsMunicpio = class(TFrmCons)
    DataSource: TDataSource;
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtConsExit(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
  public
    class function getConsMunicpio(const pFOREIGNFORMKEY: SmallInt; var pID: Integer): Boolean;
  end;

var
  FrmConsMunicpio: TFrmConsMunicpio;

implementation

{$R *.dfm}

uses UClassMunicipioDao, UClassPersistencia, UDMConexao, UClassMensagem;
{ TFrmConsMunicpio }

procedure TFrmConsMunicpio.DBGridDblClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TFrmConsMunicpio.EdtConsExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_RETURN) < 0) then
  begin
    EdtConsInvokeSearch(Self);
  end;
end;

procedure TFrmConsMunicpio.EdtConsInvokeSearch(Sender: TObject);
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

procedure TFrmConsMunicpio.FormShow(Sender: TObject);
begin
  inherited;
  EdtConsInvokeSearch(Self);
end;

class function TFrmConsMunicpio.getConsMunicpio(const pFOREIGNFORMKEY: SmallInt; var pID: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsMunicpio, FrmConsMunicpio);
  try

    try
      FrmConsMunicpio.FForeignFormKey := pFOREIGNFORMKEY;

      Result := FrmConsMunicpio.ShowModal = mrOk;
      if (Result) then
      begin
        pID := FrmConsMunicpio.FClientDataSet.FieldByName('codigo_ibge').AsInteger;
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
    FreeAndNil(FrmConsMunicpio);
  end;

end;

end.
