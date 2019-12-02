unit UClassPacienteDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistencia, UClassPaciente, System.Variants,
  UClassPersistBaseDados;

type
  TPacienteDAO = class(TPersistBase<TPaciente>)
  private

  public

    function getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt; var pPersistencia: TPersistencia): Boolean;

    function getId(const pNUM_PRONTUARIO: string): Integer;

    function getExisteProntuario(const pNUM_PRONTUARIO: string): Boolean;

    function getExisteCpf(const pCPF: string): Boolean;

    function getNomeEABO(const pNUM_PRONTUARIO: string; var pNOME, pABO: string): Boolean;

  end;

implementation

uses System.StrUtils;

function TPacienteDAO.getConsulta(const pCHAVE: string; const pTIPOCONS: SmallInt;
  var pPersistencia: TPersistencia): Boolean;
begin

  try

    pPersistencia.IniciaTransacao;

    pPersistencia.Query.SQL.Add('SELECT');
    pPersistencia.Query.SQL.Add('  p.id,');
    pPersistencia.Query.SQL.Add('  p.nome,');
    pPersistencia.Query.SQL.Add('  p.num_prontuario,');
    pPersistencia.Query.SQL.Add('  CONCAT(p.abo, p.rh) AS grupo_sanguineo,');
    pPersistencia.Query.SQL.Add('CONCAT(SUBSTRING(p.sus,1,11), ' + QuotedStr(' ') + ', SUBSTRING(p.sus,12,4), ' +
      QuotedStr(' ') + ', SUBSTRING(p.sus,16,1)) AS sus,');
    pPersistencia.Query.SQL.Add('  CONCAT(t.ddd, t.numero) AS telefone');
    pPersistencia.Query.SQL.Add('FROM paciente p');

    pPersistencia.Query.SQL.Add('LEFT JOIN telefone t');
    pPersistencia.Query.SQL.Add('ON (p.id = t.id_paciente)');

    pPersistencia.Query.SQL.Add('WHERE 0=0');

    case (pTIPOCONS) of
      0, 1: // Palavra chave e Nome
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND p.nome LIKE :pChave');
            pPersistencia.setParametro('pChave', IfThen(pTIPOCONS = 0, '%', '') + pCHAVE + '%');

          end;

          pPersistencia.Query.SQL.Add('ORDER BY p.nome');

        end;

      2: // Código(registro_paciente, o Id do paciente no sistema do hospital).
        begin

          if (not pCHAVE.Trim.IsEmpty) then
          begin

            pPersistencia.Query.SQL.Add('AND p.num_prontuario = :pChave');
            pPersistencia.setParametro('pChave', pCHAVE);

          end;

          pPersistencia.Query.SQL.Add('ORDER BY');
          pPersistencia.Query.SQL.Add('  p.num_prontuario');

        end;
    end;

    pPersistencia.Query.SQL.Add('LIMIT 500');

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

function TPacienteDAO.getExisteCpf(const pCPF: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(id)');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE cpf = :pCpf');

      lPersistencia.setParametro('pCPF', pCPF);

      lPersistencia.Query.Open;

      Result := False;
      if (not lPersistencia.Query.IsEmpty) then
      begin
        Result := lPersistencia.Query.Fields[0].AsInteger > 0;
      end;

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

function TPacienteDAO.getExisteProntuario(const pNUM_PRONTUARIO: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(id)');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE num_prontuario = :pNum_Prontuario');
      lPersistencia.setParametro('pNum_Prontuario', pNUM_PRONTUARIO);

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

function TPacienteDAO.getNomeEABO(const pNUM_PRONTUARIO: string; var pNOME, pABO: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  nome,');
      lPersistencia.Query.SQL.Add('  CONCAT(abo,rh) AS aborh');
      lPersistencia.Query.SQL.Add('FROM paciente');
      lPersistencia.Query.SQL.Add('WHERE num_prontuario = :pNum_Prontuario');

      lPersistencia.setParametro('pNum_Prontuario', pNUM_PRONTUARIO);

      lPersistencia.Query.Open;

      pNOME := lPersistencia.Query.FieldByName('nome').AsString;
      pABO := lPersistencia.Query.FieldByName('aborh').AsString;

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
