inherited FrmConsSaidas: TFrmConsSaidas
  Caption = 'Consulta de sa'#237'das'
  ClientHeight = 323
  ClientWidth = 742
  OnClose = FormClose
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
      OnDblClick = DBGridDblClick
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
          Alignment = taCenter
          Expanded = False
          FieldName = 'data_saida'
          Title.Alignment = taCenter
          Title.Caption = 'Data sa'#237'da'
          Width = 63
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'num_prontuario'
          Title.Alignment = taCenter
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
          Alignment = taCenter
          Expanded = False
          FieldName = 'tipo_sangue'
          Title.Caption = 'Abo/Rh'#13#10' paciente'
          Width = 82
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
          Alignment = taCenter
          Expanded = False
          FieldName = 'tipo_sangue_bolsa'
          Title.Alignment = taCenter
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
    inherited BtnAlterar: TSpeedButton
      OnClick = BtnAlterarClick
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
      object BtnLocalizar: TSpeedButton [0]
        Left = 640
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
        Layout = blGlyphRight
        OnClick = BtnLocalizarClick
      end
      object LabelAte: TLabel [1]
        Left = 419
        Top = 28
        Width = 17
        Height = 13
        Caption = 'At'#233
      end
      object LabelDe: TLabel [2]
        Left = 200
        Top = 28
        Width = 17
        Height = 13
        Caption = 'De:'
      end
      inherited GroupBoxTipoCons: TGroupBox
        Width = 149
        ExplicitWidth = 149
        inherited ComboBoxTipoCons: TComboBox
          Left = 9
          Width = 129
          ItemIndex = -1
          Text = ''
          Items.Strings = (
            'N'#250'mero da bolsa'
            'Ordem'
            'Paciente'
            'Per'#237'odo')
          ExplicitLeft = 9
          ExplicitWidth = 129
        end
      end
      inherited EdtCons: TSearchBox
        Left = 164
        Width = 557
        OnInvokeSearch = EdtConsInvokeSearch
        ExplicitLeft = 164
        ExplicitWidth = 557
      end
      object EdtDataFinal: TDateTimePicker
        Left = 444
        Top = 24
        Width = 190
        Height = 21
        Date = 43326.760915949080000000
        Time = 43326.760915949080000000
        TabOrder = 3
        OnDropDown = EdtDataFinalDropDown
      end
      object EdtDataIni: TDateTimePicker
        Left = 217
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
    Left = 144
    Top = 128
  end
end
