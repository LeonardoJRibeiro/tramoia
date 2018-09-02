unit UClassRelSaidaDAO;

interface

uses System.Classes, System.SysUtils, UClassConexao, UClassPersistencia, UClassRelSaida;

type
  TRelSaidaDAO = class(TPersistent)
  private
    FConexao: TConexao;
  public

    function getRelatorio(var pPersistencia: TPersistencia; const pRELSAIDA: TRelSaida): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils, UEnumsRelatorio, UBibliotecaRelatorio;

{ TRelSaidaDAO }

constructor TRelSaidaDAO.Create(const pCONEXAO: TConexao);
begin

end;

destructor TRelSaidaDAO.Destroy;
begin

  inherited;
end;

function TRelSaidaDAO.getRelatorio(var pPersistencia: TPersistencia; const pRELSAIDA: TRelSaida): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  s.id,');
    pPersistencia.Query.SQL.Add('  s.data_saida,');
    pPersistencia.Query.SQL.Add('  s.hospital,');
    pPersistencia.Query.SQL.Add('  p.nome,');
    pPersistencia.Query.SQL.Add('  CONCAT(p.abo, p.rh) AS abo_pac,');
    pPersistencia.Query.SQL.Add('  b.numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS abo_bol,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.volume,' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  s.prova_compatibilidade_ta,');
    pPersistencia.Query.SQL.Add('  s.prova_compatibilidade_agh,');
    pPersistencia.Query.SQL.Add('  s.prova_compatibilidade_37,');
    pPersistencia.Query.SQL.Add('  s.pai,');
    pPersistencia.Query.SQL.Add('  s.responsavel');
    pPersistencia.Query.SQL.Add('FROM saida s');

    pPersistencia.Query.SQL.Add('LEFT JOIN paciente p');
    pPersistencia.Query.SQL.Add('ON(s.id_paciente = p.id)');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON(b.id = s.id_bolsa)');

    pPersistencia.Query.SQL.Add('WHERE s.data_saida BETWEEN :pDataIni AND :pDataFim');
    pPersistencia.setParametro('pDataIni', pRELSAIDA.DataIni);
    pPersistencia.setParametro('pDataFim', pRELSAIDA.DataFim);

    TBibliotecaRelatorio.setSqlFiltro('b.tipo', pRELSAIDA.FiltroTipo, pRELSAIDA.ListTipo, pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.abo', pRELSAIDA.FiltroGrupoSanguineo, pRELSAIDA.ListGrupoSanguineo,
      pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.volume', pRELSAIDA.FiltroVolume, pRELSAIDA.ListVolume, pPersistencia);

    pPersistencia.Query.SQL.Add('ORDER BY');
    pPersistencia.Query.SQL.Add('  s.data_saida,');
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
