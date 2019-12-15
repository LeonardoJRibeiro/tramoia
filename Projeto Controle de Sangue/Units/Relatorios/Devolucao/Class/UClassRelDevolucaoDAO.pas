unit UClassRelDevolucaoDAO;

interface

uses System.Classes, System.SysUtils, UClassConexao, UClassPersistencia, UClassRelDevolucao;

type
  TRelDevolucaoDAO = class(TPersistent)
  private
    FConexao: TConexao;
  public

    function getRelatorio(var pPersistencia: TPersistencia; const pRELDEVOLUCAO: TRelDevolucao): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils, UEnumsRelatorio, UBibliotecaRelatorio;

{ TRelDevolucaoDAO }

constructor TRelDevolucaoDAO.Create(const pCONEXAO: TConexao);
begin

end;

destructor TRelDevolucaoDAO.Destroy;
begin

  inherited;
end;

function TRelDevolucaoDAO.getRelatorio(var pPersistencia: TPersistencia; const pRELDEVOLUCAO: TRelDevolucao): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  d.data_devolucao,');
    pPersistencia.Query.SQL.Add('  b.data_vencimento,');
    pPersistencia.Query.SQL.Add('  IF(b.numero_doacoes > 0 , CONCAT(b.numero_da_bolsa, ' + QuotedStr('-') +
      ', b.numero_doacoes), b.numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  b.abo,');
    pPersistencia.Query.SQL.Add('  b.rh,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS aborh,');
    pPersistencia.Query.SQL.Add('  b.origem AS destino,');
    pPersistencia.Query.SQL.Add('  d.origem_devolucao,');
    pPersistencia.Query.SQL.Add('  d.motivo_devolucao,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.volume,' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  u.nome AS responsavel');
    pPersistencia.Query.SQL.Add('FROM devolucao d');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON(b.id = d.id_bolsa)');

    pPersistencia.Query.SQL.Add('INNER JOIN usuario u');
    pPersistencia.Query.SQL.Add('ON(d.id_usuario = u.id)');

    pPersistencia.Query.SQL.Add('WHERE d.data_devolucao BETWEEN :pDataIni AND :pDataFim');

    pPersistencia.setParametro('pDataIni', pRELDEVOLUCAO.DataIni);
    pPersistencia.setParametro('pDataFim', pRELDEVOLUCAO.DataFim);

    TBibliotecaRelatorio.setSqlFiltro('b.tipo', pRELDEVOLUCAO.FiltroTipo, pRELDEVOLUCAO.ListTipo, pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.abo', pRELDEVOLUCAO.FiltroGrupoSanguineo, pRELDEVOLUCAO.ListGrupoSanguineo,
      pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.volume', pRELDEVOLUCAO.FiltroVolume, pRELDEVOLUCAO.ListVolume, pPersistencia);

    pPersistencia.Query.SQL.Add('ORDER BY');
    pPersistencia.Query.SQL.Add('  d.data_devolucao,');
    pPersistencia.Query.SQL.Add('  d.id,');
    pPersistencia.Query.SQL.Add('  b.numero_da_bolsa');

    pPersistencia.Query.Open;

    Result := True;

  except
    on E: Exception do
    begin

      Result := False;
      raise Exception.Create(E.Message);

    end;
  end;

end;

end.
