object FrmSaida: TFrmSaida
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Sa'#237'da de sangue'
  ClientHeight = 419
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanelClient: TPanel
    Left = 0
    Top = 0
    Width = 309
    Height = 378
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 0
    object GroupBoxSangue: TGroupBox
      Left = 9
      Top = 77
      Width = 291
      Height = 296
      Caption = 'Bolsa de sangue'
      TabOrder = 0
      object LabelVolume: TLabel
        Left = 142
        Top = 63
        Width = 34
        Height = 13
        Caption = 'Volume'
      end
      object LabelAboSangue: TLabel
        Left = 214
        Top = 63
        Width = 64
        Height = 13
        Caption = 'ABO da Bolsa'
      end
      object LabelData: TLabel
        Left = 129
        Top = 18
        Width = 23
        Height = 13
        Caption = 'Data'
      end
      object LabelNumeroBolsa: TLabel
        Left = 10
        Top = 18
        Width = 94
        Height = 13
        Caption = 'N'#250'mero da bolsa(*)'
      end
      object LabelOrdemSaida: TLabel
        Left = 217
        Top = 18
        Width = 32
        Height = 13
        Caption = 'Ordem'
      end
      object LabelHospital: TLabel
        Left = 10
        Top = 63
        Width = 38
        Height = 13
        Caption = 'Hospital'
      end
      object LabelTipo: TLabel
        Left = 94
        Top = 63
        Width = 20
        Height = 13
        Caption = 'Tipo'
      end
      object DateTimePickerData: TDateTimePicker
        Left = 129
        Top = 33
        Width = 76
        Height = 21
        Date = 43248.939316319450000000
        Time = 43248.939316319450000000
        TabOrder = 0
      end
      object EdtAboBolsa: TEdit
        Left = 214
        Top = 78
        Width = 67
        Height = 21
        TabOrder = 1
      end
      object EdtNumeroBolsa: TEdit
        Left = 10
        Top = 33
        Width = 98
        Height = 21
        TabOrder = 2
      end
      object EdtOrdemSaida: TEdit
        Left = 217
        Top = 33
        Width = 64
        Height = 21
        Enabled = False
        TabOrder = 3
      end
      object EdtOrigem: TEdit
        Left = 10
        Top = 78
        Width = 71
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 4
        Text = 'HMI'
      end
      object EdtTipo: TEdit
        Left = 96
        Top = 78
        Width = 33
        Height = 21
        TabOrder = 5
      end
      object EdtVolume: TEdit
        Left = 142
        Top = 78
        Width = 61
        Height = 21
        TabOrder = 6
      end
      object RadioGroupPai: TRadioGroup
        Left = 10
        Top = 105
        Width = 271
        Height = 37
        Caption = 'Pai'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'Positivo'
          'Negativo')
        TabOrder = 7
      end
      object GroupBoxProvaCompatibilidade: TGroupBox
        Left = 10
        Top = 141
        Width = 271
        Height = 148
        Caption = 'Prova de compatibilidade'
        TabOrder = 8
        object RadioGroupTA: TRadioGroup
          Left = 6
          Top = 16
          Width = 258
          Height = 41
          Caption = 'TA'
          Columns = 2
          ItemIndex = 1
          Items.Strings = (
            'Positivo'
            'Negativo')
          TabOrder = 0
        end
        object RadioGroupAGH: TRadioGroup
          Left = 6
          Top = 58
          Width = 258
          Height = 41
          Caption = 'AGH'
          Columns = 2
          ItemIndex = 1
          Items.Strings = (
            'Positivo'
            'Negativo')
          TabOrder = 1
        end
        object RadioGroup37: TRadioGroup
          Left = 6
          Top = 100
          Width = 258
          Height = 41
          Caption = '37'
          Columns = 2
          ItemIndex = 1
          Items.Strings = (
            'Positivo'
            'Negativo')
          TabOrder = 2
        end
      end
    end
    object GroupBoxPaciente: TGroupBox
      Left = 9
      Top = 4
      Width = 291
      Height = 65
      Caption = 'Paciente'
      TabOrder = 1
      object LabelRegistroPaciente: TLabel
        Left = 10
        Top = 18
        Width = 64
        Height = 13
        Caption = 'Prontu'#225'rio(*)'
      end
      object LabelNomePaciente: TLabel
        Left = 96
        Top = 18
        Width = 86
        Height = 13
        Caption = 'Nome do paciente'
      end
      object SearchBoxRegistroPaciente: TSearchBox
        Left = 10
        Top = 33
        Width = 76
        Height = 21
        TabOrder = 0
      end
      object EdtNomePaciente: TEdit
        Left = 96
        Top = 33
        Width = 185
        Height = 21
        Enabled = False
        TabOrder = 1
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 378
    Width = 309
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 1
    object BtnGravar: TBitBtn
      Left = 24
      Top = 9
      Width = 109
      Height = 25
      Caption = 'Gravar'
      TabOrder = 0
      OnClick = BtnGravarClick
    end
    object BtnSair: TBitBtn
      Left = 171
      Top = 9
      Width = 109
      Height = 25
      Caption = 'Sair'
      TabOrder = 1
      OnClick = BtnSairClick
    end
  end
end
