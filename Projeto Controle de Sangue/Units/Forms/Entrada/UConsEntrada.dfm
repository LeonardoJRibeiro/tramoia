inherited FrmConsEntrada: TFrmConsEntrada
  Caption = 'Consulta de Entradas'
  ClientHeight = 354
  ClientWidth = 723
  OnShow = FormShow
  ExplicitTop = -54
  ExplicitWidth = 729
  ExplicitHeight = 383
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 723
    Height = 240
    inherited DBGrid: TDBGrid
      Width = 721
      Height = 238
      DataSource = DataSource
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'id'
          Title.Alignment = taRightJustify
          Title.Caption = 'C'#243'digo'
          Width = 40
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'data_entrada'
          Title.Alignment = taCenter
          Title.Caption = 'Data'
          Width = 74
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'numero_da_bolsa'
          Title.Caption = 'N'#250'mero da bolsa'
          Width = 109
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'volume'
          Title.Caption = 'Volume'
          Width = 72
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'observacao'
          Title.Caption = 'Obseva'#231#227'o'
          Width = 243
          Visible = True
        end>
    end
  end
  inherited PanelBotoes: TPanel
    Top = 312
    Width = 723
    inherited BtnNovo: TSpeedButton
      OnClick = BtnNovoClick
    end
    inherited BtnExcluir: TSpeedButton
      OnClick = BtnExcluirClick
    end
  end
  inherited PanelConsulta: TPanel
    Width = 723
    inherited GroupBoxConsulta: TGroupBox
      Width = 721
      inherited EdtCons: TSearchBox
        Width = 576
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitWidth = 576
      end
    end
  end
  object DataSource: TDataSource
    Left = 160
    Top = 128
  end
end
