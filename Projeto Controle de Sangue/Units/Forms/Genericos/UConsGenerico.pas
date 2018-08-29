unit UConsGenerico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  UClassPersistencia, Datasnap.DBClient, Vcl.WinXCtrls;

type
  TFrmCons = class(TForm)
    PanelGrid: TPanel;
    DBGrid: TDBGrid;
    PanelBotoes: TPanel;
    PanelConsulta: TPanel;
    GroupBoxConsulta: TGroupBox;
    GroupBoxTipoCons: TGroupBox;
    ComboBoxTipoCons: TComboBox;
    EdtCons: TSearchBox;
    BtnNovo: TSpeedButton;
    BtnAlterar: TSpeedButton;
    BtnExcluir: TSpeedButton;
    BtnSair: TSpeedButton;
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBoxTipoConsChange(Sender: TObject);
  protected
    FPersistencia: TPersistencia;

  private

  end;

var
  FrmCons: TFrmCons;

implementation

uses UDMConexao;

{$R *.dfm}

procedure TFrmCons.BtnSairClick(Sender: TObject);
begin

  Close;

end;

procedure TFrmCons.ComboBoxTipoConsChange(Sender: TObject);
begin
  EdtCons.Clear;

  case (ComboBoxTipoCons.ItemIndex) of
    0: // Palavra Chave
      begin
        EdtCons.NumbersOnly := False;
        EdtCons.MaxLength := 20;
      end;

    1: // Nome
      begin
        EdtCons.NumbersOnly := False;
        EdtCons.MaxLength := 20;
      end;

    2: // Código
      begin
        EdtCons.NumbersOnly := True;
        EdtCons.MaxLength := 11;
      end;
  end;

end;

procedure TFrmCons.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_F2) then
  begin

    if (EdtCons.CanFocus) then
    begin
      EdtCons.SetFocus;
    end;

  end;

end;

procedure TFrmCons.FormCreate(Sender: TObject);
begin

  Self.FPersistencia := TPersistencia.Create(DataModuleConexao.Conexao);

end;

procedure TFrmCons.FormDestroy(Sender: TObject);
begin

  Self.FPersistencia.Destroy;

end;

procedure TFrmCons.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  case (Key) of

    VK_ESCAPE:
      begin

        if (BtnSair.Visible) and (BtnSair.Enabled) then
        begin

          BtnSairClick(Sender);

        end;

      end;

  end;

end;

end.
