{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit UAutenticacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, acPNG, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFrmAutenticacao = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    EdtUsuario: TLabeledEdit;
    EdtSenha: TLabeledEdit;
    BtnAutenticar: TButton;
    BtnCancelar: TButton;
    procedure EdtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnAutenticarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FIdUsuario: Integer;
    FNumTentativas: Byte;
  public
    class function getAutenticacao(pIdUsuario: SmallInt): Boolean;
  end;

var
  FrmAutenticacao: TFrmAutenticacao;

implementation


{$R *.dfm}

uses UClassUsuarioDao, UDMConexao, UClassMensagem, UClassBibliotecaDao;

procedure TFrmAutenticacao.BtnAutenticarClick(Sender: TObject);
var
  lUsuarioDAO: TUsuarioDAO;
  lId: Integer;
begin

  lUsuarioDAO := TUsuarioDAO.Create(DataModuleConexao.Conexao);
  try

    try

      if (lUsuarioDAO.getLogin(Trim(EdtUsuario.Text), Trim(EdtSenha.Text), lId)) then
      begin

        Self.FIdUsuario := lId;
        ModalResult := mrOk;
        
      end
      else
      begin
        
        Self.FNumTentativas := Self.FNumTentativas + 1;

        Application.MessageBox(PChar(TMensagem.getMensagem(13)), PChar('Aviso'), MB_OK + MB_ICONINFORMATION);

        if (Self.FNumTentativas = 3) then
        begin
          Application.Terminate;
        end;

        EdtSenha.SetFocus;

      end;
      
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar(TMensagem.getMensagem(27)), PChar('Erro'), MB_OK + MB_ICONERROR);
      end;
    end;                      

  finally
    lUsuarioDAO.Destroy;
  end;

end;

procedure TFrmAutenticacao.EdtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_RETURN) then
  begin
    BtnAutenticarClick(Sender);
  end;

end;

procedure TFrmAutenticacao.FormShow(Sender: TObject);
begin
  EdtUsuario.Text := TClassBibliotecaDAO.getNomeUsuario(Self.FIdUsuario, DataModuleConexao.Conexao);
end;

class function TFrmAutenticacao.getAutenticacao(pIdUsuario: SmallInt): Boolean;
begin
  Result := False;

  Application.CreateForm(TFrmAutenticacao, FrmAutenticacao);
  try

    try
    
      FrmAutenticacao.FIdUsuario := pIdUsuario;
      Result := FrmAutenticacao.ShowModal = mrOk;
      
    except
      on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar(Format(TMensagem.getMensagem(0), ['de autenticação', E.Message])), PChar('Erro'));
      end;

    end;
    
  finally
    FrmAutenticacao.Free;
  end;
  
end;

end.
