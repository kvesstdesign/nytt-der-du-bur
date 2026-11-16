# UU-gjennomgang: «Nytt der du bur» (APP-HAA)

Gjennomgått: `index.html` på `main`, commit `f5fe965` (innholdet er identisk med `bcac818` på `claude/APP-HAA-04`).
Dato: 16.11.2026. Testet lokalt, ikke mot GitHub Pages.

Oppsett: ekte Chrome (`/usr/bin/google-chrome`) via Python Playwright, `http.server` på port 8130. Forespørsler til fonts.googleapis.com, fonts.gstatic.com og docs.google.com ble blokkert (siden ble altså testet med reservefontene, ikke Bricolage Grotesque / Source Sans 3). «Send svara» ble aldri trykket. Takk-visningen ble åpnet via `#takk`. axe-core 4.x installert i `/home/claude/uu` og sprøytet inn i siden. Ingen filer i repoet er endret.

Testskript og rådata ligger i `/home/claude/uu/` (`scripts/`, `axe_nn.json`, `axe_nb_en_uk_pl.json`, `manual.json`, `shots/`).

---

## 1. Sammendrag

Skissa er godt laget for UU. Den er bedre enn mange kommunale sider: høy kontrast over alt (tekst 7,5–18:1 i lyst tema, 6,5–13:1 i mørkt), godt synlig fokusring (3 px, 8,7:1 lyst og 12,6:1 mørkt), berøringsmål på minst 44×44 på alle knapper, valgt tilstand vist med både `aria-pressed` og ✓ (ikke bare farge), riktig `lang` på `<html>` ved hvert språkbytte, fokus flyttes til overskriften ved hvert steg, og animasjonen slås av med `prefers-reduced-motion`. Hele flyten fra start til spørsmålene går fint med bare tastatur. I Windows høykontrast (forced colors) er alt fortsatt brukbart.

axe fant **ett brudd på WCAG 2.1 A/AA**, og det samme i alle 200 kombinasjonene (10 visninger × 5 språk × lyst/mørkt × med/uten A+): A+-knappen har et tilgjengelig navn som ikke inneholder den synlige teksten (2.5.3). Ellers bare «incomplete» (aria-label på `div`) og beste praksis (mangler landemerker utenfor `main`, ingen `h1` i stegene).

Den manuelle testen fant **ingen høye funn**. De viktigste middels funnene:

1. **Språkbytte flytter fokus** til overskriften og ruller til toppen (3.2.2). Med piltast på nedtrukket språkvelger skjer det etter første trykk, så tastaturbrukere mister plassen sin.
2. **A+** har navnet «Større tekst» uten «A+» (2.5.3, nivå A). Den som styrer med tale og sier «klikk A pluss», treffer ikke.
3. **Straks og Snart har nesten samme farge** for protanopi/deuteranopi og i gråtoner (fargeavstand 27–35 i lyst tema, 7 i mørkt). Teksten på merkelappen redder kravet (1.4.1), men folk som skanner etter farge, blander dem.
4. **Overskriftsnivåene i årsoversikten** er flate: «Skjedde i 2026» og alle månedene er `h3`, og månedene står to ganger.
5. **Enkeltvalg er laget som av/på-knapper** (spørsmål 1, 2 og kanalvalget). Skjermleser sier «veksleknapp, trykket» der brukeren venter radioknapper.

For eldre lesere er det viktigste som gjenstår at **merkelappene er små (12,8 px)** og at «DØME» står med store bokstaver.

Regelverk: En privat skisse fra en innbygger er etter min vurdering ikke omfattet av forskriften. Blir den en tjeneste fra Hå kommune, gjelder 48 suksesskriterier i WCAG 2.1 og krav om tilgjengelighetserklæring på uustatus.no (se del 5).

---

## 2. Funn

Alvor: **Høy** = stopper en brukergruppe. **Middels** = brudd på krav eller tydelig hinder. **Lav** = forbedring / beste praksis / utenfor norsk krav.

