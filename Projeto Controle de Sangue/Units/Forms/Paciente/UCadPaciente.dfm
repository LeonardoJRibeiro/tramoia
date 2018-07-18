object FrmCadPaciente: TFrmCadPaciente
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cadastro de paciente'
  ClientHeight = 522
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 416
    Top = 88
    Width = 24
    Height = 13
    Caption = 'Sexo'
  end
  object Label10: TLabel
    Left = 416
    Top = 96
    Width = 37
    Height = 13
    Caption = 'Label10'
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 580
    Height = 488
    ActivePage = TabSheetDadosGerais
    Align = alClient
    TabOrder = 0
    object TabSheetDadosGerais: TTabSheet
      Caption = 'Dados gerais'
      object PanelDadosPessoais: TPanel
        Left = 0
        Top = 0
        Width = 572
        Height = 180
        Align = alTop
        TabOrder = 0
        object GroupBoxDadosPessoais: TGroupBox
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 564
          Height = 153
          Align = alTop
          Caption = 'Dados Pessoais'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label1: TLabel
            Left = 365
            Top = 17
            Width = 38
            Height = 13
            Caption = 'Sexo(*)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 10
            Top = 61
            Width = 33
            Height = 13
            Caption = 'CPF(*)'
          end
          object Label3: TLabel
            Left = 109
            Top = 61
            Width = 32
            Height = 13
            Caption = 'R.G(*)'
          end
          object Label4: TLabel
            Left = 441
            Top = 17
            Width = 102
            Height = 13
            Caption = 'Dt. de Nascimento(*)'
          end
          object Label5: TLabel
            Left = 213
            Top = 61
            Width = 64
            Height = 13
            Caption = 'Prontu'#225'rio(*)'
          end
          object Label6: TLabel
            Left = 362
            Top = 62
            Width = 41
            Height = 13
            Caption = 'S.U.S(*)'
          end
          object Label11: TLabel
            Left = 481
            Top = 61
            Width = 43
            Height = 13
            Caption = 'A.B.O(*)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object EdtNome: TLabeledEdit
            Left = 10
            Top = 32
            Width = 349
            Height = 21
            AutoSize = False
            CharCase = ecUpperCase
            EditLabel.Width = 89
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome Completo(*)'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -11
            EditLabel.Font.Name = 'Tahoma'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            MaxLength = 100
            TabOrder = 0
          end
          object EdtCpf: TMaskEdit
            Left = 10
            Top = 77
            Width = 92
            Height = 21
            AutoSize = False
            EditMask = '000\.000\.000\-00;0;'
            MaxLength = 14
            TabOrder = 3
            Text = ''
            OnExit = EdtCpfExit
          end
          object ComboboxSexo: TComboBox
            Left = 365
            Top = 32
            Width = 70
            Height = 22
            Style = csOwnerDrawFixed
            TabOrder = 1
            OnEnter = s
            Items.Strings = (
              'Masculino'
              'Feminino')
          end
          object EdtRg: TEdit
            Left = 109
            Top = 77
            Width = 99
            Height = 21
            MaxLength = 7
            NumbersOnly = True
            TabOrder = 4
          end
          object EdtDataNascimento: TMaskEdit
            Left = 441
            Top = 32
            Width = 92
            Height = 21
            EditMask = '00/00/0000;1;_'
            MaxLength = 10
            TabOrder = 2
            Text = '  /  /    '
            OnExit = EdtDataNascimentoExit
          end
          object EdtNumProntuario: TEdit
            Left = 213
            Top = 77
            Width = 146
            Height = 21
            MaxLength = 20
            NumbersOnly = True
            TabOrder = 5
            OnExit = EdtNumProntuarioExit
          end
          object ComboBoxABO: TComboBox
            Left = 481
            Top = 77
            Width = 52
            Height = 22
            Style = csOwnerDrawFixed
            TabOrder = 7
            Items.Strings = (
              'A+'
              'A-'
              'B+'
              'B-'
              'AB+'
              'AB-'
              'O+'
              'O-')
          end
          object EdtNomePai: TLabeledEdit
            Left = 10
            Top = 121
            Width = 258
            Height = 21
            CharCase = ecUpperCase
            EditLabel.Width = 59
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome do Pai'
            MaxLength = 100
            TabOrder = 8
          end
          object EdtNomeMae: TLabeledEdit
            Left = 275
            Top = 121
            Width = 258
            Height = 21
            CharCase = ecUpperCase
            EditLabel.Width = 65
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome da M'#227'e'
            MaxLength = 100
            TabOrder = 9
          end
          object EdtSus: TMaskEdit
            Left = 362
            Top = 77
            Width = 115
            Height = 21
            EditMask = '00000000000 0000 0;0;_'
            MaxLength = 18
            TabOrder = 6
            Text = ''
          end
        end
      end
      object PanelEndereco: TPanel
        Left = 0
        Top = 180
        Width = 572
        Height = 168
        Align = alTop
        TabOrder = 1
        object GroupBoxEndereco: TGroupBox
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 564
          Height = 158
          Align = alTop
          Caption = 'Endere'#231'o'
          TabOrder = 0
          object Label7: TLabel
            Left = 10
            Top = 61
            Width = 57
            Height = 13
            Caption = 'Munic'#237'pio(*)'
          end
          object Label8: TLabel
            Left = 460
            Top = 61
            Width = 33
            Height = 13
            Caption = 'CEP(*)'
          end
          object EdtLogradouro: TLabeledEdit
            Left = 10
            Top = 32
            Width = 267
            Height = 21
            CharCase = ecUpperCase
            EditLabel.Width = 69
            EditLabel.Height = 13
            EditLabel.Caption = 'Logradouro(*)'
            MaxLength = 100
            TabOrder = 0
          end
          object EdtComplemento: TLabeledEdit
            Left = 10
            Top = 120
            Width = 523
            Height = 21
            CharCase = ecUpperCase
            EditLabel.Width = 65
            EditLabel.Height = 13
            EditLabel.Caption = 'Complemento'
            MaxLength = 100
            TabOrder = 7
          end
          object EdtBairro: TLabeledEdit
            Left = 283
            Top = 32
            Width = 207
            Height = 21
            CharCase = ecUpperCase
            EditLabel.Width = 42
            EditLabel.Height = 13
            EditLabel.Caption = 'Bairro(*)'
            TabOrder = 1
          end
          object EdtNumero: TLabeledEdit
            Left = 496
            Top = 32
            Width = 36
            Height = 21
            EditLabel.Width = 51
            EditLabel.Height = 13
            EditLabel.Caption = 'N'#250'mero(*)'
            MaxLength = 8
            TabOrder = 2
            OnExit = EdtNumeroExit
          end
          object EdtCep: TMaskEdit
            Left = 460
            Top = 76
            Width = 72
            Height = 21
            Alignment = taCenter
            AutoSize = False
            EditMask = '00000-000;0;_'
            MaxLength = 9
            TabOrder = 6
            Text = '76680000'
          end
          object EdtNomeMunicipio: TLabeledEdit
            Left = 86
            Top = 76
            Width = 304
            Height = 21
            Color = clInfoBk
            EditLabel.Width = 73
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome Munic'#237'pio'
            Enabled = False
            TabOrder = 4
            Text = 'ITAPURANGA'
          end
          object EdtEstado: TLabeledEdit
            Left = 396
            Top = 76
            Width = 57
            Height = 21
            Color = clInfoBk
            EditLabel.Width = 33
            EditLabel.Height = 13
            EditLabel.Caption = 'Estado'
            Enabled = False
            TabOrder = 5
            Text = 'GO'
          end
          object EdtCodMunicipio: TSearchBox
            Left = 10
            Top = 76
            Width = 71
            Height = 21
            HelpType = htKeyword
            Alignment = taRightJustify
            AutoSize = False
            MaxLength = 7
            NumbersOnly = True
            TabOrder = 3
            Text = '5211206'
            OnExit = EdtCodMunicipioExit
            OnInvokeSearch = EdtCodMunicipioInvokeSearch
          end
        end
      end
      object PanelInformacoesComplementares: TPanel
        Left = 0
        Top = 348
        Width = 572
        Height = 112
        Align = alClient
        TabOrder = 2
        object GroupBoxInfoComplementares: TGroupBox
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 564
          Height = 69
          Align = alTop
          Caption = 'Informa'#231#245'es Complementares'
          TabOrder = 0
          object Label12: TLabel
            Left = 10
            Top = 20
            Width = 39
            Height = 13
            Caption = 'Contato'
          end
          object EdtTelefone: TMaskEdit
            Left = 10
            Top = 36
            Width = 87
            Height = 21
            Alignment = taCenter
            EditMask = '!\(99\)00000-0000;0;_'
            MaxLength = 14
            TabOrder = 0
            Text = ''
            OnExit = EdtTelefoneExit
          end
        end
      end
    end
    object TabSheetObservacoes: TTabSheet
      Caption = 'Observa'#231#245'es'
      ImageIndex = 1
      object MemoObservacoes: TMemo
        Left = 16
        Top = 16
        Width = 537
        Height = 425
        MaxLength = 1000
        TabOrder = 0
      end
    end
  end
  object PanelBotoes: TPanel
    Left = 0
    Top = 488
    Width = 580
    Height = 34
    Align = alBottom
    TabOrder = 1
    object BtnSalvar: TSpeedButton
      Left = 175
      Top = 1
      Width = 106
      Height = 31
      HelpType = htKeyword
      Caption = 'Salvar - F6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnSalvarClick
    end
    object BtnSair: TSpeedButton
      Left = 287
      Top = 1
      Width = 106
      Height = 31
      Caption = 'Sair - Esc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnSairClick
    end
  end
end
