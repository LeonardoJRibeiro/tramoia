unit UClassRelDevolucao;

interface

uses System.SysUtils, System.Classes, UEnumsRelatorio;

type
  TRelDevolucao = class(TPersistent)
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

{ TRelDevolucao }

constructor TRelDevolucao.Create;
begin

  Self.FListTipo := TStringList.Create;

  Self.FListGrupoSanguineo := TStringList.Create;

  Self.FListVolume := TStringList.Create;

end;

destructor TRelDevolucao.Destroy;
begin

  Self.FListTipo.Destroy;

  Self.FListGrupoSanguineo.Destroy;

  Self.FListVolume.Destroy;

  inherited;

end;

function TRelDevolucao.getDataFim: TDate;
begin

  Result := Self.FDataFim;

end;

function TRelDevolucao.getDataIni: TDate;
begin

  Result := Self.FDataIni;

end;

function TRelDevolucao.getFiltroGrupoSanguineo: TTipoFiltro;
begin

  Result := Self.FFiltroGrupoSanguineo;

end;

function TRelDevolucao.getFiltroTipo: TTipoFiltro;
begin

  Result := Self.FFiltroTipo;

end;

function TRelDevolucao.getFiltroVolume: TTipoFiltro;
begin

  Result := Self.FFiltroVolume;

end;

function TRelDevolucao.getVisualizar: Boolean;
begin

  Result := Self.FVisualizar;

end;

procedure TRelDevolucao.setDataFim(const pDATAFIM: TDate);
begin

  Self.FDataFim := pDATAFIM;

end;

procedure TRelDevolucao.setDataIni(const pDATAINI: TDate);
begin

  Self.FDataIni := pDATAINI;

end;

procedure TRelDevolucao.setFiltroGrupoSanguineo(const pFILTROGRUPOSANGUINEO: TTipoFiltro);
begin

  Self.FFiltroGrupoSanguineo := pFILTROGRUPOSANGUINEO;

end;

procedure TRelDevolucao.setFiltroTipo(const pFILTROTIPO: TTipoFiltro);
begin

  Self.FFiltroTipo := pFILTROTIPO;

end;

procedure TRelDevolucao.setFiltroVolume(const pFILTROVOLUME: TTipoFiltro);
begin

  Self.FFiltroVolume := pFILTROVOLUME;

end;

procedure TRelDevolucao.setVisualizar(const pVISUALIZAR: Boolean);
begin

  Self.FVisualizar := pVISUALIZAR;

end;

end.
