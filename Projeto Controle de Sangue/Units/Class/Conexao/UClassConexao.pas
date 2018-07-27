unit UClassConexao;

interface

uses System.SysUtils, System.Classes, FireDAC.Comp.Client;

type
  TConexao = class(TPersistent)
  private
    FDConnection: TFDConnection;
  public

    function PreparaConexao(): Boolean;

    property Connection: TFDConnection read FDConnection write FDConnection;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses UBiblioteca;
{ TConexao }

constructor TConexao.Create;
begin
  inherited;

  Self.FDConnection := TFDConnection.Create(nil);

  Self.PreparaConexao;

end;

destructor TConexao.Destroy;
begin
  FreeAndNil(Self.FDConnection);
  inherited;
end;

function TConexao.PreparaConexao: Boolean;
begin

  try

    Self.FDConnection.Connected := False;

    Self.FDConnection.LoginPrompt := False;

    Self.FDConnection.Params.Clear;

    Self.FDConnection.Params.Add('DriverID=MySQL');

    Self.FDConnection.Params.Add('hostname=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'hostname', ''));

    Self.FDConnection.Params.Add('user_name=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'user_name', ''));

    Self.FDConnection.Params.Add('password=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'password', ''));

    Self.FDConnection.Params.Add('port=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'port', ''));

    Self.FDConnection.Params.Add('Database=banco');

    Self.FDConnection.Connected := True;

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao conectar no banco de dados. Motivo: ' + E.Message);
    end;
  end;

end;

end.
