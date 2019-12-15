inherited FrmConsDevolucao: TFrmConsDevolucao
  Caption = 'Consulta de Devolu'#231#227'o'
  ClientHeight = 433
  ClientWidth = 1036
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 1042
  ExplicitHeight = 462
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelGrid: TPanel
    Width = 1036
    Height = 319
    ExplicitWidth = 1036
    ExplicitHeight = 319
    inherited DBGrid: TDBGrid
      Width = 1034
      Height = 317
      DataSource = DataSource
      OnDblClick = DBGridDblClick
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'id'
          Title.Alignment = taRightJustify
          Title.Caption = 'Ordem'
          Width = 42
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'data_devolucao'
          Title.Alignment = taCenter
          Title.Caption = 'Dt. devolu'#231#227'o'
          Width = 76
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'responsavel'
          Title.Caption = 'Respons'#225'vel'
          Width = 114
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'data_coleta'
          Title.Alignment = taCenter
          Title.Caption = 'Dt. Coleta'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'data_vencimento'
          Title.Alignment = taCenter
          Title.Caption = 'Dt. Vencimento'
          Width = 77
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'origem_devolucao'
          Title.Caption = 'Origem'
          Width = 63
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'destino'
          Title.Caption = 'Destino'
          Width = 63
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'tipo'
          Title.Alignment = taCenter
          Title.Caption = 'Tipo'
          Width = 35
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'numero_da_bolsa'
          Title.Alignment = taCenter
          Title.Caption = 'N'#250'mero da bolsa'
          Width = 113
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'grupo_sanguineo'
          Title.Alignment = taCenter
          Title.Caption = 'ABO/Rh'
          Width = 41
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'volume'
          Title.Alignment = taCenter
          Title.Caption = 'Volume'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'motivo_devolucao'
          Title.Caption = 'Motivo'
          Width = 250
          Visible = True
        end>
    end
  end
  inherited PanelBotoes: TPanel
    Top = 391
    Width = 1036
    ExplicitTop = 391
    ExplicitWidth = 1036
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
    Width = 1036
    ExplicitWidth = 1036
    inherited GroupBoxConsulta: TGroupBox
      Width = 1034
      ExplicitWidth = 1034
      object LabelAte: TLabel [0]
        Left = 440
        Top = 28
        Width = 17
        Height = 13
        Caption = 'At'#233
      end
      object LabelDe: TLabel [1]
        Left = 188
        Top = 28
        Width = 17
        Height = 13
        Caption = 'De:'
      end
      object BtnLocalizar: TSpeedButton [2]
        Left = 770
        Top = 21
        Width = 78
        Height = 27
        Caption = 'Localizar'
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0011000000780000002A00000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          007D010101FF010101EE00000032000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          002F010101F0010101FF010101EE000000320000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000037010101F0010101FF010101EE0000003200000033010101810101
          01980000007C0000002B00000000000000000000000000000000000000000000
          00000000000000000037010101F0010101FF010101F7010101FF010101F60101
          01DC010101F8010101FE01010193000000030000000000000000000000000000
          0000000000000000000000000037010101F9010101FB00000071000000070000
          00000000000B0000007F010101FE0101018F0000000000000000000000000000
          0000000000000000000000000037010101FF0000006F00000000000000000000
          0000000000000000000001010185010101FD0000002300000000000000000000
          0000000000000000000001010186010101F30000000600000000000000000000
          0000000000000000000000000011010101FD0000006E00000000000000000000
          000000000000000000000101019D010101D80000000000000000000000000000
          0000000000000101018C00000016010101EC0101018800000000000000000000
          0000000000000000000001010183010101F50000000800000000000000000000
          000000000058010101F500000027010101FE0000006D00000000000000000000
          0000000000000000000000000033010101FF0000007900000000000000000101
          018F010101F7000000550101018B010101FC0000002100000000000000000000
          00000000000000000000000000000101019E010101FD0000007E0000000E0000
          001A0000002901010189010101FF010101890000000000000000000000000000
          00000000000000000000000000000000000501010199010101FE010101FB0101
          01E8010101FC010101FD0101018B000000020000000000000000000000000000
          000000000000000000000000000000000000000000000000002A000000760101
          018D000000720000002300000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        OnClick = BtnLocalizarClick
      end
      inherited EdtCons: TSearchBox [3]
        Left = 163
        Width = 686
        OnKeyDown = EdtConsKeyDown
        OnKeyPress = EdtConsKeyPress
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitLeft = 163
        ExplicitWidth = 686
      end
      inherited GroupBoxTipoCons: TGroupBox [4]
        Width = 137
        ExplicitWidth = 137
        inherited ComboBoxTipoCons: TComboBox
          Width = 122
          ItemIndex = -1
          Text = ''
          Items.Strings = (
            'C'#243'digo'
            'N'#250'mero da bolsa'
            'Per'#237'odo')
          ExplicitWidth = 122
        end
      end
      object EdtDataFinal: TDateTimePicker
        Left = 488
        Top = 24
        Width = 190
        Height = 21
        Date = 43326.760915949080000000
        Time = 43326.760915949080000000
        TabOrder = 3
        OnExit = EdtDataFinalExit
      end
      object EdtDataIni: TDateTimePicker
        Left = 211
        Top = 24
        Width = 190
        Height = 21
        Date = 43326.760915949080000000
        Time = 43326.760915949080000000
        TabOrder = 2
      end
    end
  end
  object DataSource: TDataSource
    Left = 160
    Top = 128
  end
end
