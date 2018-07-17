unit UClassEstoqueDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassEstoque;

type
  TEstoqueDAO = class(TInterfacedPersistent, IInterfaceDao<TEstoque>)
  private
    FConexao: TConexao;

  public
    function getExiste(const pID: Integer): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TEstoque): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TEstoque): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

constructor TEstoqueDAO.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TEstoqueDAO.Destroy;
begin

  inherited;
end;

function TEstoqueDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM estoque');
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

function TEstoqueDAO.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM estoque');
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

function TEstoqueDAO.Salvar(var pObjeto: TEstoque): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin

        lPersistencia.Query.SQL.Add('INSERT INTO estoque (');
        lPersistencia.Query.SQL.Add('  quantidade,');
        lPersistencia.Query.SQL.Add('  grupo_sanguineo');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pQuantidade,');
        lPersistencia.Query.SQL.Add('  :pGrupo_Sanguineo');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE estoque SET');
        lPersistencia.Query.SQL.Add('  quantidade= :pQuantidade,');
        lPersistencia.Query.SQL.Add('  grupo_sanguineo= :pGrupo_Sanguineo');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

        lPersistencia.setParametro('pId', pObjeto.Id);

      end;

      lPersistencia.setParametro('pQuantidade', pObjeto.Quantidade);
      lPersistencia.setParametro('pGrupo_Sanguineo', pObjeto.Grupo_Sanguineo);

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

function TEstoqueDAO.getObjeto(const pID: Integer; var pObjeto: TEstoque): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM estoque');
      lPersistencia.Query.SQL.Add('WHERE id= :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Quantidade := lPersistencia.Query.FieldByName('quantidade').AsCurrency;
      pObjeto.Grupo_Sanguineo := lPersistencia.Query.FieldByName('grupo_sanguineo').Asstring;

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
