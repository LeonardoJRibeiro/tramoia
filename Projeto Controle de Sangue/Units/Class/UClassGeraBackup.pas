unit UClassGeraBackup;

interface

uses System.Classes, System.SysUtils;

type
  TGeraBackup = class(TPersistent)
  private

    FCaminhoExe: string;

    function PreparaScript(const pUPLOADDRIVE: Boolean): Boolean;

  public

    function CriaBackup(const pUPLOADDRIVE: Boolean): Boolean;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses Vcl.Forms, ShellAPI, WinAPI.Windows, UClassBiblioteca;

{ TGeraBackup }

constructor TGeraBackup.Create;
begin

  Self.FCaminhoExe := ExtractFilePath(Application.ExeName);

end;

destructor TGeraBackup.Destroy;
begin

  inherited;
end;

function TGeraBackup.CriaBackup(const pUPLOADDRIVE: Boolean): Boolean;
begin

  try

    if (FileExists(Self.FCaminhoExe + 'mysqldump.exe')) then
    begin

      if (Self.PreparaScript(pUPLOADDRIVE)) then
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

function TGeraBackup.PreparaScript(const pUPLOADDRIVE: Boolean): Boolean;
var
  lTextFile: TextFile;
  lUserName: string;
  lPassWord: string;
  lHostName: string;

  lStringListScript: TStringList;

begin

  try

    if (not DirectoryExists(Self.FCaminhoExe + '\Backup')) then
    begin

      CreateDir(Self.FCaminhoExe + '\Backup');

    end;

    lStringListScript := TStringList.Create;
    try

      lStringListScript.Add('@ECHO OFF');

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
        lUserName + ' --password="' + lPassWord + '" -h ' + lHostName + ' > ' + '"%~dp0Backup\backup_%data%.sql"');

      lStringListScript.Add('forfiles.exe -p"%~dp0Backup" -m*.sql -c"cmd /c del /f /q @FILE" -d-180');

      if (pUPLOADDRIVE) then
      begin

        lStringListScript.Add('gdrive-windows-386.exe upload "%~dp0Backup\backup_%data%.sql"');

      end;

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
