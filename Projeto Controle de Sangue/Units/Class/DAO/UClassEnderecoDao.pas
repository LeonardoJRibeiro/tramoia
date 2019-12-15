unit UClassEnderecoDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistBaseDados, UClassPersistencia, UClassEndereco;

type
  TEnderecoDAO = class(TPersistBase<TEndereco>)
  private

  public

    function getObjetoPorIdPaciente(const pID_PACIENTE: Integer; var pObjeto: TEndereco): Boolean;

    function getId(const pID_PACIENTE: Integer): Integer;

  end;

implementation

function TEnderecoDAO.getId(const pID_PACIENTE: Integer): Integer;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
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

function TEnderecoDAO.getObjetoPorIdPaciente(const pID_PACIENTE: Integer; var pObjeto: TEndereco): Boolean;
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
