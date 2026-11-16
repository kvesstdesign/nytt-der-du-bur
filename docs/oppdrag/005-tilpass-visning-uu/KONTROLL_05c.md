# Kontroll 05c av APP-HAA oppdrag 05 (Tilpass-panel og UU-retting)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-05`, commit d75597a (rettingen etter 05b, diff mot ee5563b). Jeg har ikke endret noe i repoet (`git status` er tom).

Testet i ekte Chrome (`/usr/bin/google-chrome --no-sandbox`, Chrome 153) med Python Playwright. Repoet ble servert med http.server på 127.0.0.1:8171. Fonts (fonts.googleapis.com/gstatic) og alle kall til docs.google.com ble blokkert, og alt annet enn den lokale serveren ble avvist. Siden gjorde 0 forsøk mot docs.google.com. «Send svara» ble aldri trykket. #takk ble bare nådd via adressen. Chrome selv prøvde å nå accounts.google.com (bakgrunnstjeneste i nettleseren), og proxyen avviste det.

Skript, rådata og skjermbilder ligger i /home/claude/t03/k05c/. Skriptene fra 05b er gjenbrukt med to endringer. c6 sjekker nå at panelet er synlig bare når det skal være det, og at klassen `stor` er satt. Ordbrudd telles av et nytt skript, brot2.py, som skiller mellom orddeling med bindestrek og harde brudd. Det deler først ordet der linjen skifter. Så slår det av `overflow-wrap` på foreldreelementet og ser om ordet fortsatt deles på samme sted. Hvis ja, er det orddeling (hyphens:auto). Hvis nei, er det et hardt brudd. Delingspunktet blir funnet med prefiks-Range, og jeg sjekket det mot et skjermbilde (hyph_test.png). Selvtesten av overflytsmålingen (to innlagte feil) fant begge feilene.

Viktig om miljøet: Chrome i denne containeren deler ord for nn, nb, en og uk, men **ikke for pl** (målt i hyph.py). På ekte telefoner avhenger orddelingen av nettleser og språk.

## 1. Funn A og B fra 05b

| Funn 05b | Status i d75597a | Bevis |
|---|---|---|
| A (høy): panelet alltid synlig | **Rettet.** Regelen `.tilpass[hidden]{display:none}` står før `.tilpass{display:grid}` og vinner fordi den er mer spesifikk. Jeg testet 120 sidelastinger: 10 visninger × 375/320 × nn/uk × 3 lagrede oppsett (ingen, Mørk+Størst+luftig, Større). Etter lasting, etter navigering og etter reload var panelet `display:none` og 0 px høyt hver gang. elementFromPoint traff det aldri, aria-expanded var false, og panelet var ikke i tilgjengelighetstreet. Ingen av 45 Tab-trykk havnet i panelet, verken før eller etter reload. | a.py, a.json, c1_lukka_375_nn.png |
| B (middels): to kolonner ved Større, 43 ord brutt midt i ordet | **Rettet.** Ny klasse `stor` (Større og Størst) gir én kolonne. På startsiden er det én kolonne ved Større, Størst og luftig, på alle språk og bredder. To kolonner er det bare ved Normal uten luftig tekst, og der er tekstkolonnen 101–189 px. Gamle lagrede valg (`s:true`, `s:"1"`) gir også `stor` og én kolonne. Harde brudd i hele matrisen gikk ned fra 54 (05b) til **2**, og begge er samme ord: «przeciwpowodzi\|owe» (pl, årsoversikten, 320 px, Størst+luftig). Grunnen er at Chrome mangler orddeling for pl. Alle de andre 3060 bruddene er orddeling med bindestrek på gyldige steder («høy-ringar», «попе-редження»). | brot2.py/.out/.json, start_levels_320_*_s1_l0.png, aaret_320_pl_s2_l1_hardt_brot.png |

Matrisen for orddeling har 1200 tilstander: 10 visninger × 375/320 × 5 språk × 3 størrelser × luftig av/på, med panelet både lukket og åpent. Språket ble bekreftet i alle tilstandene.

## 2. Akseptkriterier og regresjon

