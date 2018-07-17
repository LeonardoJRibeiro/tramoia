unit UClassUsuario;

interface

uses System.Classes, System.SysUtils;

type
  TUsuario = class(TPersistent)
  private
    FId: Integer;
    FNome: string[16];
    FSenha: string[8];
    FAdmin: string[1];

    function getId: Integer;
    function getNome: string;
    function getSenha: string;
    function getAdmin: string;

    procedure setId(const pID: Integer);
    procedure setNome(const pNOME: string);
    procedure setSenha(const pSENHA: string);
    procedure setAdmin(const pADMIN: string);

  public
    property Id: Integer read getId write setId;
    property Nome: string read getNome write setNome;
    property Senha: string read getSenha write setSenha;
    property Admin: string read getAdmin write setAdmin;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TUsuario}

constructor TUsuario.Create;
begin

end;

destructor TUsuario.Destroy;
begin

  inherited;
end;
function TUsuario.getId: Integer;
begin
  Result := Self.FId;
end;

function TUsuario.getNome: string;
begin
  Result := Self.FNome;
end;

function TUsuario.getSenha: string;
begin
  Result := Self.FSenha;
end;

function TUsuario.getAdmin: string;
begin
  Result := Self.FAdmin;
end;

procedure TUsuario.setId(const pID: Integer);
begin
  Self.FId:= pId;
end;

procedure TUsuario.setNome(const pNOME: string);
begin
  Self.FNome:= pNome;
end;

procedure TUsuario.setSenha(const pSENHA: string);
begin
  Self.FSenha:= pSenha;
end;

procedure TUsuario.setAdmin(const pADMIN: string);
begin
  Self.FAdmin:= pAdmin;
end;

end.
