unit UDMConexao;

interface

uses
  System.SysUtils, System.Classes, UClassConexao;

type
  TDMConexao = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    FConexao: TConexao;

    function getConexao: TConexao;

    procedure setConexao(const pCONEXAO: TConexao);

  public
    property Conexao: TConexao read getConexao write setConexao;
  end;

var
  DMConexao: TDMConexao;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }
{$R *.dfm}

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  Self.FConexao := TConexao.Create;
end;

function TDMConexao.getConexao: TConexao;
begin
  Result := Self.FConexao;
end;

procedure TDMConexao.setConexao(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

end.
