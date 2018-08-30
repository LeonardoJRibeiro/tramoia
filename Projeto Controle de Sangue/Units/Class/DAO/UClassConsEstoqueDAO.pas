unit UClassConsEstoqueDAO;

interface

uses System.SysUtils, System.Classes, UClassPersistencia;

type
  TConsEstoqueDAO = class(TPersistent)
  private

  public

    function getConsulta(const pTIPOCONS: SmallInt; const pCHAVE: string; var pPersistencia: TPersistencia): Boolean;

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

function TConsEstoqueDAO.getConsulta(const pTIPOCONS: SmallInt; const pCHAVE: string;
  var pPersistencia: TPersistencia): Boolean;
var
  lOrderBy: string;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  COUNT(b.id) AS quantidade,');
    pPersistencia.Query.SQL.Add('  CONCAT(sum(b.volume), ' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, ' + QuotedStr('/') + ', b.rh) AS abo,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('IF(b.sorologia=' + QuotedStr('S') + ',' + QuotedStr('SIM') + ',' + QuotedStr('NÃO') +
      ') AS sorologia');
    pPersistencia.Query.SQL.Add('FROM bolsa b');

    pPersistencia.Query.SQL.Add('WHERE  possui_estoque='+QuotedStr('S'));

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
    pPersistencia.Query.SQL.Add('  b.sorologia');

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
