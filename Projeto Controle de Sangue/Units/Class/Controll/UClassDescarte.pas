unit UClassDescarte;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('descarte')]
  TDescarte = class(TPersistent)
  private
    FId: Integer;
    FId_Bolsa: Integer;
    FId_Usuario: Integer;
    FMotivo: string[80];
    FVolume: Integer;
    FData_Descarte: TDate;

    function getId: Integer;
    function getId_Bolsa: Integer;
    function getId_Usuario: Integer;
    function getMotivo: string;
    function getVolume: Integer;
    function getData_Descarte: TDate;

    procedure setId(const pID: Integer);
    procedure setId_Bolsa(const pID_BOLSA: Integer);
    procedure setId_Usuario(const pID_USUARIO: Integer);
    procedure setMotivo(const pMOTIVO: string);
    procedure setVolume(const pVOLUME: Integer);
    procedure setData_Descarte(const pDATA_DESCARTE: TDate);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('id_bolsa')]
    property Id_Bolsa: Integer read getId_Bolsa write setId_Bolsa;

    [TAtributo('id_usuario')]
    property Id_Usuario: Integer read getId_Usuario write setId_Usuario;

    [TAtributo('motivo')]
    property Motivo: string read getMotivo write setMotivo;

    [TAtributo('volume')]
    property Volume: Integer read getVolume write setVolume;

    [TAtributo('data_descarte')]
    property Data_Descarte: TDate read getData_Descarte write setData_Descarte;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TDescarte }

constructor TDescarte.Create;
begin

end;

destructor TDescarte.Destroy;
begin

  inherited;
end;

function TDescarte.getId: Integer;
begin
  Result := Self.FId;
end;

function TDescarte.getId_Bolsa: Integer;
begin
  Result := Self.FId_Bolsa;
end;

function TDescarte.getId_Usuario: Integer;
begin
  Result := Self.FId_Usuario;
end;

function TDescarte.getMotivo: string;
begin
  Result := Self.FMotivo;
end;

function TDescarte.getVolume: Integer;
begin
  Result := Self.FVolume;
end;

function TDescarte.getData_Descarte: TDate;
begin
  Result := Self.FData_Descarte;
end;

procedure TDescarte.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TDescarte.setId_Bolsa(const pID_BOLSA: Integer);
begin
  Self.FId_Bolsa := pID_BOLSA;
end;

procedure TDescarte.setId_Usuario(const pID_USUARIO: Integer);
begin
  Self.FId_Usuario := pID_USUARIO;
end;

procedure TDescarte.setMotivo(const pMOTIVO: string);
begin
  Self.FMotivo := pMOTIVO;
end;

procedure TDescarte.setVolume(const pVOLUME: Integer);
begin
  Self.FVolume := pVOLUME;
end;

procedure TDescarte.setData_Descarte(const pDATA_DESCARTE: TDate);
begin
  Self.FData_Descarte := pDATA_DESCARTE;
end;

end.
