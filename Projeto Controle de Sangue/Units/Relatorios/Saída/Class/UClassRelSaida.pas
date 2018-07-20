unit UClassRelSaida;

interface

uses System.SysUtils, System.Classes, UEnumsRelatorio;

type
  TRelSaida = class(TPersistent)
  private

    FDataIni: TDate;
    FDataFim: TDate;

    FFiltroTipo: TTipoFiltro;
    FListTipo: TStringList;

    FFiltroGrupoSanguineo: TTipoFiltro;
    FListGrupoSanguineo: TStringList;

    FFiltroVolume: TTipoFiltro;
    FListVolume: TStringList;

    FVisualizar: Boolean;

    function getDataIni: TDate;
    function getDataFim: TDate;
    function getFiltroGrupoSanguineo: TTipoFiltro;
    function getFiltroTipo: TTipoFiltro;
    function getFiltroVolume: TTipoFiltro;
    function getVisualizar: Boolean;

    procedure setDataIni(const pDATAINI: TDate);
    procedure setDataFim(const pDATAFIM: TDate);
    procedure setFiltroGrupoSanguineo(const pFILTROGRUPOSANGUINEO: TTipoFiltro);
    procedure setFiltroTipo(const pFILTROTIPO: TTipoFiltro);
    procedure setFiltroVolume(const pFILTROVOLUME: TTipoFiltro);
    procedure setVisualizar(const pVISUALIZAR: Boolean);

  public

    property DataIni: TDate read getDataIni write setDataIni;
    property DataFim: TDate read getDataFim write setDataFim;

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

{ TRelSaida }

constructor TRelSaida.Create;
begin

  Self.FListTipo := TStringList.Create;

  Self.FListGrupoSanguineo := TStringList.Create;

  Self.FListVolume := TStringList.Create;

end;

destructor TRelSaida.Destroy;
begin

  Self.FListTipo.Destroy;

  Self.FListGrupoSanguineo.Destroy;

  Self.FListVolume.Destroy;

  inherited;

end;

function TRelSaida.getDataFim: TDate;
begin

  Result := Self.FDataFim;

end;

function TRelSaida.getDataIni: TDate;
begin

  Result := Self.FDataIni;

end;

function TRelSaida.getFiltroGrupoSanguineo: TTipoFiltro;
begin

  Result := Self.FFiltroGrupoSanguineo;

end;

function TRelSaida.getFiltroTipo: TTipoFiltro;
begin

  Result := Self.FFiltroTipo;

end;

function TRelSaida.getFiltroVolume: TTipoFiltro;
begin

  Result := Self.FFiltroVolume;

end;

function TRelSaida.getVisualizar: Boolean;
begin

  Result := Self.FVisualizar;

end;

procedure TRelSaida.setDataFim(const pDATAFIM: TDate);
begin

  Self.FDataFim := pDATAFIM;

end;

procedure TRelSaida.setDataIni(const pDATAINI: TDate);
begin

  Self.FDataIni := pDATAINI;

end;

procedure TRelSaida.setFiltroGrupoSanguineo(const pFILTROGRUPOSANGUINEO: TTipoFiltro);
begin

  Self.FFiltroGrupoSanguineo := pFILTROGRUPOSANGUINEO;

end;

procedure TRelSaida.setFiltroTipo(const pFILTROTIPO: TTipoFiltro);
begin

  Self.FFiltroTipo := pFILTROTIPO;

end;

procedure TRelSaida.setFiltroVolume(const pFILTROVOLUME: TTipoFiltro);
begin

  Self.FFiltroVolume := pFILTROVOLUME;

end;

procedure TRelSaida.setVisualizar(const pVISUALIZAR: Boolean);
begin

  Self.FVisualizar := pVISUALIZAR;

end;

end.
