unit USelCons;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, UConsDescarte;

type
  TFrmSelCons = class(TForm)
    PanelBotoes: TPanel;
    BtnSair: TBitBtn;
    PanelRelatorios: TPanel;
    BtnConsEstoque: TBitBtn;
    BtnConsSaidas: TBitBtn;
    BtnConsPacientes: TBitBtn;
    BtnConsEntradas: TBitBtn;
    BtnDescartes: TBitBtn;
    BtnDevolucoes: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnConsEstoqueClick(Sender: TObject);
    procedure BtnConsEntradasClick(Sender: TObject);
    procedure BtnConsPacientesClick(Sender: TObject);
    procedure BtnConsSaidasClick(Sender: TObject);
    procedure BtnDescartesClick(Sender: TObject);
    procedure BtnDevolucoesClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FCodUsu: Integer;
  public
    class function getSelCons(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
  end;

var
  FrmSelCons: TFrmSelCons;

implementation

uses UClassMensagem, UClassForeignKeyForms, UConsEstoque, UConsEntrada,
  UConsSaidas, UConsPaciente, UConsDevolucao;

{$R *.dfm}

procedure TFrmSelCons.BtnConsPacientesClick(Sender: TObject);
var
  lRegistro: string;
begin

  TFrmConsPaciente.getConsPaciente(Self.FForeignFormKey, Self.FCodUsu, lRegistro);

end;

procedure TFrmSelCons.BtnConsSaidasClick(Sender: TObject);
begin

  TFrmConsSaidas.getConsSaida(Self.FForeignFormKey, Self.FCodUsu);

end;

procedure TFrmSelCons.BtnDescartesClick(Sender: TObject);
begin
  TFrmConsDescarte.getConsDescarte(Self.FForeignFormKey, Self.FCodUsu);
end;

procedure TFrmSelCons.BtnDevolucoesClick(Sender: TObject);
begin
  TFrmConsDevolucao.getConsDevolucao(Self.FForeignFormKey, Self.FCodUsu);
end;

procedure TFrmSelCons.BtnConsEntradasClick(Sender: TObject);
begin

  TFrmConsEntrada.getConsEntrada(Self.FForeignFormKey, Self.FCodUsu);

end;

procedure TFrmSelCons.BtnConsEstoqueClick(Sender: TObject);
begin

  TFrmConsEstoque.getConsEstoque(Self.FForeignFormKey, Self.FCodUsu);

end;

procedure TFrmSelCons.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmSelCons.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin

    BtnSairClick(Sender);

  end;

end;

class function TFrmSelCons.getSelCons(const pFOREIGNFORMKEY: SmallInt; const pCOD_USU: Integer): Boolean;
begin

  try

    try

      Application.CreateForm(TFrmSelCons, FrmSelCons);

      FrmSelCons.FForeignFormKey := pFOREIGNFORMKEY;
      FrmSelCons.FCodUsu := pCOD_USU;

      FrmSelCons.ShowModal;

      Result := True;

    except
      on E: Exception do
      begin

        Result := False;
        raise Exception.Create(Format(TMensagem.getMensagem(0), ['de selecionar a consulta', E.Message]));

      end;
    end;

  finally
    FrmSelCons.Destroy;
  end;

end;

end.
