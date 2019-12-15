unit USelRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmSelRelatorio = class(TForm)
    PanelRelatorios: TPanel;
    PanelBotoes: TPanel;
    BtnSair: TBitBtn;
    BtnRelEntradaSangue: TBitBtn;
    BtnRelSaidaSangue: TBitBtn;
    BtnRelEstoque: TBitBtn;
    BtnDescartes: TBitBtn;
    BtnRelDevolucoes: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnRelSaidaSangueClick(Sender: TObject);
    procedure BtnRelEntradaSangueClick(Sender: TObject);
    procedure BtnRelEstoqueClick(Sender: TObject);
    procedure BtnDescartesClick(Sender: TObject);
    procedure BtnRelDevolucoesClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
  public
    class function getSelRelatorio(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmSelRelatorio: TFrmSelRelatorio;

implementation

uses UClassMensagem, UClassForeignKeyForms, URelEntrada, URelSaida, URelEstoque, URelDescarte, URelDevolucao;

{$R *.dfm}
{ TFrmSelRelatorio }

procedure TFrmSelRelatorio.BtnDescartesClick(Sender: TObject);
begin
  TFrmRelDescarte.getRelDescarte(TForeignKeyForms.FIdUSelRelatorio, Self.FCodUsu);
end;

procedure TFrmSelRelatorio.BtnRelDevolucoesClick(Sender: TObject);
begin
  TFrmRelDevolucao.getRelDevolucao(TForeignKeyForms.FIdUSelRelatorio, Self.FCodUsu);
end;

procedure TFrmSelRelatorio.BtnRelEntradaSangueClick(Sender: TObject);
begin

  TFrmRelEntrada.getRelEntrada(TForeignKeyForms.FIdUSelRelatorio, Self.FCodUsu);

end;

procedure TFrmSelRelatorio.BtnRelEstoqueClick(Sender: TObject);
begin
  TFrmRelEstoque.getRelEstoque(TForeignKeyForms.FIdUSelRelatorio, Self.FCodUsu);
end;

procedure TFrmSelRelatorio.BtnRelSaidaSangueClick(Sender: TObject);
begin

  TFrmRelSaida.getRelSaida(TForeignKeyForms.FIdUSelRelatorio, Self.FCodUsu);

end;

procedure TFrmSelRelatorio.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmSelRelatorio.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin

    BtnSairClick(Sender);

  end;

end;

class function TFrmSelRelatorio.getSelRelatorio(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  Application.CreateForm(TFrmSelRelatorio, FrmSelRelatorio);
  try

    try

      FrmSelRelatorio.FForeignFormKey := pFOREIGNFORMKEY;
      FrmSelRelatorio.FCodUsu := pCOD_USU;

      FrmSelRelatorio.ShowModal;

      Result := True;

    except
      on E: Exception do
      begin

        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de selecionar o relatório', E.Message]));
      end;
    end;

  finally
    FrmSelRelatorio.Destroy;
  end;

end;

end.
