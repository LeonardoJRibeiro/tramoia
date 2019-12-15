unit URlRelDevolucao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Datasnap.DBClient, Data.DB, UClassRelDevolucao,
  UClassPersistencia, RLFilters, RLPDFFilter;

type
  TFrmRlRelDevolucao = class(TForm)
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
    RLLabel2: TRLLabel;
    RLPanel11: TRLPanel;
    RLDBText2: TRLDBText;
    RLLabel1: TRLLabel;
    RLDBText3: TRLDBText;
    RLPanel10: TRLPanel;
    RLLabel3: TRLLabel;
    RLLabelAboRh: TRLLabel;
    RLLabel4: TRLLabel;
    RLPanel12: TRLPanel;
    RLDBText4: TRLDBText;
    RLPanel9: TRLPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RLReportBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private

    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
    FRelDevolucao: TRelDevolucao;
    FPersistencia: TPersistencia;
    FClientDataSet: TClientDataSet;

    function PreparaRelatorio: Boolean;

  public
    class function getRlRelDevolucao(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
      const pRELDEVOLUCAO: TRelDevolucao): Boolean;
  end;

var
  FrmRlRelDevolucao: TFrmRlRelDevolucao;

implementation

uses UClassMensagem, UDMConexao, UClassRelDevolucaoDAO;

{$R *.dfm}
{ TFrmRlRelDevolucao }

procedure TFrmRlRelDevolucao.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Self.FClientDataSet.Close;
  Self.FClientDataSet.Active := False;

  DataSource.DataSet := nil;

end;

procedure TFrmRlRelDevolucao.FormCreate(Sender: TObject);
begin

  Self.FPersistencia := TPersistencia.Create(DMConexao.Conexao);

  Self.FClientDataSet := TClientDataSet.Create(nil);
  Self.FClientDataSet.Aggregates.Clear;
  Self.FClientDataSet.Params.Clear;
  Self.FClientDataSet.AggregatesActive := False;
  Self.FClientDataSet.AutoCalcFields := True;
  Self.FClientDataSet.FetchOnDemand := True;
  Self.FClientDataSet.ObjectView := True;

end;

procedure TFrmRlRelDevolucao.FormDestroy(Sender: TObject);
begin

  Self.FPersistencia.Destroy;
  Self.FClientDataSet.Destroy;

end;

class function TFrmRlRelDevolucao.getRlRelDevolucao(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer;
  const pRELDEVOLUCAO: TRelDevolucao): Boolean;
begin

  Application.CreateForm(TFrmRlRelDevolucao, FrmRlRelDevolucao);
  try

    try

      FrmRlRelDevolucao.FForeignFormKey := pFOREIGNFORMKEY;
      FrmRlRelDevolucao.FCodUsu := pCOD_USU;
      FrmRlRelDevolucao.FRelDevolucao := pRELDEVOLUCAO;

      Result := False;

      if (FrmRlRelDevolucao.PreparaRelatorio) then
      begin

        if (pRELDEVOLUCAO.Visualizar) then
        begin

          Result := FrmRlRelDevolucao.RLReport.PreviewModal;

        end
        else
        begin

          FrmRlRelDevolucao.RLReport.Print;
          Result := True;

        end;

      end;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de relatório de devolução', E.Message]));
      end;
    end;

  finally
    FreeAndNil(FrmRlRelDevolucao);
  end;

end;

function TFrmRlRelDevolucao.PreparaRelatorio: Boolean;
var
  lRelDevolucaoDAO: TRelDevolucaoDAO;
begin

  lRelDevolucaoDAO := TRelDevolucaoDAO.Create(DMConexao.Conexao);
  try

    try

      if (lRelDevolucaoDAO.getRelatorio(Self.FPersistencia, Self.FRelDevolucao)) then
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
        raise Exception.Create(Format(TMensagem.getMensagem(1), ['devolucções para gerar o relatório', E.Message]));
      end;
    end;

  finally
    lRelDevolucaoDAO.Destroy;
  end;

end;

procedure TFrmRlRelDevolucao.RLReportBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin

  SelectedFilter := RLPDFFilter;

end;

end.
