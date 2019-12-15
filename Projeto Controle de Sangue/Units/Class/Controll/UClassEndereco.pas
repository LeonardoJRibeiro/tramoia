unit UClassEndereco;

interface

uses System.Classes, System.SysUtils, UAtributos;

type

  [TEntidade('endereco')]
  TEndereco = class
  private
    FId: Integer;
    FId_Municipio: Integer;
    FId_Paciente: Integer;
    FLogradouro: string[100];
    FBairro: string[100];
    FComplemento: string[100];
    FNumero: string[8];
    FCep: string[8];

    function getId: Integer;
    function getId_Municipio: Integer;
    function getId_Paciente: Integer;
    function getLogradouro: string;
    function getBairro: string;
    function getComplemento: string;
    function getNumero: string;
    function getCep: string;

    procedure setId(const pID: Integer);
    procedure setId_Municipio(const pID_MUNICIPIO: Integer);
    procedure setId_Paciente(const pID_PACIENTE: Integer);
    procedure setLogradouro(const pLOGRADOURO: string);
    procedure setBairro(const pBAIRRO: string);
    procedure setComplemento(const pCOMPLEMENTO: string);
    procedure setNumero(const pNUMERO: string);
    procedure setCep(const pCEP: string);

  public

    [TChavePrimaria]
    [TAtributo('id')]
    property Id: Integer read getId write setId;

    [TAtributo('id_Municipio')]
    property Id_Municipio: Integer read getId_Municipio write setId_Municipio;

    [TAtributo('id_paciente')]
    property Id_Paciente: Integer read getId_Paciente write setId_Paciente;

    [TAtributo('logradouro')]
    property Logradouro: string read getLogradouro write setLogradouro;

    [TAtributo('bairro')]
    property Bairro: string read getBairro write setBairro;

    [TAtributo('complemento')]
    property Complemento: string read getComplemento write setComplemento;

    [TAtributo('numero')]
    property Numero: string read getNumero write setNumero;

    [TAtributo('cep')]
    property Cep: string read getCep write setCep;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin

end;

destructor TEndereco.Destroy;
begin

  inherited;
end;

function TEndereco.getId: Integer;
begin
  Result := Self.FId;
end;

function TEndereco.getId_Municipio: Integer;
begin
  Result := Self.FId_Municipio;
end;

function TEndereco.getId_Paciente: Integer;
begin
  Result := Self.FId_Paciente;
end;

function TEndereco.getLogradouro: string;
begin
  Result := Self.FLogradouro;
end;

function TEndereco.getBairro: string;
begin
  Result := Self.FBairro;
end;

function TEndereco.getComplemento: string;
begin
  Result := Self.FComplemento;
end;

function TEndereco.getNumero: string;
begin
  Result := Self.FNumero;
end;

function TEndereco.getCep: string;
begin
  Result := Self.FCep;
end;

procedure TEndereco.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TEndereco.setId_Municipio(const pID_MUNICIPIO: Integer);
begin
  Self.FId_Municipio := pID_MUNICIPIO;
end;

procedure TEndereco.setId_Paciente(const pID_PACIENTE: Integer);
begin
  Self.FId_Paciente := pID_PACIENTE;
end;

procedure TEndereco.setLogradouro(const pLOGRADOURO: string);
begin
  Self.FLogradouro := pLOGRADOURO;
end;

procedure TEndereco.setBairro(const pBAIRRO: string);
begin
  Self.FBairro := pBAIRRO;
end;

procedure TEndereco.setComplemento(const pCOMPLEMENTO: string);
begin
  Self.FComplemento := pCOMPLEMENTO;
end;

procedure TEndereco.setNumero(const pNUMERO: string);
begin
  Self.FNumero := pNUMERO;
end;

procedure TEndereco.setCep(const pCEP: string);
begin
  Self.FCep := pCEP;
end;

end.
