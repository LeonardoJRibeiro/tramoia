unit UClassEntrada;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('Entrada')]
  TEntrada = class(TPersistent)

  private
    FId: Integer;
    FIdUsuario: Integer;
    FDataEntrada: TDate;
    FIdBolsa: Integer;

    function getId: Integer;
    function getId_Usuario: Integer;
    function getIdBolsa: Integer;
    function getData_Entrada: TDate;

    procedure setId(const pID: Integer);
    procedure setIdUsuario(const pID_USUARIO: Integer);
    procedure setDataEntrada(const pDATA_ENTRADA: TDate);
    procedure setIdBolsa(const pID_BOLSA: Integer);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('id_usuario')]
    property IdUsuario: Integer read getId_Usuario write setIdUsuario;

    [TAtributo('data_entrada')]
    property DataEntrada: TDate read getData_Entrada write setDataEntrada;

    [TAtributo('id_bolsA')]
    property IdBolsa: Integer read getIdBolsa write setIdBolsa;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TEntrada }

constructor TEntrada.Create;
begin

end;

destructor TEntrada.Destroy;
begin

  inherited;
end;

function TEntrada.getId: Integer;
begin
  Result := Self.FId;
end;

function TEntrada.getIdBolsa: Integer;
begin
  Result := Self.FIdBolsa;
end;

function TEntrada.getId_Usuario: Integer;
begin
  Result := Self.FIdUsuario;
end;

function TEntrada.getData_Entrada: TDate;
begin
  Result := Self.FDataEntrada;
end;

procedure TEntrada.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TEntrada.setIdBolsa(const pID_BOLSA: Integer);
begin
  Self.FIdBolsa := pID_BOLSA;
end;

procedure TEntrada.setIdUsuario(const pID_USUARIO: Integer);
begin
  Self.FIdUsuario := pID_USUARIO;
end;

procedure TEntrada.setDataEntrada(const pDATA_ENTRADA: TDate);
begin
  Self.FDataEntrada := pDATA_ENTRADA;
end;

end.
