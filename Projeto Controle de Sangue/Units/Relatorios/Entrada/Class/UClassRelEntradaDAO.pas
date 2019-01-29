unit UClassRelEntradaDAO;

interface

uses System.Classes, System.SysUtils, UClassConexao, UClassPersistencia, UClassRelEntrada;

type
  TRelEntradaDAO = class(TPersistent)
  private
    FConexao: TConexao;
  public

    function getRelatorio(var pPersistencia: TPersistencia; const pRELENTRADA: TRelEntrada): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils, UEnumsRelatorio, UBibliotecaRelatorio;

{ TRelEntradaDAO }

constructor TRelEntradaDAO.Create(const pCONEXAO: TConexao);
begin

end;

destructor TRelEntradaDAO.Destroy;
begin

  inherited;
end;

function TRelEntradaDAO.getRelatorio(var pPersistencia: TPersistencia; const pRELENTRADA: TRelEntrada): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  e.data_entrada,');
    pPersistencia.Query.SQL.Add('  IF(b.numero_doacoes > 0 , CONCAT(b.numero_da_bolsa, ' + QuotedStr('-') +
      ', b.numero_doacoes), b.numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  b.abo,');
    pPersistencia.Query.SQL.Add('  b.rh,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS aborh,');
    pPersistencia.Query.SQL.Add('  b.origem,');

    pPersistencia.Query.SQL.Add('  if(b.pai = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg') +
      ') AS pai,');

    pPersistencia.Query.SQL.Add('  if(b.chagas = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg') +
      ') AS chagas,');

    pPersistencia.Query.SQL.Add('  if(b.sifilis = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg') +
      ') AS sifilis,');

    pPersistencia.Query.SQL.Add('  if(b.hepatiteB = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg')
      + ') AS hepatiteB,');

    pPersistencia.Query.SQL.Add('  if(b.hepatiteC = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg')
      + ') AS hepatiteC,');

    pPersistencia.Query.SQL.Add('  if(b.hiv = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg') +
      ') AS  hiv,');

    pPersistencia.Query.SQL.Add('  if(b.htlv = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg') +
      ') AS htlv,');

    pPersistencia.Query.SQL.Add('  if(b.hemoglobinas = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' +
      QuotedStr('Neg') + ') AS hemoglobinas,');

    pPersistencia.Query.SQL.Add('  CONCAT(b.volume,' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  u.nome AS responsavel');
    pPersistencia.Query.SQL.Add('FROM entrada e');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON(b.id = e.id_bolsa)');

    pPersistencia.Query.SQL.Add('INNER JOIN usuario u');
    pPersistencia.Query.SQL.Add('ON(e.id_usuario = u.id)');

    pPersistencia.Query.SQL.Add('WHERE e.data_entrada BETWEEN :pDataIni AND :pDataFim');

    pPersistencia.setParametro('pDataIni', pRELENTRADA.DataIni);
    pPersistencia.setParametro('pDataFim', pRELENTRADA.DataFim);

    TBibliotecaRelatorio.setSqlFiltro('b.tipo', pRELENTRADA.FiltroTipo, pRELENTRADA.ListTipo, pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.abo', pRELENTRADA.FiltroGrupoSanguineo, pRELENTRADA.ListGrupoSanguineo,
      pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.volume', pRELENTRADA.FiltroVolume, pRELENTRADA.ListVolume, pPersistencia);

    pPersistencia.Query.SQL.Add('ORDER BY');
    pPersistencia.Query.SQL.Add('  e.data_entrada,');
    pPersistencia.Query.SQL.Add('  e.id,');
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
