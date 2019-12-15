unit UClassConfiguracaoDao;

interface

uses System.Classes, System.SysUtils, UClassPersistBaseDados, UClassPersistencia, UClassConfiguracao;

type
  TConfiguracaoDAO = class(TPersistBase<TConfiguracao>)
  private

  public
    function getObjeto(var pObjeto: TConfiguracao): Boolean; overload;
    function getQuantDiasAvisoVencimento: Integer;

  end;

implementation

{ TConfiguracoesDAO }

function TConfiguracaoDAO.getObjeto(var pObjeto: TConfiguracao): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM configuracao');

      lPersistencia.Query.Open;

      pObjeto.Id := lPersistencia.Query.FieldByName('id').AsInteger;
      pObjeto.Quant_Dias_Aviso_Vencimento := lPersistencia.Query.FieldByName('quant_dias_aviso_vencimento').AsInteger;

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

function TConfiguracaoDAO.getQuantDiasAvisoVencimento: Integer;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  id First,');
      lPersistencia.Query.SQL.Add('  quant_dias_aviso_vencimento');
      lPersistencia.Query.SQL.Add('FROM configuracao;');

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.FieldByName('quant_dias_aviso_vencimento').AsInteger;

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

end.
