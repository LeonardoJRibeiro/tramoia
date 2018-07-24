unit UClassRelEstoque;

interface

uses System.SysUtils, System.Classes, UEnumsRelatorio;

type
  TRelEstoque = class(TPersistent)
  private

    FFiltroTipo: TTipoFiltro;
    FListTipo: TStringList;

    FFiltroGrupoSanguineo: TTipoFiltro;
    FListGrupoSanguineo: TStringList;

    FFiltroVolume: TTipoFiltro;
    FListVolume: TStringList;

    FVisualizar: Boolean;

    function getFiltroGrupoSanguineo: TTipoFiltro;
    function getFiltroTipo: TTipoFiltro;
    function getFiltroVolume: TTipoFiltro;
    function getVisualizar: Boolean;

    procedure setFiltroGrupoSanguineo(const pFILTROGRUPOSANGUINEO: TTipoFiltro);
    procedure setFiltroTipo(const pFILTROTIPO: TTipoFiltro);
    procedure setFiltroVolume(const pFILTROVOLUME: TTipoFiltro);
    procedure setVisualizar(const pVISUALIZAR: Boolean);

  public

    property FiltroTipo: TTipoFiltro read getFiltroTipo write setFiltroTipo;
    property ListTipo: TStringList read FListTipo write FListTipo;

    property FiltroGrupoSanguineo: TTipoFiltro read getFiltroGrupoSanguineo write setFiltroGrupoSanguineo;
    property ListGrupoSanguineo: TStringList read FListGrupoSanguineo write FListGrupoSanguineo;

    property FiltroVolume: TTipoFiltro read getFiltroVolume write setFiltroVolume;
    property ListVolume: TStringList read FListVolume write FListVolume;

    property Visualizar: Boolean read getVisualizar write setVisualizar;

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TRelEstoque }

constructor TRelEstoque.Create;
begin

  Self.FListTipo := TStringList.Create;

  Self.FListGrupoSanguineo := TStringList.Create;

  Self.FListVolume := TStringList.Create;

end;

destructor TRelEstoque.Destroy;
begin

  Self.FListTipo.Destroy;

  Self.FListGrupoSanguineo.Destroy;

  Self.FListVolume.Destroy;

  inherited;

end;

function TRelEstoque.getFiltroGrupoSanguineo: TTipoFiltro;
begin

  Result := Self.FFiltroGrupoSanguineo;

end;

function TRelEstoque.getFiltroTipo: TTipoFiltro;
begin

  Result := Self.FFiltroTipo;

end;

function TRelEstoque.getFiltroVolume: TTipoFiltro;
begin

  Result := Self.FFiltroVolume;

end;

function TRelEstoque.getVisualizar: Boolean;
begin

  Result := Self.FVisualizar;

end;

procedure TRelEstoque.setFiltroGrupoSanguineo(const pFILTROGRUPOSANGUINEO: TTipoFiltro);
begin

  Self.FFiltroGrupoSanguineo := pFILTROGRUPOSANGUINEO;

end;

procedure TRelEstoque.setFiltroTipo(const pFILTROTIPO: TTipoFiltro);
begin

  Self.FFiltroTipo := pFILTROTIPO;

end;

procedure TRelEstoque.setFiltroVolume(const pFILTROVOLUME: TTipoFiltro);
begin

  Self.FFiltroVolume := pFILTROVOLUME;

end;

procedure TRelEstoque.setVisualizar(const pVISUALIZAR: Boolean);
begin

  Self.FVisualizar := pVISUALIZAR;

end;

end.
