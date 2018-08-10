inherited FrmConsSaidas: TFrmConsSaidas
  Caption = 'Consulta de sa'#237'das'
  ClientHeight = 323
  ClientWidth = 742
  OnShow = FormShow
  ExplicitWidth = 748
  ExplicitHeight = 352
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 742
    Height = 209
    ExplicitWidth = 742
    ExplicitHeight = 209
    inherited DBGrid: TDBGrid
      Width = 740
      Height = 207
      DataSource = DataSource
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'id'
          Title.Alignment = taRightJustify
          Title.Caption = 'Ordem'
          Width = 41
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'data_saida'
          Title.Caption = 'Data sa'#237'da'
          Width = 63
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'num_prontuario'
          Title.Caption = 'N'#250'mero prontu'#225'rio'
          Width = 108
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Title.Caption = 'Paciente'
          Width = 194
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tipo_sangue'
          Title.Caption = 'Abo/Rh'#13#10' paciente'
          Width = 84
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'numero_da_bolsa'
          Title.Caption = 'N'#250'mero da bolsa'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tipo'
          Title.Caption = 'Tipo'
          Width = 27
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tipo_sangue_bolsa'
          Title.Caption = 'Abo/Rh bolsa'
          Width = 68
          Visible = True
        end>
    end
  end
  inherited PanelBotoes: TPanel
    Top = 281
    Width = 742
    ExplicitTop = 281
    ExplicitWidth = 742
    inherited BtnNovo: TSpeedButton
      OnClick = BtnNovoClick
    end
    inherited BtnExcluir: TSpeedButton
      OnClick = BtnExcluirClick
    end
  end
  inherited PanelConsulta: TPanel
    Width = 742
    ExplicitWidth = 742
    inherited GroupBoxConsulta: TGroupBox
      Width = 740
      ExplicitWidth = 740
      inherited EdtCons: TSearchBox
        Width = 592
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitWidth = 592
      end
    end
  end
  object DataSource: TDataSource
    Left = 144
    Top = 128
  end
end
