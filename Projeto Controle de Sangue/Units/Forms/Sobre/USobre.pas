unit USobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, acPNG, Vcl.ExtCtrls;

type
  TFrmSobre = class(TForm)
    PanelFoto: TPanel;
    ImageUEG: TImage;
    PanelClient: TPanel;
    LabelVersao: TLabel;
    LabelTramoia: TLabel;
    LabelAlexandre: TLabel;
    LabelDanilloFernandes: TLabel;
    LabelDaniloPinheiro: TLabel;
    LabelGeus: TLabel;
    LabelJoaoVinicius: TLabel;
    LabelLeonardo: TLabel;
    LabelMaxoel: TLabel;
    LabelMurilo: TLabel;
    LabelRicardo: TLabel;
    Label1: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImageUEGClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    function getVersaoExe: string;

  public
    class function getSobre(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
  end;

var
  FrmSobre: TFrmSobre;

implementation

uses ShellAPI, UClassMensagem;

{$R *.dfm}

procedure TFrmSobre.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin

    Close;

  end;

end;

procedure TFrmSobre.FormShow(Sender: TObject);
begin

  LabelVersao.Caption := 'Versão: ' + Self.getVersaoExe;

end;

class function TFrmSobre.getSobre(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
begin

  Application.CreateForm(TFrmSobre, FrmSobre);
  try

    try

      FrmSobre.FForeignFormKey := pFOREIGNFORMKEY;

      FrmSobre.FIdUsuario := pID_USUARIO;

      FrmSobre.ShowModal;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmSobre.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmSobre);
  end;

end;

function TFrmSobre.getVersaoExe: string;
type
  PFFI = ^vs_FixedFileInfo;
var
  lPffi: PFFI;
  lHandle: Dword;
  lLen: Longint;
  lData: PChar;
  lBuffer: Pointer;
  lTamanho: Dword;
  lPArquivo: PChar;
  lArquivo: String;
begin

  lArquivo := Application.ExeName;

  lPArquivo := StrAlloc(Length(lArquivo) + 1);

  StrPcopy(lPArquivo, lArquivo);

  lLen := GetFileVersionInfoSize(lPArquivo, lHandle);

  Result := '';

  if lLen > 0 then
  begin

    lData := StrAlloc(lLen + 1);

    if GetFileVersionInfo(lPArquivo, lHandle, lLen, lData) then
    begin
      VerQueryValue(lData, '', lBuffer, lTamanho);
      lPffi := PFFI(lBuffer);
      Result := Format('%d.%d.%d.%d', [HiWord(lPffi^.dwFileVersionMs), LoWord(lPffi^.dwFileVersionMs),
        HiWord(lPffi^.dwFileVersionLs), LoWord(lPffi^.dwFileVersionLs)]);
    end;

    StrDispose(lData);
  end;

  StrDispose(lPArquivo);
end;

procedure TFrmSobre.ImageUEGClick(Sender: TObject);
begin

  ShellExecute(Handle, 'open', 'http://www.itaberai.ueg.br/', '', '', SW_SHOWNORMAL);

end;

end.
