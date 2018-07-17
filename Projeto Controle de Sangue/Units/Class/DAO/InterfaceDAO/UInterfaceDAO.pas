unit UInterfaceDAO;

interface

type
  IInterfaceDAO<T> = Interface

    function Salvar(var pOBJETO: T): Boolean;
    function Excluir(const pID: Integer): Boolean;
    function getExiste(const pID: Integer): Boolean;
    function getObjeto(const pID: Integer; var pOBJETO: T): Boolean;

  end;

implementation

end.
