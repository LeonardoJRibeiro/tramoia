unit UClassBolsaDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassBolsa;

type
  TBolsaDAO = class(TInterfacedPersistent, IInterfaceDao<TBolsa>)
  private
    FConexao: TConexao;

  public
    function getExiste(const pID: Integer): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TBolsa): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TBolsa): Boolean;

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
      lPersistencia.Query.SQL.Add('  count(*)');
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

        pObjeto.Id := lPersistencia.getProximoCodigo('bolsa', 'id');
        lPersistencia.Query.SQL.Add('INSERT INTO bolsa (');
        lPersistencia.Query.SQL.Add('  id,');
        lPersistencia.Query.SQL.Add('  numero_bolsa,');
        lPersistencia.Query.SQL.Add('  tipo,');
        lPersistencia.Query.SQL.Add('  abo,');
        lPersistencia.Query.SQL.Add('  rh,');
        lPersistencia.Query.SQL.Add('  origem,');
        lPersistencia.Query.SQL.Add('  volume,');
        lPersistencia.Query.SQL.Add('  sorologia,');
        lPersistencia.Query.SQL.Add('  possui_estoque');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pId,');
        lPersistencia.Query.SQL.Add('  :pNumero_Bolsa,');
        lPersistencia.Query.SQL.Add('  :pTipo,');
        lPersistencia.Query.SQL.Add('  :pAbo,');
        lPersistencia.Query.SQL.Add('  :pRh,');
        lPersistencia.Query.SQL.Add('  :pOrigem,');
        lPersistencia.Query.SQL.Add('  :pVolume,');
        lPersistencia.Query.SQL.Add('  :pSorologia,');
        lPersistencia.Query.SQL.Add('  :pPossui_Estoque');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE bolsa SET');
        lPersistencia.Query.SQL.Add('  numero_bolsa= :pNumero_Bolsa,');
        lPersistencia.Query.SQL.Add('  tipo= :pTipo,');
        lPersistencia.Query.SQL.Add('  abo= :pAbo,');
        lPersistencia.Query.SQL.Add('  rh= :pRh,');
        lPersistencia.Query.SQL.Add('  origem= :pOrigem,');
        lPersistencia.Query.SQL.Add('  volume= :pVolume,');
        lPersistencia.Query.SQL.Add('  sorologia= :pSorologia,');
        lPersistencia.Query.SQL.Add('  possui_estoque= :pPossui_Estoque');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

      end;

      lPersistencia.setParametro('pId', pObjeto.Id);
      lPersistencia.setParametro('pNumero_Bolsa', pObjeto.NumeroBolsa);
      lPersistencia.setParametro('pTipo', pObjeto.Tipo);
      lPersistencia.setParametro('pAbo', pObjeto.Abo);
      lPersistencia.setParametro('pRh', pObjeto.Rh);
      lPersistencia.setParametro('pOrigem', pObjeto.Origem);
      lPersistencia.setParametro('pVolume', pObjeto.Volume);
      lPersistencia.setParametro('pSorologia', pObjeto.Sorologia);
      lPersistencia.setParametro('pPossui_Estoque', pObjeto.PossuiEstoque);

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
      lPersistencia.Query.SQL.Add('  numero_bolsa,');
      lPersistencia.Query.SQL.Add('  tipo,');
      lPersistencia.Query.SQL.Add('  abo,');
      lPersistencia.Query.SQL.Add('  rh,');
      lPersistencia.Query.SQL.Add('  origem,');
      lPersistencia.Query.SQL.Add('  volume,');
      lPersistencia.Query.SQL.Add('  sorologia,');
      lPersistencia.Query.SQL.Add('  possui_estoque');
      lPersistencia.Query.SQL.Add('FROM bolsa');

      lPersistencia.Query.SQL.Add('WHERE id= :pId');
      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.NumeroBolsa := lPersistencia.Query.FieldByName('numero_bolsa').Asstring;
      pObjeto.Tipo := lPersistencia.Query.FieldByName('tipo').Asstring;
      pObjeto.Abo := lPersistencia.Query.FieldByName('abo').Asstring;
      pObjeto.Rh := lPersistencia.Query.FieldByName('rh').Asstring;
      pObjeto.Origem := lPersistencia.Query.FieldByName('origem').Asstring;
      pObjeto.Volume := lPersistencia.Query.FieldByName('volume').AsInteger;
      pObjeto.Sorologia := lPersistencia.Query.FieldByName('sorologia').Asstring;
      pObjeto.PossuiEstoque := lPersistencia.Query.FieldByName('possui_estoque').Asstring;

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
