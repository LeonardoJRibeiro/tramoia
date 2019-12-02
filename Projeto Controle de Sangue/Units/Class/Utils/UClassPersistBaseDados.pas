unit UClassPersistBaseDados;

interface

uses System.Classes, System.SysUtils, UInterfaceDao, UClassConexao, System.Rtti, UClassPersistencia;

type
  TPersistBase<T: class> = class(TInterfacedObject, IInterfaceDAO<T>)
  private
    FNomeEntidade: string;
    FNomeAtributoChave: string;

    FRttiContext: TRttiContext;
    FRttiType: TRttiType;

    function ExecutaSqlInsert(var pOBJETO: T): Boolean;
    function ExecutaSqlUpdate(var pOBJETO: T): Boolean;

    procedure setParametrosInsertEUpdate(const pRTTIPROPERTY: TRttiProperty; const pOBJETO: T;
      const pPERSISTENCIA: TPersistencia; const pNOME_ATRIBUTO: string);

    function getNomeEntidade: string;
    function getNomeAtributoChave: string;
    function getValorAtributoChave(const pOBJETO: T): Integer;

  protected
    FConexao: TConexao;

  public

    function Salvar(var pOBJETO: T): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function getExiste(const pID: Integer): Boolean;
    function getObjeto(const pID: Integer; var pOBJETO: T): Boolean;

    constructor Create(const pCONEXAO: TConexao); overload; virtual;
    destructor Destroy; override;

  end;

implementation

uses UAtributos;

{ TPersistBase<T> }

constructor TPersistBase<T>.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
  Self.FRttiContext := TRttiContext.Create;
  Self.FRttiType := Self.FRttiContext.GetType(T);

  Self.FNomeEntidade := Self.getNomeEntidade;
  Self.FNomeAtributoChave := Self.getNomeAtributoChave;
end;

destructor TPersistBase<T>.Destroy;
begin
  Self.FRttiContext.Free;
  inherited;
end;

