object FrmSobre: TFrmSobre
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Sobre'
  ClientHeight = 214
  ClientWidth = 518
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
    Width = 518
    Height = 214
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 8
    ExplicitHeight = 204
    object LabelVersao: TLabel
      Left = 5
      Top = 196
      Width = 163
      Height = 13
      AutoSize = False
      Caption = 'Vers'#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object LabelTramoia: TLabel
      Left = 1
      Top = 1
      Width = 516
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Time "Tram'#243'ia"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 115
    end
    object LabelAlexandre: TLabel
      Left = 5
      Top = 25
      Width = 102
      Height = 13
      Caption = '- Alexandre Carvalho'
    end
    object LabelDanilloFernandes: TLabel
      Left = 5
      Top = 44
      Width = 92
      Height = 13
      Caption = '- Danillo Fernandes'
    end
    object LabelDaniloPinheiro: TLabel
      Left = 5
      Top = 64
      Width = 77
      Height = 13
      Caption = '- Danilo Pinheiro'
    end
    object LabelGeus: TLabel
      Left = 5
      Top = 82
      Width = 63
      Height = 13
      Caption = '- Ge'#250's Junior'
    end
    object LabelJoaoVinicius: TLabel
      Left = 5
      Top = 101
      Width = 67
      Height = 13
      Caption = '- Jo'#227'o Vinicius'
    end
    object LabelLeonardo: TLabel
      Left = 5
      Top = 120
      Width = 88
      Height = 13
      Caption = '- Leonardo Ribeiro'
    end
    object LabelMaxoel: TLabel
      Left = 5
      Top = 139
      Width = 102
      Height = 13
      Caption = '- Maxoel Silva Santos'
    end
    object LabelMurilo: TLabel
      Left = 5
      Top = 158
      Width = 66
      Height = 13
      Caption = '- Murilo Olinto'
    end
    object LabelRicardo: TLabel
      Left = 5
      Top = 175
      Width = 89
      Height = 13
      Caption = '- Ricardo Carvalho'
    end
  end
end
