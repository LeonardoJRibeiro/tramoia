unit UClassAtualizaBase;

interface

uses System.Classes, System.SysUtils, UClassConexao;

type
  TAtualizacaoBase = class(TPersistent)
  private
    FConexao: TConexao;

  const
    FVersaoBase: Integer = 2;

    function getExisteEntidade(const pNOME_ENTIDADE: string): Boolean;

    function PopulaEntidadeBaseDados: Boolean;
    function AtualizaTabelaVersao(const pVERSAO: string): Boolean;

    function CriaTabelaVersaoBd: Boolean;
    function CriaTabelaConfiguracao: Boolean;
    function CriaTabelaDevolucao: Boolean;

    function CriaTriggerInsertDevolucao: Boolean;
    function CriaTriggerUpdateDevolucao: Boolean;
    function CriaTriggerDeleteDevolucao: Boolean;

    function CriaAtributoDestinoDevolucao: Boolean;

    function getVersaoAtualBase: string;

    function geraBakup: Boolean;

  public

    function AtualizaBaseDados: Boolean;

    constructor Create(const pCONEXAO: TConexao); overload;
    destructor Destroy; override;

  end;

implementation

{ TAtualizacaoBase }

uses UClassPersistencia, UClassGeraBackup;

function TAtualizacaoBase.AtualizaBaseDados: Boolean;
var
  lVersaoAtual: string;
begin

  if (not Self.getExisteEntidade('versao_bd')) then
  begin
    Self.geraBakup;
    Self.CriaTabelaVersaoBd;
    Self.PopulaEntidadeBaseDados;
  end;

  lVersaoAtual := Self.getVersaoAtualBase;

  if (lVersaoAtual.ToInteger < Self.FVersaoBase) then
  begin

    if ((lVersaoAtual.ToInteger + 1) = 2) then
    begin

      Self.geraBakup;
      Self.CriaTabelaConfiguracao;
      Self.CriaTabelaDevolucao;
      Self.CriaTriggerInsertDevolucao;
      Self.CriaTriggerUpdateDevolucao;
      Self.CriaTriggerDeleteDevolucao;
      Self.CriaAtributoDestinoDevolucao;
      Self.AtualizaTabelaVersao('00002');

    end;

  end;

end;

