unit UClassEstoque;

interface

uses System.Classes, System.SysUtils;

type
  TEstoque = class(TPersistent)
  private
    FId: Integer;
    FQuantidade: Currency;
    FGrupo_Sanguineo: string[3];

    function getId: Integer;
    function getQuantidade: Currency;
    function getGrupo_Sanguineo: string;

    procedure setId(const pID: Integer);
    procedure setQuantidade(const pQUANTIDADE: Currency);
    procedure setGrupo_Sanguineo(const pGRUPO_SANGUINEO: string);

  public
    property Id: Integer read getId write setId;
    property Quantidade: Currency read getQuantidade write setQuantidade;
    property Grupo_Sanguineo: string read getGrupo_Sanguineo write setGrupo_Sanguineo;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TEstoque}

constructor TEstoque.Create;
begin

end;

destructor TEstoque.Destroy;
begin

  inherited;
end;
function TEstoque.getId: Integer;
begin
  Result := Self.FId;
end;

function TEstoque.getQuantidade: Currency;
begin
  Result := Self.FQuantidade;
end;

function TEstoque.getGrupo_Sanguineo: string;
begin
  Result := Self.FGrupo_Sanguineo;
end;

procedure TEstoque.setId(const pID: Integer);
begin
  Self.FId:= pId;
end;

procedure TEstoque.setQuantidade(const pQUANTIDADE: Currency);
begin
  Self.FQuantidade:= pQuantidade;
end;

procedure TEstoque.setGrupo_Sanguineo(const pGRUPO_SANGUINEO: string);
begin
  Self.FGrupo_Sanguineo:= pGrupo_Sanguineo;
end;

end.
