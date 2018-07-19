inherited FrmConsPaciente: TFrmConsPaciente
  Caption = 'Consulta do paciente'
  ClientHeight = 386
  ClientWidth = 802
  OnShow = FormShow
  ExplicitWidth = 808
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelTop: TPanel
    Width = 802
    Height = 345
    ExplicitWidth = 802
    ExplicitHeight = 345
    inherited DBGrid: TDBGrid
      Top = 73
      Width = 800
      Height = 271
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      OnDblClick = DBGridDblClick
      OnKeyDown = DBGridKeyDown
      Columns = <
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'num_prontuario'
          Title.Alignment = taCenter
          Title.Caption = 'Registro'
          Width = 94
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Title.Alignment = taCenter
          Title.Caption = 'Nome'
          Width = 260
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
          Width = 62
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'telefone'
          Title.Alignment = taCenter
          Title.Caption = 'Telefone'
          Width = 84
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
    inherited Panel1: TPanel
      Width = 800
      Height = 72
      ExplicitWidth = 800
      ExplicitHeight = 72
      inherited GroupBoxConsulta: TGroupBox
        Width = 770
        Height = 59
        ExplicitWidth = 770
        ExplicitHeight = 59
        inherited GroupBoxTipoCons: TGroupBox
          Top = 5
          Width = 147
          ExplicitTop = 5
          ExplicitWidth = 147
          inherited ComboBoxTipoCons: TComboBox
            Width = 129
            ItemIndex = 2
            Text = 'N'#250'm. Protu'#225'rio'
            Items.Strings = (
              'Palavra chave'
              'Nome'
              'N'#250'm. Protu'#225'rio')
            ExplicitWidth = 129
          end
        end
        inherited EdtCons: TSearchBox
          Left = 176
          Top = 20
          Width = 497
          OnExit = EdtConsExit
          OnInvokeSearch = EdtConsInvokeSearch
          ExplicitLeft = 176
          ExplicitTop = 20
          ExplicitWidth = 497
        end
      end
    end
  end
  inherited PanelClient: TPanel
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
  object DataSource: TDataSource
    Left = 128
    Top = 152
  end
end
