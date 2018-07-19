unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, UClassActiveControl, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ExtCtrls,
  Vcl.Menus, acPNG;

type
  TFrmPrincipal = class(TForm)
    BtnEntrada: TSpeedButton;
    BtnSaida: TSpeedButton;
    BtnPacientes: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    BtnSair: TSpeedButton;
    Panel3: TPanel;
    MainMenu: TMainMenu;
    Paciente1: TMenuItem;
    Cadastrar1: TMenuItem;
    Histrico1: TMenuItem;
    Relatrios1: TMenuItem;
    Entradas1: TMenuItem;
    Sadas1: TMenuItem;
    Usurios1: TMenuItem;
    Cadastrar2: TMenuItem;
    Consultar1: TMenuItem;
    BtnRelatorios: TSpeedButton;
    Panel4: TPanel;
    TimerLogin: TTimer;
    Logof: TMenuItem;
    ImageUEG: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPacientesClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure TimerLoginTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LogofClick(Sender: TObject);
    procedure BtnSaidaClick(Sender: TObject);
    procedure BtnEntradaClick(Sender: TObject);
    procedure BtnRelatoriosClick(Sender: TObject);
    procedure Cadastrar2Click(Sender: TObject);
  private
    FActiveControl: TActiveControl;
    FIdUsuario: Integer;
  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses UEntrada, USaida, UConsPaciente, UClassForeignKeyForms, ULogin, USelRelatorio, UCadUsuario;

procedure TFrmPrincipal.BtnEntradaClick(Sender: TObject);
begin

  TFrmEntrada.getEntrada(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);

end;

procedure TFrmPrincipal.BtnPacientesClick(Sender: TObject);
var
  lRegistro: Integer;
begin

  TFrmConsPaciente.getConsPaciente(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario, lRegistro);

end;

procedure TFrmPrincipal.BtnRelatoriosClick(Sender: TObject);
begin

  TFrmSelRelatorio.getSelRelatorio(TForeignKeyForms.FIdUSelRelatorio, Self.FIdUsuario);

end;

procedure TFrmPrincipal.BtnSaidaClick(Sender: TObject);
begin

  TFrmSaida.getSaida(TForeignKeyForms.FIdUPrincipal, 1);

end;

procedure TFrmPrincipal.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrincipal.Cadastrar2Click(Sender: TObject);
begin
  TFrmCadUsuario.getCadUsuario(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin

  Self.FActiveControl := TActiveControl.Create;

  Application.OnMessage := Self.FActiveControl.OnMessage;

end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin

  Self.FActiveControl.Destroy;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  TimerLogin.Enabled := True;
end;

procedure TFrmPrincipal.LogofClick(Sender: TObject);
begin
  TimerLogin.Enabled := True;
end;

procedure TFrmPrincipal.TimerLoginTimer(Sender: TObject);
begin

  TimerLogin.Enabled := False;

  if (not TFrmLogin.getLogin(TForeignKeyForms.FIdUPrincipal, Self.FIdUsuario)) then
  begin
    Close;
  end;

end;

end.
