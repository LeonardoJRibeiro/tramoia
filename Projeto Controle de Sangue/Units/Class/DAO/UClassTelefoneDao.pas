unit UClassTelefoneDAO;

interface

uses System.Classes, System.SysUtils, UClassPersistBaseDados, UClassPersistencia, UClassTelefone;

type
  TTelefoneDAO = class(TPersistBase<TTelefone>)
  private

  public

    function getId(const pID_PACIENTE: Integer): Integer;

    function getObjetoTelefone(const pID_PACIENTE: Integer; var pObjeto: TTelefone): Boolean;

  end;

implementation

function TTelefoneDAO.getId(const pID_PACIENTE: Integer): Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id');
      lPersistencia.Query.SQL.Add('FROM telefone');
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

function TTelefoneDAO.getObjetoTelefone(const pID_PACIENTE: Integer; var pObjeto: TTelefone): Boolean;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM telefone');
      lPersistencia.Query.SQL.Add('WHERE id_paciente = :pId_Paciente');

      lPersistencia.setParametro('pId_Paciente', pID_PACIENTE);

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Id_Paciente := lPersistencia.Query.FieldByName('id_paciente').AsInteger;
      pObjeto.Ddd := lPersistencia.Query.FieldByName('ddd').Asstring;
      pObjeto.Numero := lPersistencia.Query.FieldByName('numero').Asstring;
      pObjeto.Tipo_Telefone := lPersistencia.Query.FieldByName('tipo_telefone').Asstring;

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
