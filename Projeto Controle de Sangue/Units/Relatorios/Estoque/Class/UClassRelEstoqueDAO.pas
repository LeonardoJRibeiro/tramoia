unit UClassRelEstoqueDAO;

interface

uses System.Classes, System.SysUtils, UClassConexao, UClassPersistencia, UClassRelEstoque;

type
  TRelEstoqueDAO = class(TPersistent)
  private
    FConexao: TConexao;
  public

    function getRelatorio(var pPersistencia: TPersistencia; const pRELESTOQUE: TRelEstoque): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils, UEnumsRelatorio, UBibliotecaRelatorio;

{ TRelEstoqueDAO }

constructor TRelEstoqueDAO.Create(const pCONEXAO: TConexao);
begin

end;

destructor TRelEstoqueDAO.Destroy;
begin

  inherited;
end;

function TRelEstoqueDAO.getRelatorio(var pPersistencia: TPersistencia; const pRELESTOQUE: TRelEstoque): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  COUNT(b.id) AS quantidade,');
    pPersistencia.Query.SQL.Add('  CONCAT(SUM(b.volume), ' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS abo,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('IF(b.sorologia=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' + QuotedStr('NÃO') +
      ') AS sorologia');
    pPersistencia.Query.SQL.Add('FROM bolsa b');

    // Se parar parâmetro pro SQL da erro.
    pPersistencia.Query.SQL.Add('WHERE b.possui_estoque = ' + QuotedStr('S'));

    TBibliotecaRelatorio.setSqlFiltro('b.tipo', pRELESTOQUE.FiltroTipo, pRELESTOQUE.ListTipo, pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.abo', pRELESTOQUE.FiltroGrupoSanguineo, pRELESTOQUE.ListGrupoSanguineo,
      pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.volume', pRELESTOQUE.FiltroVolume, pRELESTOQUE.ListVolume, pPersistencia);

    pPersistencia.Query.SQL.Add('GROUP BY');
    pPersistencia.Query.SQL.Add('  b.abo,');
    pPersistencia.Query.SQL.Add('  b.rh,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  b.sorologia');

    pPersistencia.Query.SQL.Add('ORDER BY');
    pPersistencia.Query.SQL.Add('  quantidade DESC,');
    pPersistencia.Query.SQL.Add('  volume DESC');

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
