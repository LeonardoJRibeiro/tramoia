unit UDMConexao;

interface

uses
  System.SysUtils, System.Classes, UClassConexao;

type
  TDataModuleConexao = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    FConexao: TConexao;

    function getConexao: TConexao;

    procedure setConexao(const pCONEXAO: TConexao);

  public
    property Conexao: TConexao read getConexao write setConexao;
  end;

var
  DataModuleConexao: TDataModuleConexao;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }
{$R *.dfm}

procedure TDataModuleConexao.DataModuleCreate(Sender: TObject);
begin
  Self.FConexao := TConexao.Create;
end;

function TDataModuleConexao.getConexao: TConexao;
begin
  Result := Self.FConexao;
end;

procedure TDataModuleConexao.setConexao(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

end.
