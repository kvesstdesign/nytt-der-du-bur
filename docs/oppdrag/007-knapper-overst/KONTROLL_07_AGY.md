> AGY-modell: gemini-4-argon-high (runde 07)

# Kontroll av APP-HAA oppdrag 07: knappene øverst på «Slik kunne det sett ut for deg»

## Akseptkriterier
| # | Kriterium | PASS / FAIL / KAN IKKE AVGJØRES | Begrunnelse med fil:linje |
|---|---|---|---|
| K1 | På #ferdig er rekkefølgen: overskrift, «Du valde …», «Seks korte spørsmål», «Sjå kva du ville fått gjennom eit heilt år», Straks, Snart, e-posten, «Seks korte spørsmål» | PASS | I `index.html:325-334` (`#v-ferdig .stack`) er DOM-rekkefølgen: `<h2 id="h-ferdig">` (326), `<p class="lead" id="t-val">` (327, fylles med «Du valde …» i `renderFerdig()` på `index.html:1078-1079`), `<button class="btn" id="n-ferdig-topp">Seks korte spørsmål</button>` (328), `<a class="btn ghost" href="#aaret">Sjå kva du ville fått gjennom eit heilt år</a>` (329), `#p-straks` (330), `#p-snart` (331), `#p-mail` (332), `<button class="btn" id="n-ferdig">Seks korte spørsmål</button>` (333). |
| K2 | Begge «Seks korte spørsmål»-knappene går til #svar, og «Sjå kva …» går til #aaret | PASS | `#n-ferdig` (`index.html:1274`) og `#n-ferdig-topp` (`index.html:1275`) kaller begge `go("svar")`, som setter `location.hash = "#svar"` (`index.html:1023-1027`). Lenka på `index.html:329` har `href="#aaret"`, som ruter til `visAaret()` via `hashchange` (`index.html:1235-1240`, `1331`). |
| K3 | Knappene er oversatt på alle fem språk (begge kopiene) | PASS | `walk(document.body)` (`index.html:744-751`, `769`) traverserer alle tekstnoder i DOM-treet og lagrer originaltekst per tekstnode-instans i `ORIG` (`WeakMap`, `index.html:720-729`). Begge kopier av `"Seks korte spørsmål"` (`index.html:328`, `333`) treffer oppslaget i `R` på `index.html:629` (nn/nb/en/uk/pl), og `"Sjå kva du ville fått gjennom eit heilt år"` (`index.html:329`) treffer `R` på `index.html:539` (nn/nb/en/uk/pl). |
| K4 | Ingen horisontal overflyt i #ferdig på 375 og 320 px | KAN IKKE AVGJØRES | Statisk gjennomgang av CSS viser at `* { box-sizing: border-box }` (`index.html:55`), `.stack > * { min-width: 0 }` (`index.html:71`), `body { overflow-wrap: break-word }` (`index.html:74`) og `.btn { width: 100% }` (`index.html:134`) gjelder begge knappene og lenka i `#v-ferdig`, med identisk tekst og klasser som allerede lå i `#v-ferdig`. Faktisk pikselmåling ved 375 og 320 px krever nettlesarkjøring, jf. instruksen om ingen skallkommandoer. Bekreftes med: `npx playwright test` eller et Playwright-sjekkskript som måler `document.documentElement.scrollWidth <= window.innerWidth` på `#ferdig` ved viewport-bredde `375` og `320` på alle fem språk og tekststørrelser. |
| K5 | Ingen andre visninger er endret (diff bare i #ferdig og én ny lytter) | PASS | Diffen i `index.html` (`review/ut/diff.txt:26-50`) inneholder kun endringen inne i `#v-ferdig` (`index.html:328-329`, flytting av `#aaret`-lenka fra linje 339 og ny knapp `#n-ferdig-topp`) samt én ny klikklytter for `#n-ferdig-topp` (`index.html:1275`). Ingen andre visninger eller funksjoner er rørt, og `pameldtSek` settes fortsatt ved klikk på `#n-kanal` før `#ferdig` (`index.html:1270-1273`). |

## Funn
Ingen funn. Diffen utgjør 3 endrede linjer i `index.html` (`index.html:328-329` og `index.html:1275`). Både DOM-rekkefølge, ruting til `#svar` og `#aaret`, tilbake-navigasjon fra `#aaret` til `#ferdig` (`aarFra` i `index.html:1236`), tidsmåling (`pameldtSek` i `index.html:1271`), CSS-regler i `.stack` og oversettelsesmotorens `WeakMap`-baserte tekstnode-håndtering (`index.html:720-751`) er kontrollert uten avvik.

## Utenfor oppdraget
ingen

## Etterkontroll K4 (PC-økta, 17.11.2026)
Målt i nettleser på index.html (e9fb34c) med #v-ferdig synlig, alle fem språk (nn, nb, en, uk, pl). 375 px: scrollWidth 375, største høyrekant i #v-ferdig 359. 320 px: scrollWidth 320, største høyrekant 304. Ingen horisontal overflyt. K4: PASS.
