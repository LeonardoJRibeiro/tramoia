unit UClassTelefone;

interface

uses System.Classes, System.SysUtils;

type
  TTelefone = class(TPersistent)
  private
    FId: Integer;
    FId_Paciente: Integer;
    FDdd: string[2];
    FNumero: string[10];
    FTipo_Telefone: string[1];

    function getId: Integer;
    function getId_Paciente: Integer;
    function getDdd: string;
    function getNumero: string;
    function getTipo_Telefone: string;

    procedure setId(const pID: Integer);
    procedure setId_Paciente(const pID_PACIENTE: Integer);
    procedure setDdd(const pDDD: string);
    procedure setNumero(const pNUMERO: string);
    procedure setTipo_Telefone(const pTIPO_TELEFONE: string);

  public
    property Id: Integer read getId write setId;
    property Id_Paciente: Integer read getId_Paciente write setId_Paciente;
    property Ddd: string read getDdd write setDdd;
    property Numero: string read getNumero write setNumero;
    property Tipo_Telefone: string read getTipo_Telefone write setTipo_Telefone;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TTelefone }

constructor TTelefone.Create;
begin

end;

destructor TTelefone.Destroy;
begin

  inherited;
end;

function TTelefone.getId: Integer;
begin
  Result := Self.FId;
end;

function TTelefone.getId_Paciente: Integer;
begin
  Result := Self.FId_Paciente;
end;

function TTelefone.getDdd: string;
begin
  Result := Self.FDdd;
end;

function TTelefone.getNumero: string;
begin
  Result := Self.FNumero;
end;

function TTelefone.getTipo_Telefone: string;
begin
  Result := Self.FTipo_Telefone;
end;

procedure TTelefone.setId(const pID: Integer);
begin
  Self.FId := pID;
end;

procedure TTelefone.setId_Paciente(const pID_PACIENTE: Integer);
begin
  Self.FId_Paciente := pID_PACIENTE;
end;

procedure TTelefone.setDdd(const pDDD: string);
begin
  Self.FDdd := pDDD;
end;

procedure TTelefone.setNumero(const pNUMERO: string);
begin
  Self.FNumero := pNUMERO;
end;

procedure TTelefone.setTipo_Telefone(const pTIPO_TELEFONE: string);
begin
  Self.FTipo_Telefone := pTIPO_TELEFONE;
end;

end.
