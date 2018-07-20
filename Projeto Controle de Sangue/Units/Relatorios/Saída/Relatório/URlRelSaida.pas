unit URlRelSaida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Datasnap.DBClient, Data.DB, UClassRelSaida,
  UClassPersistencia;

type
  TFrmRlRelSaida = class(TForm)
    RLReport: TRLReport;
    RLBandHeader: TRLBand;
    RLLabel: TRLLabel;
    RLBandTitle: TRLBand;
    RLLabelDataSaida: TRLLabel;
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
    RLLabel1: TRLLabel;
    RLBand1: TRLBand;
    RLDBTextDataEntrada: TRLDBText;
    RLDBTextNumeroBolsa: TRLDBText;
    RLDBTextOrigem: TRLDBText;
    RLDBTextTipo: TRLDBText;
    RLDBTextVolume: TRLDBText;
    RLDBTextAboRh: TRLDBText;
    RLDBTextObservacao: TRLDBText;
    RLPanel7: TRLPanel;
    RLPanel8: TRLPanel;
    RLPanel9: TRLPanel;
    RLPanel10: TRLPanel;
    RLPanel11: TRLPanel;
    RLPanel12: TRLPanel;
    DataSource: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRlRelSaida: TFrmRlRelSaida;

implementation

{$R *.dfm}

end.
