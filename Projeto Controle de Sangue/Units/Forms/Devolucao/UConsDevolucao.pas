unit UConsDevolucao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmConsDevolucao = class(TFrmCons)
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
    procedure EdtConsKeyPress(Sender: TObject; var Key: Char);
    procedure EdtConsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FForeignFormKey: SmallInt;
    FIdUsuario: Integer;

    function getUsuarioPossuiPermissao: Boolean;

  public
    class function getConsDevolucao(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;

  end;

var
  FrmConsDevolucao: TFrmConsDevolucao;

implementation

{$R *.dfm}

uses System.Math, UDMConexao, UClassMensagem, UClassBiblioteca, UClassForeignKeyForms,
  UClassUsuarioDao, UClassBolsaDao, UDevolucao, UAutenticacao, UClassDevolucaoDao;

procedure TFrmConsDevolucao.BtnAlterarClick(Sender: TObject);
var
  lPosicaoQuery: Integer;
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

    TFrmDevolucao.getDevolucao(TForeignKeyForms.FIdUConsDevolucao, Self.FIdUsuario,
      Self.FPersistencia.Query.FieldByName('id').AsInteger);

    lPosicaoQuery := Self.FPersistencia.Query.RecNo;

    EdtConsInvokeSearch(Self);

    Self.FPersistencia.Query.RecNo := lPosicaoQuery;

  end;

end;

procedure TFrmConsDevolucao.BtnExcluirClick(Sender: TObject);
var
  lDevolucaoDao: TDevolucaoDAO;
  lPosicaoQuery: Integer;
begin
  inherited;

  if (not Self.FPersistencia.Query.IsEmpty) then
  begin

    if (Self.getUsuarioPossuiPermissao) then
    begin

      if (Application.MessageBox(PChar(Format(TMensagem.getMensagem(9), ['a devolução'])), PChar('Cuidado'),
        MB_YESNO + MB_ICONQUESTION) = IDYES) then
      begin

        if (TFrmAutenticacao.getAutenticacao(Self.FIdUsuario)) then
        begin

          lDevolucaoDao := TDevolucaoDAO.Create(DMConexao.Conexao);
          try

            try

              if (lDevolucaoDao.Excluir(Self.FPersistencia.Query.FieldByName('id').AsInteger)) then
              begin

                lPosicaoQuery := Self.FPersistencia.Query.RecNo;

                EdtConsInvokeSearch(Self);

                Self.FPersistencia.Query.RecNo := lPosicaoQuery - 1;

              end;

            except
              on E: Exception do
              begin
                Application.MessageBox(PChar(Format(TMensagem.getMensagem(2), ['devolução', E.Message])), '1',
                  MB_OK + MB_ICONSTOP);
              end;
            end;

          finally
            lDevolucaoDao.Destroy;
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

procedure TFrmConsDevolucao.BtnLocalizarClick(Sender: TObject);
begin
  inherited;
  EdtConsInvokeSearch(Self);
end;

procedure TFrmConsDevolucao.BtnNovoClick(Sender: TObject);
begin
  inherited;

  TFrmDevolucao.getDevolucao(TForeignKeyForms.FIdUConsDevolucao, Self.FIdUsuario);
  EdtConsInvokeSearch(Self);

end;

procedure TFrmConsDevolucao.ComboBoxTipoConsChange(Sender: TObject);
begin

  EdtCons.Clear;

  BtnLocalizar.Visible := ComboBoxTipoCons.ItemIndex = 2;

  EdtCons.Visible := ComboBoxTipoCons.ItemIndex <> 2;

  EdtDataIni.Visible := ComboBoxTipoCons.ItemIndex = 2;
  EdtDataFinal.Visible := ComboBoxTipoCons.ItemIndex = 2;

  case (ComboBoxTipoCons.ItemIndex) of

    0: // Código
      begin

        EdtCons.MaxLength := 11;

        EdtCons.SetFocus;

        EdtCons.NumbersOnly := True;

      end;

    1: // Número da bolsa.
      begin

        EdtCons.MaxLength := 20;

        EdtCons.NumbersOnly := False;

        EdtCons.SetFocus;

      end;

    2: // Período
      begin

        EdtDataIni.Date := TBiblioteca.getPrimeiroDiaMes(Now);
        EdtDataFinal.Date := TBiblioteca.getUltimoDiaMes(Now);

        EdtDataIni.SetFocus;

      end;

  end;

end;

procedure TFrmConsDevolucao.DBGridDblClick(Sender: TObject);
begin
  inherited;
  BtnAlterarClick(Self);
end;

procedure TFrmConsDevolucao.DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmConsDevolucao.EdtConsInvokeSearch(Sender: TObject);
var
  lDevolucaoDao: TDevolucaoDAO;
  lChave: string;
begin
  inherited;

  lDevolucaoDao := TDevolucaoDAO.Create(DMConexao.Conexao);
  try

    try

      if (lDevolucaoDao.getConsulta(EdtCons.Text, EdtDataIni.Date, EdtDataFinal.Date, ComboBoxTipoCons.ItemIndex,
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
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(1), ['devoluções', E.Message])), PChar('Erro'),
          MB_OK + MB_ICONERROR);
      end;
    end;

  finally
    lDevolucaoDao.Destroy;
  end;

