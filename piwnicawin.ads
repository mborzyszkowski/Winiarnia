with Wina;
package PiwnicaWin is

   PojemnoscPiwincyZWinami : constant Integer := 200;
   
   -- dodaje jedna butelke wina
   procedure dodajButelke(BWina : in Wina.ButelkaWina);
   
   -- oddaje jedna butelke wina
   function zabierzButelke return Wina.ButelkaWina;
   
   -- sprawdza ilosc butelek w piwnicy
   function ileButelekWPiwnicy return Integer;
   
   -- wypisuje ilosc butelek w pwnicy
   procedure stanPiwnicy;
   
   -- zwieksza wiek win w piwnicy o 1
   procedure starzenieWina;
   
private
   
   IloscButelekNaStojakach : Integer := 0;
   -- tablica na wina ograniczona maxymalna Pojemnoscia piwnicy
   StojakiNaWino : array (1 .. PojemnoscPiwincyZWinami) of Wina.ButelkaWina;

end PiwnicaWin;
