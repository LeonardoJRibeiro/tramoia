unit UClassPersistencia;

interface

uses System.Classes, System.SysUtils, IBX.IBDatabase, Data.DB,
  IBX.IBCustomDataSet, UClassConexao, Data.SqlExpr, Datasnap.Provider;

type
  TPersistencia = class(TPersistent)
  private
    FQuery: TSQLQuery;
    FDataSetProvider: TDataSetProvider;
    FTransacao: TIBTransaction;

    FConexao: TConexao;
  protected

  public
    property Query: TSQLQuery read FQuery write FQuery;

    property DataSetProvider: TDataSetProvider read FDataSetProvider write FDataSetProvider;

    property Transacao: TIBTransaction read FTransacao write FTransacao;

    procedure IniciaTransacao;

    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: string); overload;
    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Integer); overload;
    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Variant); overload;
    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Double); overload;
    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: TDate); overload;
    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: TDateTime); overload;
    procedure setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Currency); overload;

    function getProximoCodigo(const pENTIDADE: string; const pATRIBUTO: string): Integer;

    class function getValorAtributo(const pENTIDADE, pATRIBUTO_RETORNO, pIDENTIFICADOR: string; const pCHAVE: Integer;
      const pCONEXAO: TConexao): Variant;

    class function setValorAtributo(const pENTIDADE, pCAMPO_A_SER_ALTERADO, pIDENTIFICADOR: string;
      const pCHAVE: Variant; const pALTERACAO: Variant; const pCONEXAO: TConexao): Boolean;

    constructor Create(const pCONEXAO: TConexao);
    destructor Destroy;
  published
    { published declarations }
  end;

implementation

uses System.Variants;

{ TClassPersistencia }

constructor TPersistencia.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;

  Self.FQuery := TSQLQuery.Create(nil);
  Self.FQuery.MaxBlobSize := -1;

  Self.FQuery.SQLConnection := Self.FConexao.SQLConnection;

  Self.FDataSetProvider := TDataSetProvider.Create(nil);
  Self.FDataSetProvider.UpdateMode := upWhereKeyOnly;
  Self.FDataSetProvider.DataSet := Self.FQuery;

end;

destructor TPersistencia.Destroy;
begin

  if (Self.FQuery <> nil) then
  begin
    Self.Query.Close;
    FreeAndNil(Self.FQuery);
  end;

  if (Self.FDataSetProvider <> nil) then
  begin

    Self.FDataSetProvider.DataSet := nil;
    FreeAndNil(Self.FDataSetProvider);

  end;

end;

function TPersistencia.getProximoCodigo(const pENTIDADE, pATRIBUTO: string): Integer;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  MAX(' + pATRIBUTO + ')');
      lPersistencia.Query.SQL.Add('FROM ' + pENTIDADE);

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.Fields[0].AsInteger + 1;

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

class function TPersistencia.getValorAtributo(const pENTIDADE, pATRIBUTO_RETORNO, pIDENTIFICADOR: string;
  const pCHAVE: Integer; const pCONEXAO: TConexao): Variant;
var
  lPersistencia: TPersistencia;
begin
  lPersistencia := TPersistencia.Create(pCONEXAO);
  try
    try
      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add(pATRIBUTO_RETORNO);
      lPersistencia.Query.SQL.Add('FROM ' + pENTIDADE);
      lPersistencia.Query.SQL.Add('WHERE ' + pIDENTIFICADOR + '=' + IntToStr(pCHAVE));

      lPersistencia.Query.Open;

      if (not lPersistencia.Query.IsEmpty) then
      begin
        Result := lPersistencia.Query.FieldByName(pATRIBUTO_RETORNO).Value;
      end
      else
      begin
        Result := -1;
      end;

    except
      on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

procedure TPersistencia.IniciaTransacao;
begin
  Query.Close;
  Query.SQL.Clear;
end;

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Variant);
begin
  Query.ParamByName(pATRIBUTO).Value := pVALORATRIBUIDO;
end;

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Integer);
begin

///  if (pVALORATRIBUIDO <> -1) then
 // begin

    Query.ParamByName(pATRIBUTO).AsInteger := pVALORATRIBUIDO;

//  end
 // else
 // begin

 //   Query.ParamByName(pATRIBUTO).Value := null;

 // end;

end;

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: string);
begin

  if (pVALORATRIBUIDO <> '-1') then
  begin

    Query.ParamByName(pATRIBUTO).AsString := pVALORATRIBUIDO;

  end
  else
  begin

    Query.ParamByName(pATRIBUTO).Value := null;

  end;

end;

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Double);
begin

  if (pVALORATRIBUIDO <> -1) then
  begin

    Query.ParamByName(pATRIBUTO).AsFloat := pVALORATRIBUIDO;

  end
  else
  begin

    Query.ParamByName(pATRIBUTO).Value := null;

  end;

end;

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: Currency);
begin

  if (pVALORATRIBUIDO <> -1) then
  begin

    Query.ParamByName(pATRIBUTO).AsCurrency := pVALORATRIBUIDO;

  end
  else
  begin

    Query.ParamByName(pATRIBUTO).Value := null;

  end;

end;

class function TPersistencia.setValorAtributo(const pENTIDADE, pCAMPO_A_SER_ALTERADO, pIDENTIFICADOR: string;
  const pCHAVE, pALTERACAO: Variant; const pCONEXAO: TConexao): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(pCONEXAO);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('UPDATE ' + pENTIDADE);
      lPersistencia.Query.SQL.Add('SET ' + pCAMPO_A_SER_ALTERADO + ' = ' + QuotedStr(pALTERACAO));
      lPersistencia.Query.SQL.Add('WHERE (' + pIDENTIFICADOR + ' = ' + QuotedStr(pCHAVE) + ');');

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

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: TDateTime);
begin
  Query.ParamByName(pATRIBUTO).AsDateTime := pVALORATRIBUIDO;
end;

procedure TPersistencia.setParametro(const pATRIBUTO: string; pVALORATRIBUIDO: TDate);
begin
  Query.ParamByName(pATRIBUTO).AsDate := pVALORATRIBUIDO;
end;

end.