end;

procedure TFrmConsDevolucao.EdtConsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  if (Key = VK_RETURN) then
  begin
    EdtConsInvokeSearch(Self);
  end;

end;

procedure TFrmConsDevolucao.EdtConsKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if (ComboBoxTipoCons.ItemIndex = 1) then
  begin

    if (Key in ['-']) then
    begin

      if (Pos('-', Trim(EdtCons.Text)) > 0) then
      begin
        Key := #0;
      end;

    end
    else if (not(Key in ['0' .. '9', #8])) then
    begin
      Key := #0;
    end;

  end;

end;

procedure TFrmConsDevolucao.EdtDataFinalExit(Sender: TObject);
begin
  inherited;

  if (GetKeyState(VK_RETURN) < 0) then
  begin
    BtnLocalizarClick(Self);
  end;

end;

procedure TFrmConsDevolucao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  TBiblioteca.GravaArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox', 'FrmConsDevolucao.ComboBoxTipoCons',
    ComboBoxTipoCons.ItemIndex.ToString);
end;

procedure TFrmConsDevolucao.FormShow(Sender: TObject);
begin
  inherited;

  ComboBoxTipoCons.ItemIndex := TBiblioteca.LeArquivoIni('cnfConfiguracoes.ini', 'IndexCombobox',
    'FrmConsDevolucao.ComboBoxTipoCons', '0').ToInteger;

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

function TFrmConsDevolucao.getUsuarioPossuiPermissao: Boolean;
begin

  try

    Result := TBiblioteca.getUsuarioPossuiPermissao(Self.FIdUsuario, DMConexao.Conexao);

  except
    on E: Exception do
    begin
      Result := True;
      Application.MessageBox(PChar(Format(TMensagem.getMensagem(12), ['informação do usuário', E.Message])),
        PChar('Erro'), MB_OK + MB_ICONERROR);
    end;
  end;

end;

class function TFrmConsDevolucao.getConsDevolucao(const pFOREIGNFORMKEY: SmallInt; const pID_USUARIO: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsDevolucao, FrmConsDevolucao);
  try

    try

      FrmConsDevolucao.FForeignFormKey := pFOREIGNFORMKEY;
      FrmConsDevolucao.FIdUsuario := pID_USUARIO;

      Result := FrmConsDevolucao.ShowModal = mrOk;

    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), [FrmConsDevolucao.Caption, E.Message])), 'Erro',
          MB_ICONERROR + MB_OK);
      end;
    end;

  finally
    FreeAndNil(FrmConsDevolucao);
  end;

end;

end.
