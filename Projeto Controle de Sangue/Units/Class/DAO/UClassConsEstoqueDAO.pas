unit UClassConsEstoqueDAO;

interface

uses System.SysUtils, System.Classes, UClassPersistencia;

type
  TConsEstoqueDAO = class(TPersistent)
  private
    procedure setSqlComEstoque(var pPersistencia: TPersistencia);
    procedure setSqlSemEstoque(var pPersistencia: TPersistencia);

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

procedure TConsEstoqueDAO.setSqlComEstoque(var pPersistencia: TPersistencia);
begin

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  COUNT(b.id) AS quantidade,');
    pPersistencia.Query.SQL.Add('  CONCAT(SUM(b.volume), ' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, ' + QuotedStr('/') + ', b.rh) AS abo,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  IF(b.sorologia=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' + QuotedStr('NÃO') +
      ') AS sorologia,');
    pPersistencia.Query.SQL.Add('  IF(b.possui_estoque=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' +
      QuotedStr('NÃO') + ') AS possui_estoque ');
    pPersistencia.Query.SQL.Add('FROM bolsa b ');

    pPersistencia.Query.SQL.Add('WHERE b.possui_estoque = ' + QuotedStr('S'));

end;

procedure TConsEstoqueDAO.setSqlSemEstoque(var pPersistencia: TPersistencia);
begin

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  (SELECT MAX(s.data_saida) FROM saida s LEFT JOIN bolsa b ON s.id_bolsa = b.id WHERE s.id_bolsa = b.id) AS ultimasaida,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, ' + QuotedStr('/') + ', b.rh) AS abo,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  IF(b.sorologia=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' + QuotedStr('NÃO') +
      ') AS sorologia,');
    pPersistencia.Query.SQL.Add('  IF(b.possui_estoque=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' +
      QuotedStr('NÃO') + ') AS possui_estoque ');
    pPersistencia.Query.SQL.Add('FROM bolsa b ');

    pPersistencia.Query.SQL.Add('WHERE  b.possui_estoque = '+QuotedStr('N')+' and CONCAT(b.abo, '+QuotedStr('/')+', b.rh) NOT IN (SELECT CONCAT(b.abo, '+QuotedStr('/')+', b.rh) FROM bolsa b WHERE b.possui_estoque = '+QuotedStr('S')+')');

end;

function TConsEstoqueDAO.getConsulta(const pTIPOCONS, pLISTESTOQUE: SmallInt; const pCHAVE: string;
  var pPersistencia: TPersistencia): Boolean;
var
  lOrderBy: string;
begin

  try

    pPersistencia.IniciaTransacao;

    case (pLISTESTOQUE) of
      0: // Com estoque.
        begin
          setSqlComEstoque(pPersistencia);
        end;
      1: // Sem estoque.
        begin
          setSqlSemEstoque(pPersistencia);
        end;
    end;

    if (pTIPOCONS = 0) then // Tipo.
    begin

      if (not pCHAVE.Trim.IsEmpty) then
      begin

        pPersistencia.Query.SQL.Add(' AND b.tipo = :pTipo');
        pPersistencia.setParametro('pTipo', pCHAVE);

      end;

      lOrderBy := 'b.tipo';

    end
    else
    begin // Grupo sanguíneo

      if (not pCHAVE.Trim.IsEmpty) then
      begin

        pPersistencia.Query.SQL.Add(' AND b.abo = :pAbo');
        pPersistencia.setParametro('pAbo', pCHAVE);

      end;

      lOrderBy := 'b.abo';

    end;

    pPersistencia.Query.SQL.Add(' GROUP BY');
    pPersistencia.Query.SQL.Add('  b.abo,');
    pPersistencia.Query.SQL.Add('  b.rh,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  b.sorologia,');
    pPersistencia.Query.SQL.Add('  b.possui_estoque');

    pPersistencia.Query.SQL.Add(' ORDER BY ' + lOrderBy);

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
