unit UClassBibliotecaDao;

interface

uses System.Classes, System.SysUtils, UClassPersistencia, UClassConexao;

type
  TClassBibliotecaDao = class(TPersistent)
  private
    FConexao: TConexao;

  public
    class function getValorAtributo(const pEntidade, pCAMPO_RETORNO, pIDENTIFICADOR: string; const pCHAVE: Integer;
      const pCONEXAO: TConexao): Variant; overload;

    class function getValorAtributo(const pEntidade, pCAMPO_RETORNO, pIDENTIFICADOR: string; const pCHAVE: string;
      const pCONEXAO: TConexao): Variant; overload;

    class function setValorAtributo(const pEntidade, pCAMPO_A_SER_ALTERADO, pIDENTIFICADOR: string;
      const pCHAVE: Variant; const pALTERACAO: Variant; const pCONEXAO: TConexao): Boolean;

    class function getNomeUsuario(const pID_USUARIO: Integer; const pCONEXAO: TConexao): string;

  published
    { published declarations }
  end;

implementation

{ TClassBibliotecaDao }

uses UClassUsuarioDao;

class function TClassBibliotecaDao.getNomeUsuario(const pID_USUARIO: Integer; const pCONEXAO: TConexao): string;
var
  lUsuarioDao: TUSUARIODAO;
begin
  lUsuarioDao := TUSUARIODAO.Create(pCONEXAO);
  try

    try
      Result := lUsuarioDao.getNomeUsuario(pID_USUARIO);
    except
      on E: Exception do
      begin
        Result := '';
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lUsuarioDao.Destroy;
  end;
end;

class function TClassBibliotecaDao.getValorAtributo(const pEntidade, pCAMPO_RETORNO, pIDENTIFICADOR: string;
  const pCHAVE: Integer; const pCONEXAO: TConexao): Variant;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(pCONEXAO);
  try

    try
      Result := lPersistencia.getValorAtributo(pEntidade, pCAMPO_RETORNO, pIDENTIFICADOR, pCHAVE, pCONEXAO);

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

class function TClassBibliotecaDao.getValorAtributo(const pEntidade, pCAMPO_RETORNO, pIDENTIFICADOR, pCHAVE: string;
  const pCONEXAO: TConexao): Variant;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(pCONEXAO);
  try

    try

      Result := lPersistencia.getValorAtributo(pEntidade, pCAMPO_RETORNO, pIDENTIFICADOR, pCHAVE, pCONEXAO);

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

class function TClassBibliotecaDao.setValorAtributo(const pEntidade, pCAMPO_A_SER_ALTERADO, pIDENTIFICADOR: string;
  const pCHAVE, pALTERACAO: Variant; const pCONEXAO: TConexao): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(pCONEXAO);
  try
    try
      Result := lPersistencia.setValorAtributo(pEntidade, pCAMPO_A_SER_ALTERADO, pIDENTIFICADOR, pCHAVE, pALTERACAO,
        pCONEXAO);

    except
      on E: Exception do
      begin
        Result := false;
        raise Exception.Create(E.Message);
      end;

    end;
  finally
    lPersistencia.Destroy;
  end;

end;

end.
