inherited FrmCons1: TFrmCons1
  Caption = 'FrmCons1'
  ClientWidth = 490
  ExplicitWidth = 496
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 490
    inherited DBGrid: TDBGrid
      Width = 488
      Columns = <
        item
          Expanded = False
          FieldName = 'id'
          Visible = True
        end
        item
          Expanded = False
          Visible = True
        end
        item
          Expanded = False
          Visible = True
        end>
    end
  end
  inherited PanelBotoes: TPanel
    Width = 490
  end
  inherited PanelConsulta: TPanel
    Width = 490
    inherited GroupBoxConsulta: TGroupBox
      Width = 458
      ExplicitWidth = 458
      inherited EdtCons: TSearchBox
        Width = 312
        ExplicitWidth = 312
      end
    end
  end
end
