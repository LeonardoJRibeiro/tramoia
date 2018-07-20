unit UClassEntrada;

interface

uses System.Classes, System.SysUtils;

type
  TEntrada = class(TPersistent)
  private
    FId: Integer;
    FId_Usuario: Integer;
    FData_Entrada: TDate;
    FNumero_Da_Bolsa: string[20];
    FOrigem: string[15];
    FTipo: string[2];
    FVolume: Currency;
    FGrupo_Sanguineo: string[3];
    FSorologia: string[1];
    FObservacao: string[100];

    function getId: Integer;
    function getId_Usuario: Integer;
    function getData_Entrada: TDate;
    function getNumero_Da_Bolsa: string;
    function getOrigem: string;
    function getTipo: string;
    function getVolume: Currency;
    function getGrupo_Sanguineo: string;
    function getSorologia: string;
    function getObservacao: string;

    procedure setId(const pID: Integer);
    procedure setId_Usuario(const pID_USUARIO: Integer);
    procedure setData_Entrada(const pDATA_ENTRADA: TDate);
    procedure setNumero_Da_Bolsa(const pNUMERO_DA_BOLSA: string);
    procedure setOrigem(const pORIGEM: string);
    procedure setTipo(const pTIPO: string);
    procedure setVolume(const pVOLUME: Currency);
    procedure setGrupo_Sanguineo(const pGRUPO_SANGUINEO: string);
    procedure setSorologia(const pSOROLOGIA: string);
    procedure setObservacao(const pOBSERVACAO: string);

  public
    property Id: Integer read getId write setId;
    property Id_Usuario: Integer read getId_Usuario write setId_Usuario;
    property Data_Entrada: TDate read getData_Entrada write setData_Entrada;
    property Numero_Da_Bolsa: string read getNumero_Da_Bolsa write setNumero_Da_Bolsa;
    property Origem: string read getOrigem write setOrigem;
    property Tipo: string read getTipo write setTipo;
    property Volume: Currency read getVolume write setVolume;
    property Grupo_Sanguineo: string read getGrupo_Sanguineo write setGrupo_Sanguineo;
    property Sorologia: string read getSorologia write setSorologia;
    property Observacao: string read getObservacao write setObservacao;

    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

{ TEntrada}

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

function TEntrada.getId_Usuario: Integer;
begin
  Result := Self.FId_Usuario;
end;

function TEntrada.getData_Entrada: TDate;
begin
  Result := Self.FData_Entrada;
end;

function TEntrada.getNumero_Da_Bolsa: string;
begin
  Result := Self.FNumero_Da_Bolsa;
end;

function TEntrada.getOrigem: string;
begin
  Result := Self.FOrigem;
end;

function TEntrada.getTipo: string;
begin
  Result := Self.FTipo;
end;

function TEntrada.getVolume: Currency;
begin
  Result := Self.FVolume;
end;

function TEntrada.getGrupo_Sanguineo: string;
begin
  Result := Self.FGrupo_Sanguineo;
end;

function TEntrada.getSorologia: string;
begin
  Result := Self.FSorologia;
end;

function TEntrada.getObservacao: string;
begin
  Result := Self.FObservacao;
end;

procedure TEntrada.setId(const pID: Integer);
begin
  Self.FId:= pId;
end;

procedure TEntrada.setId_Usuario(const pID_USUARIO: Integer);
begin
  Self.FId_Usuario:= pId_Usuario;
end;

procedure TEntrada.setData_Entrada(const pDATA_ENTRADA: TDate);
begin
  Self.FData_Entrada:= pData_Entrada;
end;

procedure TEntrada.setNumero_Da_Bolsa(const pNUMERO_DA_BOLSA: string);
begin
  Self.FNumero_Da_Bolsa:= pNumero_Da_Bolsa;
end;

procedure TEntrada.setOrigem(const pORIGEM: string);
begin
  Self.FOrigem:= pOrigem;
end;

procedure TEntrada.setTipo(const pTIPO: string);
begin
  Self.FTipo:= pTipo;
end;

procedure TEntrada.setVolume(const pVOLUME: Currency);
begin
  Self.FVolume:= pVolume;
end;

procedure TEntrada.setGrupo_Sanguineo(const pGRUPO_SANGUINEO: string);
begin
  Self.FGrupo_Sanguineo:= pGrupo_Sanguineo;
end;

procedure TEntrada.setSorologia(const pSOROLOGIA: string);
begin
  Self.FSorologia:= pSorologia;
end;

procedure TEntrada.setObservacao(const pOBSERVACAO: string);
begin
  Self.FObservacao:= pObservacao;
end;

end.
