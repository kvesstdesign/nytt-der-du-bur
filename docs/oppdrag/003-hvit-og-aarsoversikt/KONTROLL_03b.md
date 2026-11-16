# Kontroll 03b av APP-HAA oppdrag 03 (retting etter 03a)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-03`, HEAD 7e1fe1c. Rettingen (`git diff 9525cd1 7e1fe1c -- index.html`) gjør `.sumrow` om fra grid (`2.4rem max-content 1fr`) til `flex-wrap: wrap`, gir `.kan` `min-width:0; overflow-wrap:anywhere`, og setter `berreMine = true` i #b-igjen-handleren.

Testet i ekte Chrome (`/usr/bin/google-chrome --no-sandbox`, Python Playwright). fonts.googleapis.com, fonts.gstatic.com og alle forespørsler til docs.google.com ble blokkert (27 + 40 blokkerte font-kall, 0 kall til docs.google.com). «Send svara» ble ikke trykket; #takk ble nådd via adressen.

Avvik fra bestillingen:
- Port 8098 var opptatt av en http.server som ble stående igjen etter kontroll 03a (serverer /home/claude/t03/kontroll/base). Den ble ikke stoppet. Repoet ble servert på 8094 i stedet.
- Commit 8cbbc2c (før oppdrag 03) og 9525cd1 (før retting) ble pakket ut med `git archive` til /home/claude/t03/gammel03b og /home/claude/t03/k3b/f03a, i stedet for `git worktree add`, så .git i repoet ikke ble rørt. Servert på 8099 og 8096.
- Jeg har ikke endret noe i repoet. `git status` viser likevel `M docs/STATUS.md` (+2 linjer, endret 01:44:59, under kontrollen). Den endringen kommer ikke fra denne kontrollen, sannsynligvis fra hovedøkta.

Skript, rådata og skjermbilder: /home/claude/t03/k3b/ (k3b.py, k3b_start.py, k3b_sum.py, k3b_out.json, *.png).

## Resultat

| Nr | Resultat | Bevis |
|---|---|---|
| A6 (funn 1 fra 03a) | **BESTÅTT** | 80 målinger på 7e1fe1c: 375 og 320 px × nn, nb, en, uk, pl × med og uten A+ × med valg (Nærbø, alle 7 tema, Godt å vite = Nei takk, gjort i UI #bygd → #tema → #kanal → #n-kanal) og uten valg × `<details>` åpen og lukket. `scrollWidth` og `body.scrollWidth` er ≤ `innerWidth` i alle 80 (største avvik 0). Samme skript på 9525cd1 gir 8 overflyter (uk 375 A+ = 381, uk 320 = 322, uk 320 A+ = 381, pl 320 A+ = 338), så testen fanger feilen og rettingen fjerner den. Oppsummeringen bryter nå raden: kanalteksten («SMS напередодні», «не надсилається») legger seg på egen linje under tallet (sum_uk_320_Aplus.png, sum_uk_375_Aplus.png). |
| A6, andre visninger | BESTÅTT innenfor oppdraget | 320 px, A+, med valg, uk og pl: bygd, tema, kanal, ferdig, svar, takk, lapp og aaret har scrollWidth = 320. **start** har overflyt: uk 335, pl 321 (h1, ingress og hovedknapp går ut over kanten). 8cbbc2c gir nøyaktig de samme tallene for start, så det fantes før oppdrag 03. Bare 320 + A+ i uk/pl er rammet; 375 px og alle språk uten A+ er OK, i både gammel og ny versjon. 8cbbc2c hadde også overflyt i aaret på 320 + A+ (uk 354, pl 342), og den er nå borte. |
| Funn 2 fra 03a | **RETTET** | I én og samme side (1 navigation, ingen omlasting): valg → #aaret, bryter på (7 ekte saker) → trykk #t-mine, aria-pressed=false og 12 saker → #takk → #b-igjen (synlig) → hash tom (start) → nye valg i UI → #aaret: aria-pressed=**true**, 7 ekte saker. |
| A1 | BESTÅTT | Mørk-emulering (`prefers-color-scheme: dark` = true), ingenting lagret: `data-theme` = null, bakgrunn `rgb(236,234,228)` = #eceae4, knappen ☾. |
| A4 | BESTÅTT | #aar-sum viser «Med vala dine i 2026»: 3 Straks (SMS), 4 Snart (SMS dagen før), 0 Godt å vite («ikkje sendt»), 7 ekte saker i lista. Egen telling fra EKTE-tabellen i kildeteksten gir det samme: Straks = raudt farevarsel, oransje farevarsel, straumbrot Nærbø; Snart = Store Ring, Kviavegen, influensavaksine, fugleinfluensa; Godt = 0 (Nei takk). |
| A5 | BESTÅTT | Uten valg: «I heile Hå i 2026» 4/5/3 (= 12, likt egen telling), hintet «Vel bygd og tema i starten …» vises, bryteren er skjult og alle 12 ekte saker står i lista. |
| A8 | BESTÅTT | Alle 9 visninger på alle 5 språk med valg. I aaret ble details åpnet og bryter, ☾ og A+ trykket to ganger hver. I lapp ble en URL lagt inn. Pluss alle A6-kjøringene. 0 pageerror. De eneste console error er 17 × «Failed to load resource: net::ERR_FAILED». `requestfailed` viser at alle kommer fra blokkerte fonts.googleapis.com. |

## Funn

| # | Alvor | Innenfor oppdraget | Funn |
|---|---|---|---|
| 1 | Lav | **Nei**, fantes før oppdrag 03 (8cbbc2c gir likt resultat) | Startsiden blir for bred på 320 px med A+ på ukrainsk (335 px) og polsk (321 px). Overskrift, ingress og «Prøv det»-knappen går ut over kanten. Gjelder bare svært smale telefoner med større tekst. Bør tas som eget lite oppdrag eller legges i IDEBANK. |
| 2 | Lav (merknad) | Ja, men kosmetisk | Når raden i oppsummeringen bryter (uk og pl, smal skjerm eller A+), legger kanalteksten seg helt til venstre under tallet, og ikke under merkelappen. Den er lesbar og ingenting stikker ut, men den hører litt mindre tydelig til raden sin. Dette er ikke et krav i A6. Om ønskelig kan `.kan` få innrykk når den bryter. |

Funnene fra 03a (middels A6 og lav «Start på nytt») er rettet. Det er ikke kommet regresjoner i A1, A4, A5 eller A8.

## Samlet dom

**GODKJENT.** Kontrollen fant ingen høye eller middels funn innenfor oppdraget, så A9 kan regnes som oppfylt sammen med 03a. Det eneste overflytfunnet (startsiden, 320 px + A+, uk/pl) fantes før oppdrag 03 og ligger utenfor oppdraget.
