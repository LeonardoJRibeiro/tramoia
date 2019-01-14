unit UClassProcedimento_EspecialDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassProcedimento_Especial;

type
  TProcedimento_EspecialDAO = class(TInterfacedPersistent, IInterfaceDao<TProcedimento_Especial>)
  private
    FConexao : TConexao;

  public
    function getExiste(const pID: Integer) : Boolean;
    function Excluir(const pID: Integer) : Boolean;
    function Salvar(var pObjeto: TProcedimento_Especial) : Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TProcedimento_Especial) : Boolean;

    constructor Create(const pCONEXAO : TConexao); overload;
    destructor Destroy; override;

  end;

implementation

constructor TProcedimento_EspecialDAO.Create(const pCONEXAO : TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TProcedimento_EspecialDAO.Destroy;
begin

  inherited;
end;

function TProcedimento_EspecialDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM procedimento_especial');
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

function TProcedimento_EspecialDAO.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM procedimento_especial');
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

function TProcedimento_EspecialDAO.Salvar(var pObjeto : TProcedimento_Especial): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin

        pObjeto.Id:= lPersistencia.getProximoCodigo('procedimento_especial','id');
        lPersistencia.Query.SQL.Add('INSERT INTO procedimento_especial (');
        lPersistencia.Query.SQL.Add('  id,');
        lPersistencia.Query.SQL.Add('  id_saida,');
        lPersistencia.Query.SQL.Add('  id_descarte,');
        lPersistencia.Query.SQL.Add('  irradiacao,');
        lPersistencia.Query.SQL.Add('  filtracao,');
        lPersistencia.Query.SQL.Add('  fracionamento,');
        lPersistencia.Query.SQL.Add('  fenotipagem');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pId,');
        lPersistencia.Query.SQL.Add('  :pId_Saida,');
        lPersistencia.Query.SQL.Add('  :pId_Descarte,');
        lPersistencia.Query.SQL.Add('  :pIrradiacao,');
        lPersistencia.Query.SQL.Add('  :pFiltracao,');
        lPersistencia.Query.SQL.Add('  :pFracionamento,');
        lPersistencia.Query.SQL.Add('  :pFenotipagem');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE procedimento_especial SET');
        lPersistencia.Query.SQL.Add('  id_saida= :pId_Saida,');
        lPersistencia.Query.SQL.Add('  id_descarte= :pId_Descarte,');
        lPersistencia.Query.SQL.Add('  irradiacao= :pIrradiacao,');
        lPersistencia.Query.SQL.Add('  filtracao= :pFiltracao,');
        lPersistencia.Query.SQL.Add('  fracionamento= :pFracionamento,');
        lPersistencia.Query.SQL.Add('  fenotipagem= :pFenotipagem');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

      end;

      lPersistencia.setParametro('pId', pObjeto.Id);
      lPersistencia.setParametro('pId_Saida', pObjeto.Id_Saida);
      lPersistencia.setParametro('pId_Descarte', pObjeto.Id_Descarte);
      lPersistencia.setParametro('pIrradiacao', pObjeto.Irradiacao);
      lPersistencia.setParametro('pFiltracao', pObjeto.Filtracao);
      lPersistencia.setParametro('pFracionamento', pObjeto.Fracionamento);
      lPersistencia.setParametro('pFenotipagem', pObjeto.Fenotipagem);
 
      lPersistencia.Query.ExecSQL;
 
      Result:= True;

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

function TProcedimento_EspecialDAO.getObjeto(const pID: Integer; var pObjeto: TProcedimento_Especial): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM procedimento_especial');
      lPersistencia.Query.SQL.Add('WHERE id= :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Id_Saida := lPersistencia.Query.FieldByName('id_saida').AsInteger;
      pObjeto.Id_Descarte := lPersistencia.Query.FieldByName('id_descarte').AsInteger;
      pObjeto.Irradiacao := lPersistencia.Query.FieldByName('irradiacao').Asstring;
      pObjeto.Filtracao := lPersistencia.Query.FieldByName('filtracao').Asstring;
      pObjeto.Fracionamento := lPersistencia.Query.FieldByName('fracionamento').Asstring;
      pObjeto.Fenotipagem := lPersistencia.Query.FieldByName('fenotipagem').Asstring;
 
 
      Result:= True;

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
