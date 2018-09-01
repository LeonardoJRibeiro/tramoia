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

      raise Exception.Create('Arquivo mysqldump.exe não encontrado');

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

  lStringListScript: TStringList;

begin

  try

    lStringListScript := TStringList.Create;
    try

      lStringListScript.Add('FOR /F "tokens=1,2,3 delims=/ " %%a in ("%DATE%") do (');
      lStringListScript.Add('set DIA=%%a');
      lStringListScript.Add('set MES=%%b');
      lStringListScript.Add('set ANO=%%c');
      lStringListScript.Add(')');

      lStringListScript.Add('set data=%DIA%_%MES%_%ANO%');

      lUserName := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'user_name', 'root');
      lPassWord := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'password', '');
      lHostName := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'Conexao', 'hostname', 'localhost');

      lStringListScript.Add('mysqldump.exe -B -c --single-transaction --default-character-set=latin1 banco -u ' +
        lUserName + ' --password="' + lPassWord + '" -h ' + lHostName + ' > ' +
        '"%userprofile%\documents\Controle de sangue\Backups\backup_%data%.sql"');

      AssignFile(lTextFile, Self.FCaminhoExe + 'doBackup.bat');

      Rewrite(lTextFile);

      Writeln(lTextFile, lStringListScript.Text);

      CloseFile(lTextFile);

      Result := True;

    finally
      lStringListScript.Destroy;
    end;

  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao criar script(.bat). Motivo: ' + E.Message);
    end;
  end;

end;

end.
