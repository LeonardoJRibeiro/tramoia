unit UClassEnderecoDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassEndereco;

type
  TEnderecoDAO = class(TInterfacedPersistent, IInterfaceDao<TEndereco>)
  private
    FConexao: TConexao;

  public
    function getExiste(const pID: Integer): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TEndereco): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TEndereco): Boolean;

    function getObjetoEndereco(const pID_PACIENTE: Integer; var pObjeto: TEndereco): Boolean;

    function getId(const pID_PACIENTE: Integer): Integer;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

constructor TEnderecoDAO.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TEnderecoDAO.Destroy;
begin

  inherited;
end;

function TEnderecoDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM endereco');
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

function TEnderecoDAO.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM endereco');
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

function TEnderecoDAO.getId(const pID_PACIENTE: Integer): Integer;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM endereco');
      lPersistencia.Query.SQL.Add('WHERE id_paciente = :pId_Paciente');

      lPersistencia.setParametro('pId_Paciente', pID_PACIENTE);

      lPersistencia.Query.Open;

      Result := -1;
      if (not lPersistencia.Query.IsEmpty) then
      begin
        Result := lPersistencia.Query.FieldByName('id').AsInteger;
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

function TEnderecoDAO.Salvar(var pObjeto: TEndereco): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin

        lPersistencia.Query.SQL.Add('INSERT INTO endereco (');
        lPersistencia.Query.SQL.Add('  id_municipio,');
        lPersistencia.Query.SQL.Add('  id_paciente,');
        lPersistencia.Query.SQL.Add('  logradouro,');
        lPersistencia.Query.SQL.Add('  bairro,');
        lPersistencia.Query.SQL.Add('  complemento,');
        lPersistencia.Query.SQL.Add('  numero,');
        lPersistencia.Query.SQL.Add('  cep');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pId_Municipio,');
        lPersistencia.Query.SQL.Add('  :pId_Paciente,');
        lPersistencia.Query.SQL.Add('  :pLogradouro,');
        lPersistencia.Query.SQL.Add('  :pBairro,');
        lPersistencia.Query.SQL.Add('  :pComplemento,');
        lPersistencia.Query.SQL.Add('  :pNumero,');
        lPersistencia.Query.SQL.Add('  :pCep');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE endereco SET');
        lPersistencia.Query.SQL.Add('  id_municipio= :pId_Municipio,');
        lPersistencia.Query.SQL.Add('  id_paciente= :pId_Paciente,');
        lPersistencia.Query.SQL.Add('  logradouro= :pLogradouro,');
        lPersistencia.Query.SQL.Add('  bairro= :pBairro,');
        lPersistencia.Query.SQL.Add('  complemento= :pComplemento,');
        lPersistencia.Query.SQL.Add('  numero= :pNumero,');
        lPersistencia.Query.SQL.Add('  cep= :pCep');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

        lPersistencia.setParametro('pId', pObjeto.Id);

      end;

      lPersistencia.setParametro('pId_Municipio', pObjeto.Id_Municipio);
      lPersistencia.setParametro('pId_Paciente', pObjeto.Id_Paciente);
      lPersistencia.setParametro('pLogradouro', pObjeto.Logradouro);
      lPersistencia.setParametro('pBairro', pObjeto.Bairro);
      lPersistencia.setParametro('pComplemento', pObjeto.Complemento);
      lPersistencia.setParametro('pNumero', pObjeto.Numero);
      lPersistencia.setParametro('pCep', pObjeto.Cep);

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

function TEnderecoDAO.getObjeto(const pID: Integer; var pObjeto: TEndereco): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM endereco');
      lPersistencia.Query.SQL.Add('WHERE id= :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Id_Municipio := lPersistencia.Query.FieldByName('id_municipio').AsInteger;
      pObjeto.Id_Paciente := lPersistencia.Query.FieldByName('id_paciente').AsInteger;
      pObjeto.Logradouro := lPersistencia.Query.FieldByName('logradouro').Asstring;
      pObjeto.Bairro := lPersistencia.Query.FieldByName('bairro').Asstring;
      pObjeto.Complemento := lPersistencia.Query.FieldByName('complemento').Asstring;
      pObjeto.Numero := lPersistencia.Query.FieldByName('numero').Asstring;
      pObjeto.Cep := lPersistencia.Query.FieldByName('cep').Asstring;

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

function TEnderecoDAO.getObjetoEndereco(const pID_PACIENTE: Integer; var pObjeto: TEndereco): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM endereco');
      lPersistencia.Query.SQL.Add('WHERE id_paciente = :pId_Paciente');

      lPersistencia.setParametro('pId_Paciente', pID_PACIENTE);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Id_Municipio := lPersistencia.Query.FieldByName('id_municipio').AsInteger;
      pObjeto.Id_Paciente := lPersistencia.Query.FieldByName('id_paciente').AsInteger;
      pObjeto.Logradouro := lPersistencia.Query.FieldByName('logradouro').Asstring;
      pObjeto.Bairro := lPersistencia.Query.FieldByName('bairro').Asstring;
      pObjeto.Complemento := lPersistencia.Query.FieldByName('complemento').Asstring;
      pObjeto.Numero := lPersistencia.Query.FieldByName('numero').Asstring;
      pObjeto.Cep := lPersistencia.Query.FieldByName('cep').Asstring;

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
