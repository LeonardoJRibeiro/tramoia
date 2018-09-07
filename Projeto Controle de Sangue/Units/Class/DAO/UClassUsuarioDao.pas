unit UClassUsuarioDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassUsuario,
  System.Generics.Collections;

type
  TUsuarioDAO = class(TInterfacedPersistent, IInterfaceDao<TUsuario>)
  private
    FConexao: TConexao;

  public
    function getExiste(const pID: Integer): Boolean; overload;
    function getExiste(const pNOME: string): Boolean; overload;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TUsuario): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TUsuario): Boolean;

    function getPermiteExclusao(const pID: Integer; var pMensagem: string): Boolean;

    function getLogin(const pNOME, pSENHA: string; var pID: Integer): Boolean;

    function getNomeUsuario(const pID: Integer): string;

    function getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt; var pPersistencia: TPersistencia): Boolean;

    function getExisteUsuariosCadastrados: Boolean;

    function getAdmin(const pID: Integer): Boolean;

    function getListaObjeto(var pLista: TObjectList<TUsuario>): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses UBiblioteca, UClassBibliotecaDAO, System.StrUtils;

constructor TUsuarioDAO.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TUsuarioDAO.Destroy;
begin

  inherited;
end;

function TUsuarioDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM usuario');
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

function TUsuarioDAO.getAdmin(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  admin');
      lPersistencia.Query.SQL.Add('FROM usuario');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.FieldByName('admin').AsString = 'S';
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

function TUsuarioDAO.getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
begin
  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  id,');
    pPersistencia.Query.SQL.Add('  nome,');
    pPersistencia.Query.SQL.Add('  if (admin = ' + QuotedStr('S') + ', ' + QuotedStr('Sim') + ', ' + QuotedStr('Não') +
      ') AS admin  ');
    pPersistencia.Query.SQL.Add('FROM usuario');
    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pTIPOCONS) of
      0, 1: // Palavra chave e Nome
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND nome LIKE :pChave');
            pPersistencia.setParametro('pChave', IfThen(pTIPOCONS = 0, '%', '') + pCHAVE + '%');

          end;

          pPersistencia.Query.SQL.Add('ORDER BY nome');

        end;

      2: // Id
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND id = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY id');

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

function TUsuarioDAO.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM usuario');
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

