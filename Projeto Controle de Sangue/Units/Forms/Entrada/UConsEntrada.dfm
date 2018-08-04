inherited FrmConsEntrada: TFrmConsEntrada
  Caption = 'Consulta de Entradas'
  ClientHeight = 370
  ClientWidth = 745
  OnShow = FormShow
  ExplicitWidth = 751
  ExplicitHeight = 399
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 745
    Height = 256
    ExplicitWidth = 745
    ExplicitHeight = 256
    inherited DBGrid: TDBGrid
      Width = 743
      Height = 254
      DataSource = DataSource
      Columns = <
        item
          Alignment = taRightJustify
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
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'numero_da_bolsa'
          Title.Caption = 'N'#250'mero da bolsa'
          Width = 109
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'tipo_sangue'
          Title.Alignment = taCenter
          Title.Caption = 'ABO/Rh'
          Width = 43
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'origem'
          Title.Caption = 'Origem'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'volume'
          Title.Caption = 'Volume'
          Width = 58
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'sorologia'
          Title.Caption = 'Sorologia'
          Width = 50
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
    Top = 328
    Width = 745
    ExplicitTop = 328
    ExplicitWidth = 745
    inherited BtnNovo: TSpeedButton
      OnClick = BtnNovoClick
    end
    inherited BtnAlterar: TSpeedButton
      OnClick = BtnAlterarClick
    end
    inherited BtnExcluir: TSpeedButton
      OnClick = BtnExcluirClick
    end
  end
  inherited PanelConsulta: TPanel
    Width = 745
    ExplicitWidth = 745
    inherited GroupBoxConsulta: TGroupBox
      Width = 743
      ExplicitLeft = 1
      ExplicitTop = 7
      ExplicitWidth = 743
      inherited EdtCons: TSearchBox
        Width = 592
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitWidth = 592
      end
    end
  end
  object DataSource: TDataSource
    Left = 160
    Top = 128
  end
end
