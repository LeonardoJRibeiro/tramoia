unit UAvisoVencimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  UClassPersistencia, UClassBolsaDao;

type
  TFrmAvisoSistema = class(TForm)
    PanelGrid: TPanel;
    DBGrid: TDBGrid;
    Panel1: TPanel;
    RadioGroupFiltrarPor: TRadioGroup;
    PanelBotoes: TPanel;
    DataSource: TDataSource;
    BtnSair: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RadioGroupFiltrarPorClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;
    FQuantDiasAvisoVencimento: Integer;

    FPersistencia: TPersistencia;

    function getConsulta(const pFILTRARPOR: SmallInt; const pQUANT_DIAS_AVISO_VENCIMENTO: Integer): Boolean;

  public

    class function getAvisoVencimento(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      const pQUANT_DIAS_AVISO_VENCIMENTO: Integer): Boolean;

  end;

var
  FrmAvisoSistema: TFrmAvisoSistema;

implementation

{$R *.dfm}

uses UClassMensagem, UDMConexao, UClassConfiguracaoDao;

procedure TFrmAvisoSistema.BtnNovoClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmAvisoSistema.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAvisoSistema.FormCreate(Sender: TObject);
begin
  Self.FPersistencia := TPersistencia.Create(DMConexao.Conexao);
end;

procedure TFrmAvisoSistema.FormDestroy(Sender: TObject);
begin
  Self.FPersistencia.Destroy;
end;

procedure TFrmAvisoSistema.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
  begin
    Close;
  end;

end;

procedure TFrmAvisoSistema.FormShow(Sender: TObject);
begin
  DBGrid.SetFocus;
end;

class function TFrmAvisoSistema.getAvisoVencimento(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
  const pQUANT_DIAS_AVISO_VENCIMENTO: Integer): Boolean;
begin

  Result := False;

  Application.CreateForm(TFrmAvisoSistema, FrmAvisoSistema);
  try

    try

      FrmAvisoSistema.FForeignFormKey := pFOREIGNFORMKEY;
      FrmAvisoSistema.FIdUsuario := pID_USUARIO;
      FrmAvisoSistema.FQuantDiasAvisoVencimento := pQUANT_DIAS_AVISO_VENCIMENTO;

      // Inicia a consulta filtrando por todos.
      if (FrmAvisoSistema.getConsulta(2, pQUANT_DIAS_AVISO_VENCIMENTO)) then
      begin
        Result := FrmAvisoSistema.ShowModal = mrOk;
      end;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmAvisoSistema.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmAvisoSistema);
  end;

end;

function TFrmAvisoSistema.getConsulta(const pFILTRARPOR: SmallInt; const pQUANT_DIAS_AVISO_VENCIMENTO: Integer)
  : Boolean;
var
  lBolsaDao: TBolsaDAO;
begin

  Result := False;

  lBolsaDao := TBolsaDAO.Create(DMConexao.Conexao);
  try

    try

      if (lBolsaDao.getConsulta(pFILTRARPOR, pQUANT_DIAS_AVISO_VENCIMENTO, Self.FPersistencia)) then
      begin

        DataSource.DataSet := Self.FPersistencia.Query;

        Result := not Self.FPersistencia.Query.IsEmpty;

      end;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['bolsas de sangue', E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    lBolsaDao.Destroy;
  end;

end;

procedure TFrmAvisoSistema.RadioGroupFiltrarPorClick(Sender: TObject);
begin
  Self.getConsulta(RadioGroupFiltrarPor.ItemIndex, Self.FQuantDiasAvisoVencimento);
end;

end.
