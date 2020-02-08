unit USobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, acPNG, Vcl.ExtCtrls;

type
  TFrmSobre = class(TForm)
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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImageUEGClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

  public
    class function getSobre(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
  end;

var
  FrmSobre: TFrmSobre;

implementation

uses Winapi.ShellAPI, UClassBiblioteca, UClassMensagem;

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

  LabelVersao.Caption := 'Versão: ' + TBiblioteca.getVersaoExe;

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

procedure TFrmSobre.ImageUEGClick(Sender: TObject);
begin

  ShellExecute(Handle, 'open', 'http://www.itaberai.ueg.br/', '', '', SW_SHOWNORMAL);

end;

end.