| # | WCAG 2.1 | Alvor | Hvor | Funn | Forslag til retting |
|---|---|---|---|---|---|
| 1 | 3.2.2 Ved inndata (A) | Middels | Språkvelger `#langsel`, alle visninger | `setLang()` kaller `__rerender` → `route()` → `show()`, som flytter fokus til `h1/h2` og ruller til toppen. Målt: på `#kanal` med fokus på «Nei takk» ble fokus flyttet til `H2#h-kanal` og `scrollY` satt til 0. Pil ned på lukket velger byttet til bokmål og flyttet fokus etter første trykk. | La `show()` ta et flagg, f.eks. `show(name, {behold: true})`, og hopp over `focus()` og `scrollTo` når kallet kommer fra språkbytte: `window.__rerender = function () { route(true); }`. Valgt tilstand er bevart allerede (testet). |
| 2 | 2.5.3 Etikett i navn (A) | Middels | `#b-stor` (A+) | `aria-label="Større tekst"` mens synlig tekst er «A+». axe: violation i alle 200 kjøringer. | `aria-label="A+ Større tekst"` (og oversett), eller fjern aria-label og vis «A+ Større tekst» som tekst. |
| 3 | 1.4.1 Bruk av farge (A), bestått; anbefaling | Middels (for målgruppen) | `.b-straks` / `.b-snart` i alle visninger, venstrekant på `.notif` | Simulert: protanopi gir Straks `rgb(121,120,21)` og Snart `rgb(105,104,35)`, avstand 27. Deuteranopi 35, gråtoner 5. Mørkt tema: 7. Kravet er oppfylt fordi teksten står på lappen, men fargen bærer ikke forskjellen. Se `shots/cb_light_all.png` og `cb_dark_all.png`. | Legg til ikon/form per nivå, samme i alle visninger: f.eks. ⚠ (trekant) for Straks, klokke for Snart, «i» for Godt å vite (som `aria-hidden` SVG; teksten er fortsatt navnet). Gi Snart en lysere/gulere tone så forskjellen også er lyshet (helst 3:1 mellom Straks og Snart). |
| 4 | 1.3.1 Info og relasjoner (A) | Middels | `#v-aaret` | `h2 Eit år i Hå` → `h3 Skjedde i 2026` → måneder som `h3` (samme nivå). De oppdiktede eksemplene i `<details>` har også måneder som `h3`, uten egen overskrift, så «Januar» kommer to ganger på samme nivå. | Måneder under «Skjedde i 2026» som `h4`. Gi demo-delen en `h3` (f.eks. «Oppdikta døme») og månedene der `h4`. |
| 5 | 4.1.2 Navn, rolle, verdi (A) / 1.3.1 | Middels | Spørsmål 1 og 2, kanalvalgene (Straks/Snart/Godt å vite) | Enkeltvalg er laget som `button aria-pressed`. Skjermleser sier «veksleknapp, trykket». I kanalvalget kan man ikke trykke av et valgt alternativ (koden returnerer stille). Det er teknisk lov, men uklart. | Bruk ekte radioknapper (`<input type="radio">` i `fieldset`) stylet som chips, eller `role="radiogroup"` / `role="radio"` med `aria-checked` og piltaster. Behold av/på-knapper for flervalg (bygd, tema, spørsmål 3). |
| 6 | 1.4.10 Reflow (AA), utover kravet | Lav | `#v-start` og `#v-kanal`, uk og pl med A+ ved 320 px | 400 % zoom (320×200) uten A+: bare 1 px overløp i pl. Med A+ (500 % effektivt): uk 15 px horisontal rulling på start, `Крок 3 з 3` 28 px på kanal. Årsak: langt ukrainsk ord i `h1` og `white-space: nowrap` på merkelappene i `.levels`. | `h1, h2 { overflow-wrap: anywhere; hyphens: auto; }` og la `.badge` bryte under 360 px (`@media (max-width: 22.5rem) { .badge { white-space: normal; } }`). La `.topbar` få `flex-wrap: wrap`. |
| 7 | 1.4.12 Tekstavstand (AA) | Lav | Topplinja og start (uk) ved 320 px | Bestått ved 390 og 1280 px i nn/uk/pl, og ved 320 px i nn. Feiler bare kombinert med 320 px og A+ (A+ presses 10 px ut av skjermen) og uk-start ved 320 px (7 px). Ingen tekst klippes (ingen `overflow: hidden`). | Samme retting som #6. |
| 8 | 2.4.2 Sidetittel (A), beste praksis | Lav | Alle steg | `document.title` er «Nytt der du bur» i alle visninger. Den skifter språk, men ikke steg. | Sett tittelen i `show()`: «Steg 1 av 3: Kvar bur du? – Nytt der du bur». |
| 9 | 1.3.1 / beste praksis | Lav | Alle steg unntatt start | Ingen `h1` utenom startsiden (axe: page-has-heading-one). QR-lappen har to `h2`. I «Slik kunne det sett ut» er Straks/Snart-delene `<b>`, mens e-postdelene er `h3`. | Gjør stegoverskriftene til `h1` (bare én synlig visning om gangen), eller legg inn en skjult `h1` «Nytt der du bur». Gjør lane-overskriftene til `h3`. |
| 10 | 4.1.2 (axe incomplete) | Lav | `.levels`, `.notif`, `#qr` | `aria-label` på `div` uten rolle blir ignorert av de fleste skjermlesere. | `.notif`: `role="group"` (eller `<figure>` + `<figcaption>`). `.levels`: gjør om til `<ul>` / `<dl>` med overskrift. `#qr`: fjern aria-label (bildet har `alt`). |
| 11 | Beste praksis (landemerker) | Lav | Topplinja, flagget «Forslag frå …» | Ligger utenfor alle landemerker (axe: region). | Pakk topplinja og flagget i `<header>`. |
| 12 | 2.4.3 Fokusrekkefølge (A), bestått; anbefaling | Lav | `#v-aaret` | Fokus settes på `h2`, som står etter «Tilbake»-knappen øverst. Første Tab hopper derfor over den, og man må bruke Shift+Tab. | Flytt den øverste «Tilbake» ned rett etter overskriften, eller sett fokus på «Tilbake». |
| 13 | 2.4.1 / beste praksis | Lav | Sideinnlasting | Fokus settes på `h1` ved lasting. Skjermleserbrukere starter dermed etter språkvelgeren og forbeholdet («ikkje ei teneste frå Hå kommune»). | Ikke flytt fokus ved første lasting, bare ved stegbytte. |
| 14 | 4.1.3 Statusmeldinger (AA) | Lav | Bygd, tema, spørsmål | Når «Vidare» / «Send svara» blir aktiv, forsvinner hintet «Vel minst éi bygd …» stille (`visibility`). Deaktiverte knapper nås ikke med Tab, så skjermleserbrukere finner dem ikke. | Koble hintet til knappen med `aria-describedby`. Vurder `aria-disabled="true"` i stedet for `disabled`, med melding ved trykk. Mange eldre forstår ikke gråe knapper. |
| 15 | 2.4.7 Synlig fokus (AA), bestått; anbefaling | Lav | `details > summary` i årsoversikten | Bruker Chromes standardring (1 px auto) i stedet for den egne 3 px-ringen. | Legg `summary:focus-visible` inn i fokusregelen. |
| 16 | 3.2.5 (AAA) / G201 | Lav | Kildelenkene (Jærbladet, ha.no) og «Opne skjemaet» | Åpner i ny fane uten varsel. Forvirrende for eldre på mobil (tilbakeknappen virker ikke). | Legg til «(opnar i ny fane)» i teksten, eller åpne i samme fane. |
| 17 | 2.5.8 (WCAG 2.2, ikke krav i Norge) | Lav | «Til starten» (`#a-aar-start`, lapp) | 358×22 px. Kildelenkene inne i teksten er unntatt. | Gjør «Til starten» til en `btn ghost` (48 px høy) som de andre. |
| 18 | Ikke WCAG-krav, lesbarhet | Middels (for målgruppen) | `.badge` 0,8 rem = 12,8 px, `.hint` 0,9 rem = 14,4 px | Merkelappene bærer hovedbudskapet (hastegrad), men er minste tekst på siden. «DØME» med store bokstaver er tyngre å lese for personer med dysleksi. | `.badge` minst 0,9 rem (helst 1 rem), `.hint` 1 rem. Skriv «Døme». Se del 3. |
| 19 | Ikke WCAG-krav, mørkt tema | Lav | Merkelappene i mørkt tema | Bakgrunnen til merkelappene er 1,0–1,2:1 mot kortet, så de ser ut som vanlig farget tekst, ikke som lapper (`shots/cb_dark_all.png`). Teksten har 8–9,7:1. | Gi mørke merkelapper en 1,5 px kant i tekstfargen, eller lysere bakgrunn. |
| 20 | 3.1.2 Språk i deler (AA) | Lav | `#langsel` aria-label | «Språk / Language / Мова / Język» leses med sidens språk. Alternativene har riktig `lang` (bra). | Akseptabelt. Eventuelt synlig etikett med hvert ord i eget `<span lang>`. |

