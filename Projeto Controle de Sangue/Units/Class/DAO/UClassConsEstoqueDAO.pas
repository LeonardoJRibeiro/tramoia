unit UClassConsEstoqueDAO;

interface

uses System.SysUtils, System.Classes, UClassPersistencia;

type
  TConsEstoqueDAO = class(TPersistent)
  private
    function getSqlComEstoque: string;
    function getSqlSemEstoque: string;

  public

    function getConsulta(const pTIPOCONS, pLISTESTOQUE: SmallInt; const pCHAVE: string;
      var pPersistencia: TPersistencia): Boolean;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TConsEstoqueDAO }

constructor TConsEstoqueDAO.Create;
begin
  inherited;

end;

destructor TConsEstoqueDAO.Destroy;
begin

  inherited;
end;

function TConsEstoqueDAO.getSqlComEstoque: string;
var
  SQL: TStringBuilder;
begin
  SQL := TStringBuilder.Create;

  try
    SQL.Append('SELECT');
    SQL.Append('  COUNT(b.id) AS quantidade,');
    SQL.Append('  CONCAT(SUM(b.volume), ' + QuotedStr(' mL') + ') AS volume,');
    SQL.Append('  CONCAT(b.abo, ' + QuotedStr('/') + ', b.rh) AS abo,');
    SQL.Append('  b.tipo,');
    SQL.Append('  IF(b.sorologia=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' + QuotedStr('NÃO') +
      ') AS sorologia,');
    SQL.Append('  IF(b.possui_estoque=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' +
      QuotedStr('NÃO') + ') AS possui_estoque ');
    SQL.Append('FROM bolsa b ');

    SQL.Append(' WHERE b.possui_estoque = ' + QuotedStr('S'));

    Result := SQL.ToString;
  finally
    SQL.Free;
  end;
end;

function TConsEstoqueDAO.getSqlSemEstoque: string;
var
  SQL: TStringBuilder;
begin
  SQL := TStringBuilder.Create;

  try
    SQL.Append('SELECT');
    SQL.Append('  CONCAT(b.abo, ' + QuotedStr('/') + ', b.rh) AS abo,');
    SQL.Append('  b.tipo,');
    SQL.Append('  IF(b.sorologia=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' + QuotedStr('NÃO') +
    ') AS sorologia,');
    SQL.Append('  IF(b.possui_estoque=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' +
    QuotedStr('NÃO') + ') AS possui_estoque ');
    SQL.Append('FROM bolsa b ');
    SQL.Append(' INNER JOIN saida s ');
    SQL.Append(' ON b.id = s.id_bolsa');

    SQL.Append(' WHERE  b.possui_estoque = '+QuotedStr('N')+' and CONCAT(b.abo, '+QuotedStr('/')+', b.rh)'+
    ' NOT IN (SELECT CONCAT(b.abo, '+QuotedStr('/')+', b.rh) FROM bolsa b WHERE b.possui_estoque = '+QuotedStr('S')+')');

    Result := SQL.ToString;
  finally
    SQL.Free;
  end;

end;

function TConsEstoqueDAO.getConsulta(const pTIPOCONS, pLISTESTOQUE: SmallInt; const pCHAVE: string;
  var pPersistencia: TPersistencia): Boolean;
var
  lOrderBy: string;
  lGroupBy: TStringBuilder;
begin

  lGroupBy := TStringBuilder.Create;

  try

    lGroupBy.Append(' GROUP BY');
    lGroupBy.Append('  b.abo,');
    lGroupBy.Append('  b.rh,');
    lGroupBy.Append('  b.tipo,');
    lGroupBy.Append('  b.sorologia,');

    pPersistencia.IniciaTransacao;

    case (pLISTESTOQUE) of
      0: // Com estoque.
        begin
          pPersistencia.Query.SQL.Add(getSqlComEstoque);
          lGroupBy.Append('  b.possui_estoque');
        end;
      1: // Sem estoque.
        begin
          pPersistencia.Query.SQL.Add(getSqlSemEstoque);
          lGroupBy.Append('  b.possui_estoque,');
          lGroupBy.Append('  s.data_saida ');
        end;
    end;

    if (pTIPOCONS = 0) then // Tipo.
    begin

      if (not pCHAVE.Trim.IsEmpty) then
      begin

        pPersistencia.Query.SQL.Add(' AND b.tipo = :pTipo ');
        pPersistencia.setParametro('pTipo', pCHAVE);

      end;

      lOrderBy := 'b.tipo';

    end
    else
    begin // Grupo sanguíneo

      if (not pCHAVE.Trim.IsEmpty) then
      begin

        pPersistencia.Query.SQL.Add(' AND b.abo = :pAbo ');
        pPersistencia.setParametro('pAbo', pCHAVE);

      end;

      lOrderBy := 'b.abo';

    end;

    pPersistencia.Query.SQL.Add(lGroupBy.ToString);
    pPersistencia.Query.SQL.Add(' ORDER BY ' + lOrderBy + ';');
    pPersistencia.Query.SQL.SaveToFile('C:\Users\xande\Desktop\sql.txt');

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
