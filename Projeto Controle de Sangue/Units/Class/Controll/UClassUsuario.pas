unit UClassUsuario;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('usuario')]
  TUsuario = class(TPersistent)
  private
    FId: Integer;
    FNome: string[20];
    FSenha: string[50];
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

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('nome')]
    property Nome: string read getNome write setNome;

    [TAtributo('senha')]
    property Senha: string read getSenha write setSenha;

    [TAtributo('admin')]
    property Admin: string read getAdmin write setAdmin;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TUsuario }

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
  Self.FId := pID;
end;

procedure TUsuario.setNome(const pNOME: string);
begin
  Self.FNome := pNOME;
end;

procedure TUsuario.setSenha(const pSENHA: string);
begin
  Self.FSenha := pSENHA;
end;

procedure TUsuario.setAdmin(const pADMIN: string);
begin
  Self.FAdmin := pADMIN;
end;

end.
