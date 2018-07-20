unit UClassBolsa;

interface

uses System.Classes, System.SysUtils;

type
  TBolsa = class(TPersistent)
  private
    FId: Integer;
    FNumero_Bolsa: string[20];
    FTipo: string[3];
    FAbo: string[2];
    FRh: string[1];
    FOrigem: string[15];
    FVolume: Integer;
    FSorologia: string[1];
    FPossui_Estoque: string[1];

    function getId: Integer;
    function getNumero_Bolsa: string;
    function getTipo: string;
    function getAbo: string;
    function getRh: string;
    function getOrigem: string;
    function getVolume: Integer;
    function getSorologia: string;
    function getPossui_Estoque: string;

    procedure setId(const pID: Integer);
    procedure setNumero_Bolsa(const pNUMERO_BOLSA: string);
    procedure setTipo(const pTIPO: string);
    procedure setAbo(const pABO: string);
    procedure setRh(const pRH: string);
    procedure setOrigem(const pORIGEM: string);
    procedure setVolume(const pVOLUME: Integer);
    procedure setSorologia(const pSOROLOGIA: string);
    procedure setPossui_Estoque(const pPOSSUI_ESTOQUE: string);

  public
    property Id: Integer read getId write setId;
    property Numero_Bolsa: string read getNumero_Bolsa write setNumero_Bolsa;
    property Tipo: string read getTipo write setTipo;
    property Abo: string read getAbo write setAbo;
    property Rh: string read getRh write setRh;
    property Origem: string read getOrigem write setOrigem;
    property Volume: Integer read getVolume write setVolume;
    property Sorologia: string read getSorologia write setSorologia;
    property Possui_Estoque: string read getPossui_Estoque write setPossui_Estoque;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TBolsa}

constructor TBolsa.Create;
begin

end;

destructor TBolsa.Destroy;
begin

  inherited;
end;
function TBolsa.getId: Integer;
begin
  Result := Self.FId;
end;

function TBolsa.getNumero_Bolsa: string;
begin
  Result := Self.FNumero_Bolsa;
end;

function TBolsa.getTipo: string;
begin
  Result := Self.FTipo;
end;

function TBolsa.getAbo: string;
begin
  Result := Self.FAbo;
end;

function TBolsa.getRh: string;
begin
  Result := Self.FRh;
end;

function TBolsa.getOrigem: string;
begin
  Result := Self.FOrigem;
end;

function TBolsa.getVolume: Integer;
begin
  Result := Self.FVolume;
end;

function TBolsa.getSorologia: string;
begin
  Result := Self.FSorologia;
end;

function TBolsa.getPossui_Estoque: string;
begin
  Result := Self.FPossui_Estoque;
end;

procedure TBolsa.setId(const pID: Integer);
begin
  Self.FId:= pId;
end;

procedure TBolsa.setNumero_Bolsa(const pNUMERO_BOLSA: string);
begin
  Self.FNumero_Bolsa:= pNumero_Bolsa;
end;

procedure TBolsa.setTipo(const pTIPO: string);
begin
  Self.FTipo:= pTipo;
end;

procedure TBolsa.setAbo(const pABO: string);
begin
  Self.FAbo:= pAbo;
end;

procedure TBolsa.setRh(const pRH: string);
begin
  Self.FRh:= pRh;
end;

procedure TBolsa.setOrigem(const pORIGEM: string);
begin
  Self.FOrigem:= pOrigem;
end;

procedure TBolsa.setVolume(const pVOLUME: Integer);
begin
  Self.FVolume:= pVolume;
end;

procedure TBolsa.setSorologia(const pSOROLOGIA: string);
begin
  Self.FSorologia:= pSorologia;
end;

procedure TBolsa.setPossui_Estoque(const pPOSSUI_ESTOQUE: string);
begin
  Self.FPossui_Estoque:= pPossui_Estoque;
end;

end.
