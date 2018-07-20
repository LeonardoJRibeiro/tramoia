unit UConsMunicipio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConsGenerico, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.WinXCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFrmConsMunicpio = class(TFrmCons)
  private
    FForeignFormKey: SmallInt;
  public
    class function getConsMunicpio(const pFOREIGNFORMKEY: SmallInt; var pID: Integer): Boolean;
  end;

var
  FrmConsMunicpio: TFrmConsMunicpio;

implementation

{$R *.dfm}
{ TFrmConsMunicpio }

class function TFrmConsMunicpio.getConsMunicpio(const pFOREIGNFORMKEY: SmallInt; var pID: Integer): Boolean;
begin

  Application.CreateForm(TFrmConsMunicpio, FrmConsMunicpio);
  try

    try
      FrmConsMunicpio.FForeignFormKey := pFOREIGNFORMKEY;

      FrmConsMunicpio.ShowModal;

    except
      on E: Exception do
      begin
        Result := False;

      end;
    end;

  finally
    FreeAndNil(FrmConsMunicpio);
  end;

end;

end.
