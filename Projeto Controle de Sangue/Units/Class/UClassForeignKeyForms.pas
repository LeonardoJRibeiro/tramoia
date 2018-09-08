unit UClassForeignKeyForms;

interface

uses System.SysUtils, System.Classes;

type
  TForeignKeyForms = class(TPersistent)
  private

  public

    const
    FIdUPrincipal: Byte = 1;
    FIdUConsPaciente: Byte = 2;
    FIdUCadPaciente: Byte = 3;
    FIdUConsMunicipio: Byte = 4;
    FIdUSaida: Byte = 5;
    FIdUSelRelatorio: Byte = 6;
    FIdURelEntrada: Byte = 7;
    FIdULogin: Byte = 8;
    FIdURelSaida: Byte = 9;
    FIdUConsUsuario: Byte = 10;
    FIdURelEstoque: Byte = 11;
    FIdUSobre: Byte = 12;
    FIdUConsEntrada: Byte = 13;
    FIdUConsSaida: Byte = 14;
    FIdUAutenticacao: Byte = 15;

  end;

implementation

end.
