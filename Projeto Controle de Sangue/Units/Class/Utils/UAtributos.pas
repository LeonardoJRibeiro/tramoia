unit UAtributos;

interface

type
  TEntidade = class(TCustomAttribute)

  private
    FNomeEntidade: string;

  public

    property NomeEntidade: string read FNomeEntidade write FNomeEntidade;

    constructor Create(const pNOME_ENTIDADE: string);

  end;

  TAtributo = class(TCustomAttribute)

  private
    FNomeAtributo: string;

  public

    property NomeAtributo: string read FNomeAtributo write FNomeAtributo;

    constructor Create(const pNOME_ATRIBUTO: string);

  end;

  TChavePrimaria = class(TCustomAttribute)

  public

    constructor Create;

  end;

implementation

{ TAtributo }

constructor TAtributo.Create(const pNOME_ATRIBUTO: string);
begin
  Self.FNomeAtributo := pNOME_ATRIBUTO;
end;

{ TChavePrimaria }

constructor TChavePrimaria.Create;
begin

end;

{ TEntidade }

constructor TEntidade.Create(const pNOME_ENTIDADE: string);
begin
  Self.FNomeEntidade := pNOME_ENTIDADE;
end;

end.
