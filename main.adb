-- Winiarnia
-- by Maciej Borzyszkowski 165407
-- TODO:
-- accept na klienta (przemyslec)
-- poprawki ostateczne
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Wina;
with MagazynSurowcowy;
with PiwnicaWin;

procedure Main is

   -- constants
   MnorznikCzasu : constant Integer := 2;
   MonopolowyKonsumpcja : Duration := 7.0;
   RestauracjaKonsumpcja : Duration := 20.0;
   -- tablice i zmienne
   package LosSmakuWina is new Ada.Numerics.Discrete_Random(Wina.smaki);
   package LosProcentyWina is new Ada.Numerics.Discrete_Random(Wina.procentArkocholu);
   subtype ZbioryGospodarzaCzas is Integer range 15*MnorznikCzasu .. 20*MnorznikCzasu;
   package CzasZbiorow is new Ada.Numerics.Discrete_Random(ZbioryGospodarzaCzas);
   subtype DowstawyHurtowniWiniarskiejCzas is Integer range 5*MnorznikCzasu .. 10*MnorznikCzasu;
   package CzasDostawy is new Ada.Numerics.Discrete_Random(DowstawyHurtowniWiniarskiejCzas);
   subtype ZbioryGospodarzaIloscOwocow is Integer range 30 .. 50;
   package LosIloscOwocow is new Ada.Numerics.Discrete_Random(ZbioryGospodarzaIloscOwocow);
   subtype DowstawyHurtowniWiniarskiejIloscPaczekCukru is Integer range 6 .. 9;
   package LosIloscPaczekCukru is new Ada.Numerics.Discrete_Random(DowstawyHurtowniWiniarskiejIloscPaczekCukru);
   subtype DowstawyHurtowniWiniarskiejIloscDrozdzy is Integer range 2 .. 3;
   package LosIloscDrozdzy is new Ada.Numerics.Discrete_Random(DowstawyHurtowniWiniarskiejIloscDrozdzy);
   type SkrzynkaNaWino is array (Natural range <>) of Wina.ButelkaWina;

   -- zadania:
   -- Producenci
   task Gospodarstwo;
   task HurtowniaWiniarska;

   -- Konsumenci
   task Restauracja;
   task SklepMonopolowy;

   --Bufor

   task Winiarnia is
      entry dostawaOwocow ( IloscKgOwocow : in Integer);
      entry dostawaCukruIDrozdzy ( IloscPaczekCukru : in Integer; IloscDrozdzy : in Integer);
      entry sprzedarzWina ( SkrzyniaWin : out SkrzynkaNaWino);
   end Winiarnia;

   -- dostarcza owoce
   task body Gospodarstwo is
      LosCzas : CzasZbiorow.Generator;
      LosOwoce : LosIloscOwocow.Generator;
      IloscKgOwocow : Integer;
   begin
      CzasZbiorow.Reset(LosCzas);
      LosIloscOwocow.Reset(LosOwoce);
      delay 4.0*MnorznikCzasu;
      loop
         IloscKgOwocow := LosIloscOwocow.Random(LosOwoce);
         Put_Line("-->Gospodarstwo: Panie czy znajdzie sie miejsce na " & Integer'Image(IloscKgOwocow) & " kg owocow");
         if MagazynSurowcowy.czyBedzieMiejsceNaNoweTowary(IloscKgOwocow) then
            Put_Line("-->Gospodarstwo: Dostawa owocow poleciala");
            Winiarnia.dostawaOwocow(IloscKgOwocow);
         else
            Put_Line("-->Gospodarstwo: Ech wasza strata, sprzedam gdzie indziej");
         end if;
         delay Duration(CzasZbiorow.Random(LosCzas)*MnorznikCzasu);
         end loop;
   end Gospodarstwo;

   --dostarcza paczki cukru i drozdze
   task body HurtowniaWiniarska is
      LosCzas : CzasDostawy.Generator;
      LosPaczkiCukru : LosIloscPaczekCukru.Generator;
      LosDrozdze : LosIloscDrozdzy.Generator;
      IloscPaczekCukru : Integer;
      IloscDrozdzy : Integer;
   begin
      CzasDostawy.Reset(LosCzas);
      LosIloscPaczekCukru.Reset(LosPaczkiCukru);
      LosIloscDrozdzy.Reset(LosDrozdze);
      delay 1.0*MnorznikCzasu;
      loop
         IloscPaczekCukru := LosIloscPaczekCukru.Random(LosPaczkiCukru);
         IloscDrozdzy := LosIloscDrozdzy.Random(LosDrozdze);
         Put_Line("-->HurtowaniaWiniarska: Czy jest miejsce na " & Integer'Image(IloscPaczekCukru) & " paczek cukru i "
                    & Integer'Image(IloscDrozdzy) & " Drozdzy");
         if MagazynSurowcowy.czyBedzieMiejsceNaNoweTowary(IloscPaczekCukru+IloscDrozdzy) then
            Put_Line("-->HurtowaniaWiniarska: Puszczam dostawe");
            Winiarnia.dostawaCukruIDrozdzy(IloscPaczekCukru, IloscDrozdzy);
         else
            Put_Line("-->HurtowaniaWiniarska: Dobrze to sprzedam gdzie indziej");
         end if;
         delay Duration(CzasDostawy.Random(LosCzas)*MnorznikCzasu);
         end loop;
   end HurtowniaWiniarska;

   -- Kupuje duze iloci wina rzadziej
   task body Restauracja is
      SkrzyniaWin : SkrzynkaNaWino(0 .. 19);
   begin
      loop
         Winiarnia.sprzedarzWina(SkrzyniaWin);
         delay RestauracjaKonsumpcja*MnorznikCzasu;
      end loop;
   end Restauracja;

   -- Kupuje male ilosci wina czesto
   task body SklepMonopolowy is
      SkrzyniaWin : SkrzynkaNaWino(0 .. 4);
   begin
      loop
         Winiarnia.sprzedarzWina(SkrzyniaWin);
         delay MonopolowyKonsumpcja*MnorznikCzasu;
      end loop;
   end SklepMonopolowy;



   task body Winiarnia is

      -- wyprodukowanie jednego wina 7, 3, 1 => 10 butelek wina
      function zrobWino return Wina.ButelkaWina is
         LosSmak : LosSmakuWina.Generator;
         LosProcenty : LosProcentyWina.Generator;
         Procenty : Integer;
         Smak : Wina.smaki;
      begin
         LosSmakuWina.Reset(LosSmak);
         LosProcentyWina.Reset(LosProcenty);
         Procenty := LosProcentyWina.Random(LosProcenty);
         Smak := LosSmakuWina.Random(LosSmak);
         return ( smak => Smak, zawartoscArkocholu => Procenty, wiek => 0);
      end zrobWino;

   begin
      Put_Line("   Winiarnia by Maciej Borzyszkowski 165407");
      New_Line;
      loop
         delay 2.0*MnorznikCzasu;

         select
            -- kotos chce kupic wino
            accept sprzedarzWina (SkrzyniaWin : out SkrzynkaNaWino) do
               Put_Line("-->Winiarnia: klient rzada wina w ilosci: " & Integer'Image(SkrzyniaWin'Length) & " butelek");
               if PiwnicaWin.ileButelekWPiwnicy >= SkrzyniaWin'Length then
                  for i in Integer range SkrzyniaWin'First .. SkrzyniaWin'Last loop
                     SkrzyniaWin(i) := PiwnicaWin.zabierzButelke;
                     delay 0.25*MnorznikCzasu;
                  end loop;
                  Put_Line("-->Winiarnia: zamowienie klienta zostalozrealizowane");
               else
                  Put_Line("-->Winiarnia: mamy za malo wina na to zamowienie");
               end if;
            end sprzedarzWina;
         else
            select
               -- przyjerzdza wczesniej zapowiedziana dostawa owocow
               accept dostawaOwocow (IloscKgOwocow : in Integer) do
                  if MagazynSurowcowy.dostawa(IleKgOwocow => IloscKgOwocow) then
                     Put_Line("-->Winiarnia: Przyjeto owoce: ");
                     Put_Line( Integer'Image(IloscKgOwocow) & " kg");
                  else
                     -- warunek awaryjny nie powinien wystapic
                     Put_Line("-->Winiarnia: Nie moge przyjac owocow");
                  end if;
               end dostawaOwocow;
            else
               select
                  -- przyjerzdza wczesniej zapowiedziana dostawa paczek cukru i drozdzy
                  accept dostawaCukruIDrozdzy (IloscPaczekCukru : in Integer; IloscDrozdzy : in Integer) do
                     if MagazynSurowcowy.dostawa(IlePaczekCukru => IloscPaczekCukru, IleDrozdzy => IloscDrozdzy) then
                        Put_Line("-->Winiarnia: Przyjeto Skladniki:");
                        Put_Line(Integer'Image(IloscPaczekCukru) & " Paczek Cukru");
                        Put_line(Integer'Image(IloscDrozdzy) & " Dozdzy");
                     else
                        -- warunek awaryjny nie powinien wystapic
                        Put_Line("-->Winiarnia: Nie moge przyjac cukru i drozdzy");
                     end if;
                  end dostawaCukruIDrozdzy;
                  -- ostatecznie jak nie ma kim sie zajec to robi wina
               else
                  Put_Line("-->Winiarnia: jest miejsce w piwnicy na 10 butelek?");
                  if(PiwnicaWin.PojemnoscPiwincyZWinami >= PiwnicaWin.ileButelekWPiwnicy + 10) then
                     Put_Line("-->PiwnicaWin: Mamy miejsce na 10 butelek");
                     if(MagazynSurowcowy.pobierzSurowce) then
                        Put_Line("-->Winiarnia: To do roboty");
                        for i in Integer range 1 .. 10 loop
                           PiwnicaWin.dodajButelke(zrobWino);
                           delay 0.5*MnorznikCzasu;
                           end loop;
                        Put_Line("-->Winiarnia: 10 Butelek wina do przodu");
                     else
                        -- jesli jest za malo surowcow nic nie robi
                        Put_Line("-->Winiarnia: No to czekamy na dostawe");
                     end if;
                  else
                     -- jesli jest za duzo butelek wina to nic nie robi
                     Put_Line("-->Winiarnia: Cos slabo idzie z ta sprzedarza");
                  end if;
               end select;
            end select;
         end select;
         -- informacje o winie i surowcach  + starzenie wina
         PiwnicaWin.starzenieWina;
         MagazynSurowcowy.stanMagazynu;
         PiwnicaWin.stanPiwnicy;
         New_Line;
      end loop;
   end Winiarnia;

begin
   null;
end Main;
