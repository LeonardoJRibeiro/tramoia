unit UClassProcedimento_Especial;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('procedimento_especial')]
  TProcedimento_Especial = class(TPersistent)
  private
    FId: Integer;
    FId_Saida: Integer;
    FId_Descarte: Integer;
    FIrradiacao: string[1];
    FFiltracao: string[1];
    FFracionamento: string[1];
    FFenotipagem: string[1];

    function getId: Integer;
    function getId_Saida: Integer;
    function getId_Descarte: Integer;
    function getIrradiacao: string;
    function getFiltracao: string;
    function getFracionamento: string;
    function getFenotipagem: string;

    procedure setId(const pID: Integer);
    procedure setId_Saida(const pID_SAIDA: Integer);
    procedure setId_Descarte(const pID_DESCARTE: Integer);
    procedure setIrradiacao(const pIRRADIACAO: string);
    procedure setFiltracao(const pFILTRACAO: string);
    procedure setFracionamento(const pFRACIONAMENTO: string);
    procedure setFenotipagem(const pFENOTIPAGEM: string);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('id_saida')]
    property Id_Saida: Integer read getId_Saida write setId_Saida;

    [TAtributo('id_descarte')]
    property Id_Descarte: Integer read getId_Descarte write setId_Descarte;

    [TAtributo('irradiacao')]
    property Irradiacao: string read getIrradiacao write setIrradiacao;

    [TAtributo('filtracao')]
    property Filtracao: string read getFiltracao write setFiltracao;

    [TAtributo('fracionamento')]
    property Fracionamento: string read getFracionamento write setFracionamento;

    [TAtributo('fenotipagem')]
    property Fenotipagem: string read getFenotipagem write setFenotipagem;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TProcedimento_Especial }

constructor TProcedimento_Especial.Create;
begin

end;

destructor TProcedimento_Especial.Destroy;
begin

  inherited;
end;

function TProcedimento_Especial.getId: Integer;
begin
  Result := Self.FId;
end;

function TProcedimento_Especial.getId_Saida: Integer;
begin
  Result := Self.FId_Saida;
end;

function TProcedimento_Especial.getId_Descarte: Integer;
begin
  Result := Self.FId_Descarte;
end;

function TProcedimento_Especial.getIrradiacao: string;
begin
  Result := Self.FIrradiacao;
end;

function TProcedimento_Especial.getFiltracao: string;
begin
  Result := Self.FFiltracao;
end;

function TProcedimento_Especial.getFracionamento: string;
begin
  Result := Self.FFracionamento;
end;

function TProcedimento_Especial.getFenotipagem: string;
begin
  Result := Self.FFenotipagem;
end;

procedure TProcedimento_Especial.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TProcedimento_Especial.setId_Saida(const pID_SAIDA: Integer);
begin
  Self.FId_Saida := pID_SAIDA;
end;

procedure TProcedimento_Especial.setId_Descarte(const pID_DESCARTE: Integer);
begin
  Self.FId_Descarte := pID_DESCARTE;
end;

procedure TProcedimento_Especial.setIrradiacao(const pIRRADIACAO: string);
begin
  Self.FIrradiacao := pIRRADIACAO;
end;

procedure TProcedimento_Especial.setFiltracao(const pFILTRACAO: string);
begin
  Self.FFiltracao := pFILTRACAO;
end;

procedure TProcedimento_Especial.setFracionamento(const pFRACIONAMENTO: string);
begin
  Self.FFracionamento := pFRACIONAMENTO;
end;

procedure TProcedimento_Especial.setFenotipagem(const pFENOTIPAGEM: string);
begin
  Self.FFenotipagem := pFENOTIPAGEM;
end;

end.
