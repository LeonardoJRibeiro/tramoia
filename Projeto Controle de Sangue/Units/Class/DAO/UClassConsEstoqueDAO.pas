unit UClassConsEstoqueDAO;

interface

uses System.SysUtils, System.Classes, UClassPersistencia;

type
  TConsEstoqueDAO = class(TPersistent)

  public

    function getConsulta(const pTIPOCONS, pFILTRARPOR: SmallInt; const pCHAVE: string;
      var pPersistencia: TPersistencia): Boolean;

    function getSqlQuantidade: string;

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

function TConsEstoqueDAO.getConsulta(const pTIPOCONS, pFILTRARPOR: SmallInt; const pCHAVE: string;
  var pPersistencia: TPersistencia): Boolean;
var
  lOrderBy: string;
  lGroupBy: TStringBuilder;
begin

  lGroupBy := TStringBuilder.Create;

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add(self.getSqlQuantidade);
    pPersistencia.Query.SQL.Add('  CONCAT(SUM(volume_atual), ' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS abo,');
    pPersistencia.Query.SQL.Add('  b.tipo');

    pPersistencia.Query.SQL.Add('FROM bolsa b ');
    pPersistencia.Query.SQL.Add('WHERE 0 = 0');

    case (pFILTRARPOR) of
      0: // Com estoque.
        begin
          pPersistencia.Query.SQL.Add('AND b.volume_atual > 0');
        end;

      1: // Sem estoque.
        begin
          pPersistencia.Query.SQL.Add('AND b.volume_atual <= 0');
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

    pPersistencia.Query.SQL.Add(' GROUP BY');
    pPersistencia.Query.SQL.Add('  b.abo,');
    pPersistencia.Query.SQL.Add('  b.rh,');
    pPersistencia.Query.SQL.Add('  b.tipo');

    pPersistencia.Query.SQL.Add(' ORDER BY ' + lOrderBy + ';');

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

function TConsEstoqueDAO.getSqlQuantidade: string;
var
  lSql: TStringList;
begin

  lSql := TStringList.Create;
  try

    lSql.Add('(SELECT');
    lSql.Add('  COUNT(bo.id)');
    lSql.Add('FROM bolsa bo');

    lSql.Add('WHERE bo.volume_atual > 0');
    lSql.Add('AND bo.abo = b.abo');
    lSql.Add('AND bo.rh = b.rh');
    lSql.Add('AND bo.tipo = b.tipo)AS quantidade,');

    Result := lSql.Text;

  finally
    FreeAndNil(lSql);
  end;
end;

end.
