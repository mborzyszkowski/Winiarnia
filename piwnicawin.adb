with Ada.Text_IO; use Ada.Text_IO;
with Wina;
package body PiwnicaWin is
   
   procedure dodajButelke(BWina : in Wina.ButelkaWina) is
   begin
      --info dod wina
      Put_Line("-->PiwnicaWin: Dodano wino " & Wina.smaki'Image(BWina.smak) & " " & Integer'Image(BWina.zawartoscArkocholu) & "%");
      IloscButelekNaStojakach := IloscButelekNaStojakach + 1;
      StojakiNaWino(IloscButelekNaStojakach) :=BWina;
   end dodajButelke;
   
   function zabierzButelke return Wina.ButelkaWina is
   begin
      Put_Line("-->PiwnicaWin: Wydano wino " & Wina.smaki'Image(StojakiNaWino(IloscButelekNaStojakach).smak) 
               & " " & Integer'Image(StojakiNaWino(IloscButelekNaStojakach).zawartoscArkocholu) & "% o wieku " 
               & Integer'Image(StojakiNaWino(IloscButelekNaStojakach).wiek));
      IloscButelekNaStojakach := IloscButelekNaStojakach - 1;
      return StojakiNaWino(IloscButelekNaStojakach + 1);
   end zabierzButelke;
   
   function ileButelekWPiwnicy return Integer is
   begin
      -- poprawic 
      --Put_Line("-->PiwnicaWin: Mamy miejsce na " & Integer'Image(PojemnoscPiwincyZWinami - IloscButelekNaStojakach) & " butelek");
        return IloscButelekNaStojakach; 
   end ileButelekWPiwnicy;
   
   procedure stanPiwnicy is 
   begin
      if IloscButelekNaStojakach > 0 then
         Put_Line("-->PiwnicaWin: Mamy " & Integer'Image(IloscButelekNaStojakach) & " butelek w piwnicy");
      else
         Put_Line("-->PiwnicaWin: Nie mamy ani jednej butelki");
      end if;
   end stanPiwnicy;
   
   procedure starzenieWina is
   begin 
      for i in Integer range 1 .. IloscButelekNaStojakach loop
         StojakiNaWino(i).wiek := StojakiNaWino(i).wiek +1;
         end loop;
   end starzenieWina;
end PiwnicaWin;
