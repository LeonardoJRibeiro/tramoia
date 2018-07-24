object FrmCons: TFrmCons
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Consulta'
  ClientHeight = 233
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanelGrid: TPanel
    Left = 0
    Top = 72
    Width = 500
    Height = 119
    Align = alClient
    TabOrder = 0
    object DBGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 498
      Height = 117
      Align = alClient
      Color = clSkyBlue
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = DBGridKeyDown
    end
  end
  object PanelBotoes: TPanel
    Left = 0
    Top = 191
    Width = 500
    Height = 42
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 1
    object BtnNovo: TSpeedButton
      Left = 8
      Top = 5
      Width = 75
      Height = 31
      HelpType = htKeyword
      Caption = '&Novo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        42040000424D4204000000000000420000002800000010000000100000000100
        20000300000000040000120B0000120B000000000000000000000000FF0000FF
        0000FF0000000000002300000033000000330000003300000033000000330000
        0033000000330000003300000033000000330000003300000033000000330000
        001E00000000A4A4A2C0AFAFADFFAEAEABFFADADABFFADADABFFADADABFFADAD
        ABFFAEAEACFFB3B0AFFFC5B5B9FF529F7AFF008B48FF008B49FF008C4CFF007E
        45AC0000001EB0B0ADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF6DC29BFF009452FF00BA84FF77E0C6FF00BB86FF0099
        5CFF007E45ACAEAEABFFFFFFFFFFFDFDFDFFFCFCFDFFFCFCFDFFFCFCFDFFFCFC
        FDFFFFFEFFFFFFFFFFFF007F36FF00BE88FF00BC83FFFFFFFFFF00BC83FF00C1
        8DFF008C4CFFADADABFFFFFFFFFFFAF8F8FFF9F8F8FFF9F8F8FFF9F8F8FFF9F8
        F8FFFDFAFBFFFFFFFFFF007F37FF72E5CBFFFFFFFFFFFFFFFFFFFFFFFFFF77E7
        CEFF008B49FFADADABFFFFFFFFFFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF9F7F8FFFFFFFFFF007E36FF00CA94FF00C88FFFFFFFFFFF00C990FF00CD
        99FF008C4BFFADADABFFFFFFFFFFF4F4F3FFF4F4F3FFF4F4F3FFF4F4F3FFF4F4
        F3FFF6F5F5FFFFFAFCFF63B68FFF009B59FF00D19AFF74EED4FF00D49FFF00A3
        67FF008E4E97ADADABFFFFFFFFFFF2F1F0FFF2F1F0FFF2F1F0FFF2F1F0FFF2F1
        F0FFF3F1F0FFF8F3F4FFFFF9FDFF62B58EFF008037FF00843EFF008947FF008E
        4D9600905100ADADABFFFFFFFFFFEFEFEEFFEFEFEEFFEFEFEEFFEFEFEEFFEFEF
        EEFFEFEFEEFFF0EFEFFFF4F1F1FFFDF4F6FFFFFFFFFFCBB4BBFF008B4400008F
        4D0000905000ADADABFFFFFFFFFFECEBEAFFEDECEBFFEDECEBFFEDECEBFFEDEC
        EBFFECEBEAFFECEBE9FFECEBEAFFEEEBEBFFFFFFFFFFB7AFB0FFCBB8BE00008B
        4300008D4700ADADABFFFFFFFFFFE9E9E8FFEAEAE9FFEAEAE9FFEAEAE9FFE9E9
        E8FFF3F4F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAEACFFBAB5B500C3B8
        BB00C7B9BD00ADAEABFFFFFFFFFFE7E5E4FFE8E7E6FFE8E7E6FFE8E7E6FFE7E5
        E4FFFFFFFFFFCBCBCAFFA7A7A4FFA5A5A3FFFFFFFFFFAFAFADFFB5B4B300B7B5
        B400B8B5B500AEAEABFFFFFFFFFFE3E3E2FFE4E4E3FFE4E5E4FFE4E4E3FFE3E3
        E2FFFFFFFFFFA7A7A4FFEBEBEAFFFFFFFFFFE9E9E9FFB0B0AEACB4B4B200B5B5
        B300B5B5B300AEAEACFFFFFFFFFFE0DFDEFFE1DFDEFFE1E0DFFFE1DFDEFFE0DF
        DEFFFFFFFFFFA5A5A3FFFFFFFFFFE8E8E8FFAFAFACA7B3B3B100B5B5B300B5B5
        B300B5B5B300AFAFADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFE9E9E9FFAEAEACA6B3B3B100B5B5B300B5B5B300B5B5
        B300B5B5B300B3B3B1EFB0B0ADFFAEAEACFFAEAEABFFAEAEABFFAEAEABFFADAE
        ABFFAEAEABFFAFAFADFFB0B0AEEAB3B3B100B5B5B300B5B5B300B5B5B300B5B5
        B300B5B5B300}
      ParentFont = False
    end
    object BtnAlterar: TSpeedButton
      Left = 86
      Top = 5
      Width = 75
      Height = 31
      Caption = '&Alterar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000B8B9B6B8B9B6
        B8B9B6B8B9B6B5B9B492AA95559964469B5C489C5E469A5A679D71ADB5ADB8B9
        B6B8B9B6B8B9B6B8B9B69AAC9CB8B9B6B8B9B6ADB2AC3788487BB88CAAD7B6B1
        DABCA0D1AE8FC99F71B985348F4E749476B8B9B6B8B9B6B8B9B645925A377D42
        889A88338849C1E0C9A3D4B169B67E42A45B41A45C59AF7065B47A5FB1753495
        4F58855BB8B9B6B8B9B667A678E1F5E771B082CAE7D27EC290239643268D412E
        82422E82442789422C994A47A76142A45C20883C7C937CB8B9B663A274D4EDDB
        BEDFC768B67E259543277B3D799B7EB5B8B4B6B9B5A2AAA12B773C339F5135A1
        5220853C49764CB8B9B6609D71C6E7D099CCA7239241329D4F32974D3277429D
        A69CB8B9B6B8B9B6ABB0AA28743A347F478B9F8DB8B9B6B1B6B05B996CC1E5CA
        3B9F562E9B4B359F51217636638667B4B7B3B8B9B6B8B9B6B8B9B6ABB0AAB4B8
        B3B6B8B5769D7C3B854D5694677EC791299C481B7634436F48ACB0ABB8B9B6B8
        B9B6B8B9B6B8B9B6B8B9B6B8B9B697A798589768ACD3B63184474B8E5D2C8E48
        3470429AA59AB8B9B6B8B9B6B8B9B6B8B9B6B8B9B6B8B9B6ACB1AB447E4C7EB0
        8BD2EBD956B26F2E7F433572437A917DB7B9B6B5B8B4ADB4ACB8B9B6B8B9B6B8
        B9B6B5B7B4688E6B559967C1E0CBB9DEC38CC89C269A452D7940B4B8B3B8B9B6
        95AC9651A5663F9A58A8AFA7B8B9B6B8B9B6A1AAA13E87509EC8AAABD9B796CC
        A5369C5231A04F2B743DB8B9B656925C48A160FFFFFFFDFFFE29803C9CA69CB5
        B7B3B4B7B37A937C3577478CC79C57AE6E2C984937A5542A733DB8B9B693A493
        147F2E8CC99DEDF8F0CEE7D57CB08B4388554C885C70AA7F8CCA9E5EB5752B9D
        4A297E3F37A6562A733DB8B9B6B8B9B68298820F7B2B40A45B98D0A8B2DCBDA2
        D5B190CDA073BE874CAB642C9C4B1A5D2A7F8C7F336138256335B8B9B6B8B9B6
        B8B9B6758F76217233218A3E299C4939A45539A4572B9B49298541285F31A6A9
        A4B8B9B6B8B9B6939E93B8B9B6B8B9B6B8B9B6B8B9B6B4B7B37C95803776452E
        743F2E733F477951849887B2B5B1B8B9B6B8B9B6B8B9B6B8B9B6}
      ParentFont = False
    end
    object BtnExcluir: TSpeedButton
      Left = 165
      Top = 5
      Width = 75
      Height = 31
      Caption = '&Excluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000B8B9B6B8B9B6
        B1B3B54D4EB1A2A3B0B8B9B6B8B9B6B8B9B6B8B9B6B8B9B6B8B9B6A2A3B05051
        B1B2B4B5B8B9B6B8B9B6B8B9B6B1B3B53D3CBA2821D22825C6A2A3B0B8B9B6B8
        B9B6B8B9B6B8B9B6A2A3B02723C62821D24040B9B2B4B5B8B9B6B2B3B53E3DBC
        2720D62720D62720D62824C9A2A3B0B8B9B6B8B9B6A2A3B02622C92720D62720
        D62720D64040BBB2B4B54D4DB7261FDA261FDA261FDA261FDA261FDA2724CDA2
        A3B0A1A3B12522CD261FDA261FDA261FDA261FDA261FDA5051B5A0A1B02621D0
        261EDD261EDD261EDD261EDD261EDD2521CF2521CF261EDD261EDD261EDD261E
        DD261EDD2521CFA1A3B1B8B9B69FA1B02521D4251DE1251DE1251DE1251DE125
        1DE1251DE1251DE1251DE1251DE1251DE12521D2A1A3B1B8B9B6B8B9B6B8B9B6
        9FA0B02521D6241DE5241DE5241DE5241DE5241DE5241DE5241DE5241DE52521
        D4A1A3B1B8B9B6B8B9B6B8B9B6B8B9B6B8B9B69EA0B12521D9241CE9241CE924
        1CE9241CE9241CE9241CE92520D7A1A3B1B8B9B6B8B9B6B8B9B6B8B9B6B8B9B6
        B8B9B6A1A2B12926D92722EB2722EB2722EB2722EB2722EB2722EB2623D9A1A3
        B1B8B9B6B8B9B6B8B9B6B8B9B6B8B9B6A1A2B13939DC4343EE3E3EED3636ED30
        30EC2F2FEC2F2FEC2F2FEC2F2FEC2C2CDBA2A4B0B8B9B6B8B9B6B8B9B6A1A2B1
        3D40DD4A4EEF4A4EEF4A4EEF4A4EEF494DEF4348EE3F43EE3C40ED393EED383D
        ED3235DBA2A3B0B8B9B6A1A2B1424ADD515AF0515AF0515AF0515AF0515AF042
        4ADD444BDF515AF0515AF0515AF0515AF0515AF0454CDDA2A4B15155C25766F1
        5766F15766F15766F15766F14853DEA1A2B19E9FB24954E05766F15766F15766
        F15766F15766F15458C1B1B3B54D56CD5E70F15E70F15E70F14C5DDEA1A2B1B8
        B9B6B8B9B69EA0B24E5FE05E70F15E70F15E70F14D56CDB2B3B5B8B9B6B1B3B5
        505ACE657CF15267DFA1A2B1B8B9B6B8B9B6B8B9B6B8B9B69FA1B15367E0657C
        F14F5CCDB2B3B5B8B9B6B8B9B6B8B9B6B1B3B5555DC2A1A2B1B8B9B6B8B9B6B8
        B9B6B8B9B6B8B9B6B8B9B69FA1B1575FC3B2B3B5B8B9B6B8B9B6}
      ParentFont = False
    end
    object BtnSair: TSpeedButton
      Left = 244
      Top = 5
      Width = 75
      Height = 31
      Caption = '&Sair'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Glyph.Data = {
        42040000424D4204000000000000420000002800000010000000100000000100
        20000300000000040000120B0000120B000000000000000000000000FF0000FF
        0000FF0000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000120000
        0032000000330000003300000033000000330000003300000033000000330000
        0033000000330000003300000033000000330000003300000033365D7B79497B
        A2FC68A4D9FF5C5C5CFF5C5C5CFF5E5B5AFF5E5A59FF5D5A5AFF5B5A5BFF5A5B
        5BFF5A5B5BFF5A5B5BFF5B5A5AFF5C5956FF576876FF4E7EA4FF4C80ACFF5082
        ABFF65A2D5FF5E5B5C005F5A5C00635859003F69A5FF756667FF706869FF6D69
        69FF6C6A69FF6C6A69FF6C6A68FF6E6762FF4C89BAFF4E85B2FF4D83AEFF5D8C
        B2FF629ED1FF66565D0069555C0010866D0013826BFF009346FF715C62FF6A62
        63FF676463FF666463FF676462FF68615BFF4F8ABBFF5086B4FF4F84B1FF6895
        B9FF5F9BCDFF000000300000003300000033008C46FF4FDDB0FF008D43FF6B58
        5EFF655E60FF636160FF62605FFF645D57FF518DBEFF528AB7FF5187B4FF739F
        C2FF5D97C9FF008B4BF2008A47FF008845FF008441FF00DAA2FF60D9B3FF008D
        42FF68545AFF625B5CFF605C5AFF605852FF5490C2FF558CBAFF4E81ADFF7EA6
        C8FF5A94C4FF008A47FF63EDD0FF00D4A0FF00D29EFF00CC9CFF00CD9CFF6FDC
        BDFF009346FF615457FF5C5756FF5B534DFF5794C5FF588EBCFF47749BFF88AF
        CFFF5790C0FF008A47FF61E1D0FF60DDCAFF63DCC8FF00C49BFF00C69CFF82E1
        C8FF009447FF5C5054FF585353FF574F4AFF5A96CAFF5B8FBEFF22B9F7FF95B5
        D3FF548DBCFF008D4CEF008A47FF008844FF00853FFF00C1A0FF97E3D1FF008F
        43FF5A484EFF565051FF53514FFF524B45FF5B9ACDFF5C91C1FF20B7F5FF9EBC
        D7FF5189B8FF008F4E00008F4C00008E4900008B44FFA0E8DAFF009144FF5543
        4AFF524B4DFF4F4D4EFF4F4D4CFF4D4641FF5E9CD2FF5C95C5FF5990C1FFA6C4
        DFFF4E86B5FF00904C00009147001A866E0017866DFF009647FF523F45FF4F47
        49FF4D494AFF4C4A4AFF4C4848FF4A423DFF60A0D5FF5D98C9FF5894C6FFAFCC
        E6FF4B83B0FF009242005276AF004E77AB004D7BB0FF4C3D3BFF4A4343FF4845
        44FF484644FF484644FF474542FF433C36FF5FA1D8FF5C9ACCFF5896C9FFB8D3
        EBFF4980ACFF4F79AB004C7AA7004A7BA6004A7FACFF443831FF433B37FF433D
        38FF433D38FF433D38FF423B36FF3C332CFFB9DAF5FF7FB0DAFF5495CCFFC0DA
        EFFF467CA8FF4B7CA6004A7CA5004A7CA6004A7EA8B04A82AEFF4A83B0FF4A83
        B0FF4A83B0FF4A83B0FF4A82AFFF447DA9FF709CBFFFB9D5EBFFB3D1EAFFC1DB
        F2FF4279A5FF4A7CA5004A7CA5004A7CA5004A7CA5004A7EA7004A7EA8004A7E
        A8004A7EA8004A7EA800497DA7004579A400709BBE00B5D2EA00C3DAEF58CDE3
        F5FB3F75A1FF}
      ParentFont = False
      OnClick = BtnSairClick
    end
  end
  object PanelConsulta: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 72
    Align = alTop
    TabOrder = 2
    object GroupBoxConsulta: TGroupBox
      Left = 1
      Top = 7
      Width = 498
      Height = 64
      Align = alBottom
      TabOrder = 0
      ExplicitLeft = 7
      ExplicitTop = 6
      ExplicitWidth = 482
      object GroupBoxTipoCons: TGroupBox
        Left = 9
        Top = 7
        Width = 114
        Height = 49
        Caption = 'Consultar por'
        TabOrder = 0
        object ComboBoxTipoCons: TComboBox
          Left = 8
          Top = 17
          Width = 97
          Height = 21
          Cursor = crHandPoint
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = 'Palavra chave'
          OnChange = ComboBoxTipoConsChange
          Items.Strings = (
            'Palavra chave'
            'Nome'
            'C'#243'digo')
        end
      end
      object EdtCons: TSearchBox
        Left = 129
        Top = 24
        Width = 350
        Height = 21
        AutoSize = False
        CharCase = ecUpperCase
        TabOrder = 1
      end
    end
  end
end
