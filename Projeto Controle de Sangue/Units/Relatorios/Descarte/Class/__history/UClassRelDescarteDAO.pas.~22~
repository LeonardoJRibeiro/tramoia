unit UClassRelDescarteDAO;

interface

uses System.Classes, System.SysUtils, UClassConexao, UClassPersistencia, UClassRelDescarte;

type
  TRelDescarteDAO = class(TPersistent)
  private
    FConexao: TConexao;
  public

    function getRelatorio(var pPersistencia: TPersistencia; const pRELDESCARTE: TRelDescarte): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils, UEnumsRelatorio, UBibliotecaRelatorio;

{ TRelDescarteDAO }

constructor TRelDescarteDAO.Create(const pCONEXAO: TConexao);
begin

end;

destructor TRelDescarteDAO.Destroy;
begin

  inherited;
end;

function TRelDescarteDAO.getRelatorio(var pPersistencia: TPersistencia; const pRELDESCARTE: TRelDescarte): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  d.id,');
    pPersistencia.Query.SQL.Add('  d.data_coleta,');
    pPersistencia.Query.SQL.Add('  d.data_descarte,');
    pPersistencia.Query.SQL.Add('  d.motivo,');
    pPersistencia.Query.SQL.Add('  b.numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  b.abo,');
    pPersistencia.Query.SQL.Add('  b.rh,');
    pPersistencia.Query.SQL.Add('  b.irradiada,');
    pPersistencia.Query.SQL.Add('  b.filtrada,');
    pPersistencia.Query.SQL.Add('  b.fracionada,');
    pPersistencia.Query.SQL.Add('  b.fenotipada,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS aborh,');
    pPersistencia.Query.SQL.Add('  b.origem,');
    pPersistencia.Query.SQL.Add('  b.data_vencimento,');

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

    pPersistencia.Query.SQL.Add('  CONCAT(d.volume,' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  u.nome AS responsavel');
    pPersistencia.Query.SQL.Add('FROM descarte d');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON(b.id = d.id_bolsa)');

    pPersistencia.Query.SQL.Add('INNER JOIN usuario u');
    pPersistencia.Query.SQL.Add('ON(d.id_usuario = u.id)');

    pPersistencia.Query.SQL.Add('WHERE d.data_descarte BETWEEN :pDataIni AND :pDataFim');
    pPersistencia.setParametro('pDataIni', pRELDESCARTE.DataIni);
    pPersistencia.setParametro('pDataFim', pRELDESCARTE.DataFim);

    TBibliotecaRelatorio.setSqlFiltro('b.tipo', pRELDESCARTE.FiltroTipo, pRELDESCARTE.ListTipo, pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.abo', pRELDESCARTE.FiltroGrupoSanguineo, pRELDESCARTE.ListGrupoSanguineo,
      pPersistencia);

    TBibliotecaRelatorio.setSqlFiltro('b.volume', pRELDESCARTE.FiltroVolume, pRELDESCARTE.ListVolume, pPersistencia);

    pPersistencia.Query.SQL.Add('ORDER BY');
    pPersistencia.Query.SQL.Add('  d.data_descarte,');
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
