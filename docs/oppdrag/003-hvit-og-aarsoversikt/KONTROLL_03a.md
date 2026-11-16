# Kontroll av APP-HAA oppdrag 03 (hvit som standard og tydeligere årsoversikt)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-03`, commit 9525cd1, sammenlignet med 8cbbc2c.
Testet i ekte Chrome (`/usr/bin/google-chrome`, Playwright) mot lokal http.server på port 8097. Forrige commit (8cbbc2c) ble servert som kopi på port 8098 for å sammenligne.
fonts.googleapis.com, fonts.gstatic.com og docs.google.com ble blokkert. «Send svara» ble ikke trykket.
Ingen filer i repoet er endret (`git status` er tom). Skriptene og skjermbildene ligger i /home/claude/t03/kontroll/ (k1.py til k4.py, k2_out.json og k_*.png).

## Akseptkriterier

| Nr | Resultat | Bevis |
|---|---|---|
| A1 | BESTÅTT | Mørk-emulering er på (`matchMedia('(prefers-color-scheme: dark)')` = true), og ingenting er lagret. Da er `data-theme` = null, bakgrunnen er `rgb(236,234,228)` = #eceae4, knappen viser ☾ og color-scheme er light. Med lys-emulering blir resultatet det samme. |
| A2 | BESTÅTT | Et trykk på ☾ gir `data-theme="dark"`, bakgrunn `rgb(23,26,24)` og knappen ☀, og `ndb-vis` blir `{"t":"dark"}`. Valget står seg etter reload. Trykker man ☀ igjen, blir det lyst, og det står seg også etter reload. Settes mørk på igjen og man trykker #b-igjen på #takk, blir `data-theme` null, bakgrunnen #eceae4, knappen ☾ og `ndb-vis` fjernet. Det er fortsatt lyst etter reload. |
| A3 | BESTÅTT | Barna til `.stack` i #v-aaret kommer i denne rekkefølgen: h2, ingress, `#aar-sum`, `#t-mine-box`, h3 «Skjedde i 2026», hint, `#aar-ekte` (div.month med h3 per måned), `<details id="aar-demo">` (lukket som standard), deretter tilbake-knappen og lenken. |
| A4 | BESTÅTT | Egen telling av EKTE for Nærbø, alle 7 tema og Godt å vite = Nei takk: **Straks 3** (raudt farevarsel, oransje farevarsel, straumbrot Nærbø), **Snart 4** (Store Ring, Kviavegen, influensavaksine, fugleinfluensa) og **Godt 0**. Vigrestad-, Varhaug- og Jærbanen-sakene er riktig utelatt. Valgene ble gjort i UI (#b-start, Nærbø, alle tema, SMS / SMS dagen før / Nei takk, «Meld meg på (døme)», #ferdig og så #aaret). #aar-sum viser «Med vala dine i 2026»: 3 Straks SMS, 4 Snart SMS dagen før, 0 Godt å vite «ikkje sendt». Tallene stemmer, og lista viser de samme 7 sakene. |
| A5 | BESTÅTT | Uten valg viser oppsummeringen «I heile Hå i 2026» med 4 Straks, 5 Snart og 3 Godt (til sammen 12, likt egen telling), og hintet «Vel bygd og tema i starten …». Bryteren er skjult, og alle 12 ekte saker står i 6 månedsgrupper (Januar, April, Mai, Oktober, November, «Heile året»). |
| A6 | **IKKE BESTÅTT** (gjelder bare uk med A+) | Merkelappen står over teksten i både `.mline` og `.item`: én kolonne, samme venstrekant, og teksten er 309 px av 309. Målt `scrollWidth` på 375×812 er lik `innerWidth` (375) i nn, nb, en og pl, med og uten valg, med og uten A+, og med `<details>` åpen og lukket. **Unntaket er uk med valg og A+, der scrollWidth = 381.** Hele `.stack` blir 365 px bred og stikker 6 px ut. Forrige commit gir 375 under de samme forholdene, så feilen kom inn med denne endringen. Se funn 1 og k_uk_Aplus_val.png. |
| A7 | BESTÅTT | Jeg sammenlignet alle tekstnoder og aria-label/title i #v-aaret mellom nn og de andre språkene (102 noder med bryteren på og 174 med den av). Bare dette er likt på uk og pl: tallene, «SMS», stedsnavn (Nærbø, Vigrestad, Varhaug, Brusand, Ogna), kildenavn (Jærbladet, ha.no) og «2026». På en er i tillegg April, August, September og November like, men det er korrekt engelsk. På nb er det likt der bokmål og nynorsk skrives likt (Straks, Snart, Godt å vite, «SMS dagen før», «Skjedde i 2026», «Til starten», månedene, «Når som helst»), pluss sakstekster som er unntatt. All ny tekst er oversatt: overskrift, ingress, oppsummering, hint, «ikkje sendt», «Heile året», summary og hint i details. |
| A8 | BESTÅTT | Visningene start, bygd, tema, kanal, ferdig, svar, takk, aaret og lapp ble lastet med valg på alle 5 språk. I aaret ble details åpnet, bryteren trykket to ganger og ☾ trykket to ganger. I lapp ble en URL lagt inn. Start, aaret, lapp og bygd ble i tillegg testet uten valg med mørk-emulering. Det kom 0 pageerror. De eneste console error var 5 stk «Failed to load resource», og alle kom fra den blokkerte fonts.googleapis.com. |
| A9 | – | Denne rapporten. Det er ett middels funn innenfor oppdraget, så A9 er ikke oppfylt ennå. |

## Funn

| # | Alvor | Innenfor oppdraget | Funn |
|---|---|---|---|
| 1 | **Middels** | Ja (A6, ny `.sumrow`) | Siden blir bredere enn skjermen i oppsummeringen på ukrainsk med A+. `.sumrow` bruker `grid-template-columns: 2.4rem max-content 1fr`. Kolonnen med merkelappen («Корисно знати», 134 px) kan ikke brytes, og `1fr` har som minste bredde det lengste ordet («надсилається»). På 375 px med A+ blir kortet 365 px, scrollWidth 381 og hele `.stack` 6 px for bred, så siden kan scrolles sidelengs. På 360 og 320 px er det det samme for uk, og på 320 px med A+ gjelder det også pl (338). Uten A+ er alt OK på 375. Forslag til retting: la raden brytes, for eksempel `grid-template-columns: 2.4rem 1fr` med merkelapp og kanal under hverandre, eller `flex-wrap: wrap`. Alternativt `minmax(0,1fr)` sammen med `overflow-wrap: anywhere` på `.kan` og `white-space: normal` på badgen. Mål på nytt i uk og pl med A+ på 375 og 320. |
| 2 | Lav | Ja (bryteren skal være på som standard) | `berreMine` nullstilles ikke av «Start på nytt». Hvis person 1 slår av «Berre det som passar vala mine», ser person 2 i samme økt bryteren av og alle 12 sakene, selv om spec sier at den er på som standard. Målt: p1 aria-pressed=false, så #b-igjen og nye valg, og p2 aria-pressed=false med 12 saker. Språk og tema nullstilles allerede for neste person, så dette er inkonsekvent. Retting: sett `berreMine = true` i `reset()` eller i #b-igjen-handleren. Oppsummeringen påvirkes ikke, for den teller alltid etter valgene. |
| 3 | Lav (merknad) | Ja | Oppsummeringen endres ikke når bryteren slås av. Den viser fortsatt 3/4/0 «Med vala dine» mens lista viser alle 12. Det er rimelig etter spec, men verdt å vite når Oleiv tester. |

## Regresjoner sjekket uten funn

- Mørk modus: alle nye elementer (sumkort, details og summary, månedsoverskrifter) får mørke flater og lesbar tekst (k_aar_mork.png). OS-innstillingen påvirker ikke lenger siden, noe som er tilsiktet, og den gamle `matchMedia`-lytteren er fjernet uten feil.
- `ekteOk`-endringen (Nei takk skjuler Godt å vite) brukes bare i `visEkte` og `visSum`. Lista og tallene stemmer overens.
- `berreMine = true`: bryteren skjules uten valg (`valgjort()`), og med valg er den på. Av og på gir riktig liste (7 ↔ 12 ekte, 11 ↔ 26 oppdiktede).
- «Start på nytt» nullstiller språk, tema og A+ som før.
- `.mline` er endret fra to kolonner til én. Klassen brukes bare i #aar-body.

## Samlet dom

**IKKE GODKJENT ennå.** A1–A5, A7 og A8 er bestått. A6 feiler for ukrainsk med større tekst (6 px sidelengs overflyt), og det er et middels funn innenfor oppdraget. Etter retting av funn 1, og helst funn 2, holder det å kjøre en kort ny kontroll av A6 i alle språk med og uten A+ på 375 og 320 px.
