program spellchecktest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, HunSpell, dllfuncs;

var
  SpellPtr: Pointer;
begin
  writeln('init...');
  SpellPtr := hunspell_initialize(PChar('dict/en_US.aff'), PChar('dict/un_US.dic'));
  writeln('init... complete');
  if Assigned(SpellPtr) then
    writeln('Seems init went okay');
  writeln('cleanup...');
  hunspell_uninitialize(SpellPtr);
  writeln('cleanup....done');
end.

