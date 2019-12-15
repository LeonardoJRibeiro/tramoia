unit UClassConfiguracao;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('configuracao')]
  TConfiguracao = class(TPersistent)
  private
    FId: Integer;
    FQuant_Dias_Aviso_Vencimento: Integer;

    function getId: Integer;
    function getQuant_Dias_Aviso_Vencimento: Integer;

    procedure setId(const pID: Integer);
    procedure setQuant_Dias_Aviso_Vencimento(const pQUANT_DIAS_AVISO_VENCIMENTO: Integer);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('quant_dias_aviso_vencimento')]
    property Quant_Dias_Aviso_Vencimento: Integer read getQuant_Dias_Aviso_Vencimento
      write setQuant_Dias_Aviso_Vencimento;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TConfiguracoes }

constructor TConfiguracao.Create;
begin

end;

destructor TConfiguracao.Destroy;
begin

  inherited;
end;

function TConfiguracao.getId: Integer;
begin
  Result := Self.FId;
end;

function TConfiguracao.getQuant_Dias_Aviso_Vencimento: Integer;
begin
  Result := Self.FQuant_Dias_Aviso_Vencimento;
end;

procedure TConfiguracao.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TConfiguracao.setQuant_Dias_Aviso_Vencimento(const pQUANT_DIAS_AVISO_VENCIMENTO: Integer);
begin
  Self.FQuant_Dias_Aviso_Vencimento := pQUANT_DIAS_AVISO_VENCIMENTO;
end;

end.
