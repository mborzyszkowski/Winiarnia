with Ada.Text_IO; use Ada.Text_IO;
package body MagazynSurowcowy is
   
   -- przyjecie dostawy
   function dostawa ( IleKgOwocow : in Integer := 0; IlePaczekCukru : in Integer := 0; IleDrozdzy : in Integer := 0) return Boolean is
   begin
      if IleKgOwocow+IleDrozdzy+IlePaczekCukru+MagazynSurowcowy.ObecneZapelnienie < MagazynSurowcowy.PojemnoscMagazynu then
         KgOwocow := KgOwocow + IleKgOwocow;
         PaczkiCukru := PaczkiCukru + IlePaczekCukru;
         Drozdze := Drozdze + IleDrozdzy;
         ObecneZapelnienie := ObecneZapelnienie + IlePaczekCukru + IleDrozdzy + IleKgOwocow;
         -- dostawa zrealizowana mozna odjac wartosc oczekiwana
         OczekiwanaDostawa := OczekiwanaDostawa - IleDrozdzy - IlePaczekCukru - IleKgOwocow;
         Put_Line("-->MagazynSurowcowy: Dostawa przyjeta :)");
         return True;
      else
         -- warunek awaryjny ( nie powinien wystapic )
         Put_Line("-->MagazynSurowcowy: Mamy za malo miejsca na ta dostawe");
         -- magazyn jest przepelniony inne sposoby spr czego jest za malo
         return False;
      end if;
   end dostawa;
   
   -- pobranie surowcow na wytworzenie 10 butelek wina
   function pobierzSurowce return Boolean is
   begin
      if (KgOwocow >= 7 ) and (PaczkiCukru >= 3) and (Drozdze >= 1 ) then
         KgOwocow := KgOwocow - 7;
         PaczkiCukru := PaczkiCukru - 3;
         Drozdze := Drozdze - 1;
         ObecneZapelnienie := ObecneZapelnienie - 11;
         Put_Line("-->MagazynSurowcowy: Skladniki na 10 butelek wydane");
         return True;
      else 
         Put_Line("-->MagazynSurowcowy: Mamy za malo skladnikow");
         return False;
      end if;
   end pobierzSurowce;
   
   -- zwraca ilosc surowcow w magazynie
   procedure stanMagazynu is
   begin
      Put_Line("-->MagazynSurowcowy: Na stanie mamy:");
      Put_Line(Integer'Image(KgOwocow) & " kg owocow");
      Put_Line(Integer'Image(PaczkiCukru) & " paczek cukru");
      Put_Line(Integer'Image(Drozdze) & " drozdzy");
   end stanMagazynu;
   
   -- informacja dla producenta czy jest sens jechac z towarami
   function czyBedzieMiejsceNaNoweTowary (IloscTowarow : in Integer) return Boolean is
   begin
      if (IloscTowarow + OczekiwanaDostawa + ObecneZapelnienie) <= PojemnoscMagazynu then
         Put_Line("-->MagazynSurowcowy: Jest miejsce na twoje towary");
         OczekiwanaDostawa := OczekiwanaDostawa + IloscTowarow;
         return True;
      else
         Put_Line("-->MagazynSurowcowy: Nie ma miejsca na twoje towary");
         return False;
      end if;
   end czyBedzieMiejsceNaNoweTowary;
end MagazynSurowcowy;
