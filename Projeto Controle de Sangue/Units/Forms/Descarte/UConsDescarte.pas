unit UConsDescarte;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmConsDescarte = class(TFrmCons)
    DataSource: TDataSource;
    EdtDataFinal: TDateTimePicker;
    EdtDataIni: TDateTimePicker;
    LabelAte: TLabel;
    LabelDe: TLabel;
    BtnLocalizar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure EdtConsInvokeSearch(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnAlterarClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxTipoConsChange(Sender: TObject);
    procedure BtnLocalizarClick(Sender: TObject);
    procedure EdtDataFinalExit(Sender: TObject);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    function getAdmin: Boolean;

  public
    class function getConsDescarte(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
  end;

var
  FrmConsDescarte: TFrmConsDescarte;

implementation

{$R *.dfm}

uses System.Math, UDMConexao, UClassMensagem, UClassBiblioteca, UClassForeignKeyForms,
  UClassUsuarioDao, UClassBolsaDao, UClassDescarte, UClassDescarteDao, UDescarte, UAutenticacao;

procedure TFrmConsDescarte.BtnAlterarClick(Sender: TObject);
var
  lPosicaoQuery: Integer;
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

    TFrmDescarte.getDescarte(TForeignKeyForms.FIdUConsDescarte, Self.FIdUsuario,
      Self.FPersistencia.Query.FieldByName('id').AsInteger);

    lPosicaoQuery := Self.FPersistencia.Query.RecNo;

    EdtConsInvokeSearch(Self);

    Self.FPersistencia.Query.RecNo := lPosicaoQuery;

  end;

end;

procedure TFrmConsDescarte.BtnExcluirClick(Sender: TObject);
var
  lDescarteDao: TDescarteDAO;
  lPosicaoQuery: Integer;
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

    if (Self.getAdmin) then
    begin

      if (Application.MessageBox(PChar(Format(TMensagem.getMensagem(9), ['descarte'])), PChar('Cuidado'),
        MB_YESNO + MB_ICONQUESTION) = IDYES) then
      begin

        if (TFrmAutenticacao.getAutenticacao(Self.FIdUsuario)) then
        begin

          lDescarteDao := TDescarteDAO.Create(DMConexao.Conexao);
          try

            try

              if (lDescarteDao.Excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
              begin
                lPosicaoQuery := Self.FPersistencia.Query.RecNo;

                EdtConsInvokeSearch(Self);

                Self.FPersistencia.Query.RecNo := lPosicaoQuery - 1;
              end;

            except
              on E: Exception do
              begin
                Application.MessageBox(PChar(Format(TMensagem.getMensagem(2), ['paciente', E.Message])), '1',
                  MB_OK + MB_ICONSTOP);
              end;
            end;

          finally
            lDescarteDao.Destroy;
          end;

        end;

      end;

    end
    else
    begin
      Application.MessageBox(PChar(TMensagem.getMensagem(12)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);
    end;

  end;

end;

procedure TFrmConsDescarte.BtnLocalizarClick(Sender: TObject);
begin
  inherited;
  EdtConsInvokeSearch(Self);
end;

procedure TFrmConsDescarte.BtnNovoClick(Sender: TObject);
begin
  inherited;

  TFrmDescarte.getDescarte(TForeignKeyForms.FIdUConsDescarte, Self.FIdUsuario);
  EdtConsInvokeSearch(Self);

end;

procedure TFrmConsDescarte.ComboBoxTipoConsChange(Sender: TObject);
begin

  EdtCons.Clear;

  BtnLocalizar.Visible := ComboBoxTipoCons.ItemIndex = 2;

  EdtCons.Visible := ComboBoxTipoCons.ItemIndex <> 2;

  EdtDataIni.Visible := ComboBoxTipoCons.ItemIndex = 2;
  EdtDataFinal.Visible := ComboBoxTipoCons.ItemIndex = 2;

  case (ComboBoxTipoCons.ItemIndex) of

    0, 1: // 0 = C�digo e 1 = N�mero da bolsa.
      begin

        EdtCons.MaxLength := IfThen(ComboBoxTipoCons.ItemIndex = 0, 11, 20);

        EdtCons.SetFocus;

      end;

    2: // Per�odo
      begin

        EdtDataIni.Date := TBiblioteca.getPrimeiroDiaMes(Now);
        EdtDataFinal.Date := TBiblioteca.getUltimoDiaMes(Now);

        EdtDataIni.SetFocus;

      end;

  end;

end;

procedure TFrmConsDescarte.DBGridDblClick(Sender: TObject);
begin
  inherited;
  BtnAlterarClick(Self);
end;

procedure TFrmConsDescarte.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  case (Key) of
    VK_RETURN:
      begin
        BtnAlterarClick(Self);
      end;

    VK_DELETE:
      begin
        BtnExcluirClick(Self);
      end;

    VK_F2:
      begin

        if (EdtDataIni.CanFocus) then
        begin
          EdtDataIni.SetFocus;
        end;

      end;

  end;

end;

procedure TFrmConsDescarte.EdtConsInvokeSearch(Sender: TObject);
var
  lDescarteDao: TDescarteDAO;
begin
  inherited;

  lDescarteDao := TDescarteDAO.Create(DMConexao.Conexao);
  try

    try

      if (lDescarteDao.getConsulta(EdtCons.Text, EdtDataIni.Date, EdtDataFinal.Date, ComboBoxTipoCons.ItemIndex,
        Self.FPersistencia)) then
      begin

        DataSource.DataSet := Self.FPersistencia.Query;

        if (not Self.FPersistencia.Query.IsEmpty) then
        begin

          DBGrid.SetFocus;

          Self.FPersistencia.Query.Last;

        end
        else
        begin

          if (EdtCons.CanFocus) then
          begin

            EdtCons.SetFocus;
            BtnLocalizar.Visible := False;

          end
          else
          begin

            EdtDataIni.SetFocus;
            BtnLocalizar.Visible := True;

          end;

        end

      end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['descarte(s)', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lDescarteDao.Destroy;
  end;

end;

procedure TFrmConsDescarte.EdtDataFinalExit(Sender: TObject);
begin
  inherited;

  if (GetKeyState(VK_RETURN) < 0) then
  begin
    BtnLocalizarClick(Self);
  end;

end;

procedure TFrmConsDescarte.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox', 'FrmConsDescarte.ComboBoxTipoCons',
    ComboBoxTipoCons.ItemIndex.ToString);
end;

procedure TFrmConsDescarte.FormShow(Sender: TObject);
begin
  inherited;

  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsDescarte.ComboBoxTipoCons', '0').ToInteger;

  ComboBoxTipoConsChange(Self);

  EdtConsInvokeSearch(Self);

  if (EdtCons.CanFocus) then
  begin
    EdtCons.SetFocus;
  end
  else
  begin
    EdtDataIni.SetFocus;
  end;

end;

function TFrmConsDescarte.getAdmin: Boolean;
var
  lUsuaioDao: TUsuarioDAO;
begin

  lUsuaioDao := TUsuarioDAO.Create(DMConexao.Conexao);
  try

    try

      Result := lUsuaioDao.getAdmin(Self.FIdUsuario);

    except
      on E: Exception do
      begin
        Result := True;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(12), ['informa��o do usu�rio', E.Message])),
          PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lUsuaioDao.Destroy;
  end;

end;

class function TFrmConsDescarte.getConsDescarte(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsDescarte, FrmConsDescarte);
  try

    try

      FrmConsDescarte.FForeignFormKey := pFOREIGNFORMKEY;
      FrmConsDescarte.FIdUsuario := pID_USUARIO;

      Result := FrmConsDescarte.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmConsDescarte.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmConsDescarte);
  end;

end;

end.
