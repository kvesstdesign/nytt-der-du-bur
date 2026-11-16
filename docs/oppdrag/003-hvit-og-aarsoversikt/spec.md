# APP-HAA oppdrag 03: hvit som standard og tydeligere årsoversikt

Skrevet: 2026-11-16 01:35 av APP · APP-HAA 01 Hå kommune uten Facebook (skyøkt, i containeren)

Godkjent av Oleiv 16.11 kl. 01:31: «Følg opp selv, og gjennomfør. Du har min aksept.» Det dekker også merge til main etter kontroll, ettersom Pages bare bygger main.

Valg tatt av AI på fullmakt, ikke sett av Oleiv: alternativ 1 av tre for årsoversikten, det med oppsummering øverst og ekte saker først.

## Hvorfor

Oleiv testet på telefonen 16.11 kl. 01:30 og fant to ting:
1. Siden skal være hvit som standard. I dag følger den telefonens mørk/lys-innstilling.
2. Årsoversikten (#aaret) gjør det vanskelig å se hvordan et år ville sett ut. Det er tre grunner til det:
   - Lista er lang, og man må lese alt.
   - Merkelappene står i en egen kolonne, så teksten blir trang på mobil.
   - De oppdiktede eksemplene står øverst, mens de ekte sakene fra 2026 havner nederst.

## Omfang

1. **Hvit som standard.** Lys variant med sterk kontrast gjelder når `data-theme` ikke er satt, uansett hva telefonen er innstilt på. Knappen ☾/☀ og valget som huskes (`ndb-vis`), virker som før.
2. **Ny rekkefølge i årsoversikten:**
   - overskrift «Eit år i Hå» og en kort ingress
   - en oppsummeringskort: hvor mange Straks, Snart og Godt å vite naboen ville fått fra de ekte sakene i 2026 med sine valg, og hvilken kanal hvert nivå kommer på. Uten valg vises tallene for hele Hå, med et hint om å velge bygd og tema.
   - bryteren «Berre det som passar vala mine», som er på som standard når valgene er gjort
   - de ekte sakene fra 2026 gruppert per måned, med merkelappen over teksten
   - de oppdiktede eksemplene i en sammenleggbar boks («Vis oppdikta døme …»), med merkelappen over teksten
3. Godt å vite med «Nei takk» telles ikke og vises ikke under «Berre det som passar vala mine», på samme måte som for de oppdiktede sakene.
4. All ny tekst finnes på alle fem språk (nn, nb, en, uk, pl).

## Utenfor omfang

- nye saker
- endringer i skjemaet eller sendingen
- endringer i andre visninger

## Akseptkriterier

| Nr | Kriterium | Hvordan det sjekkes |
|---|---|---|
| A1 | Uten lagret valg og med `prefers-color-scheme: dark` vises lys variant: bakgrunn `#eceae4` og knappen ☾ | nettleser med mørk-emulering |
| A2 | ☾ gir mørk variant og huskes etter omlasting. «Start på nytt» gir lys igjen. | nettleser |
| A3 | Rekkefølgen i #aaret er: oppsummering, bryter, ekte saker gruppert per måned, sammenleggbare oppdiktede eksempler | DOM-sjekk |
| A4 | Med Nærbø + alle tema + Godt å vite = Nei takk viser oppsummeringen riktige tall. Tallene kontrolleres mot en uavhengig telling av EKTE, og Godt å vite er 0. | jsdom/nettleser med eigen telling |
| A5 | Uten valg viser oppsummeringen tallene for hele Hå (alle 12 ekte saker) og hintet | DOM-sjekk |
| A6 | Ingen merkelapp står i egen kolonne i #aaret. Teksten bruker hele bredden på 375 px, og ingenting stikker ut horisontalt. | skjermbilde 375×812, scrollWidth |
| A7 | All ny tekst er oversatt på nb, en, uk og pl. Ingen nynorsk står igjen i #aaret på de andre språkene, bortsett fra stedsnavn, kildenavn og saksteksten. | DOM-sjekk per språk |
| A8 | Ingen JS-feil i konsollen i noen visning på noe språk | nettleser |
| A9 | Uavhengig kontroll (en egen agent som ikke har skrevet koden) uten høye eller middels funn innenfor oppdraget | kontrollrapport i denne mappa |
