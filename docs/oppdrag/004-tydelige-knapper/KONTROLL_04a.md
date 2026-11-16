# Kontroll 04a av APP-HAA oppdrag 04 (tydelige knapper til og fra årsoversikten)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-04`. Kontrollert endring: `git diff 0a49c6a fc422f2` (index.html + spec).

Testet i ekte Chrome (`/usr/bin/google-chrome --no-sandbox`, Python Playwright), servert med http.server på 8113 (og 8114 for én ekstra måling). fonts.googleapis.com og fonts.gstatic.com ble blokkert (35 kall), alle forespørsler til docs.google.com ble blokkert (0 kall forsøkt). «Send svara» ble ikke trykket; #takk ble nådd via adressen bare for å teste «Start på nytt». All navigasjon til og fra #aaret gikk med klikk på knappene, og telefonens tilbakeknapp ble testet med `page.go_back()`/`go_forward()`. Valg ble gjort i UI: Nærbø, alle 7 tema, Godt å vite = Nei takk.

Merknad: HEAD på grenen er nå c06b922 («rett klokkeslett i spec»). `git diff fc422f2 HEAD` endrer bare én linje i spec.md, så index.html er identisk med fc422f2. Jeg har ikke endret noe i repoet (`git status` er tom).

Skript, rådata og skjermbilder: /home/claude/t03/k04a/ (k04a.py, chk.py, k04a_out.json, *.png).

## Resultat

| Nr | Resultat | Bevis |
|---|---|---|
| B1 | **BESTÅTT** | 375 px, nn. #start: `A.btn.ghost`, 343 × 55,5 px, lik bredde som «Prøv det» (343) og stack (343). #ferdig: `A.btn.ghost`, 343 × 81 px (to linjer), lik bredde som «Fire korte spørsmål» (343 × 53,5). Gjennomsiktig bakgrunn, omriss og tekst i accent, ingen understrek, så hovedknappen er fortsatt tydeligst (b1_start.png, b1_ferdig.png). |
| B2 | **BESTÅTT** | Klikk fra start: begge knappene «Tilbake til starten», `data-fra=start`, «Til starten» har `display:none`. Toppknappen → hash tom, v-start vises. Bunnknappen → det samme. |
| B3 | **BESTÅTT** | Klikk fra #ferdig: begge «Tilbake til veka di», «Til starten» vises. Toppknappen → #ferdig, bunnknappen → #ferdig (v-ferdig vises begge ganger). |
| B4 | **BESTÅTT** | Ny kontekst, `goto(#aaret)`: begge «Tilbake til starten», «Til starten» skjult, klikk → start. Også en andre fane i samme kontekst etter at første fane hadde vært innom → samme resultat. |
| B5 | **BESTÅTT** | For hvert av nn, nb, en, uk, pl: startknapp, ferdigknapp, begge tilbakeknapper fra start og fra ferdig og «Til starten» er lik ordlisten i index.html (5 av 5 ok). Språkbyte mens #aaret er åpen: fra ferdig gjennom alle fem språk og tilbake (30 bytter), og fra start gjennom alle fem. Alle ok, og hashen blir stående på #aaret. |
| B6 | **BESTÅTT** | 20 kjøringer: 375 og 320 px × A+ av/på × 5 språk. #ferdig, #aaret fra start, #aaret fra ferdig og #aaret med åpen `<details>`: `documentElement.scrollWidth` og `body.scrollWidth` ≤ innerWidth i alle 80 målinger, ingen element utenfor kanten, ingen knapp med avkuttet tekst. Toppknappen er 175–315 px bred og bryter pent på 320 + A+ (høyeste 94 px, to linjer). |
| B7 | **BESTÅTT** | 0 pageerror. De 35 `console error` er «Failed to load resource: net::ERR_FAILED». Det er nøyaktig like mange som blokkerte font-kall, og ingen andre forespørsler feilet. |

## Ekstra sjekker

| Sjekk | Resultat |
|---|---|
| Telefonens tilbakeknapp fra #aaret (kom fra start) | OK. Tilbake til start, URL `/#`. |
| #ferdig → #aaret → tilbake → #aaret igjen | OK. Tilbake gir v-ferdig. Klikk inn igjen gir «Tilbake til veka di». Tilbake + fram gir det samme. |
| #aaret (fra start) → bytt til en → tilbakeknapp | OK. Start vises på engelsk, «See a whole year of examples». Fra ferdig på alle språk: tilbake → #ferdig på nytt språk, inn igjen → riktig tekst. |
| «Tilbake til veka di» skal ikke vises uten valg | OK i tre tilfeller: (1) #ferdig åpnet uten valg (viser bygd), så #aaret → «Tilbake til starten». (2) Valg gjort, tilbake med telefonen til #tema, alle tema fjernet, fram til #ferdig (viser bygd) og #aaret → «Tilbake til starten». (3) #takk → «Start på nytt» → start → #aaret → «Tilbake til starten». |
| Mørk modus (☾) | OK. Ghost-knappene har tekst og omriss #8fc7a5 på #171a18, «Til starten» er #b3bab4. Ser riktig ut på start, ferdig og i #aaret, øverst og nederst (mork_*.png). |
| Regresjon fra oppdrag 03 | Ingen. Uten valg: «I heile Hå i 2026» 4/5/3, hint, bryter skjult, 12 ekte saker. Med valg: 3 SMS / 4 SMS dagen før / 0 ikkje sendt, bryter på, 7 saker. Bryter av → 12, på → 7. Details åpner (11 linjer) og lukker. Rekkefølgen er toppknapp, h2, ingress, oppsummering, bryter, h3, hint, ekte saker, details, bunnknapp, «Til starten». |

## Funn

| # | Alvor | Innenfor oppdraget | Funn |
|---|---|---|---|
| 1 | Lav | Ja | Tilbakeknappene i #aaret bruker `go()`, som legger til en ny historikkoppføring i stedet for å gå tilbake. Etter #ferdig → #aaret → «Tilbake til veka di» sender telefonens tilbakeknapp deg til #aaret igjen, ikke til #kanal. Gjentas det, går historikken fram og tilbake mellom #ferdig og #aaret. Dette ble målt: fire trykk på tilbake ga aaret, ferdig, aaret, ferdig. Ingen feil vises, og knappen gjør det spec sier. Mulig forbedring: bruk `history.back()` når forrige oppføring er den samme siden som `data-fra`. Kan legges i IDEBANK. |
| 2 | Lav | Nei, fantes før (likt funn 1 i 03b) | Startsiden er for bred på 320 px med A+ på uk (335 px) og pl (321 px). Den nye knappen på startsiden følger bare stackbredden og gjør ikke overflyten større. Tallene er de samme som i kontroll 03b. B6 gjelder bare #ferdig og #aaret. |

## Samlet dom

**GODKJENT.** B1–B7 er bestått. Kontrollen fant ingen høye eller middels funn, så B8 er oppfylt fra denne kontrollens side. Funn 1 er lav og innenfor oppdraget og kan avgjøres med en idé i IDEBANK. Funn 2 ligger utenfor oppdraget og var kjent fra før.

## Etterpå (hovedøkta, 16.11)
Funn 1 (lav, innenfor) er rettet. Tilbakeknappene bruker `history.back()` når forrige side er den knappen peker til, og ellers `go()`. Testet: #ferdig → #aaret → «Tilbake til veka di» gir #ferdig, og telefonens tilbakeknapp etterpå gir #kanal. Åpnes #aaret direkte, går knappen til start. Ingen JS-feil.
