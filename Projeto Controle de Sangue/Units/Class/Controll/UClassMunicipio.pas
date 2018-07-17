unit UClassMunicipio;

interface

uses System.Classes, System.SysUtils;

type
  TMunicipio = class(TPersistent)
  private
    FId: Integer;
    FId_Estado: Integer;
    FCodigo_Ibge: Integer;
    FNome: string;

    function getId: Integer;
    function getId_Estado: Integer;
    function getCodigo_Ibge: Integer;
    function getNome: string;

    procedure setId(const pID: Integer);
    procedure setId_Estado(const pID_ESTADO: Integer);
    procedure setCodigo_Ibge(const pCODIGO_IBGE: Integer);
    procedure setNome(const pNOME: string);

  public
    property Id: Integer read getId write setId;
    property Id_Estado: Integer read getId_Estado write setId_Estado;
    property Codigo_Ibge: Integer read getCodigo_Ibge write setCodigo_Ibge;
    property Nome: string read getNome write setNome;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TMunicipio}

constructor TMunicipio.Create;
begin

end;

destructor TMunicipio.Destroy;
begin

  inherited;
end;
function TMunicipio.getId: Integer;
begin
  Result := Self.FId;
end;

function TMunicipio.getId_Estado: Integer;
begin
  Result := Self.FId_Estado;
end;

function TMunicipio.getCodigo_Ibge: Integer;
begin
  Result := Self.FCodigo_Ibge;
end;

function TMunicipio.getNome: string;
begin
  Result := Self.FNome;
end;

procedure TMunicipio.setId(const pID: Integer);
begin
  Self.FId:= pId;
end;

procedure TMunicipio.setId_Estado(const pID_ESTADO: Integer);
begin
  Self.FId_Estado:= pId_Estado;
end;

procedure TMunicipio.setCodigo_Ibge(const pCODIGO_IBGE: Integer);
begin
  Self.FCodigo_Ibge:= pCodigo_Ibge;
end;

procedure TMunicipio.setNome(const pNOME: string);
begin
  Self.FNome:= pNome;
end;

end.