function TAtualizacaoBase.AtualizaTabelaVersao(const pVERSAO: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('UPDATE versao_bd SET');
      lPersistencia.Query.SQL.Add('  versao = :pVersao');

      lPersistencia.setParametro('pVersao', pVERSAO);

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

constructor TAtualizacaoBase.Create(const pCONEXAO: TConexao);
begin
  Self.FConexao := pCONEXAO;
end;

function TAtualizacaoBase.CriaAtributoDestinoDevolucao: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('ALTER TABLE bolsa');
      lPersistencia.Query.SQL.Add('ADD COLUMN destino_devolucao VARCHAR(45) NULL AFTER numero_doacoes;');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.CriaTabelaConfiguracao: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('CREATE TABLE configuracao (');
      lPersistencia.Query.SQL.Add('  id int(11) NOT NULL AUTO_INCREMENT,');
      lPersistencia.Query.SQL.Add('  quant_dias_aviso_vencimento int(11) NOT NULL,');
      lPersistencia.Query.SQL.Add('  PRIMARY KEY (id)');
      lPersistencia.Query.SQL.Add(') ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.CriaTabelaDevolucao: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('CREATE TABLE devolucao (');
      lPersistencia.Query.SQL.Add('  id int(11) NOT NULL AUTO_INCREMENT,');
      lPersistencia.Query.SQL.Add('  id_usuario int(11) NOT NULL,');
      lPersistencia.Query.SQL.Add('  id_bolsa int(11) NOT NULL,');
      lPersistencia.Query.SQL.Add('  data_devolucao date NOT NULL,');
      lPersistencia.Query.SQL.Add('  origem_devolucao varchar(100) NOT NULL,');
      lPersistencia.Query.SQL.Add('  motivo_devolucao varchar(200) NOT NULL,');
      lPersistencia.Query.SQL.Add('  volume int(11) NOT NULL,');
      lPersistencia.Query.SQL.Add('  PRIMARY KEY (id),');
      lPersistencia.Query.SQL.Add('  KEY fk_devolucao_id_bolsa_idx (id_bolsa),');
      lPersistencia.Query.SQL.Add('  KEY fk_devolucao_id_usuario_idx (id_usuario),');
      lPersistencia.Query.SQL.Add
        ('  CONSTRAINT fk_devolucao_id_bolsa FOREIGN KEY (id_bolsa) REFERENCES bolsa (id) ON DELETE NO ACTION ON UPDATE NO ACTION,');
      lPersistencia.Query.SQL.Add
        ('  CONSTRAINT fk_devolucao_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id) ON DELETE NO ACTION ON UPDATE NO ACTION');
      lPersistencia.Query.SQL.Add(') ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.CriaTabelaVersaoBd: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('CREATE TABLE IF NOT EXISTS versao_bd (');
      lPersistencia.Query.SQL.Add('  id int(11) NOT NULL,');
      lPersistencia.Query.SQL.Add('  versao char(5) NOT NULL,');
      lPersistencia.Query.SQL.Add('  PRIMARY KEY (id)');
      lPersistencia.Query.SQL.Add(') ENGINE=InnoDB DEFAULT CHARSET=latin1;');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.CriaTriggerDeleteDevolucao: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('CREATE TRIGGER tg_Devolucao_After_Delete AFTER DELETE ON devolucao');
      lPersistencia.Query.SQL.Add(' FOR EACH ROW begin');
      lPersistencia.Query.SQL.Add
        ('update bolsa set volume_atual = (volume_atual + old.volume) where id = old.id_bolsa;');
      lPersistencia.Query.SQL.Add('end');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.CriaTriggerInsertDevolucao: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('CREATE TRIGGER tg_Devolucao_After_Insert AFTER INSERT ON devolucao');
      lPersistencia.Query.SQL.Add(' FOR EACH ROW begin');
      lPersistencia.Query.SQL.Add
        ('	update bolsa set volume_atual = (volume_atual - new.volume) where id = new.id_bolsa;');
      lPersistencia.Query.SQL.Add('end');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.CriaTriggerUpdateDevolucao: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('CREATE TRIGGER tg_Devolucao_After_Update AFTER UPDATE ON devolucao');
      lPersistencia.Query.SQL.Add(' FOR EACH ROW begin');
      lPersistencia.Query.SQL.Add
        ('	update bolsa set volume_atual = (volume_atual + old.volume) where id = old.id_bolsa;');
      lPersistencia.Query.SQL.Add
        ('    update bolsa set volume_atual = (volume_atual - new.volume) where id = new.id_bolsa;');
      lPersistencia.Query.SQL.Add('end');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

destructor TAtualizacaoBase.Destroy;
begin

  inherited;
end;

function TAtualizacaoBase.geraBakup: Boolean;
var
  lGeraBackup: TGeraBackup;
begin

  lGeraBackup := TGeraBackup.Create;
  try

    try

      Result := lGeraBackup.CriaBackup(False);

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lGeraBackup.Destroy;
  end;

end;

function TAtualizacaoBase.getExisteEntidade(const pNOME_ENTIDADE: string): Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  COUNT(table_name)');
      lPersistencia.Query.SQL.Add('FROM INFORMATION_SCHEMA.TABLES');
      lPersistencia.Query.SQL.Add('WHERE table_name LIKE ' + QuotedStr(pNOME_ENTIDADE));

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.Fields[0].AsInteger > 0;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.getVersaoAtualBase: string;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('SELECT');
      lPersistencia.Query.SQL.Add('  versao');
      lPersistencia.Query.SQL.Add('FROM versao_bd');

      lPersistencia.Query.Open;

      Result := lPersistencia.Query.Fields[0].AsString;

    except
      on E: Exception do
      begin
        Result := '';
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

function TAtualizacaoBase.PopulaEntidadeBaseDados: Boolean;
var
  lPersistencia: TPersistencia;
begin

  lPersistencia := TPersistencia.Create(Self.FConexao);
  try

    try

      lPersistencia.IniciaTransacao;

      lPersistencia.Query.SQL.Add('INSERT INTO versao_bd (');
      lPersistencia.Query.SQL.Add('  id,');
      lPersistencia.Query.SQL.Add('  versao');
      lPersistencia.Query.SQL.Add(') VALUES (');
      lPersistencia.Query.SQL.Add('  1,');
      lPersistencia.Query.SQL.Add(QuotedStr('00001'));
      lPersistencia.Query.SQL.Add(');');

      lPersistencia.Query.ExecSQL;

      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        raise Exception.Create(E.Message);
      end;
    end;

  finally
    lPersistencia.Destroy;
  end;

end;

end.
