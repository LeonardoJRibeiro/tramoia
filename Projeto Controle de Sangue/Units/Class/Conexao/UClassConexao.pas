unit UClassConexao;

interface

uses System.SysUtils, System.Classes, Data.DB, Data.DBXMySQL, Data.SqlExpr;

type
  TConexao = class(TPersistent)
  private

    FSqlConnection: TSQLConnection;
    FSqlDataset: TSQLDataset;

  public

    function PreparaConexao(): Boolean;

    property SqlConnection: TSQLConnection read FSqlConnection write FSqlConnection;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses UBiblioteca;

{ TConexao }

constructor TConexao.Create;
begin
  inherited;

  Self.FSqlConnection := TSQLConnection.Create(nil);

  Self.FSqlDataset := TSQLDataset.Create(nil);

end;

destructor TConexao.Destroy;
begin

  inherited;
end;

function TConexao.PreparaConexao: Boolean;
begin

  try

    Self.FSqlConnection.Connected := False;

    Self.FSqlConnection.ConnectionName := 'MySQLConnection';

    Self.FSqlConnection.DriverName := 'MySQL';

    Self.FSqlConnection.ParamsLoaded := True;

    Self.FSqlConnection.LoadParamsOnConnect := False;

    Self.FSqlConnection.GetDriverFunc := 'getSQLDriverMYSQL';

    Self.FSqlConnection.LibraryName := 'dbxmys.dll';

    Self.FSqlConnection.VendorLib := 'LIBMYSQL.dll';

    Self.FSqlConnection.LoginPrompt := False;

    Self.FSqlConnection.Params.Clear;

    Self.FSqlConnection.Params.Add('servercharset=utf8');

    Self.FSqlConnection.Params.Add('hostname=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'hostname', ''));

    Self.FSqlConnection.Params.Add('user_name=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'user_name', ''));

    Self.FSqlConnection.Params.Add('password=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'password', ''));

    Self.FSqlConnection.Params.Add('port=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'port', ''));

    Self.FSqlConnection.Params.Add('Database=banco');

    Self.FSqlConnection.Connected := True;

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao conectar no banco de dados: ' + E.Message);
    end;
  end;

end;

end.
