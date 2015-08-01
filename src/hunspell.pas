{
  Same spellchecker as the one used in OpenOffice
}
unit HunSpell;

{$mode objfpc}{$H+}

interface

uses
  Classes;

const
  {$IFDEF MSWINDOWS}
  cLibHunSpell = 'hunspelldll.dll';
  {$ENDIF}
  {$IFDEF UNIX}
  cLibHunSpell = 'libhunspell.so';
  {$ENDIF}

type

  Thunspell_initialize = function(aff_file: PChar; dict_file: PChar): Pointer; cdecl;
  Thunspell_uninitialize = procedure(sspel: Pointer); cdecl;
  Thunspell_spell= function(spell: Pointer; word: PChar): Boolean; cdecl;
  Thunspell_suggest = function(spell: Pointer; word: PChar; var suggestions: PPChar): Integer; cdecl;
  Thunspell_suggest_auto = function(spell: Pointer; word: PChar; var suggestions: PPChar): Integer; cdecl;
  Thunspell_suggest_free = procedure(spell: Pointer; suggestions: PPChar; suggestLen: Integer); cdecl;
  Thunspell_get_dic_encoding = function(spell: Pointer): PChar; cdecl;
  Thunspell_put_word = function(spell: Pointer; word: PChar): Integer; cdecl;



var
  hunspell_initialize: Thunspell_initialize;
  hunspell_uninitialize: Thunspell_uninitialize;
  hunspell_spell: Thunspell_spell;
  hunspell_suggest: Thunspell_suggest;
  hunspell_suggest_auto: Thunspell_suggest_auto;
  hunspell_suggest_free: Thunspell_suggest_free;
  hunspell_get_dic_encoding: Thunspell_get_dic_encoding;
  hunspell_put_word: Thunspell_put_word;

  LibsLoaded: Boolean = False;


 {
function hunspell_initialize(aff_file: PChar; dict_file: PChar): Pointer; cdecl; external cLibHunSpell;
procedure hunspell_uninitialize(sspel: Pointer); cdecl; external cLibHunSpell;
}

function LoadLibHunspell(libraryName: String): Boolean;

implementation

uses
  dllfuncs;


var DLLHandle: THandle;


function LoadLibHunspell(libraryName: String): Boolean;
begin
  if libraryName = '' then
    libraryName := cLibHunSpell;

  Result := LibsLoaded;
  if Result then //already loaded.
    exit;

  DLLHandle := LoadLibrary(PAnsiChar(libraryName));
  if DLLHandle <> 0 then begin
    Result := True; //assume everything ok unless..

    @hunspell_initialize := GetProcAddress(DLLHandle, 'hunspell_initialize');
    if not Assigned(@hunspell_initialize) then Result := False;
    @hunspell_uninitialize := GetProcAddress(DLLHandle, 'hunspell_uninitialize');
    if not Assigned(@hunspell_uninitialize) then Result := False;
    @hunspell_spell := GetProcAddress(DLLHandle, 'hunspell_spell');
    if not Assigned(@hunspell_spell) then Result := False;
    @hunspell_suggest := GetProcAddress(DLLHandle, 'hunspell_suggest');
    if not Assigned(@hunspell_suggest) then Result := False;
    @hunspell_suggest_auto := GetProcAddress(DLLHandle, 'hunspell_suggest_auto');
    if not Assigned(@hunspell_suggest_auto) then Result := False;
    @hunspell_suggest_free := GetProcAddress(DLLHandle, 'hunspell_suggest_free');
    if not Assigned(@hunspell_suggest_free) then Result := False;
    @hunspell_get_dic_encoding := GetProcAddress(DLLHandle, 'hunspell_get_dic_encoding');
    if not Assigned(@hunspell_get_dic_encoding) then Result := False;
    @hunspell_put_word := GetProcAddress(DLLHandle, 'hunspell_put_word');
    if not Assigned(@hunspell_put_word) then Result := False;
  end;
}
end;


end.
