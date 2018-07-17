unit UClassEstado;

interface

uses System.Classes, System.SysUtils;

type
  TEstado = class(TPersistent)
  private
    FId: Integer;
    FUf_Codigo: Integer;
    FNome: string[50];
    FUf: string[2];

    function getId: Integer;
    function getUf_Codigo: Integer;
    function getNome: string;
    function getUf: string;

    procedure setId(const pID: Integer);
    procedure setUf_Codigo(const pUF_CODIGO: Integer);
    procedure setNome(const pNOME: string);
    procedure setUf(const pUF: string);

  public
    property Id: Integer read getId write setId;
    property Uf_Codigo: Integer read getUf_Codigo write setUf_Codigo;
    property Nome: string read getNome write setNome;
    property Uf: string read getUf write setUf;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TEstado}

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

function TEstado.getUf_Codigo: Integer;
begin
  Result := Self.FUf_Codigo;
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
  Self.FId:= pId;
end;

procedure TEstado.setUf_Codigo(const pUF_CODIGO: Integer);
begin
  Self.FUf_Codigo:= pUf_Codigo;
end;

procedure TEstado.setNome(const pNOME: string);
begin
  Self.FNome:= pNome;
end;

procedure TEstado.setUf(const pUF: string);
begin
  Self.FUf:= pUf;
end;

end.
