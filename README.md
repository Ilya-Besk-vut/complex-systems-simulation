# Simulace komplexních systémů (Bakalářská práce)

Tento repozitář obsahuje praktickou implementaci a simulační skripty vytvořené v rámci mé bakalářské práce s názvem **„Úvod do simulací komplexních systémů“**.

Projekt se zaměřuje na generování síťových struktur a simulaci dynamických procesů na těchto sítích.

## Rychlé odkazy
* **[Přečíst celou bakalářskou práci v archivu univerzity](https://www.vut.cz/studenti/zav-prace/detail/162316)** — *Zde naleznete teoretický a matematický základ, experimentální grafy a závěrečnou analýzu.*

---

## Struktura projektu a hlavní skripty

Všechny algoritmy jsou implementovány v prostředí **MATLAB**.

### Základní modely a generátory
* `BA.m` – Generuje bezškálové sítě Barabási–Albert pomocí mechanismu preferenčního připojování.
* `ER.m` – Generuje náhodné grafy Erdős–Rényi na základě pravděpodobnosti propojení hran.
* `SmalWorld.m` – Generuje sítě typu „Malý svět“ (Watts–Strogatz) pomocí přepojování hran.
* `Vaha.m` & `color.m` – Pomocné utility pro dynamické vážení hran a barvení uzlů grafu.

### Hlavní simulační skripty (`src/`)
* `main_opinions.m` – **Model polarizace názorů**. Simuluje dynamiku názorů ve skupině, demonstruje formování názorových klastrů a výsledný stav zobrazuje pomocí histogramů.
* `main_kuramoto.m` – **Kuramotův model synchronizace**. Vyhodnocuje a porovnává závislost řádového parametru na síле vazby mezi oscilátory v topologiích ER a BA sítí.
* `test_BA.m` – Validační skript pro ověření a vykreslení bezškálových vlastností BA algoritmu oproti teoretickému mocninnému rozdělení $k^{-3}$.
* `main_economy.m` – **Simulace vlastního komplexního socioekonomického systému**. Modeluje interakce mezi městy na základě jejich bohatství, mírumilovnosti, obchodních cest a válečných konfliktů. Cílem tohoto modelu bylo ukázat evoluci na dvouvrstvé síti, nikoliv se pokusit vysvětlit sociálně-ekonomické chování.

---

*Poznámka: Vzhledem k tomu, že veškeré výsledné grafy, podrobné nastavení parametrů a analytické závěry jsou detailně dokumentovány v textu samotné práce, slouží tento repozitář primárně jako open-source archiv zdrojového kódu.*
