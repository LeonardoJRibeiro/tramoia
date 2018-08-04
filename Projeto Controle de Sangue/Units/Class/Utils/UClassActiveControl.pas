unit UClassActiveControl;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Grids, Vcl.StdCtrls, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.Windows, Winapi.Messages, Vcl.WinXCtrls, Vcl.Buttons;

type
  TActiveControl = class(TPersistent)
  private

  public

    procedure OnMessage(var Msg: TMsg; var Handled: Boolean);

    constructor Create; overload;
    destructor Destroy; override;

  end;

implementation

{ TActiveControl }

constructor TActiveControl.Create;
begin
  inherited;

end;

destructor TActiveControl.Destroy;
begin

  inherited;
end;

procedure TActiveControl.OnMessage(var Msg: TMsg; var Handled: Boolean);
begin

  try
    if not((Screen.ActiveControl is TCustomMemo) or (Screen.ActiveControl is TCustomGrid) or
      (Screen.ActiveControl is TBitBtn) or (Screen.ActiveForm.ClassName = 'TMessageForm')) then
    begin

      if (Msg.message = WM_KEYDOWN) then
      begin

        case Msg.wParam of
          VK_RETURN:
            begin
              Screen.ActiveForm.Perform(WM_NextDlgCtl, 0, 0);
            end;
        end;

      end
      else
      begin

        if (Screen.ActiveControl is TComboBox) then
        begin

          if (Msg.wParam = VK_SPACE) then
          begin

            // Método não fecha ainda, pq a aplicação ta chamando aqui várias vezes, assim liga e desliga
            // o droppeddown se deixar -> TComboBox(Screen.ActiveControl).DroppedDown := not TComboBox(Screen.ActiveControl).DroppedDown;
            TComboBox(Screen.ActiveControl).DroppedDown := True;

          end;

        end;

      end;

    end;

  except
    // Vazio para não gerar erro de memoria.
  end;

end;

end.
