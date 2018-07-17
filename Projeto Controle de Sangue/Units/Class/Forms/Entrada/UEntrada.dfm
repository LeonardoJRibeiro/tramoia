object FrmEntrada: TFrmEntrada
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Entrada ade sangue'
  ClientHeight = 198
  ClientWidth = 277
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelClient: TPanel
    Left = 0
    Top = 0
    Width = 277
    Height = 157
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 0
    object LabelData: TLabel
      Left = 9
      Top = 8
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object LabelNumeroBolsa: TLabel
      Left = 10
      Top = 55
      Width = 80
      Height = 13
      Caption = 'N'#250'mero da bolsa'
    end
    object LabelOrigem: TLabel
      Left = 10
      Top = 103
      Width = 34
      Height = 13
      Caption = 'Origem'
    end
    object LabelTipo: TLabel
      Left = 104
      Top = 54
      Width = 20
      Height = 13
      Caption = 'Tipo'
    end
    object LabelAboSangue: TLabel
      Left = 201
      Top = 55
      Width = 64
      Height = 13
      Caption = 'ABO da Bolsa'
    end
    object LabelObservacao: TLabel
      Left = 105
      Top = 103
      Width = 58
      Height = 13
      Caption = 'Observa'#231#227'o'
    end
    object Label1: TLabel
      Left = 145
      Top = 54
      Width = 34
      Height = 13
      Caption = 'Volume'
    end
    object LabelOrdemSaida: TLabel
      Left = 105
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Ordem'
    end
    object DateTimePickerData: TDateTimePicker
      Left = 9
      Top = 24
      Width = 81
      Height = 21
      Date = 43248.939316319450000000
      Time = 43248.939316319450000000
      TabOrder = 0
    end
    object EdtNumeroBolsa: TEdit
      Left = 10
      Top = 70
      Width = 80
      Height = 21
      NumbersOnly = True
      TabOrder = 2
    end
    object EdtOrigem: TEdit
      Left = 10
      Top = 120
      Width = 80
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 6
      OnEnter = EdtOrigemEnter
    end
    object EdtTipo: TEdit
      Left = 104
      Top = 70
      Width = 33
      Height = 21
      TabOrder = 3
    end
    object EdtAboBolsa: TEdit
      Left = 201
      Top = 70
      Width = 64
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 5
      OnEnter = EdtAboBolsaEnter
    end
    object EdtObservacao: TEdit
      Left = 105
      Top = 120
      Width = 160
      Height = 21
      TabOrder = 7
    end
    object EdtVolume: TEdit
      Left = 145
      Top = 70
      Width = 49
      Height = 21
      NumbersOnly = True
      TabOrder = 4
    end
    object EdtOrdemSaida: TEdit
      Left = 105
      Top = 24
      Width = 58
      Height = 21
      Enabled = False
      NumbersOnly = True
      TabOrder = 1
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 157
    Width = 277
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 1
    object BtnGravar: TBitBtn
      Left = 9
      Top = 9
      Width = 109
      Height = 25
      Caption = 'Gravar'
      TabOrder = 0
      OnClick = BtnGravarClick
    end
    object BtnSair: TBitBtn
      Left = 156
      Top = 9
      Width = 109
      Height = 25
      Caption = 'Sair'
      TabOrder = 1
      OnClick = BtnSairClick
    end
  end
end
