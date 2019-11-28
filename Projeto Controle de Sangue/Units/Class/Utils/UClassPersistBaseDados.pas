unit UClassPersistBaseDados;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, System.Rtti;

type
  TPersistBase<T: class> = class(TInterfacedObject, IInterfaceDAO<T>)
  private
    FNomeEntidade: string;
    FNomeAtributoChave: string;

    FRttiContext: TRttiContext;
    FRttiType: TRttiType;

  protected
    FConexao: TConexao;
  public

    function Salvar(var pOBJETO: T): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function getExiste(const pID: Integer): Boolean;
    function getObjeto(const pID: Integer; var pOBJETO: T): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Desotry; override;
  end;

implementation

uses UClassPersistencia;

{ TPersistBase<T> }

constructor TPersistBase<T>.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
  Self.FRttiContext := TRttiContext.Create;
  Self.FRttiType := Self.FRttiContext.GetType(T);
end;

destructor TPersistBase<T>.Desotry;
begin
  Self.FRttiContext.Free;
  inherited;
end;

function TPersistBase<T>.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE FROM ' + Self.FNomeEntidade);
      lPersistencia.Query.SQL.Add('WHERE ' + Self.FNomeAtributoChave + ' = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.ExecSQL;
      lPersistencia.Transacao.Commit;

    except
      on E: Exception do
      begin
        Result := False;
        lPersistencia.Transacao.Rollback;
        raise Exception.Create(E.Message);
      end;

    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TPersistBase<T>.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(*)');
      lPersistencia.Query.SQL.Add('FROM ' + Self.FNomeEntidade);
      lPersistencia.Query.SQL.Add('WHERE ' + Self.FNomeAtributoChave + ' = :pId');

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

function TPersistBase<T>.getObjeto(const pID: Integer; var pOBJETO: T): Boolean;
begin

end;

function TPersistBase<T>.Salvar(var pOBJETO: T): Boolean;
var
  lRttiProperty: TRttiProperty;
begin

  for lRttiProperty in Self.FRttiType.GetProperties do
  begin

  end;

end;

end.
