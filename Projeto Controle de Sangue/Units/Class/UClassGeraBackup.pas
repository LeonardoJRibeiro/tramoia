unit UClassGeraBackup;

interface

uses System.Classes, System.SysUtils;

type
  TGeraBackup = class(TPersistent)
  private

    FCaminhoExe: string;

    function PreparaScript: Boolean;

  public

    function CriaBackup: Boolean;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses Vcl.Forms, ShellAPI, WinAPI.Windows, UBiblioteca;

{ TGeraBackup }

constructor TGeraBackup.Create;
begin

  Self.FCaminhoExe := ExtractFilePath(Application.ExeName);

end;

destructor TGeraBackup.Destroy;
begin

  inherited;
end;

function TGeraBackup.CriaBackup: Boolean;
begin

  try

    if (FileExists(Self.FCaminhoExe + 'mysqldump.exe')) then
    begin

      if (Self.PreparaScript) then
      begin

        ShellExecute(0, 'open', pchar(Self.FCaminhoExe + 'doBackup.bat'), '', nil, SW_NORMAL);

        Result := True;

      end;

    end
    else
    begin

      Result := False;

      raise Exception.Create('Arquivo mysqldump.exe n�o encontrado');

    end;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao gerar backup. Motivo: ' + E.Message);
    end;
  end;

end;

function TGeraBackup.PreparaScript: Boolean;
var
  lTextFile: TextFile;
  lUserName: string;
  lPassWord: string;
  lHostName: string;
begin

  try

    AssignFile(lTextFile, Self.FCaminhoExe + 'doBackup.bat');

    Rewrite(lTextFile);

    lUserName := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'user_name', 'root');
    lPassWord := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'password', '');
    lHostName := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'hostname', 'localhost');

    Writeln(lTextFile, 'mysqldump.exe -B -c --single-transaction --default-character-set=latin1 banco -u ' + lUserName +
      ' --password="' + lPassWord + '" -h ' + lHostName + ' > backup.sql');

    CloseFile(lTextFile);

    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao criar script(.bat). Motivo: ' + E.Message);
    end;
  end;

end;

end.
