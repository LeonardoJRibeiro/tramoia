inherited FrmConsUsuario: TFrmConsUsuario
  Caption = 'Consulta de usu'#225'rio'
  ClientHeight = 280
  ClientWidth = 472
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 478
  ExplicitHeight = 309
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 472
    Height = 166
    ExplicitWidth = 472
    ExplicitHeight = 166
    inherited DBGrid: TDBGrid
      Width = 470
      Height = 164
      DataSource = DataSource
      OnDblClick = DBGridDblClick
      Columns = <
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'id'
          Title.Alignment = taCenter
          Title.Caption = 'C'#243'digo'
          Width = 45
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Title.Caption = 'Nome'
          Width = 308
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'admin'
          Title.Caption = 'Administrador'
          Width = 71
          Visible = True
        end>
    end
  end
  inherited PanelBotoes: TPanel
    Top = 238
    Width = 472
    ExplicitTop = 238
    ExplicitWidth = 472
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
    Width = 472
    ExplicitWidth = 472
    inherited GroupBoxConsulta: TGroupBox
      Width = 470
      ExplicitLeft = 1
      ExplicitTop = 7
      ExplicitWidth = 470
      inherited EdtCons: TSearchBox
        Width = 324
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitWidth = 324
      end
    end
  end
  object DataSource: TDataSource
    Left = 80
    Top = 108
  end
end
