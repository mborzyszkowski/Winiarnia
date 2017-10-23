with Ada.Text_IO; use Ada.Text_IO;
with Wina;

package MagazynSurowcowy is

   PojemnoscMagazynu : constant Integer :=200;
   
   -- jesli false to nie magazyn przepelniony
   function dostawa ( IleKgOwocow : in Integer := 0; IlePaczekCukru : in Integer := 0; IleDrozdzy : in Integer := 0) return Boolean;
   -- jesli false brak potrzebnych surowcow
   function pobierzSurowce return Boolean; 
   -- zwraca stan magazynu
   procedure stanMagazynu;
   -- zapytanie producenta do magazynu czy jest miesce na towary
   function czyBedzieMiejsceNaNoweTowary (IloscTowarow : in Integer) return Boolean;
private
   -- ObecnaZapelnienie = KgOwocow + PaczkiCukru + Drozdze, OczekiwanaDostawa - produkty ktore umownie zostana dostarczone
   -- maksymalnie zapenienie jest <= Pojemnosci magazynu
   OczekiwanaDostawa : Integer := 0;
   ObecneZapelnienie : Integer := 0;
   KgOwocow : Integer := 0;
   PaczkiCukru : Integer := 0;
   Drozdze : Integer := 0;
   
   

end MagazynSurowcowy;
