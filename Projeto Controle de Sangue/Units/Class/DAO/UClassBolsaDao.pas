unit UClassBolsaDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassBolsa;

type
  TBolsaDAO = class(TInterfacedPersistent, IInterfaceDao<TBolsa>)
  private
    FConexao: TConexao;

  public

    function getExiste(const pID: Integer): Boolean; overload;
    function getExiste(const pNUMERO_DA_BOLSA, pTIPO: string): Boolean; overload;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TBolsa): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TBolsa): Boolean;

    function getId(const pNUMERO_DA_BOLSA, pTIPO: string): Integer;

    function getConsulta(const pNUMERO_DA_BOLSA: string; var pPersistencia: TPersistencia): Boolean;

    function getPermiteAlteracaoOuExclusao(const pID: Integer): Boolean;

    function getPermiteMovimentacao(const pID: Integer): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

constructor TBolsaDAO.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TBolsaDAO.Destroy;
begin

  inherited;
end;

function TBolsaDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM bolsa');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');
      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.ExecSQL;

      Result := True;

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

function TBolsaDAO.getExiste(const pID: Integer): Boolean;
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

      lPersistencia.Query.SQL.Add('WHERE id = :pId');
      lPersistencia.setParametro('pId', pID);

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

function TBolsaDAO.Salvar(var pObjeto: TBolsa): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin

        lPersistencia.Query.SQL.Add('INSERT INTO bolsa (');
        lPersistencia.Query.SQL.Add('  numero_da_bolsa,');
        lPersistencia.Query.SQL.Add('  tipo,');
        lPersistencia.Query.SQL.Add('  abo,');
        lPersistencia.Query.SQL.Add('  rh,');
        lPersistencia.Query.SQL.Add('  origem,');
        lPersistencia.Query.SQL.Add('  volume,');
        lPersistencia.Query.SQL.Add('  pai,');
        lPersistencia.Query.SQL.Add('  sifilis,');
        lPersistencia.Query.SQL.Add('  chagas,');
        lPersistencia.Query.SQL.Add('  hepatiteb,');
        lPersistencia.Query.SQL.Add('  hepatitec,');
        lPersistencia.Query.SQL.Add('  hiv,');
        lPersistencia.Query.SQL.Add('  htlv,');
        lPersistencia.Query.SQL.Add('  hemoglobinas,');
        lPersistencia.Query.SQL.Add('  data_vencimento,');
        lPersistencia.Query.SQL.Add('  volume_atual,');
        lPersistencia.Query.SQL.Add('  data_coleta');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pNumero_Da_Bolsa,');
        lPersistencia.Query.SQL.Add('  :pTipo,');
        lPersistencia.Query.SQL.Add('  :pAbo,');
        lPersistencia.Query.SQL.Add('  :pRh,');
        lPersistencia.Query.SQL.Add('  :pOrigem,');
        lPersistencia.Query.SQL.Add('  :pVolume,');
        lPersistencia.Query.SQL.Add('  :pPai,');
        lPersistencia.Query.SQL.Add('  :pSifilis,');
        lPersistencia.Query.SQL.Add('  :pChagas,');
        lPersistencia.Query.SQL.Add('  :pHepatiteb,');
        lPersistencia.Query.SQL.Add('  :pHepatitec,');
        lPersistencia.Query.SQL.Add('  :pHiv,');
        lPersistencia.Query.SQL.Add('  :pHtlv,');
        lPersistencia.Query.SQL.Add('  :pHemoglobinas,');
        lPersistencia.Query.SQL.Add('  :pData_Vencimento,');
        lPersistencia.Query.SQL.Add('  :pVolume_Atual,');
        lPersistencia.Query.SQL.Add('  :pData_Coleta');
        lPersistencia.Query.SQL.Add(');');

      end
      else
      begin

        lPersistencia.Query.SQL.Add('UPDATE bolsa SET');
        lPersistencia.Query.SQL.Add('  numero_da_bolsa = :pNumero_Da_Bolsa,');
        lPersistencia.Query.SQL.Add('  tipo = :pTipo,');
        lPersistencia.Query.SQL.Add('  abo = :pAbo,');
        lPersistencia.Query.SQL.Add('  rh = :pRh,');
        lPersistencia.Query.SQL.Add('  origem = :pOrigem,');
        lPersistencia.Query.SQL.Add('  volume = :pVolume,');
        lPersistencia.Query.SQL.Add('  pai = :pPai,');
        lPersistencia.Query.SQL.Add('  sifilis = :pSifilis,');
        lPersistencia.Query.SQL.Add('  chagas = :pChagas,');
        lPersistencia.Query.SQL.Add('  hepatiteb = :pHepatiteB,');
        lPersistencia.Query.SQL.Add('  hepatitec = :pHepatiteC,');
        lPersistencia.Query.SQL.Add('  hiv = :pHiv,');
        lPersistencia.Query.SQL.Add('  htlv = :pHtlv,');
        lPersistencia.Query.SQL.Add('  hemoglobinas = :pHemoglobinas,');
        lPersistencia.Query.SQL.Add('  data_vencimento = :pData_Vencimento,');
        lPersistencia.Query.SQL.Add('  volume_atual = :pVolume_Atual,');
        lPersistencia.Query.SQL.Add('  data_coleta = :pData_Coleta');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

        lPersistencia.setParametro('pId', pObjeto.Id);

      end;

      lPersistencia.setParametro('pNumero_Da_Bolsa', pObjeto.NumeroBolsa);
      lPersistencia.setParametro('pTipo', pObjeto.Tipo);
      lPersistencia.setParametro('pAbo', pObjeto.Abo);
      lPersistencia.setParametro('pRh', pObjeto.Rh);
      lPersistencia.setParametro('pOrigem', pObjeto.Origem);
      lPersistencia.setParametro('pVolume', pObjeto.Volume);
      lPersistencia.setParametro('pPai', pObjeto.Pai);
      lPersistencia.setParametro('pSifilis', pObjeto.Sifilis);
      lPersistencia.setParametro('pChagas', pObjeto.Chagas);
      lPersistencia.setParametro('pHepatiteb', pObjeto.HepatiteB);
      lPersistencia.setParametro('pHepatitec', pObjeto.HepatiteC);
      lPersistencia.setParametro('pHiv', pObjeto.Hiv);
      lPersistencia.setParametro('pHtlv', pObjeto.Htlv);
      lPersistencia.setParametro('pHemoglobinas', pObjeto.Hemoglobinas);
      lPersistencia.setParametro('pData_Vencimento', pObjeto.DataVencimento);
      lPersistencia.setParametro('pVolume_Atual', pObjeto.VolumeAtual);
      lPersistencia.setParametro('pData_Coleta', pObjeto.DataColeta);

      lPersistencia.Query.ExecSQL;

      Result := True;

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

