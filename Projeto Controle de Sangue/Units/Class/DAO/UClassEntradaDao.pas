unit UClassEntradaDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistencia, UClassEntrada, UClassPersistBaseDados;

type
  TEntradaDAO = class(TPersistBase<TEntrada>)
  private

  public

    function getConsulta(const pCHAVE: string; const pDATAINI, pDATAFIM: TDate; const pTIPOCONS: SmallInt;
      var pPersistencia: TPersistencia): Boolean;

  end;

implementation

function TEntradaDAO.getConsulta(const pCHAVE: string; const pDATAINI, pDATAFIM: TDate; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
var
  lPos: Integer;
  lNumeroBolsa: string;
  lNumeroDoacoes: Integer;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  e.id,');
    pPersistencia.Query.SQL.Add('  u.nome AS responsavel,');
    pPersistencia.Query.SQL.Add('  e.data_entrada,');
    pPersistencia.Query.SQL.Add('  IF(b.numero_doacoes > 0 , CONCAT(b.numero_da_bolsa, ' + QuotedStr('-') +
      ', b.numero_doacoes), b.numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) AS grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('  b.id AS id_bolsa,');
    pPersistencia.Query.SQL.Add('  b.origem,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  IF(b.pai = ' + QuotedStr('P') + ',' + QuotedStr('Pos') + ',' + QuotedStr('Neg') +
      ') AS pai,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.volume,' + QuotedStr(' mL') + ') AS volume');

    pPersistencia.Query.SQL.Add('FROM entrada e');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON (e.id_bolsa = b.id)');

    pPersistencia.Query.SQL.Add('INNER JOIN usuario u');
    pPersistencia.Query.SQL.Add('ON (e.id_usuario = u.id)');

    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pTIPOCONS) of
      0: // Código(Id)
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND e.id = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY id');

        end;

      1: // Número da Bolsa
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

            pPersistencia.Query.SQL.Add('ORDER BY');
            pPersistencia.Query.SQL.Add('  e.id,');
            pPersistencia.Query.SQL.Add('  e.data_entrada,');
            pPersistencia.Query.SQL.Add('  b.numero_da_bolsa');
          end;

        end;

      2: // Período
        begin
          pPersistencia.Query.SQL.Add('AND e.data_entrada BETWEEN :pDataIni AND :pDataFim');
          pPersistencia.setParametro('pDataIni', pDATAINI);
          pPersistencia.setParametro('pDataFim', pDATAFIM);

          pPersistencia.Query.SQL.Add('ORDER BY');
          pPersistencia.Query.SQL.Add('  e.data_entrada,');
          pPersistencia.Query.SQL.Add('  e.id');
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
