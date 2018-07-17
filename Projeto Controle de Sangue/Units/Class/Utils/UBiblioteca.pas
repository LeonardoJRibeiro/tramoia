unit UBiblioteca;

interface

uses System.Classes, System.SysUtils, IniFiles, Vcl.Forms, Vcl.stdctrls;

type
  TBiblioteca = class(TPersistent)
  public
    class function GravaArquivoIni(const pNOMEARQUIVO, pNOMECHAVE, pNOMESUBSHCAVE, pVALOR: string): Boolean;
    class function LeArquivoIni(const pNOMEARQUIVO, pNOMECHAVE, pNOMESUBSHCAVE, pDEFAULT: string): string;
    class function Crypt(Action, Src: string): string;
    class function getPrimeiroDiaMes(const pDATA: TDate): TDate;
    class function getUltimoDiaMes(const pDATA: TDate): TDate;
    class function IsCpfValido(const pCPF: string): Boolean;
    class procedure LimparCampos;
  end;

implementation

uses System.DateUtils;

{ TClassBiblioteca }

class function TBiblioteca.Crypt(Action, Src: string): string;
Label Fim;
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  Dest, Key: String;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  Range: Integer;
begin
  if (Src = '') Then
  begin
    Result := '';
    Goto Fim;
  end;
  Key := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSL9RTIKJ';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x', [OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;

      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x', [SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$' + copy(Src, 1, 2));
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$' + copy(Src, SrcPos, 2));
      if (KeyPos < KeyLen) Then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      if TmpSrcAsc <= OffSet then
        TmpSrcAsc := 255 + TmpSrcAsc - OffSet
      else
        TmpSrcAsc := TmpSrcAsc - OffSet;
      Dest := Dest + Chr(TmpSrcAsc);
      OffSet := SrcAsc;
      SrcPos := SrcPos + 2;
    until (SrcPos >= Length(Src));
  end;
  Result := Dest;
Fim:
end;

class function TBiblioteca.getPrimeiroDiaMes(const pDATA: TDate): TDate;
begin

  Result := StartOfTheMonth(pDATA);

end;

class function TBiblioteca.getUltimoDiaMes(const pDATA: TDate): TDate;
begin

  Result := EndOfTheMonth(pDATA);

end;

class function TBiblioteca.GravaArquivoIni(const pNOMEARQUIVO, pNOMECHAVE, pNOMESUBSHCAVE, pVALOR: string): Boolean;
var
  lArquivoINI: TIniFile;
begin
  try
    lArquivoINI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + pNOMEARQUIVO);
    try
      lArquivoINI.WriteString(pNOMECHAVE, pNOMESUBSHCAVE, pVALOR);
      Result := True;
    finally
      lArquivoINI.Free;
    end;

  except
    on E: Exception do
    begin
      Result := false;
      raise Exception.Create(E.Message);
    end;

  end;

end;

class function TBiblioteca.IsCpfValido(const pCPF: string): Boolean;
var
  lDig10: string;
  lDig11: string;
  s, i, r, peso: Integer;
begin
  // length - retorna o tamanho da string (CPF é um número formado por 11 dígitos)
  if ((pCPF = '00000000000') or (pCPF = '11111111111') or (pCPF = '22222222222') or (pCPF = '33333333333') or
    (pCPF = '44444444444') or (pCPF = '55555555555') or (pCPF = '66666666666') or (pCPF = '77777777777') or
    (pCPF = '88888888888') or (pCPF = '99999999999') or (Length(pCPF) <> 11)) then
  begin
    Result := false;
    exit;
  end;

  try
    // Cálculo do 1o. Digito Verificador
    s := 0;
    peso := 10;
    for i := 1 to 9 do
    begin
      // StrToInt converte o i-ésimo caractere do CPF em um número
      s := s + (StrToInt(pCPF[i]) * peso);
      peso := peso - 1;
    end;

    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
    begin
      lDig10 := '0'
    end
    else
    begin
      str(r: 1, lDig10); // converte um número no respectivo caractere numérico
    end;

    // Cálculo do 2o. Digito Verificador
    s := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      s := s + (StrToInt(pCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);

    if ((r = 10) or (r = 11)) then
    begin
      lDig11 := '0'
    end
    else
    begin
      str(r: 1, lDig11);
    end;

    // Verifica se os digitos calculados conferem com os digitos informados. }
    if ((lDig10 = pCPF[10]) and (lDig11 = pCPF[11])) then
    begin
      Result := True
    end
    else
    begin
      Result := false;
    end;

  except
    Result := false
  end;

end;


class function TBiblioteca.LeArquivoIni(const pNOMEARQUIVO, pNOMECHAVE, pNOMESUBSHCAVE, pDEFAULT: string): string;
var
  lArquivoINI: TIniFile;
begin

  try

    lArquivoINI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + pNOMEARQUIVO);
    try

      Result := lArquivoINI.ReadString(pNOMECHAVE, pNOMESUBSHCAVE, pDEFAULT);

    finally
      lArquivoINI.Free;
    end;

  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;

end;

class procedure TBiblioteca.LimparCampos;
var
  lCount: SmallInt;
begin

  for lCount := 0 to Screen.ActiveControl.ComponentCount - 1 do
  begin

    if (TComponent(Screen.ActiveControl.Components[lCount]) is TEdit) then
    begin
      TEdit(TComponent(Screen.ActiveControl.Components[lCount])).Clear;
      Break;
    end;

    if (TComponent(Screen.ActiveControl.Components[lCount]) is TComboBox) then
    begin
      TComboBox(TComponent(Screen.ActiveControl.Components[lCount])).ItemIndex := -1;
      Break;
    end;

    if (TComponent(Screen.ActiveControl.Components[lCount]) is TCheckBox) then
    begin
      TCheckBox(TComponent(Screen.ActiveControl.Components[lCount])).Checked := false;
      Break;
    end;

  end;

end;

end.