**Bestått (kort):** kontrast tekst 1.4.3 og grafikk/fokus 1.4.11 i begge tema (laveste tekst 6,55:1 i e-posthodet i mørkt; skjemakanter 4,16:1 i mørkt); 1.4.4 tekststørrelse (A+ og nettleserzoom); 1.4.10 reflow ved 200 % og 400 % uten A+; 1.4.12 tekstavstand ved vanlige bredder; 2.1.1 / 2.1.2 tastatur (hele flyten, ingen feller); 2.4.7 synlig fokus i lyst, mørkt og forced colors (`shots/focus_all.png`); 3.1.1 og 3.1.2 (`lang` riktig for nn, nb, en, uk, pl; `navigator.language = uk-UA` gir ukrainsk og varsel om maskinoversettelse); 1.4.1 for valgt chip (✓ + fyll); `prefers-reduced-motion` (animasjon `none` ved reduce); ingen JavaScript-feil i noen visning. Bare stedsnavn, «Facebook», kildenavn og noen månedsnavn står uoversatt i en/uk/pl, og det er riktig.

**Ikke testet:** ekte skjermleser (NVDA/JAWS/VoiceOver/TalkBack finnes ikke i containeren; semantikken er vurdert fra DOM og tilgjengelighetstre), selve innsendingen til Google Forms og Google-skjemaets egen UU, utskrift av QR-lappen, ekte telefon.

