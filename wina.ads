package Wina is

   -- smaki, wiek (jak winiarnia select sie skonczy kazde wino w skladzie dostaje wiek+1), procenty
   type smaki is (wisniowe, truskawkowe, jablkowe, sliwkowe);
   subtype procentArkocholu is Integer range 9 .. 16;
   
   -- definicja struktury butelka wina
   type ButelkaWina is record
      smak : smaki;
      wiek : Integer := 0;
      zawartoscArkocholu : procentArkocholu;
   end record;
   
end Wina;
