unit UClassPaciente;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('paciente')]
  TPaciente = class(TPersistent)
  private
    FId: Integer;
    FNome: string[100];
    FNome_Pai: string[100];
    FNome_Mae: string[100];
    FData_Nascimento: TDate;
    FSexo: string[1];
    FNum_Prontuario: string[20];
    FAbo: string[2];
    FRh: string[1];
    FCpf: string[11];
    FRg: string[10];
    FSus: string[16];
    FObservacao: string[255];

    function getId: Integer;
    function getNome: string;
    function getNome_Pai: string;
    function getNome_Mae: string;
    function getData_Nascimento: TDate;
    function getSexo: string;
    function getNum_Prontuario: string;
    function getAbo: string;
    function getRh: string;
    function getCpf: string;
    function getRg: string;
    function getSus: string;
    function getObservacao: string;

    procedure setId(const pID: Integer);
    procedure setNome(const pNOME: string);
    procedure setNome_Pai(const pNOME_PAI: string);
    procedure setNome_Mae(const pNOME_MAE: string);
    procedure setData_Nascimento(const pDATA_NASCIMENTO: TDate);
    procedure setSexo(const pSEXO: string);
    procedure setNum_Prontuario(const pNUM_PRONTUARIO: string);
    procedure setAbo(const pABO: string);
    procedure setRh(const pRH: string);
    procedure setCpf(const pCPF: string);
    procedure setRg(const pRG: string);
    procedure setSus(const pSUS: string);
    procedure setObservacao(const pOBSERVACAO: string);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('nome')]
    property Nome: string read getNome write setNome;

    [TAtributo('nome_pai')]
    property Nome_Pai: string read getNome_Pai write setNome_Pai;

    [TAtributo('nome_mae')]
    property Nome_Mae: string read getNome_Mae write setNome_Mae;

    [TAtributo('data_nascimento')]
    property Data_Nascimento: TDate read getData_Nascimento write setData_Nascimento;

    [TAtributo('sexo')]
    property Sexo: string read getSexo write setSexo;

    [TAtributo('num_prontuario')]
    property Num_Prontuario: string read getNum_Prontuario write setNum_Prontuario;

    [TAtributo('abo')]
    property Abo: string read getAbo write setAbo;

    [TAtributo('rh')]
    property Rh: string read getRh write setRh;

    [TAtributo('cpf')]
    property Cpf: string read getCpf write setCpf;

    [TAtributo('rg')]
    property Rg: string read getRg write setRg;

    [TAtributo('sus')]
    property Sus: string read getSus write setSus;

    [TAtributo('observacao')]
    property Observacao: string read getObservacao write setObservacao;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TPaciente }

constructor TPaciente.Create;
begin

end;

destructor TPaciente.Destroy;
begin

  inherited;
end;

function TPaciente.getId: Integer;
begin
  Result := Self.FId;
end;

function TPaciente.getNome: string;
begin
  Result := Self.FNome;
end;

function TPaciente.getNome_Pai: string;
begin
  Result := Self.FNome_Pai;
end;

function TPaciente.getNome_Mae: string;
begin
  Result := Self.FNome_Mae;
end;

function TPaciente.getData_Nascimento: TDate;
begin
  Result := Self.FData_Nascimento;
end;

function TPaciente.getSexo: string;
begin
  Result := Self.FSexo;
end;

function TPaciente.getNum_Prontuario: string;
begin
  Result := Self.FNum_Prontuario;
end;

function TPaciente.getObservacao: string;
begin
  Result := Self.FObservacao;
end;

function TPaciente.getAbo: string;
begin
  Result := Self.FAbo;
end;

function TPaciente.getRh: string;
begin
  Result := Self.FRh;
end;

function TPaciente.getCpf: string;
begin
  Result := Self.FCpf;
end;

function TPaciente.getRg: string;
begin
  Result := Self.FRg;
end;

function TPaciente.getSus: string;
begin
  Result := Self.FSus;
end;

procedure TPaciente.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TPaciente.setNome(const pNOME: string);
begin
  Self.FNome := pNOME;
end;

procedure TPaciente.setNome_Pai(const pNOME_PAI: string);
begin
  Self.FNome_Pai := pNOME_PAI;
end;

procedure TPaciente.setNome_Mae(const pNOME_MAE: string);
begin
  Self.FNome_Mae := pNOME_MAE;
end;

procedure TPaciente.setData_Nascimento(const pDATA_NASCIMENTO: TDate);
begin
  Self.FData_Nascimento := pDATA_NASCIMENTO;
end;

procedure TPaciente.setSexo(const pSEXO: string);
begin
  Self.FSexo := pSEXO;
end;

procedure TPaciente.setNum_Prontuario(const pNUM_PRONTUARIO: string);
begin
  Self.FNum_Prontuario := pNUM_PRONTUARIO;
end;

procedure TPaciente.setObservacao(const pOBSERVACAO: string);
begin
  Self.FObservacao := pOBSERVACAO;
end;

procedure TPaciente.setAbo(const pABO: string);
begin
  Self.FAbo := pABO;
end;

procedure TPaciente.setRh(const pRH: string);
begin
  Self.FRh := pRH;
end;

procedure TPaciente.setCpf(const pCPF: string);
begin
  Self.FCpf := pCPF;
end;

procedure TPaciente.setRg(const pRG: string);
begin
  Self.FRg := pRG;
end;

procedure TPaciente.setSus(const pSUS: string);
begin
  Self.FSus := pSUS;
end;

end.
