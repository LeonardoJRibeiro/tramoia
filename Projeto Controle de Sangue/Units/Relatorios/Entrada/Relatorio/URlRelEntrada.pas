unit URlRelEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Datasnap.DBClient, Data.DB, UClassRelEntrada,
  UClassPersistencia, RLFilters, RLPDFFilter;

type
  TFrmRlRelEntrada = class(TForm)
    RLReport: TRLReport;
    RLBandHeader: TRLBand;
    RLLabel: TRLLabel;
    RLBandTitle: TRLBand;
    RLLabelDataEntrada: TRLLabel;
    RLPanel1: TRLPanel;
    RLLabelNumeroBolsa: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabelOrigem: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabelTipo: TRLLabel;
    RLPanel4: TRLPanel;
    RLLabelVolume: TRLLabel;
    RLPanel5: TRLPanel;
    RLLabelAboRh: TRLLabel;
    RLPanel6: TRLPanel;
    DataSource: TDataSource;
    RLBand1: TRLBand;
    RLDBTextDataEntrada: TRLDBText;
    RLDBTextNumeroBolsa: TRLDBText;
    RLDBTextOrigem: TRLDBText;
    RLDBTextTipo: TRLDBText;
    RLDBTextVolume: TRLDBText;
    RLDBTextAboRh: TRLDBText;
    RLPanel13: TRLPanel;
    RLPanel14: TRLPanel;
    RLPanel15: TRLPanel;
    RLPanel16: TRLPanel;
    RLPanel17: TRLPanel;
    RLPanel18: TRLPanel;
    RLBand2: TRLBand;
    RLLabelTotalEntradas: TRLLabel;
    RLDBResultTotalEntradas: TRLDBResult;
    RLPDFFilter: TRLPDFFilter;
    RLLabelResponsavel: TRLLabel;
    RLPanel7: TRLPanel;
    RLPanel8: TRLPanel;
    RLDBText1: TRLDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RLReportBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private

    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
    FRelEntrada: TRelEntrada;
    FPersistencia: TPersistencia;
    FClientDataSet: TClientDataSet;

    function PreparaRelatorio: Boolean;

  public
    class function getRlRelEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
      const pRELENTRADA: TRelEntrada): Boolean;
  end;

var
  FrmRlRelEntrada: TFrmRlRelEntrada;

implementation

uses UClassMensagem, UDMConexao, UClassRelEntradaDAO;

{$R *.dfm}
{ TFrmRelEntrada }

procedure TFrmRlRelEntrada.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Self.FClientDataSet.Close;
  Self.FClientDataSet.Active := False;

  DataSource.DataSet := nil;

end;

procedure TFrmRlRelEntrada.FormCreate(Sender: TObject);
begin

  Self.FPersistencia := TPersistencia.Create(DataModuleConexao.Conexao);

  Self.FClientDataSet := TClientDataSet.Create(nil);
  Self.FClientDataSet.Aggregates.Clear;
  Self.FClientDataSet.Params.Clear;
  Self.FClientDataSet.AggregatesActive := False;
  Self.FClientDataSet.AutoCalcFields := True;
  Self.FClientDataSet.FetchOnDemand := True;
  Self.FClientDataSet.ObjectView := True;

end;

procedure TFrmRlRelEntrada.FormDestroy(Sender: TObject);
begin

  Self.FPersistencia.Destroy;
  Self.FClientDataSet.Destroy;

end;

class function TFrmRlRelEntrada.getRlRelEntrada(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
  const pRELENTRADA: TRelEntrada): Boolean;
begin

  Application.CreateForm(TFrmRlRelEntrada, FrmRlRelEntrada);
  try

    try

      FrmRlRelEntrada.FForeignFormKey := pFOREIGNFORMKEY;
      FrmRlRelEntrada.FCodUsu := pCOD_USU;
      FrmRlRelEntrada.FRelEntrada := pRELENTRADA;

      Result := False;

      if (FrmRlRelEntrada.PreparaRelatorio) then
      begin

        if (pRELENTRADA.Visualizar) then
        begin

          Result := FrmRlRelEntrada.RLReport.PreviewModal;

        end
        else
        begin

          FrmRlRelEntrada.RLReport.Print;
          Result := True;

        end;

      end;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de relatório de entrada', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmRlRelEntrada);
  end;

end;

function TFrmRlRelEntrada.PreparaRelatorio: Boolean;
var
  lRelEntradaDAO: TRelEntradaDAO;
begin

  lRelEntradaDAO := TRelEntradaDAO.Create(DataModuleConexao.Conexao);
  try

    try

      if (lRelEntradaDAO.getRelatorio(Self.FPersistencia, Self.FRelEntrada)) then
      begin

        Result := not Self.FPersistencia.Query.IsEmpty;

        if (Result) then
        begin

          // Usa o ClientDataSet pra não dar erro com o TSQLQuery qnd for gerar o relatório.
          DataSource.DataSet := Self.FPersistencia.Query;

        end
        else
        begin

          MessageBox(Self.Handle, 'Não há registros na sua busca', 'Aviso', mb_Ok);

        end;

      end;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(1), ['entradas para gerar o relatório', E.Message]));
      end;
    end;

  finally
    lRelEntradaDAO.Destroy;
  end;

end;

procedure TFrmRlRelEntrada.RLReportBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin

  SelectedFilter := RLPDFFilter;

end;

end.
