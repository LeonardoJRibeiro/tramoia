unit UClassBolsa;

interface

uses System.SysUtils, System.Classes;

type
  TBolsa = class(TPersistent)
  private

    FId: Integer;
    FNumeroBolsa: string[20];
    FTipo: string[3];
    FAbo: string[2];
    FRh: string[1];
    FOrigem: string[15];
    FVolume: Integer;
    FSorologia: string[1];
    FPossuiEstoque: string[1];

    function getAbo: string;
    function getId: Integer;
    function getNumeroBolsa: string;
    function getOrigem: string;
    function getPossuiEstoque: string;
    function getRh: string;
    function getSorologia: string;
    function getTipo: string;
    function getVolume: Integer;

    procedure setAbo(const pABO: string);
    procedure setId(const pID: Integer);
    procedure setNumeroBolsa(const pNUMERO_BOLSA: string);
    procedure setOrigem(const pORIGEM: string);
    procedure setPossuiEstoque(const pPOSSUI_ESTOQUE: string);
    procedure setRh(const pRH: string);
    procedure setSorologia(const pSOROLOGIA: string);
    procedure setTipo(const pTIPO: string);
    procedure setVolume(const pVOLUME: Integer);

  public

    property Id: Integer read getId write setId;
    property NumeroBolsa: string read getNumeroBolsa write setNumeroBolsa;
    property Tipo: string read getTipo write setTipo;
    property Abo: string read getAbo write setAbo;
    property Rh: string read getRh write setRh;
    property Origem: string read getOrigem write setOrigem;
    property Volume: Integer read getVolume write setVolume;
    property Sorologia: string read getSorologia write setSorologia;
    property PossuiEstoque: string read getPossuiEstoque write setPossuiEstoque;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TBolsa }

constructor TBolsa.Create;
begin
  inherited;

end;

destructor TBolsa.Destroy;
begin

  inherited;
end;

function TBolsa.getAbo: string;
begin
  Result := Self.FAbo;
end;

function TBolsa.getId: Integer;
begin
  Result := Self.FId;
end;

function TBolsa.getNumeroBolsa: string;
begin
  Result := Self.FNumeroBolsa;
end;

function TBolsa.getOrigem: string;
begin
  Result := Self.FOrigem;
end;

function TBolsa.getPossuiEstoque: string;
begin
  Result := Self.FPossuiEstoque;
end;

function TBolsa.getRh: string;
begin
  Result := Self.FRh;
end;

function TBolsa.getSorologia: string;
begin
  Result := Self.FSorologia;
end;

function TBolsa.getTipo: string;
begin
  Result := Self.FTipo;
end;

function TBolsa.getVolume: Integer;
begin
  Result := Self.FVolume;
end;

procedure TBolsa.setAbo(const pABO: string);
begin
  Self.FAbo := pABO;
end;

procedure TBolsa.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TBolsa.setNumeroBolsa(const pNUMERO_BOLSA: string);
begin
  Self.FNumeroBolsa := pNUMERO_BOLSA;
end;

procedure TBolsa.setOrigem(const pORIGEM: string);
begin
  Self.FOrigem := pORIGEM;
end;

procedure TBolsa.setPossuiEstoque(const pPOSSUI_ESTOQUE: string);
begin
  Self.FPossuiEstoque := pPOSSUI_ESTOQUE;
end;

procedure TBolsa.setRh(const pRH: string);
begin
  Self.FRh := pRH;
end;

procedure TBolsa.setSorologia(const pSOROLOGIA: string);
begin
  Self.FSorologia := pSOROLOGIA;
end;

procedure TBolsa.setTipo(const pTIPO: string);
begin
  Self.FTipo := pTIPO;
end;

procedure TBolsa.setVolume(const pVOLUME: Integer);
begin
  Self.FVolume := pVOLUME;
end;

end.
