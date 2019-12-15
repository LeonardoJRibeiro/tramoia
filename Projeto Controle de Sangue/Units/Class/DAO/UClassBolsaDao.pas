unit UClassBolsaDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistencia, UClassBolsa, UClassPersistBaseDados;

type
  TBolsaDAO = class(TPersistBase<TBolsa>)
  private

  public

    function getExiste(const pNUMERO_DA_BOLSA, pTIPO: string): Boolean; overload;

    function getId(const pNUMERO_DA_BOLSA, pTIPO: string): Integer;

    function getConsulta(const pNUMERO_DA_BOLSA: string; var pPersistencia: TPersistencia): Boolean; overload;
    function getConsulta(const pFILTRARPOR: SmallInt; const pQUANT_DIAS_AVISO_VENCIMENTO: Integer;
      var pPersistencia: TPersistencia): Boolean; overload;

    function getPermiteAlteracaoOuExclusao(const pID: Integer): Boolean;

    function getPermiteMovimentacao(const pID: Integer): Boolean;

  end;

implementation

function TBolsaDAO.getConsulta(const pNUMERO_DA_BOLSA: string; var pPersistencia: TPersistencia): Boolean;
var
  lPos: Integer;
  lNumeroBolsa: string;
  lNumeroDoacoes: Integer;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  id,');
    pPersistencia.Query.SQL.Add('  IF(numero_doacoes > 0 , CONCAT(numero_da_bolsa, ' + QuotedStr('-') +
      ', numero_doacoes), numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  tipo,');
    pPersistencia.Query.SQL.Add('  CONCAT(abo, rh)AS grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('  CONCAT(volume_atual,' + QuotedStr(' mL') + ') AS volume_atual');
    pPersistencia.Query.SQL.Add('FROM bolsa');
    pPersistencia.Query.SQL.Add('WHERE 0=0');

    lPos := Pos('-', Trim(pNUMERO_DA_BOLSA));

    if (lPos <> 0) then
    begin

      if (Copy(Trim(pNUMERO_DA_BOLSA), lPos + 1, Trim(pNUMERO_DA_BOLSA).Length).Trim = '') then
      begin
        lNumeroBolsa := Copy(Trim(pNUMERO_DA_BOLSA), 0, Trim(pNUMERO_DA_BOLSA).Length - 1).Trim;
        lNumeroDoacoes := -1;
      end
      else
      begin
        lNumeroBolsa := Copy(Trim(pNUMERO_DA_BOLSA), 0, lPos - 1).Trim;
        lNumeroDoacoes := Copy(Trim(pNUMERO_DA_BOLSA), lPos + 1, Trim(pNUMERO_DA_BOLSA).Length).Trim.ToInteger;
      end;

    end
    else
    begin
      lNumeroBolsa := Trim(pNUMERO_DA_BOLSA);
      lNumeroDoacoes := -1;
    end;

    pPersistencia.Query.SQL.Add('AND numero_da_bolsa = :pNumero_Da_Bolsa');
    pPersistencia.setParametro('pNumero_Da_Bolsa', lNumeroBolsa);

    if (lNumeroDoacoes > 0) then
    begin
      pPersistencia.Query.SQL.Add('AND numero_doacoes = :pNumero_Doacoes');
      pPersistencia.setParametro('pNumero_Doacoes', lNumeroDoacoes);
    end;

    pPersistencia.Query.SQL.Add('AND volume_atual > 0');

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

function TBolsaDAO.getConsulta(const pFILTRARPOR: SmallInt; const pQUANT_DIAS_AVISO_VENCIMENTO: Integer;
  var pPersistencia: TPersistencia): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  id,');
    pPersistencia.Query.SQL.Add('  data_coleta,');
    pPersistencia.Query.SQL.Add('  data_vencimento,');
    pPersistencia.Query.SQL.Add
      ('  IF(data_vencimento - CURRENT_DATE() > 0, data_vencimento - CURRENT_DATE(),0) AS quant_dias_vencimento,');
    pPersistencia.Query.SQL.Add('  origem,');
    pPersistencia.Query.SQL.Add('  IF(numero_doacoes > 0 , CONCAT(numero_da_bolsa, ' + QuotedStr('-') +
      ', numero_doacoes), numero_da_bolsa) AS numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  tipo,');
    pPersistencia.Query.SQL.Add('  CONCAT(abo, rh)AS grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('  CONCAT(volume,' + QuotedStr(' mL') + ') AS volume_inicial,');
    pPersistencia.Query.SQL.Add('  CONCAT(volume_atual,' + QuotedStr(' mL') + ') AS volume_atual');
    pPersistencia.Query.SQL.Add('FROM bolsa');
    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pFILTRARPOR) of
      0: // Mechidas
        begin
          pPersistencia.Query.SQL.Add('AND volume_atual <> volume');
        end;

      1: // Não mechidas
        begin
          pPersistencia.Query.SQL.Add('AND volume_atual = volume');
        end;
    end;

    pPersistencia.Query.SQL.Add('AND volume_atual > 0');

    pPersistencia.Query.SQL.Add('AND (data_vencimento - ' + pQUANT_DIAS_AVISO_VENCIMENTO.ToString +
      '  <= CURRENT_DATE())');

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

function TBolsaDAO.getExiste(const pNUMERO_DA_BOLSA, pTIPO: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(id)');
      lPersistencia.Query.SQL.Add('FROM bolsa');

      lPersistencia.Query.SQL.Add('WHERE numero_da_bolsa = :pNumeroBolsa');
      lPersistencia.setParametro('pNumeroBolsa', pNUMERO_DA_BOLSA);

      lPersistencia.Query.SQL.Add('AND tipo = :pTipo');
      lPersistencia.setParametro('pTipo', pTIPO);

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

function TBolsaDAO.getId(const pNUMERO_DA_BOLSA, pTIPO: string): Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
      lPersistencia.Query.SQL.Add('FROM bolsa');

      lPersistencia.Query.SQL.Add('WHERE numero_da_bolsa = :pNumeroBolsa');
      lPersistencia.setParametro('pNumeroBolsa', pNUMERO_DA_BOLSA);

      lPersistencia.Query.SQL.Add('AND tipo = :pTipo');
      lPersistencia.setParametro('pTipo', pTIPO);

      lPersistencia.Query.Open;

      Result := -1;
      if (not lPersistencia.Query.IsEmpty) then
      begin
        Result := lPersistencia.Query.Fields[0].AsInteger;
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

function TBolsaDAO.getPermiteAlteracaoOuExclusao(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  IF(volume = volume_atual , ' + QuotedStr('S') + ',' + QuotedStr('N') +
        ') permite');
      lPersistencia.Query.SQL.Add('FROM bolsa');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      Result := UpperCase(Trim(lPersistencia.Query.FieldByName('permite').Asstring)) = 'S';
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

function TBolsaDAO.getPermiteMovimentacao(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  IF(volume_atual > 0  , ' + QuotedStr('S') + ',' + QuotedStr('N') + ') permite');
      lPersistencia.Query.SQL.Add('FROM bolsa');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      Result := UpperCase(Trim(lPersistencia.Query.FieldByName('permite').Asstring)) = 'S';
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

end.