function TBolsaDAO.getConsulta(const pNUMERO_DA_BOLSA: string; var pPersistencia: TPersistencia): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  id,');
    pPersistencia.Query.SQL.Add('  numero_da_bolsa,');
    pPersistencia.Query.SQL.Add('  tipo,');
    pPersistencia.Query.SQL.Add('  CONCAT(abo, rh)AS grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('  CONCAT(volume_atual,' + QuotedStr(' mL') + ') AS volume_atual');
    pPersistencia.Query.SQL.Add('FROM bolsa');
    pPersistencia.Query.SQL.Add('WHERE numero_da_bolsa = :pNumero_Da_Bolsa');
    pPersistencia.Query.SQL.Add('AND volume_atual > 0');

    pPersistencia.setParametro('pNumero_Da_Bolsa', pNUMERO_DA_BOLSA);

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

function TBolsaDAO.getObjeto(const pID: Integer; var pObjeto: TBolsa): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id,');
      lPersistencia.Query.SQL.Add('  numero_da_bolsa,');
      lPersistencia.Query.SQL.Add('  tipo,');
      lPersistencia.Query.SQL.Add('  abo,');
      lPersistencia.Query.SQL.Add('  rh,');
      lPersistencia.Query.SQL.Add('  origem,');
      lPersistencia.Query.SQL.Add('  volume,');
      lPersistencia.Query.SQL.Add('  pai,');
      lPersistencia.Query.SQL.Add('  sifilis,');
      lPersistencia.Query.SQL.Add('  chagas,');
      lPersistencia.Query.SQL.Add('  hepatiteb,');
      lPersistencia.Query.SQL.Add('  hepatitec,');
      lPersistencia.Query.SQL.Add('  hiv,');
      lPersistencia.Query.SQL.Add('  htlv,');
      lPersistencia.Query.SQL.Add('  hemoglobinas,');
      lPersistencia.Query.SQL.Add('  data_vencimento,');
      lPersistencia.Query.SQL.Add('  volume_atual,');
      lPersistencia.Query.SQL.Add('  data_coleta');
      lPersistencia.Query.SQL.Add('FROM bolsa');

      lPersistencia.Query.SQL.Add('WHERE id= :pId');
      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.NumeroBolsa := lPersistencia.Query.FieldByName('numero_da_bolsa').Asstring;
      pObjeto.Tipo := lPersistencia.Query.FieldByName('tipo').Asstring;
      pObjeto.Abo := lPersistencia.Query.FieldByName('abo').Asstring;
      pObjeto.Rh := lPersistencia.Query.FieldByName('rh').Asstring;
      pObjeto.Origem := lPersistencia.Query.FieldByName('origem').Asstring;
      pObjeto.Volume := lPersistencia.Query.FieldByName('volume').AsInteger;
      pObjeto.Pai := lPersistencia.Query.FieldByName('pai').Asstring;
      pObjeto.Sifilis := lPersistencia.Query.FieldByName('sifilis').Asstring;
      pObjeto.Chagas := lPersistencia.Query.FieldByName('chagas').Asstring;
      pObjeto.HepatiteB := lPersistencia.Query.FieldByName('hepatiteB').Asstring;
      pObjeto.HepatiteC := lPersistencia.Query.FieldByName('hepatiteC').Asstring;
      pObjeto.Hiv := lPersistencia.Query.FieldByName('hiv').Asstring;
      pObjeto.Htlv := lPersistencia.Query.FieldByName('htlv').Asstring;
      pObjeto.Hemoglobinas := lPersistencia.Query.FieldByName('hemoglobinas').Asstring;
      pObjeto.DataVencimento := lPersistencia.Query.FieldByName('data_vencimento').AsDateTime;
      pObjeto.VolumeAtual := lPersistencia.Query.FieldByName('volume_atual').AsInteger;
      pObjeto.DataColeta := lPersistencia.Query.FieldByName('data_coleta').AsDateTime;

      Result := True;

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
