unit UClassMensagem;

interface

uses System.SysUtils, System.Classes;

type
  TMensagem = class(TComponent)
  public
    class function getMensagem(const pMSG: SmallInt): string;
  end;

implementation

{ TMensagem }

class function TMensagem.getMensagem(const pMSG: SmallInt): string;
begin

  case (pMSG) of
    0:
      begin
        Result := 'Erro ao criar janela %S: %S.';
      end;

    1:
      begin
        Result := 'Erro ao consultar %S: %S.';
      end;

    2:
      begin
        Result := 'Erro ao excluir %s. Motivo: %s.';
      end;

    3:
      begin
        Result := 'Campo "%S" é obrigatório e não foi informado.';
      end;

    4:
      begin
        Result := 'Erro ao salvar %S. Motivo: %S.';
      end;

    5:
      begin
        Result := 'Erro ao pesquisar %S. Motivo: %S.';
      end;

    6:
      begin
        Result := '%S não cadastrado.';
      end;

    7:
      begin
        Result := 'Erro ao preparar %S. Motivo %S.';
      end;

    8:
      begin
        Result := '%s salvo com sucesso.'
      end;

    9:
      begin
        Result := 'Deseja realmente excluir o %s selecionado?'
      end;

    10:
      begin
        Result := 'Município não encontrado.';
      end;

    11:
      begin
        Result := 'CPF inválido.';
      end;

    12:
      begin
        Result := 'Você não possui permissão para realizar a operação.';
      end;

    13:
      begin
        Result := 'Senha ou usuário incorreto.';
      end;

    14:
      begin
        Result := 'Erro ao realizar o login. Motivo: %S';
      end;

    15:
      begin
        Result := 'Erro ao verificar a existência do CPF no cadastro de pacientes. Motivo %s'
      end;

    16:
      begin
        Result := 'CPF já cadastrado na base de dados.';
      end;

    17:
      begin
        Result := 'Cartão SUS inválido.';
      end;

    18:
      begin
        Result := 'Número de RG inválido.';
      end;

    19:
      begin
        Result := 'Não é possível excluir o paciente. Motivo: Paciente já possui histórico.'
      end;

    20:
      begin
        Result := 'Não foi possivel realizar o cadastro do usuário. Motivo: Usuário já cadastrado no sistema.';
      end;

    21:
      begin
        Result := 'Não é possível alterar a entrada. Motivo: A bolsa da entrada já não está mais no estoque.';
      end;

    22:
      begin
        Result := 'Não é possível excluir a entrada. Motivo: A bolsa da entrada já não está mais no estoque.';
      end;

    23:
      begin
        Result := 'Entrada gravada com sucesso.';
      end;

    24:
      begin
        Result := 'Saída gravada com sucesso.';
      end;

    25:
      begin
        Result := 'Erro ao carregar informações da entrada. Motivo %s';
      end;

    26:
      begin
        Result := 'Erro ao carregar informações da bolsa. Motivo %s';
      end;

    27:
      begin
        Result := 'Erro ao realizar a autenticação do usuário. Motivo: %s';
      end;

    28:
      begin
        Result := 'Descarte gravado com sucesso.';
      end;

    29:
      begin
        Result := 'Erro ao verificar permissão de alteração ou exclusão. Motivo: %S'
      end;

  end;

end;

end.
