# APP-HAA oppdrag 05: «Tilpass»-panel og retting av UU-funn

Skrevet 2026-11-16 av APP · APP-HAA 01 (skyøkta i containeren). Bestilt av Oleiv 16.11 kl. 10:07: «Legg også til mulighet for folk til å endre tekst, ut fra om de er fargeblinde, eller har dysleksi … Ta en sjekk med andre om vi treffer.»

Grunnlag: den uavhengige UU-gjennomgangen (UU_GJENNOMGANG.md i denne mappa). Den brukte axe-core i 200 kombinasjoner og manuell test, og fant ingen høye funn, men fem middels. Forskning viser at mer luft mellom bokstaver, ord og linjer hjelper ved dysleksi, mens egne dysleksiskrifter ikke har vist effekt. Derfor lages det ingen dysleksiskrift.

## Omfang

1. Knappene ☾ og A+ øverst erstattes av én knapp med synlig tekst: «Aa Tilpass». Den åpner et panel med tre valg:
   - Tekststorleik: Normal, Større eller Størst (100, 125 eller 150 %)
   - Luftig tekst: Av eller På. Verdiene er fra WCAG 1.4.12: bokstavavstand 0,12em, ordavstand 0,16em og linjeavstand 1,8.
   - Bakgrunn: Lys eller Mørk
   Valgene huskes på telefonen. «Start på nytt» nullstiller dem. Esc og «Ferdig» lukker panelet og sender fokus tilbake til knappen. Gamle lagrede valg fra før (`s: true`) fungerer fortsatt.
2. Fargeblindhet: merkelappene får symbol i tillegg til farge, for alle: ▲ Straks, ● Snart, ■ Godt å vite. Symbolet leses ikke opp av skjermleser. Merkelappene blir større (0,9rem i stedet for 0,8rem).
3. UU-funn som rettes:
   - Språkbytte flytter ikke lenger fokus og ruller ikke (3.2.2).
   - Tilpass-knappen har synlig tekst og ingen aria-label som avviker fra den (2.5.3, avløser A+).
   - Månedene i årsoversikten er h4 under «Skjedde i 2026» (1.3.1).
   - «DØME» er endret til «Døme» på alle språk.
4. Siden blir aldri bredere enn skjermen, heller ikke med Størst og Luftig tekst på 320 px.

## Utenfor omfang (lagt i IDEBANK)

- Radioknapp-semantikk i stedet for av/på-knapper for enkeltvalg. Av/på-knapper med aria-pressed oppfyller 4.1.2. Radiogruppe krever piltast-navigasjon og er et eget oppdrag.
- Tilgjengelighetserklæring. Den kreves først for en ekte kommunal tjeneste.

## Akseptkriterier

| Nr | Kriterium |
|---|---|
| C1 | «Aa Tilpass» åpner og lukker panelet. aria-expanded stemmer, og Esc og «Ferdig» lukker og gir fokus tilbake. |
| C2 | Hvert valg virker, vises med aria-pressed og ✓, huskes etter reload og nullstilles av «Start på nytt» |
| C3 | Luftig tekst gir letter-spacing 0,12em, word-spacing 0,16em og line-height ≥ 1,5 på brødtekst |
| C4 | Merkelappene har ▲, ● og ■. Skjermleserens navn på merkelappen er bare teksten. |
| C5 | Språkbytte flytter ikke fokus og ruller ikke |
| C6 | Ingen horisontal overflyt på 375 og 320 px, på nn, nb, en, uk og pl, med alle tekststørrelser, med og uten luftig tekst, i alle visninger og med panelet åpent |
| C7 | axe-core (WCAG 2.1 A/AA) gir 0 brudd i alle visninger på alle språk, i lys og mørk, med Størst og med luftig tekst |
| C8 | Ingen JS-feil |
| C9 | Uavhengig kontroll uten høye eller middels funn innenfor oppdraget |
