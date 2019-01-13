unit UClassDescarte;

interface

uses System.Classes, System.SysUtils;

type
  TDescarte = class(TPersistent)
  private
    FId: Integer;
    FId_Bolsa: Integer;
    FId_Usuario: Integer;
    FData_Coleta: TDate;
    FMotivo: string[80];
    FVolume: Integer;
    FData_Descarte: TDate;

    function getId: Integer;
    function getId_Bolsa: Integer;
    function getId_Usuario: Integer;
    function getData_Coleta: TDate;
    function getMotivo: string;
    function getVolume: Integer;
    function getData_Descarte: TDate;

    procedure setId(const pID: Integer);
    procedure setId_Bolsa(const pID_BOLSA: Integer);
    procedure setId_Usuario(const pID_USUARIO: Integer);
    procedure setData_Coleta(const pDATA_COLETA: TDate);
    procedure setMotivo(const pMOTIVO: string);
    procedure setVolume(const pVOLUME: Integer);
    procedure setData_Descarte(const pDATA_DESCARTE: TDate);

  public
    property Id: Integer read getId write setId;
    property Id_Bolsa: Integer read getId_Bolsa write setId_Bolsa;
    property Id_Usuario: Integer read getId_Usuario write setId_Usuario;
    property Data_Coleta: TDate read getData_Coleta write setData_Coleta;
    property Motivo: string read getMotivo write setMotivo;
    property Volume: Integer read getVolume write setVolume;
    property Data_Descarte: TDate read getData_Descarte write setData_Descarte;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TDescarte}

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

function TDescarte.getData_Coleta: TDate;
begin
  Result := Self.FData_Coleta;
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
  Self.FId:= pId;
end;

procedure TDescarte.setId_Bolsa(const pID_BOLSA: Integer);
begin
  Self.FId_Bolsa:= pId_Bolsa;
end;

procedure TDescarte.setId_Usuario(const pID_USUARIO: Integer);
begin
  Self.FId_Usuario:= pId_Usuario;
end;

procedure TDescarte.setData_Coleta(const pDATA_COLETA: TDate);
begin
  Self.FData_Coleta:= pData_Coleta;
end;

procedure TDescarte.setMotivo(const pMOTIVO: string);
begin
  Self.FMotivo:= pMotivo;
end;

procedure TDescarte.setVolume(const pVOLUME: Integer);
begin
  Self.FVolume:= pVolume;
end;

procedure TDescarte.setData_Descarte(const pDATA_DESCARTE: TDate);
begin
  Self.FData_Descarte:= pData_Descarte;
end;

end.
