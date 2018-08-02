inherited FrmConsPaciente: TFrmConsPaciente
  Caption = 'Consulta do paciente'
  ClientHeight = 386
  ClientWidth = 802
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 808
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 802
    Height = 273
    ExplicitWidth = 802
    ExplicitHeight = 273
    inherited DBGrid: TDBGrid
      Width = 800
      Height = 271
      DataSource = DataSource
      OnDblClick = DBGridDblClick
      Columns = <
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'num_prontuario'
          Title.Alignment = taCenter
          Title.Caption = 'Registro'
          Width = 115
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Title.Alignment = taCenter
          Title.Caption = 'Nome'
          Width = 250
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'grupo_sanguineo'
          Title.Caption = 'A.B.O/Rh'
          Width = 50
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'cpf'
          Title.Alignment = taCenter
          Title.Caption = 'CPF'
          Width = 85
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'rg'
          Title.Alignment = taCenter
          Title.Caption = 'RG'
          Width = 56
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'telefone'
          Title.Alignment = taCenter
          Title.Caption = 'Telefone'
          Width = 81
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'sus'
          Title.Alignment = taCenter
          Title.Caption = 'SUS'
          Width = 107
          Visible = True
        end>
    end
  end
  inherited PanelBotoes: TPanel
    Top = 345
    Width = 802
    Height = 41
    ExplicitTop = 345
    ExplicitWidth = 802
    ExplicitHeight = 41
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
    Width = 802
    ExplicitWidth = 802
    inherited GroupBoxConsulta: TGroupBox
      Width = 800
      ExplicitWidth = 800
      inherited GroupBoxTipoCons: TGroupBox
        Width = 136
        ExplicitWidth = 136
        inherited ComboBoxTipoCons: TComboBox
          Width = 118
          ItemIndex = 2
          Text = 'N'#250'm. Prontu'#225'rio'
          Items.Strings = (
            'Palavra chave'
            'Nome'
            'N'#250'm. Prontu'#225'rio')
          ExplicitWidth = 118
        end
      end
      inherited EdtCons: TSearchBox
        Left = 154
        Width = 627
        OnExit = EdtConsExit
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitLeft = 154
        ExplicitWidth = 627
      end
    end
  end
  object DataSource: TDataSource
    Left = 128
    Top = 152
  end
end