---

## 3. Innstillinger for brukere: hva hjelper egentlig?

Prinsipp: Det som hjelper alle, bør være standard. En innstilling hjelper bare dem som finner den, og eldre leter sjelden i menyer. Bruk derfor få innstillinger, samlet i én «Visning»-knapp ved siden av ☾ og A+.

| Innstilling | Hjelper det? (kilde) | Anbefaling |
|---|---|---|
| **Større tekst** (finnes: A+ = 125 %) | Ja. W3C peker på at nedsatt syn gjør lesing vanskeligere hos eldre, og nevner tilpassbar tekst og større knapper. | Behold. Gi to eller tre trinn (125 / 150 / 175 %) og vis tekst ved knappen: «A+ Større tekst». Rett funn #6 først, så 150 % også virker på uk/pl. |
| **Luftigere tekst** (linjeavstand, bokstav- og ordavstand) | Ja, best dokumentert. Zorzi m.fl. (PNAS 2012, 94 barn med dysleksi, italiensk og fransk): ekstra bred bokstavavstand økte lesehastigheten med over 20 % og doblet nøyaktigheten. Barn uten lesevansker fikk ingen gevinst. Dyslexia Scotland anbefaler linjeavstand 1,5 og litt økt bokstav- og ordavstand. | Legg inn som ett valg: `line-height: 1.8; letter-spacing: .05em; word-spacing: .16em; p { margin-bottom: 1em }`. Siden tåler dette allerede (1.4.12 bestått ved vanlige bredder). |
| **Dysleksifont** (OpenDyslexic o.l.) | Nei, ikke ifølge forskningen. Wery og Diliberto (Annals of Dyslexia 2017): OpenDyslexic ga verken bedre lesehastighet eller nøyaktighet enn Arial eller Times, og ingen av elevene foretrakk den. Dyslexia Scotland: det finnes ingen egen «dysleksivennlig» font; bruk en enkel font med jevn avstand. | Ikke lag det. Behold en ren sans-serif (Source Sans 3 er god), unngå store bokstaver («DØME» → «Døme»), venstrejuster (gjort) og hold linjene korte (34 rem er bra). |
| **Fargeblindmodus** | Liten nytte som eget valg. W3C (1.4.1) anbefaler å bruke informasjon i tillegg til farge, som form eller tekst, og påpeker at et lyshetsavvik på 3:1 også teller som en ekstra visuell forskjell. | Ikke lag modus. Gjør det for alle: ikon/form per hastegrad og større lyshetsavstand mellom Straks og Snart (funn #3). |
| **Mørkt tema** (finnes: ☾) | Hjelper noen (blending, lysfølsomhet). | Behold. Vurder tekst ved symbolet («☾ Mørk»). Siden følger ikke telefonens mørke modus; det var et bevisst valg i oppdrag 03. Ta det eventuelt opp i IDEBANK i stedet for å endre det her. |
| **Tonet bakgrunn** (krem/fersken) | Kan hjelpe noen. Dyslexia Scotland anbefaler off-white eller tonet bakgrunn i stedet for skarp hvit, men sier at folk foretrekker ulikt. | Lav prioritet. Bakgrunnen er allerede off-white (#eceae4); kortene er hvite. Eventuelt la kortene bli `#fbfaf6`. |
| **Høy kontrast** | Dekket. Siden virker i Windows høykontrast (forced colors) og ✓ viser valgt tilstand. | Ingen egen modus nødvendig. |
| **Mindre bevegelse** | Dekket via `prefers-reduced-motion`. | Ingen egen knapp nødvendig. |
| **Lese opp** | Telefonens egen opplesning er bedre enn en egen knapp, og riktig `lang` gjør at riktig stemme velges (bestått). | Ikke lag egen knapp i skissa. |

---

## 4. Klarspråk og lesbarhet for eldre og personer med dysleksi

Bra: korte setninger, aktive verb, «Steg 1 av 3», eksempler fra hverdagen («Vatnet er stengt i Dømegata no»), tydelig forbehold om at dette ikke er kommunen, ingen tidsfrister, ingen innlogging, maskinoversettelse merket for uk/pl.

Å forbedre:
- **Oppsummeringen** «Tema: Vatn og avløp, Veg og trafikk og Helse» har tre «og». Skriv heller en punktliste, eller skill med semikolon / «·».
- **Metadata-linja** «DØME · SMS · Straks · Vatn og avløp · Vigrestad» er tett. Del i to: «SMS · Vigrestad» øverst, hastegraden som merkelapp.
- **Ord** som kan være uvante for eldre: «skisse», «hastegrad», «varsel i app». Forklaringen av SMS vs. app er god; behold den.
- **«Meld meg på (døme)»** kan misforstås som ekte påmelding. Vurder «Sjå korleis det ville sett ut».
- **Uk/pl** er maskinoversatt. La en morsmålsbruker lese gjennom før testen hos innbyggere.

---

## 5. Regelverket i Norge

- WCAG 2.1 og EUs webdirektiv er norsk regelverk. Offentlig sektor har fulgt de nye kravene fra 1. februar 2023 ([uutilsynet: EUs webdirektiv](https://www.uutilsynet.no/webdirektivet-wad/eus-webdirektiv-wad/265)).
- Offentlig sektor skal følge 48 krav; privat sektor 35 ([uutilsynet: WCAG-standarden](https://www.uutilsynet.no/wcag-standarden/wcag-standarden/86)). AAA er ikke med.
- Privat sektor får ingen nye krav, og en offentlig virksomhet som kjøper innbyggerrettede tjenester fra private, må sørge for at de oppfyller de samme kravene (WAD-siden over).
- Tilgjengelighetserklæring gjelder offentlig sektor. Private skal som hovedregel ikke ha det og har ikke tilgang til uustatus.no. Erklæringen lages på uustatus.no, lenken publiseres på nettstedet, og den oppdateres minst hvert år og ved større endringer ([uutilsynet: FAQ om erklæringen](https://www.uutilsynet.no/tilgjengelighetserklaering/ofte-stilte-sporsmal-om-tilgjengelighetserklaeringen/894)).
- WCAG 2.2 er ikke en del av regelverket nå, og det endrer seg ikke på kort sikt. 4.1.1 skal fortsatt etterleves ([uutilsynet: nyere WCAG](https://www.uutilsynet.no/fremtidig-regelverk/status-nyere-versjoner-av-wcag/1868)).
- I kommunen har kommunedirektøren det overordnede ansvaret, og den som kjøper IKT, skal sørge for at UU-kravene oppfylles ([KS](https://www.ks.no/fagomrader/digitalisering/universell-utforming/universell-utforming-av-ikt-losninger/)).

**Vurdering for skissa:** Den er laget av en privatperson, er ikke kommersiell og sier tydelig at den ikke er en tjeneste fra Hå kommune. Etter min vurdering er den ikke omfattet av forskriften og trenger ingen tilgjengelighetserklæring. Dette er ikke juridisk rådgivning; uutilsynet sier at virksomheten selv må vurdere om den er omfattet. Skissa oppfyller likevel nesten alle de 48 kravene i dag, og det er et godt argument når den vises til kommunen.

### Det en ekte kommunal tjeneste må ha i tillegg

1. **Alle 48 krav i WCAG 2.1 A/AA** fra første dag, også i påmelding, profil, avmelding og e-post/SMS-maler. Rett funn #1, #2, #4 og #5 før lansering.
2. **Tilgjengelighetserklæring på uustatus.no**, lenket fra tjenesten, oppdatert hvert år og ved store endringer, med kjente avvik og plan for retting.
3. **UU-krav i anskaffelsen** (WCAG 2.1 AA / EN 301 549) og rett til å teste før kontraktsavslutning, hvis kommunen kjøper en varslingsløsning.
4. **Test med ekte brukere:** eldre, skjermleser (VoiceOver og TalkBack på mobil), forstørrelse, og brukere som snakker ukrainsk og polsk.
5. **Faglig oversettelse** i stedet for maskinoversettelse, i hvert fall for Straks-meldinger.
6. **Kanaler uten app:** SMS må virke på gamle telefoner, og det trengs en vei å melde seg på via telefon eller servicetorg for dem som ikke bruker nett.
7. **Personvern** (utenfor UU, men nødvendig): ikke Google Forms; databehandleravtale, DPIA og egen samtykke-/avmeldingsflyt for telefonnummer og e-post.
8. **Klarspråk i meldingene:** faste maler for Straks/Snart/Godt å vite med kort tittel, hva du skal gjøre, og når det gjelder til. (Språkloven har krav om klart språk for offentlige organ; ikke sjekket mot lovteksten i denne økta.)

---

## 6. Kilder (åpnet i denne økta)

- Uu-tilsynet: [EUs webdirektiv (WAD)](https://www.uutilsynet.no/webdirektivet-wad/eus-webdirektiv-wad/265)
- Uu-tilsynet: [Ofte stilte spørsmål om tilgjengelighetserklæringen](https://www.uutilsynet.no/tilgjengelighetserklaering/ofte-stilte-sporsmal-om-tilgjengelighetserklaeringen/894)
- Uu-tilsynet: [Status for nyere versjoner av WCAG](https://www.uutilsynet.no/fremtidig-regelverk/status-nyere-versjoner-av-wcag/1868)
- Uu-tilsynet: [WCAG-standarden (48 / 35 krav)](https://www.uutilsynet.no/wcag-standarden/wcag-standarden/86)
- KS: [Universell utforming av IKT-løsninger](https://www.ks.no/fagomrader/digitalisering/universell-utforming/universell-utforming-av-ikt-losninger/)
- W3C: [Understanding SC 1.4.1 Use of Color](https://www.w3.org/WAI/WCAG21/Understanding/use-of-color)
- W3C WAI: [Older Users and Web Accessibility](https://www.w3.org/wai/older-users/)
- Wery og Diliberto (2017), *Annals of Dyslexia* 67: [The effect of a specialized dyslexia font, OpenDyslexic, on reading rate and accuracy](https://link.springer.com/article/10.1007/s11881-016-0127-1)
- Zorzi m.fl. (2012), PNAS, omtalt i [Medical Xpress: Wider letter spacing helps dyslexics read](https://m.medicalxpress.com/news/2012-06-wider-letter-spacing-dyslexics.html) (originalen på PubMed/PMC var bak reCAPTCHA og kunne ikke åpnes)
- Dyslexia Scotland: [Dyslexia-friendly typed formats](https://dyslexiascotland.org.uk/dyslexia-friendly-typed-formats)
- Verktøy: [axe-core](https://github.com/dequelabs/axe-core) (npm `axe-core`), regelsett `wcag2a, wcag2aa, wcag21a, wcag21aa`, samt `best-practice` og `wcag22aa` for informasjon.

Ikke åpnet: forsiden til uutilsynet.no (tilgang ble ikke godkjent i økta), lovteksten på Lovdata og regjeringen.no-saken om endringer i forskriften (siden feilet).
