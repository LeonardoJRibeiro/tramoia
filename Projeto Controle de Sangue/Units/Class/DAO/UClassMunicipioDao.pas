unit UClassMunicipioDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassMunicipio;

type
  TMunicipioDAO = class(TInterfacedPersistent, IInterfaceDao<TMunicipio>)
  private
    FConexao: TConexao;

  public
    function getExiste(const pID: Integer): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TMunicipio): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TMunicipio): Boolean;

    function getIdMunicipio(const pCODIGO_IBGE: Integer): Integer;
    function getNomeAndUF(const pCODIGO_IBGE: Integer; var pNomeMunicpio, pUF: string): Boolean;
    function getCodigoIbge(const pID: Integer): Integer;

    function getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt; var pPersistencia: TPersistencia): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils;

constructor TMunicipioDAO.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TMunicipioDAO.Destroy;
begin

  inherited;
end;

function TMunicipioDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM municipio');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.ExecSQL;

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

function TMunicipioDAO.getCodigoIbge(const pID: Integer): Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  codigo_ibge');
      lPersistencia.Query.SQL.Add('FROM municipio');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.Fields[0].AsInteger;

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

function TMunicipioDAO.getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
begin
  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  m.codigo_ibge,');
    pPersistencia.Query.SQL.Add('  m.nome,');
    pPersistencia.Query.SQL.Add('  e.uf');
    pPersistencia.Query.SQL.Add('FROM municipio m');
    pPersistencia.Query.SQL.Add('INNER JOIN estado e');
    pPersistencia.Query.SQL.Add('ON (m.id_estado = e.id)');
    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pTIPOCONS) of
      0, 1: // Palavra chave e Nome
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND m.nome LIKE :pChave');
            pPersistencia.setParametro('pChave', IfThen(pTIPOCONS = 0, '%', '') + pCHAVE + '%');

          end;

          pPersistencia.Query.SQL.Add('ORDER BY nome');

        end;

      2: // Código do IBGE
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND codigo_ibge = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY codigo_ibge');

        end;
    end;

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

function TMunicipioDAO.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM municipio');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.FieldByName('count').AsInteger > 0;

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

function TMunicipioDAO.getIdMunicipio(const pCODIGO_IBGE: Integer): Integer;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
      lPersistencia.Query.SQL.Add('FROM municipio');
      lPersistencia.Query.SQL.Add('WHERE codigo_ibge = :pCodigo_Ibge');

      lPersistencia.setParametro('pCodigo_Ibge', pCODIGO_IBGE);

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.FieldByName('id').AsInteger;

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

function TMunicipioDAO.getNomeAndUF(const pCODIGO_IBGE: Integer; var pNomeMunicpio, pUF: string): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  m.nome,');
      lPersistencia.Query.SQL.Add('  e.uf');
      lPersistencia.Query.SQL.Add('FROM municipio m');
      lPersistencia.Query.SQL.Add('INNER JOIN estado e');
      lPersistencia.Query.SQL.Add('ON(m.id_estado = e.id)');
      lPersistencia.Query.SQL.Add('WHERE m.codigo_Ibge = :pCodigo_Ibge');

      lPersistencia.setParametro('pCodigo_Ibge', pCODIGO_IBGE);

      lPersistencia.Query.Open;

      Result := False;
      if (not lPersistencia.Query.IsEmpty) then
      begin
        pNomeMunicpio := lPersistencia.Query.FieldByName('nome').AsString;
        pUF := lPersistencia.Query.FieldByName('uf').AsString;
        Result := True;
      end;

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

function TMunicipioDAO.Salvar(var pObjeto: TMunicipio): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin

        pObjeto.Id := lPersistencia.getProximoCodigo('municipio', 'id');
        lPersistencia.Query.SQL.Add('INSERT INTO municipio (');
        lPersistencia.Query.SQL.Add('  id,');
        lPersistencia.Query.SQL.Add('  id_estado,');
        lPersistencia.Query.SQL.Add('  codigo_ibge,');
        lPersistencia.Query.SQL.Add('  nome');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pId,');
        lPersistencia.Query.SQL.Add('  :pId_Estado,');
        lPersistencia.Query.SQL.Add('  :pCodigo_Ibge,');
        lPersistencia.Query.SQL.Add('  :pNome');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE municipio SET');
        lPersistencia.Query.SQL.Add('  id_estado= :pId_Estado,');
        lPersistencia.Query.SQL.Add('  codigo_ibge= :pCodigo_Ibge,');
        lPersistencia.Query.SQL.Add('  nome= :pNome');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

      end;

      lPersistencia.setParametro('pId', pObjeto.Id);
      lPersistencia.setParametro('pId_Estado', pObjeto.Id_Estado);
      lPersistencia.setParametro('pCodigo_Ibge', pObjeto.Codigo_Ibge);
      lPersistencia.setParametro('pNome', pObjeto.Nome);

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

function TMunicipioDAO.getObjeto(const pID: Integer; var pObjeto: TMunicipio): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM municipio');
      lPersistencia.Query.SQL.Add('WHERE id= :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Id_Estado := lPersistencia.Query.FieldByName('id_estado').AsInteger;
      pObjeto.Codigo_Ibge := lPersistencia.Query.FieldByName('codigo_ibge').AsInteger;
      pObjeto.Nome := lPersistencia.Query.FieldByName('nome').AsString;

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

end.
