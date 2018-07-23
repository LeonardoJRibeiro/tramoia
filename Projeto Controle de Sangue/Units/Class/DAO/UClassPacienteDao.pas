unit UClassPacienteDAO;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, UClassPersistencia, UClassPaciente;

type
  TPacienteDAO = class(TInterfacedPersistent, IInterfaceDao<TPaciente>)
  private
    FConexao: TConexao;

  public
    function getExiste(const pID: Integer): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function Salvar(var pObjeto: TPaciente): Boolean;
    function getObjeto(const pID: Integer; var pObjeto: TPaciente): Boolean;

    function getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt; var pPersistencia: TPersistencia): Boolean;
    function getId(const pNUM_PRONTUARIO: string): Integer;

    function getExisteProntuario(const pNUM_PRONTUARIO: string): Boolean;

    function getExisteCpf(const pCPF: Integer): Integer;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

uses System.StrUtils;

constructor TPacienteDAO.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

destructor TPacienteDAO.Destroy;
begin

  inherited;
end;

function TPacienteDAO.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE');
      lPersistencia.Query.SQL.Add('FROM paciente');
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

function TPacienteDAO.getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  id,');
    pPersistencia.Query.SQL.Add('  nome,');
    pPersistencia.Query.SQL.Add('  num_prontuario,');
    pPersistencia.Query.SQL.Add('  CONCAT(abo, rh) grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('  CONCAT(SUBSTRING(CPF,1,3), ' + QuotedStr('.') + ', SUBSTRING(CPF,4,3), ' +
      QuotedStr('.') + ',SUBSTRING(CPF,7,3), ' + QuotedStr('-') + ', SUBSTRING(CPF,10,2)) AS cpf,');
    pPersistencia.Query.SQL.Add('CONCAT(SUBSTRING(sus,1,11), ' + QuotedStr(' ') + ', SUBSTRING(sus,12,4), ' +
      QuotedStr(' ') + ', SUBSTRING(sus,16,1)) AS sus,');
    pPersistencia.Query.SQL.Add('  rg,');
    pPersistencia.Query.SQL.Add('  telefone');
    pPersistencia.Query.SQL.Add('FROM paciente');

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

      2: // C�digo(registro_paciente, o Id do paciente no sistema do hospital).
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND num_prontuario = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY num_prontuario');

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

function TPacienteDAO.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  count(*)');
      lPersistencia.Query.SQL.Add('FROM paciente');
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

function TPacienteDAO.getExisteCpf(const pCPF: Integer): Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE cpf = :pCpf');

      lPersistencia.setParametro('pCPF', pCPF);

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
    FreeAndNil(lPersistencia);
  end;

end;

function TPacienteDAO.getExisteProntuario(const pNUM_PRONTUARIO: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE num_prontuario = :pNum_Prontuario');
      lPersistencia.setParametro('pNum_Prontuario', pNUM_PRONTUARIO);

      lPersistencia.Query.Open;

      Result := not lPersistencia.Query.IsEmpty;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;

    end;

  finally
    FreeAndNil(lPersistencia);
  end;

end;

function TPacienteDAO.getId(const pNUM_PRONTUARIO: string): Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE num_prontuario = :pNum_Prontuario');

      lPersistencia.setParametro('pNum_Prontuario', pNUM_PRONTUARIO);

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
    FreeAndNil(lPersistencia);
  end;

end;

function TPacienteDAO.Salvar(var pObjeto: TPaciente): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      if (not Self.getExiste(pObjeto.Id)) then
      begin

        lPersistencia.Query.SQL.Add('INSERT INTO paciente (');
        lPersistencia.Query.SQL.Add('  nome,');
        lPersistencia.Query.SQL.Add('  nome_pai,');
        lPersistencia.Query.SQL.Add('  nome_mae,');
        lPersistencia.Query.SQL.Add('  data_nascimento,');
        lPersistencia.Query.SQL.Add('  sexo,');
        lPersistencia.Query.SQL.Add('  num_prontuario,');
        lPersistencia.Query.SQL.Add('  abo,');
        lPersistencia.Query.SQL.Add('  rh,');
        lPersistencia.Query.SQL.Add('  cpf,');
        lPersistencia.Query.SQL.Add('  rg,');
        lPersistencia.Query.SQL.Add('  telefone,');
        lPersistencia.Query.SQL.Add('  sus,');
        lPersistencia.Query.SQL.Add('  observacao');
        lPersistencia.Query.SQL.Add(') VALUES (');
        lPersistencia.Query.SQL.Add('  :pNome,');
        lPersistencia.Query.SQL.Add('  :pNome_Pai,');
        lPersistencia.Query.SQL.Add('  :pNome_Mae,');
        lPersistencia.Query.SQL.Add('  :pData_Nascimento,');
        lPersistencia.Query.SQL.Add('  :pSexo,');
        lPersistencia.Query.SQL.Add('  :pNum_Prontuario,');
        lPersistencia.Query.SQL.Add('  :pAbo,');
        lPersistencia.Query.SQL.Add('  :pRh,');
        lPersistencia.Query.SQL.Add('  :pCpf,');
        lPersistencia.Query.SQL.Add('  :pRg,');
        lPersistencia.Query.SQL.Add('  :pTelefone,');
        lPersistencia.Query.SQL.Add('  :pSus,');
        lPersistencia.Query.SQL.Add('  :pObservacao');
        lPersistencia.Query.SQL.Add(');');
      end
      else
      begin
        lPersistencia.Query.SQL.Add('UPDATE paciente SET');
        lPersistencia.Query.SQL.Add('  nome = :pNome,');
        lPersistencia.Query.SQL.Add('  nome_pai = :pNome_Pai,');
        lPersistencia.Query.SQL.Add('  nome_mae = :pNome_Mae,');
        lPersistencia.Query.SQL.Add('  data_nascimento = :pData_Nascimento,');
        lPersistencia.Query.SQL.Add('  sexo = :pSexo,');
        lPersistencia.Query.SQL.Add('  num_prontuario = :pNum_Prontuario,');
        lPersistencia.Query.SQL.Add('  abo = :pAbo,');
        lPersistencia.Query.SQL.Add('  rh = :pRh,');
        lPersistencia.Query.SQL.Add('  cpf = :pCpf,');
        lPersistencia.Query.SQL.Add('  rg = :pRg,');
        lPersistencia.Query.SQL.Add('  telefone = :pTelefone,');
        lPersistencia.Query.SQL.Add('  sus = :pSus,');
        lPersistencia.Query.SQL.Add('  observacao = :pObservacao');
        lPersistencia.Query.SQL.Add('WHERE (id = :pId);');

        lPersistencia.setParametro('pId', pObjeto.Id);
      end;

      lPersistencia.setParametro('pNome', pObjeto.Nome);
      lPersistencia.setParametro('pNome_Pai', pObjeto.Nome_Pai);
      lPersistencia.setParametro('pNome_Mae', pObjeto.Nome_Mae);
      lPersistencia.setParametro('pData_Nascimento', pObjeto.Data_Nascimento);
      lPersistencia.setParametro('pSexo', pObjeto.Sexo);
      lPersistencia.setParametro('pNum_Prontuario', pObjeto.Num_Prontuario);
      lPersistencia.setParametro('pAbo', pObjeto.Abo);
      lPersistencia.setParametro('pRh', pObjeto.Rh);
      lPersistencia.setParametro('pCpf', pObjeto.Cpf);
      lPersistencia.setParametro('pRg', pObjeto.Rg);
      lPersistencia.setParametro('pTelefone', pObjeto.Telefone);
      lPersistencia.setParametro('pSus', pObjeto.Sus);
      lPersistencia.setParametro('pObservacao', pObjeto.Observacao);

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

function TPacienteDAO.getObjeto(const pID: Integer; var pObjeto: TPaciente): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE id= :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Nome := lPersistencia.Query.FieldByName('nome').Asstring;
      pObjeto.Nome_Pai := lPersistencia.Query.FieldByName('nome_pai').Asstring;
      pObjeto.Nome_Mae := lPersistencia.Query.FieldByName('nome_mae').Asstring;
      pObjeto.Data_Nascimento := lPersistencia.Query.FieldByName('data_nascimento').AsDateTime;
      pObjeto.Sexo := lPersistencia.Query.FieldByName('sexo').Asstring;
      pObjeto.Num_Prontuario := lPersistencia.Query.FieldByName('num_prontuario').Asstring;
      pObjeto.Abo := lPersistencia.Query.FieldByName('abo').Asstring;
      pObjeto.Rh := lPersistencia.Query.FieldByName('rh').Asstring;
      pObjeto.Cpf := lPersistencia.Query.FieldByName('cpf').Asstring;
      pObjeto.Rg := lPersistencia.Query.FieldByName('rg').Asstring;
      pObjeto.Telefone := lPersistencia.Query.FieldByName('telefone').Asstring;
      pObjeto.Sus := lPersistencia.Query.FieldByName('sus').Asstring;
      pObjeto.Observacao := lPersistencia.Query.FieldByName('observacao').Asstring;

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
