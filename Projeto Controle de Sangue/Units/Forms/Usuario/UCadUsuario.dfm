object FrmCadUsuario: TFrmCadUsuario
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cadastro de Usu'#225'rio'
  ClientHeight = 195
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBotoes: TPanel
    Left = 0
    Top = 160
    Width = 252
    Height = 35
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 150
    ExplicitWidth = 242
    object BtnFechar: TButton
      Left = 157
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Sair'
      TabOrder = 0
      OnClick = BtnFecharClick
    end
    object BtnSalvar: TButton
      Left = 76
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Gravar'
      TabOrder = 1
      OnClick = BtnSalvarClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 252
    Height = 160
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 242
    ExplicitHeight = 150
    object Label1: TLabel
      Left = 24
      Top = 65
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object EdtNome: TLabeledEdit
      Left = 24
      Top = 32
      Width = 193
      Height = 21
      EditLabel.Width = 27
      EditLabel.Height = 13
      EditLabel.Caption = 'Nome'
      MaxLength = 15
      TabOrder = 0
    end
    object EdtSenha: TMaskEdit
      Left = 24
      Top = 81
      Width = 193
      Height = 21
      MaxLength = 15
      PasswordChar = '*'
      TabOrder = 1
      Text = ''
    end
    object CheckBoxAdministrador: TCheckBox
      Left = 24
      Top = 108
      Width = 97
      Height = 17
      Caption = 'Administrador'
      TabOrder = 2
    end
  end
end