function TPersistBase<T>.Excluir(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('DELETE FROM ' + Self.FNomeEntidade);
      lPersistencia.Query.SQL.Add('WHERE ' + Self.FNomeAtributoChave + ' = :pId');

      lPersistencia.setParametro('pId', pID);

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

function TPersistBase<T>.ExecutaSqlInsert(var pOBJETO: T): Boolean;
var
  lRttiProperty: TRttiProperty;
  lAtributo: TCustomAttribute;
  lSqlAtributos: string;
  lSqlParametros: string;
  lPersistencia: TPersistencia;
  lNomeAtributo: string;
begin

  for lRttiProperty in Self.FRttiType.GetProperties do
  begin

    for lAtributo in lRttiProperty.GetAttributes do
    begin

      if (lAtributo is TAtributo) then
      begin

        lSqlAtributos := lSqlAtributos + (lAtributo as TAtributo).NomeAtributo + ',';

        lSqlParametros := lSqlParametros + ':p' + (lAtributo as TAtributo).NomeAtributo + ',';

      end;

    end;

  end;

  Delete(lSqlAtributos, lSqlAtributos.Length, 1);
  Delete(lSqlParametros, lSqlParametros.Length, 1);

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('INSERT INTO ' + Self.FNomeEntidade + ' (');

      lPersistencia.Query.SQL.Add(lSqlAtributos);

      lPersistencia.Query.SQL.Add(') VALUES (');

      lPersistencia.Query.SQL.Add(lSqlParametros);

      lPersistencia.Query.SQL.Add(');');

      for lRttiProperty in Self.FRttiType.GetProperties do
      begin

        for lAtributo in lRttiProperty.GetAttributes do
        begin

          if (lAtributo is TAtributo) then
          begin

            lNomeAtributo := (lAtributo as TAtributo).NomeAtributo;

            Self.setParametrosInsertEUpdate(lRttiProperty, pOBJETO, lPersistencia, lNomeAtributo);

          end;

        end;

      end;

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

function TPersistBase<T>.ExecutaSqlUpdate(var pOBJETO: T): Boolean;
var
  lRttiProperty: TRttiProperty;
  lAtributo: TCustomAttribute;
  lSqlAtributos: string;
  lPersistencia: TPersistencia;
  lNomeAtributo: string;
begin

  for lRttiProperty in Self.FRttiType.GetProperties do
  begin

    for lAtributo in lRttiProperty.GetAttributes do
    begin

      if (lAtributo is TAtributo) then
      begin

        lSqlAtributos := lSqlAtributos + (lAtributo as TAtributo).NomeAtributo + ' = :p' + (lAtributo as TAtributo)
          .NomeAtributo + ',';

      end;

    end;

  end;

  Delete(lSqlAtributos, lSqlAtributos.Length, 1);

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('UPDATE ' + Self.FNomeEntidade + ' SET');

      lPersistencia.Query.SQL.Add(lSqlAtributos);

      lPersistencia.Query.SQL.Add('WHERE ' + Self.FNomeAtributoChave + '= :p' + Self.FNomeAtributoChave);

      for lRttiProperty in Self.FRttiType.GetProperties do
      begin

        for lAtributo in lRttiProperty.GetAttributes do
        begin

          if (lAtributo is TAtributo) then
          begin

            lNomeAtributo := (lAtributo as TAtributo).NomeAtributo;

            Self.setParametrosInsertEUpdate(lRttiProperty, pOBJETO, lPersistencia, lNomeAtributo);

          end;

        end;

      end;

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

function TPersistBase<T>.getExiste(const pID: Integer): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(*)');
      lPersistencia.Query.SQL.Add('FROM ' + Self.FNomeEntidade);
      lPersistencia.Query.SQL.Add('WHERE ' + Self.FNomeAtributoChave + ' = :pId');

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

function TPersistBase<T>.getNomeAtributoChave: string;
var
  lRttiProperty: TRttiProperty;
  lAtributo: TCustomAttribute;
begin

  for lRttiProperty in Self.FRttiType.GetProperties do
  begin

    for lAtributo in lRttiProperty.GetAttributes do
    begin

      if (lAtributo is TChavePrimaria) then
      begin

        Result := lRttiProperty.Name;
        Break;

      end;

    end;

  end;

end;

function TPersistBase<T>.getNomeEntidade: string;
var
  lRttiProperty: TRttiProperty;
  lAtributo: TCustomAttribute;
begin

  for lAtributo in Self.FRttiType.GetAttributes do
  begin

    if (lAtributo is TEntidade) then
    begin

      Result := (lAtributo as TEntidade).NomeEntidade;
      Break;

    end;

  end;

end;

function TPersistBase<T>.getObjeto(const pID: Integer; var pOBJETO: T): Boolean;
var
  lPersistencia: TPersistencia;
  lRttiProperty: TRttiProperty;
  lAtributo: TCustomAttribute;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  *');
      lPersistencia.Query.SQL.Add('FROM ' + Self.FNomeEntidade);
      lPersistencia.Query.SQL.Add('WHERE ' + Self.FNomeAtributoChave + ' = :pId');

      lPersistencia.setParametro('pId', pID);

      lPersistencia.Query.Open;

      for lRttiProperty in Self.FRttiType.GetProperties do
      begin

        for lAtributo in lRttiProperty.GetAttributes do
        begin

          if (lAtributo is TAtributo) then
          begin

            if (lRttiProperty.PropertyType.Name = 'string') then
            begin
              lRttiProperty.SetValue(Pointer(pOBJETO), lPersistencia.Query.FieldByName(lRttiProperty.Name).AsString);
            end
            else if (lRttiProperty.PropertyType.Name = 'Integer') then
            begin
              lRttiProperty.SetValue(Pointer(pOBJETO), lPersistencia.Query.FieldByName(lRttiProperty.Name).AsInteger);
            end
            else if (lRttiProperty.PropertyType.Name = 'TDate') then
            begin
              lRttiProperty.SetValue(Pointer(pOBJETO),
                StrToDate(lPersistencia.Query.FieldByName(lRttiProperty.Name).AsString));
            end
            else if (lRttiProperty.PropertyType.Name = 'TDateTime') then
            begin
              lRttiProperty.SetValue(Pointer(pOBJETO), StrToDateTime(lPersistencia.Query.FieldByName(lRttiProperty.Name)
                .AsString));
            end;

          end;

        end;

      end;

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

function TPersistBase<T>.getValorAtributoChave(const pOBJETO: T): Integer;
var
  lRttiProperty: TRttiProperty;
  lAtributo: TCustomAttribute;
begin

  for lRttiProperty in Self.FRttiType.GetProperties do
  begin

    for lAtributo in lRttiProperty.GetAttributes do
    begin

      if (lAtributo is TChavePrimaria) then
      begin

        Result := lRttiProperty.GetValue(Pointer(pOBJETO)).ToString.ToInteger;
        Break;

      end;

    end;

  end;

end;

function TPersistBase<T>.Salvar(var pOBJETO: T): Boolean;
begin

  try

    if (Self.getExiste(Self.getValorAtributoChave(pOBJETO))) then
    begin
      Result := Self.ExecutaSqlUpdate(pOBJETO);
    end
    else
    begin
      Result := Self.ExecutaSqlInsert(pOBJETO);
    end;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create(E.Message);
    end;

  end;

end;

procedure TPersistBase<T>.setParametrosInsertEUpdate(const pRTTIPROPERTY: TRttiProperty; const pOBJETO: T;
  const pPERSISTENCIA: TPersistencia; const pNOME_ATRIBUTO: string);
begin

  if (pRTTIPROPERTY.PropertyType.Name = 'string') then
  begin
    pPERSISTENCIA.setParametro('p' + pNOME_ATRIBUTO, pRTTIPROPERTY.GetValue(Pointer(pOBJETO)).ToString);
  end
  else if (pRTTIPROPERTY.PropertyType.Name = 'Integer') then
  begin
    pPERSISTENCIA.setParametro('p' + pNOME_ATRIBUTO, pRTTIPROPERTY.GetValue(Pointer(pOBJETO)).ToString.ToInteger);
  end
  else if (pRTTIPROPERTY.PropertyType.Name = 'TDate') then
  begin
    pPERSISTENCIA.setParametro('p' + pNOME_ATRIBUTO, StrToDate(pRTTIPROPERTY.GetValue(Pointer(pOBJETO)).ToString));
  end
  else if (pRTTIPROPERTY.PropertyType.Name = 'TDateTime') then
  begin
    pPERSISTENCIA.setParametro('p' + pNOME_ATRIBUTO, StrToDateTime(pRTTIPROPERTY.GetValue(Pointer(pOBJETO)).ToString));
  end;

end;

end.
