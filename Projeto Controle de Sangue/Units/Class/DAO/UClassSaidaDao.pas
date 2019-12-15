unit UClassSaidaDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistBaseDados, UClassPersistencia,
  UClassSaida;

type
  TSaidaDAO = class(TPersistBase<TSaida>)
  private

  public

    function getIdSaidaByNumeroBolsa(const pNUMERO_DA_BOLSA: string): Integer;

    function getExisteSaidaPaciente(const pID_PACIENTE: Integer): Boolean;

    function getBolsaJaVinculada(const pNUMERO_DA_BOLSA: string): Boolean;

    function getConsulta(const pCHAVE: string; const pDATAINI, pDATAFIM: TDate; const pTIPOCONS: SmallInt;
      var pPersistencia: TPersistencia): Boolean;

  end;

implementation

function TSaidaDAO.getBolsaJaVinculada(const pNUMERO_DA_BOLSA: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(s.id)');
      lPersistencia.Query.SQL.Add('FROM saida s');

      lPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
      lPersistencia.Query.SQL.Add('ON(s.id_bolsa = b.id)');

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

function TSaidaDAO.getConsulta(const pCHAVE: string; const pDATAINI, pDATAFIM: TDate; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
var
  lPos: Integer;
  lNumeroBolsa: string;
  lNumeroDoacoes: Integer;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  s.id,');
    pPersistencia.Query.SQL.Add('  s.data_saida,');
    pPersistencia.Query.SQL.Add('  CONCAT(s.volume,' + QuotedStr(' mL') + ') AS volume,');
    pPersistencia.Query.SQL.Add('  IF(b.numero_doacoes > 0 , CONCAT(b.numero_da_bolsa, ' + QuotedStr('-') +
      ', b.numero_doacoes), b.numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  p.num_prontuario,');
    pPersistencia.Query.SQL.Add('  p.nome,');
    pPersistencia.Query.SQL.Add('  CONCAT(p.abo, p.rh) tipo_sangue,');
    pPersistencia.Query.SQL.Add('  b.tipo,');
    pPersistencia.Query.SQL.Add('  CONCAT(b.abo, b.rh) tipo_sangue_bolsa,');
    pPersistencia.Query.SQL.Add('  u.nome AS responsavel ');
    pPersistencia.Query.SQL.Add('FROM saida s');

    pPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
    pPersistencia.Query.SQL.Add('ON (s.id_bolsa = b.id)');

    pPersistencia.Query.SQL.Add('INNER JOIN paciente p');
    pPersistencia.Query.SQL.Add('ON (s.id_paciente = p.id)');

    pPersistencia.Query.SQL.Add('INNER JOIN usuario u');
    pPersistencia.Query.SQL.Add('ON (s.id_usuario = u.id)');

    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pTIPOCONS) of
      0: // Número da bolsa
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
          pPersistencia.Query.SQL.Add('  b.numero_da_bolsa,');
          pPersistencia.Query.SQL.Add('  s.id');

        end;

      1: // Ordem
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND s.id = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY id');
        end;

      2: // Paciente
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND ((p.num_prontuario = :pNum_Prontuario) OR (p.nome LIKE :pNome))');
            pPersistencia.setParametro('pNum_Prontuario', pCHAVE);
            pPersistencia.setParametro('pNome', pCHAVE + '%');

          end;

          pPersistencia.Query.SQL.Add('ORDER BY p.num_prontuario');
        end;

      3: // Período
        begin
          pPersistencia.Query.SQL.Add('AND s.data_saida BETWEEN :pDataIni AND :pDataFim');
          pPersistencia.setParametro('pDataIni', pDATAINI);
          pPersistencia.setParametro('pDataFim', pDATAFIM);

          pPersistencia.Query.SQL.Add('ORDER BY');
          pPersistencia.Query.SQL.Add('  s.data_saida,');
          pPersistencia.Query.SQL.Add('  s.id');
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

function TSaidaDAO.getExisteSaidaPaciente(const pID_PACIENTE: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(id)');
      lPersistencia.Query.SQL.Add('FROM saida');
      lPersistencia.Query.SQL.Add('WHERE id_paciente = :pId_Paciente');

      lPersistencia.setParametro('pId_Paciente', pID_PACIENTE);

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

function TSaidaDAO.getIdSaidaByNumeroBolsa(const pNUMERO_DA_BOLSA: string): Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  s.id');
      lPersistencia.Query.SQL.Add('FROM saida s');

      lPersistencia.Query.SQL.Add('INNER JOIN bolsa b');
      lPersistencia.Query.SQL.Add('ON(b.id = s.id_bolsa)');

      lPersistencia.Query.SQL.Add('WHERE b.numero_da_bolsa = :pNumeroBolsa');
      lPersistencia.setParametro('pNumeroBolsa', pNUMERO_DA_BOLSA);

      lPersistencia.Query.Open;

      if (not lPersistencia.Query.IsEmpty) then
      begin

        Result := lPersistencia.Query.FieldByName('id').AsInteger;

      end
      else
      begin

        Result := -1;

      end;

    except
      on E: Exception do
      begin
        Result := -1;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

end.
