unit USelBolsa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  UClassPersistencia;

type
  TFrmSelBolsa = class(TForm)
    Panel1: TPanel;
    DBGrid: TDBGrid;
    PanelBottom: TPanel;
    BtnConfirmar: TBitBtn;
    BtnCancelar: TBitBtn;
    DataSource: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnCancelarClick(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    FPersistencia: TPersistencia;

    function getConsulta(const pNUMERO_DA_BOLSA: string): Boolean;
  public
    class function getSelBolsa(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
      const pNUMERO_DA_BOLSA: string; var pID_BOLSA: Integer): Boolean;
  end;

var
  FrmSelBolsa: TFrmSelBolsa;

implementation

{$R *.dfm}

uses UClassMensagem, UClassBolsaDao, UDMConexao;
{ TFrmSelBolsa }

procedure TFrmSelBolsa.BtnCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmSelBolsa.BtnConfirmarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmSelBolsa.DBGridDblClick(Sender: TObject);
begin
  BtnConfirmarClick(Self);
end;

procedure TFrmSelBolsa.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_RETURN) then
  begin
    BtnConfirmarClick(Self);
  end;

end;

procedure TFrmSelBolsa.FormCreate(Sender: TObject);
begin
  Self.FPersistencia := TPersistencia.Create(DataModuleConexao.Conexao);
end;

procedure TFrmSelBolsa.FormDestroy(Sender: TObject);
begin
  Self.FPersistencia.Destroy;
end;

procedure TFrmSelBolsa.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  case (Key) of
    VK_F6:
      begin
        BtnConfirmarClick(Self);
      end;

    VK_ESCAPE:
      begin
        BtnCancelarClick(Self);
      end;
  end;

end;

function TFrmSelBolsa.getConsulta(const pNUMERO_DA_BOLSA: string): Boolean;
var
  lBolsaDao: TBolsaDAO;
begin

  lBolsaDao := TBolsaDAO.Create(DataModuleConexao.Conexao);
  try

    Result := lBolsaDao.getConsulta(pNUMERO_DA_BOLSA, Self.FPersistencia);
    if (Result) then
    begin
      DataSource.DataSet := Self.FPersistencia.Query;
    end;

  finally
    lBolsaDao.Destroy;
  end;

end;

class function TFrmSelBolsa.getSelBolsa(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer;
  const pNUMERO_DA_BOLSA: string; var pID_BOLSA: Integer): Boolean;
begin

  Application.CreateForm(TFrmSelBolsa, FrmSelBolsa);
  try

    try

      FrmSelBolsa.FForeignFormKey := pFOREIGNFORMKEY;
      FrmSelBolsa.FIdUsuario := pID_USUARIO;

      Result := False;
      if (FrmSelBolsa.getConsulta(pNUMERO_DA_BOLSA)) then
      begin

        if (FrmSelBolsa.FPersistencia.Query.RecordCount > 1) then
        begin
          Result := FrmSelBolsa.ShowModal = mrOk;
        end
        else
        begin
          Result := True;
        end;

        if (Result) then
        begin
          pID_BOLSA := FrmSelBolsa.FPersistencia.Query.FieldByName('id').AsInteger;
        end;

      end;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmSelBolsa.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmSelBolsa);
  end;

end;

end.
