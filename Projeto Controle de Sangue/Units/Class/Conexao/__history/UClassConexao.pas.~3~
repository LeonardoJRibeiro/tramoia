unit UClassConexao;

interface

uses System.SysUtils, System.Classes, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Comp.Client;

type
  TConexao = class(TPersistent)
  private
    FFDConnection: TFDConnection;
    FFDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
  public

    function PreparaConexao(): Boolean;

    property Connection: TFDConnection read FFDConnection write FFDConnection;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses Vcl.Forms, UBiblioteca;
{ TConexao }

constructor TConexao.Create;
begin
  inherited;

  Self.FFDConnection := TFDConnection.Create(nil);

  Self.FFDPhysMySQLDriverLink := TFDPhysMySQLDriverLink.Create(nil);

end;

destructor TConexao.Destroy;
begin
  FreeAndNil(Self.FFDConnection);
  inherited;
end;

function TConexao.PreparaConexao: Boolean;
begin

  try

    Self.FFDConnection.Connected := False;

    Self.FFDConnection.LoginPrompt := False;

    Self.FFDConnection.Params.Clear;

    Self.FFDConnection.Params.Add('DriverID=MySQL');

    Self.FFDConnection.Params.Add('hostname=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'hostname', ''));

    Self.FFDConnection.Params.Add('user_name=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'user_name', ''));

    Self.FFDConnection.Params.Add('password=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao',
      'password', ''));

    Self.FFDConnection.Params.Add('port=' + TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'port', ''));

    Self.FFDConnection.Params.Add('Database=banco');

    Self.FFDConnection.Connected := True;

    Self.FFDPhysMySQLDriverLink.VendorLib := ExtractFilePath(Application.ExeName) + 'libmysql.dll';

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
