unit UClassDevolucao;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('devolucao')]
  TDevolucao = class(TPersistent)
  private
    FId: Integer;
    FId_Usuario: Integer;
    FId_Bolsa: Integer;
    FData_Devolucao: TDate;
    FOrigem_Devolucao: string[100];
    FMotivo_Devolucao: string[200];
    FVolume: Integer;

    function getId: Integer;
    function getId_Usuario: Integer;
    function getId_Bolsa: Integer;
    function getData_Devolucao: TDate;
    function getOrigem_Devolucao: string;
    function getMotivo_Devolucao: string;
    function getVolume: Integer;

    procedure setId(const pID: Integer);
    procedure setId_Usuario(const pID_USUARIO: Integer);
    procedure setId_Bolsa(const pID_BOLSA: Integer);
    procedure setData_Devolucao(const pDATA_DEVOLUCAO: TDate);
    procedure setOrigem_Devolucao(const pORIGEM_DEVOLUCAO: string);
    procedure setMotivo_Devolucao(const pMOTIVO_DEVOLUCAO: string);
    procedure setVolume(const pVOLUME: Integer);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('id_usuario')]
    property Id_Usuario: Integer read getId_Usuario write setId_Usuario;

    [TAtributo('id_bolsa')]
    property Id_Bolsa: Integer read getId_Bolsa write setId_Bolsa;

    [TAtributo('data_devolucao')]
    property Data_Devolucao: TDate read getData_Devolucao write setData_Devolucao;

    [TAtributo('origem_devolucao')]
    property Origem_Devolucao: string read getOrigem_Devolucao write setOrigem_Devolucao;

    [TAtributo('motivo_devolucao')]
    property Motivo_Devolucao: string read getMotivo_Devolucao write setMotivo_Devolucao;

    [TAtributo('volume')]
    property Volume: Integer read getVolume write setVolume;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TDevolucao }

constructor TDevolucao.Create;
begin

end;

destructor TDevolucao.Destroy;
begin

  inherited;
end;

function TDevolucao.getId: Integer;
begin
  Result := Self.FId;
end;

function TDevolucao.getId_Usuario: Integer;
begin
  Result := Self.FId_Usuario;
end;

function TDevolucao.getId_Bolsa: Integer;
begin
  Result := Self.FId_Bolsa;
end;

function TDevolucao.getData_Devolucao: TDate;
begin
  Result := Self.FData_Devolucao;
end;

function TDevolucao.getOrigem_Devolucao: string;
begin
  Result := Self.FOrigem_Devolucao;
end;

function TDevolucao.getMotivo_Devolucao: string;
begin
  Result := Self.FMotivo_Devolucao;
end;

function TDevolucao.getVolume: Integer;
begin
  Result := Self.FVolume;
end;

procedure TDevolucao.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TDevolucao.setId_Usuario(const pID_USUARIO: Integer);
begin
  Self.FId_Usuario := pID_USUARIO;
end;

procedure TDevolucao.setId_Bolsa(const pID_BOLSA: Integer);
begin
  Self.FId_Bolsa := pID_BOLSA;
end;

procedure TDevolucao.setData_Devolucao(const pDATA_DEVOLUCAO: TDate);
begin
  Self.FData_Devolucao := pDATA_DEVOLUCAO;
end;

procedure TDevolucao.setOrigem_Devolucao(const pORIGEM_DEVOLUCAO: string);
begin
  Self.FOrigem_Devolucao := pORIGEM_DEVOLUCAO;
end;

procedure TDevolucao.setMotivo_Devolucao(const pMOTIVO_DEVOLUCAO: string);
begin
  Self.FMotivo_Devolucao := pMOTIVO_DEVOLUCAO;
end;

procedure TDevolucao.setVolume(const pVOLUME: Integer);
begin
  Self.FVolume := pVOLUME;
end;

end.
