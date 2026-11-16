# APP-HAA oppdrag 04: tydelige knapper til og fra årsoversikten

Skrevet 2026-11-16 09:25 av APP · APP-HAA 01 (skyøkta i containeren). Bestilt av Oleiv 16.11 kl. 09:18.

## Hvorfor

Oleiv testet på telefonen og så at lenka «Sjå kva du ville fått gjennom eit heilt år» ikke ser ut som noe man kan trykke på. Mange eldre i kommunen vil ikke finne den. Han vil ha en ordentlig knapp, slik som «Fire korte spørsmål», og en knapp som tar deg tilbake til siden du kom fra.

## Omfang

1. Lenkene til #aaret på startsiden og på «Slik kunne det sett ut for deg» (#ferdig) blir knapper i full bredde og samme størrelse som «Fire korte spørsmål». De har omriss i stedet for fylt farge, så hovedknappen fortsatt er tydeligst. Det valget er tatt av AI på fullmakt.
2. Årsoversikten husker hvor du kom fra. Den har en tilbakeknapp øverst og en nederst, og begge går dit:
   - fra #ferdig: «Tilbake til veka di»
   - fra start, eller hvis siden er åpnet direkte: «Tilbake til starten»
   - fra andre steder: «Tilbake»
   Lenka «Til starten» vises bare når tilbakeknappen ikke allerede går til starten.
3. Nye tekster finnes på fem språk.

## Akseptkriterier

| Nr | Kriterium |
|---|---|
| B1 | Lenkene til #aaret på #start og #ferdig er knapper (`a.btn`) med full bredde og minst 48 px høyde |
| B2 | Fra start: begge tilbakeknappene sier «Tilbake til starten» og går til start. «Til starten» er skjult. |
| B3 | Fra #ferdig: begge tilbakeknappene sier «Tilbake til veka di» og går til #ferdig |
| B4 | Når #aaret åpnes direkte i en ny fane, går tilbakeknappen til start |
| B5 | Tekstene er riktige på nn, nb, en, uk og pl, også etter språkbytte mens #aaret er åpen |
| B6 | Ingen horisontal overflyt på 375 og 320 px, med og uten A+, på alle språk, i #ferdig og #aaret |
| B7 | Ingen JS-feil |
| B8 | Uavhengig kontroll uten høye eller middels funn innenfor oppdraget |
