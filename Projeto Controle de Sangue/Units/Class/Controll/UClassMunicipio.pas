unit UClassMunicipio;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('municipio')]
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

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('id_estado')]
    property Id_Estado: Integer read getId_Estado write setId_Estado;

    [TAtributo('codigo_ibge')]
    property Codigo_Ibge: Integer read getCodigo_Ibge write setCodigo_Ibge;

    [TAtributo('nome')]
    property Nome: string read getNome write setNome;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TMunicipio }

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
  Self.FId := pID;
end;

procedure TMunicipio.setId_Estado(const pID_ESTADO: Integer);
begin
  Self.FId_Estado := pID_ESTADO;
end;

procedure TMunicipio.setCodigo_Ibge(const pCODIGO_IBGE: Integer);
begin
  Self.FCodigo_Ibge := pCODIGO_IBGE;
end;

procedure TMunicipio.setNome(const pNOME: string);
begin
  Self.FNome := pNOME;
end;

end.