| Nr | Resultat | Bevis |
|---|---|---|
| C1 | **BESTÅTT** (målt visuelt) | Panelet ble målt etter hver handling med getComputedStyle, rektangel og elementFromPoint. Musen åpner og lukker. Enter og Space åpner, og fokus går til «Normal». Esc i panelet, Esc på knappen, «Ferdig» med mus og «Ferdig» med Enter lukker alle panelet (`display:none`, 0 px) og gir fokus tilbake til «Aa Tilpass». Tab etter lukking går til «Prøv det», altså ikke inn i panelet. aria-expanded stemmer hele veien. | a.out (seq), func.out, c1_ope_375_nn.png |
| C2 | BESTÅTT | Alle sju valgene gir aria-pressed og ✓ bare på det aktive valget, med 16/20/24 px. Valgene huskes etter reload, og panelet er da lukket. Gamle valg (`s:true/false/7`, ødelagt JSON) gir ingen feil. «Start på nytt» med panelet åpent på #takk nullstiller valg, språk og `ndb-*`, lukker panelet og setter fokus på h-start. | func.json, a.json |
| C3 | BESTÅTT | 60 elementtyper: ≥ 0,12em / 0,16em / 1,8. Merkelappene har 0,06em med vilje, som før. | c3.out |
| C4 | BESTÅTT | ▲ ● ■ med `/ ""` i 14,4 px. Det er 3 på startsiden og 22 i årsoversikten. Ingen AX-node har symbolet i navnet. | func.out |
| C5 | BESTÅTT | Fokus blir alltid på #langsel, og hashen er uendret. Med `overflow-anchor:none` er scrollY uendret i alle 8 visningene, bortsett fra der siden blir kortere enn scrollY. Det er altså nettleserens scroll-anker som flytter siden, ikke koden. | c5.out, c5c.py |
| C6 | **BESTÅTT** | 1200 målinger (samme matrise som i 05b) gir 0 horisontal overflyt, 0 tekst utenfor sin boks og 0 feil oppsett. Panelet var synlig i nøyaktig de målingene der det skulle være åpent. Lavfunnene C (`.mline` i årsoversikten) og D (`.lapp` 3 px for bred) fra 05b er borte. Det er bekreftet med åpen details på alle språk og bredder (inv3.py, inv5.py). | c6.out, c6.json |
| C7 | **BESTÅTT** | axe-core med WCAG 2.0/2.1 A og AA i 339 kjøringer: 11 visninger × 5 språk × lys/mørk × (Normal, **Større**, Størst+luftig), og i tillegg 9 med mørk-emulering. Resultatet er 0 brudd. | c7.out, c7.json |
| C8 | BESTÅTT | Ingen pageerror i noe skript. Alle console-feilene er de blokkerte fontene (678 = 678). | c7.out, func.out |
| C9 | **OPPFYLT** | Ingen høye eller middels funn. | under |
| Årsoversikten | OK | Uten valg: 4/5/3 og 12 saker, med h2 > h3 > h4. Fra #ferdig: 4/4/2, og bryteren gir 10 eller 12 saker. | reg.out |
| Tilbake og historikk | OK | Toppknappen går til start. Bunnknappen fører til #ferdig, og historikken går #ferdig → #kanal → #tema. | reg.out |
| Lys som standard | OK | Med mørk-emulering er bakgrunnen rgb(236,234,228) og «Lys» er markert. «Mørk» gir rgb(23,26,24). | func.out |

## Funn

| # | Alvor | Innenfor | Funn |
|---|---|---|---|
| F1 | Lav | Ja (bivirkning av rettingen av B) | `hyphens:auto` står på `body` og gjelder derfor all tekst i alle størrelser, også Normal. Ved standardvisning (375 px, nn, Normal) var det 0 delte ord i 05b. Nå er det 1,8 orddelinger per side, for eksempel «kokevar-sel» og «høy-ringar» på startsiden, «Vig-restad» og «Jærbla-det» (stedsnavn og kildenavn) i årsoversikten, og «bok-stavar» i hjelpeteksten om dysleksi i panelet. Delingene er riktige og har bindestrek, men de endrer utseendet for alle og ikke bare der det trengs. Forslag hvis Oleiv vil: begrens orddelingen til `html.stor`/`html.luft` eller smale skjermer, og sett `hyphens: manual` på overskrifter, merkelapper, knapper og kildenavn. |
| F2 | Lav | Ja | Ett hardt brudd er igjen: «przeciwpowodzi\|owe» (pl, årsoversikten, 320 px, Størst+luftig). Chrome har ikke orddeling for polsk, så `overflow-wrap` bryter ordet uten bindestrek. Det er et 17 tegn langt ord i den mest ekstreme innstillingen, og det går ikke utenfor boksen. Akseptabelt. |
| F3 | Info | – | Orddelingen avhenger av nettleser og språk (her: nn, nb, en og uk ja, pl nei). Oleiv bør se på startsiden med Større på egen telefon. |

## Samlet dom

**GODKJENT.** A og B er rettet. Panelet er skjult, 0 px høyt og utenfor Tab-rekkefølgen og tilgjengelighetstreet ved lasting og etter reload, i alle visningene. Det åpnes og lukkes riktig med mus, Enter, Space, Esc og «Ferdig». Startsiden har én kolonne ved Større, Størst og luftig, og de harde ordbruddene gikk ned fra 54 til 2 (ett polsk ord). C1–C8 er bestått: C6 gir 0 overflyt i 1200 målinger, og C7 gir 0 axe-brudd i 339 kjøringer. Det er ingen regresjon i årsoversikten, historikken, «Start på nytt» eller lys standard. Det gjenstår bare to lave funn (F1: orddeling overalt, også ved Normal; F2: ett polsk ord). Begge kan tas som idé eller avgjøres av Oleiv. Ingen av dem stopper merge.
