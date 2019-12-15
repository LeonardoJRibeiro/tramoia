unit UClassDevolucaoDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistBaseDados, UClassConexao, UClassPersistencia, UClassDevolucao;

type
  TDevolucaoDAO = class(TPersistBase<TDevolucao>)
  private

  public

    function getConsulta(const pCHAVE: string; const pDATAINI, pDATAFIM: TDate; const pTIPOCONS: SmallInt;
      var pPersistencia: TPersistencia): Boolean;

    function getBolsaJaVinculada(const pNUMERO_DA_BOLSA: string): Boolean;

  end;

implementation

{ TDevolucaoDAO }

function TDevolucaoDAO.getBolsaJaVinculada(const pNUMERO_DA_BOLSA: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(d.id)');
      lPersistencia.Query.SQL.Add('FROM devolucao d');

      lPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
      lPersistencia.Query.SQL.Add('ON(d.id_bolsa = b.id)');

      lPersistencia.Query.SQL.Add('WHERE b.numero_da_bolsa = :pNumero_Da_Bolsa');
      lPersistencia.setParametro('pNumero_Da_Bolsa', pNUMERO_DA_BOLSA);

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.Fields[0].AsInteger > 0;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TDevolucaoDAO.getConsulta(const pCHAVE: string; const pDATAINI, pDATAFIM: TDate; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
var
  lPos: Integer;
  lNumeroBolsa: string;
  lNumeroDoacoes: Integer;
begin
  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  d.id,');
    pPersistencia.Query.SQL.Add('  u.nome AS responsavel,');
    pPersistencia.Query.SQL.Add('  d.data_devolucao,');
    pPersistencia.Query.SQL.Add('  d.motivo_devolucao,');
    pPersistencia.Query.SQL.Add('  d.origem_devolucao,');
    pPersistencia.Query.SQL.Add('  IF(b.numero_doacoes > 0 , CONCAT(b.numero_da_bolsa, ' + QuotedStr('-') +
      ', b.numero_doacoes), b.numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('  b.origem AS destino,');
    pPersistencia.Query.SQL.Add('  b.id id_bolsa,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  b.data_vencimento,');
    pPersistencia.Query.SQL.Add('  b.data_coleta,');
    pPersistencia.Query.SQL.Add('  CONCAT(d.volume,' + QuotedStr(' mL') + ') AS volume');

    pPersistencia.Query.SQL.Add('FROM devolucao d');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON (d.id_bolsa = b.id)');

    pPersistencia.Query.SQL.Add('INNER JOIN usuario u');
    pPersistencia.Query.SQL.Add('ON (d.id_usuario = u.id)');

    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pTIPOCONS) of
      0: // C�digo(Id)
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND d.id = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY d.id');

        end;

      1: // N�mero da Bolsa
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            lPos := Pos('-', Trim(pCHAVE));

            if (lPos <> 0) then
            begin

              if (Copy(Trim(pCHAVE), lPos + 1, Trim(pCHAVE).Length).Trim = '') then
              begin
                lNumeroBolsa := Copy(Trim(pCHAVE), 0, Trim(pCHAVE).Length - 1).Trim;
                lNumeroDoacoes := -1;
              end
              else
              begin
                lNumeroBolsa := Copy(Trim(pCHAVE), 0, lPos - 1).Trim;
                lNumeroDoacoes := Copy(Trim(pCHAVE), lPos + 1, Trim(pCHAVE).Length).Trim.ToInteger;
              end;

            end
            else
            begin
              lNumeroBolsa := Trim(pCHAVE);
              lNumeroDoacoes := -1;
            end;

            pPersistencia.Query.SQL.Add('AND b.numero_da_bolsa = :pNumero_Da_Bolsa');
            pPersistencia.setParametro('pNumero_Da_Bolsa', lNumeroBolsa);

            if (lNumeroDoacoes > 0) then
            begin
              pPersistencia.Query.SQL.Add('AND b.numero_doacoes = :pNumero_Doacoes');
              pPersistencia.setParametro('pNumero_Doacoes', lNumeroDoacoes);
            end;

          end;

          pPersistencia.Query.SQL.Add('ORDER BY');
          pPersistencia.Query.SQL.Add('  d.id,');
          pPersistencia.Query.SQL.Add('  d.data_devolucao,');
          pPersistencia.Query.SQL.Add('  b.numero_da_bolsa');

        end;

      2: // Per�odo
        begin
          pPersistencia.Query.SQL.Add('AND d.data_devolucao BETWEEN :pDataIni AND :pDataFim');
          pPersistencia.setParametro('pDataIni', pDATAINI);
          pPersistencia.setParametro('pDataFim', pDATAFIM);

          pPersistencia.Query.SQL.Add('ORDER BY');
          pPersistencia.Query.SQL.Add('  d.data_devolucao,');
          pPersistencia.Query.SQL.Add('  d.id');
        end;

    end;

    pPersistencia.Query.SQL.Add('LIMIT 500;');

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