function TUsuarioDAO.getExiste(const pNOME: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(id)');
      lPersistencia.Query.SQL.Add('FROM usuario');
      lPersistencia.Query.SQL.Add('WHERE nome = :pNome');

      lPersistencia.setParametro('pNome', pNOME);

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

function TUsuarioDAO.getExisteUsuariosCadastrados: Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM usuario');

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

function TUsuarioDAO.getListaObjeto(var pLista: TObjectList<TUsuario>): Boolean;
var
  lPersistencia: TPersistencia;
  lUsuario: TUsuario;
  I: Integer;

begin
  Result := False;
  pLista.Clear;

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    lPersistencia.IniciaTransacao;

    lPersistencia.Query.SQL.Add('SELECT ');
    lPersistencia.Query.SQL.Add('   u.id, ');
    lPersistencia.Query.SQL.Add('   u.nome ');
    lPersistencia.Query.SQL.Add('FROM usuario u ');
    lPersistencia.Query.SQL.Add('ORDER BY u.id');

    lPersistencia.Query.Open;

    if (not lPersistencia.Query.IsEmpty) then
    begin

      lPersistencia.Query.First;
      while (not lPersistencia.Query.Eof) do
      begin
        lUsuario := TUsuario.Create;

        lUsuario.Id := lPersistencia.Query.FieldByName('id').AsInteger;
        lUsuario.Nome := lPersistencia.Query.FieldByName('nome').AsString;

        pLista.Add(lUsuario);
        lPersistencia.Query.Next;

      end;

      Result:= True;

    end
    else
    begin

      Result := False;

    end;

  finally
    lPersistencia.Destroy;
  end;
end;

function TUsuarioDAO.getLogin(const pNOME, pSENHA: string; var pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin
  Result := False;

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    lPersistencia.IniciaTransacao;

    lPersistencia.Query.SQL.Add('SELECT');
    lPersistencia.Query.SQL.Add('  *');
    lPersistencia.Query.SQL.Add('FROM usuario');
    lPersistencia.Query.SQL.Add('WHERE nome = :pNome');
    lPersistencia.setParametro('pNome', pNOME);

    lPersistencia.Query.Open;

    if (not lPersistencia.Query.IsEmpty) then
    begin

      while (not lPersistencia.Query.Eof) do
      begin

        if (TBiblioteca.Crypt('D', lPersistencia.Query.FieldByName('senha').AsString.Trim) = pSENHA.Trim) then
        begin
          pID := lPersistencia.Query.FieldByName('id').AsInteger;
          Result := True;
          Break;
        end;

        lPersistencia.Query.Next;
      end;
    end
    else
    begin
      Result := False;
    end;

  finally
    lPersistencia.Destroy;
  end;
end;

function TUsuarioDAO.getNomeUsuario(const pID: Integer): string;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    Result := '';

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  nome');
      lPersistencia.Query.SQL.Add('FROM usuario');
      lPersistencia.Query.SQL.Add('WHERE id = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      if (not lPersistencia.Query.IsEmpty) then
      begin
        Result := lPersistencia.Query.FieldByName('nome').AsString;
      end;

    except
      on E: Exception do
      begin
        Result := '';
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TUsuarioDAO.Salvar(var pObjeto: TUsuario): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin
        lPersistencia.Query.SQL.Add('INSERT INTO usuario (');
        lPersistencia.Query.SQL.Add('  nome,');
        lPersistencia.Query.SQL.Add('  senha,');
        lPersistencia.Query.SQL.Add('  admin');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pNome,');
        lPersistencia.Query.SQL.Add('  :pSenha,');
        lPersistencia.Query.SQL.Add('  :pAdmin');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE usuario SET');
        lPersistencia.Query.SQL.Add('  nome = :pNome,');
        lPersistencia.Query.SQL.Add('  senha = :pSenha,');
        lPersistencia.Query.SQL.Add('  admin = :pAdmin');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

        lPersistencia.setParametro('pId', pObjeto.Id);
      end;

      lPersistencia.setParametro('pNome', pObjeto.Nome);
      lPersistencia.setParametro('pSenha', pObjeto.Senha);
      lPersistencia.setParametro('pAdmin', pObjeto.Admin);

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

function TUsuarioDAO.getObjeto(const pID: Integer; var pObjeto: TUsuario): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id,');
      lPersistencia.Query.SQL.Add('  nome,');
      lPersistencia.Query.SQL.Add('  senha,');
      lPersistencia.Query.SQL.Add('  admin');
      lPersistencia.Query.SQL.Add('FROM usuario');

      lPersistencia.Query.SQL.Add('WHERE id = :pId');
      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Nome := lPersistencia.Query.FieldByName('nome').AsString;
      pObjeto.Senha := lPersistencia.Query.FieldByName('senha').AsString;
      pObjeto.Admin := lPersistencia.Query.FieldByName('admin').AsString;

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

function TUsuarioDAO.getPermiteExclusao(const pID: Integer; var pMensagem: string): Boolean;
var
  lExisteVinculoSaida: Boolean;
  lExisteVinculoEntrada: Boolean;
begin

    try

      lExisteVinculoSaida :=  TClassBibliotecaDao.getValorAtributo('saida', 'id', 'id_usuario', pID, Self.FConexao) <> -1;
      lExisteVinculoEntrada := TClassBibliotecaDao.getValorAtributo('entrada', 'id', 'id_usuario', pID, Self.FConexao) <> -1;

      Result := (not lExisteVinculoSaida) and (not lExisteVinculoEntrada);

      if (not Result) then
      begin

        pMensagem := 'Usuário possui';

        if (lExisteVinculoSaida) then
        begin

          pMensagem := pMensagem + ' saída(s)';

        end;

        if ( lExisteVinculoEntrada) then
        begin

          pMensagem := pMensagem + IfThen(lExisteVinculoSaida, ',', '') + ' entrada(s)';

        end;

        pMensagem := pMensagem + ' vinculadas';

      end;

    except
      on E:Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

end;

end.
