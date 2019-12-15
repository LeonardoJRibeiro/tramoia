unit UClassEstado;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('estado')]
  TEstado = class(TPersistent)
  private
    FId: Integer;
    FCodigo_Uf: Integer;
    FNome: string[50];
    FUf: string[2];

    function getId: Integer;
    function getCodigo_Uf: Integer;
    function getNome: string;
    function getUf: string;

    procedure setId(const pID: Integer);
    procedure setCodigo_Uf(const pCODIGO_UF: Integer);
    procedure setNome(const pNOME: string);
    procedure setUf(const pUF: string);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('codigo_uf')]
    property Codigo_Uf: Integer read getCodigo_Uf write setCodigo_Uf;

    [TAtributo('nome')]
    property Nome: string read getNome write setNome;

    [TAtributo('uf')]
    property Uf: string read getUf write setUf;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TEstado }

constructor TEstado.Create;
begin

end;

destructor TEstado.Destroy;
begin

  inherited;
end;

function TEstado.getId: Integer;
begin
  Result := Self.FId;
end;

function TEstado.getCodigo_Uf: Integer;
begin
  Result := Self.FCodigo_Uf;
end;

function TEstado.getNome: string;
begin
  Result := Self.FNome;
end;

function TEstado.getUf: string;
begin
  Result := Self.FUf;
end;

procedure TEstado.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TEstado.setCodigo_Uf(const pCODIGO_UF: Integer);
begin
  Self.FCodigo_Uf := pCODIGO_UF;
end;

procedure TEstado.setNome(const pNOME: string);
begin
  Self.FNome := pNOME;
end;

procedure TEstado.setUf(const pUF: string);
begin
  Self.FUf := pUF;
end;

end.
