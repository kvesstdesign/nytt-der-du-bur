# Kontroll 05a av APP-HAA oppdrag 05 (Tilpass-panel og UU-retting)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-05`, commit e0432fc mot main f5fe965. Jeg har ikke endret noe i repoet (`git status` er tom).

Testet i ekte Chrome (`/usr/bin/google-chrome --no-sandbox`) med Python Playwright. Repoet ble servert med http.server på 127.0.0.1:8150. fonts.googleapis.com/fonts.gstatic.com og alle forespørsler til docs.google.com ble blokkert. Det ble gjort 0 forsøk mot docs.google.com, og fontkallene ble blokkert. «Send svara» ble aldri trykket, og #takk ble bare nådd via adressen. Alle skript er skrevet på nytt for denne kontrollen (axe-oppsettet er lånt fra /home/claude/uu/scripts). Skript, rådata og skjermbilder ligger i /home/claude/t03/k05a/ (func.py, c3.py, c5.py, c5b.py, c6.py, c7.py, reg.py, *.json, *.png).

## Resultat

| Nr | Resultat | Bevis |
|---|---|---|
| C1 | **BESTÅTT** | Fem Tab fra toppen når fram til «Aa Tilpass», som har en 3 px fokusring. Enter og Space åpner panelet (aria-expanded=true), og fokus havner på valget som er aktivt («Normal»). Tab-rekkefølgen er Normal, Større, Størst, Av, På, Lys, Mørk, Ferdig og deretter siden. Esc inne i panelet lukker det: expanded=false og fokus på «Aa Tilpass». «Ferdig» med Enter gjør det samme. Klikk på knappen åpner og lukker. Det tilgjengelige navnet er «Tilpass», synlig tekst er «Aa Tilpass», det finnes ingen aria-label, og 2.5.3 er oppfylt. Se funn 4. |
| C2 | **BESTÅTT** | Alle sju valgene gir aria-pressed=true og «✓ » (::before) bare på det aktive valget. Skriftstørrelsen blir 16/20/24 px, `html.luft` og data-theme=dark settes, og alt lagres i `ndb-vis`. Etter reload er Størst, På og Mørk fortsatt valgt. «Start på nytt» fra #takk, med panelet åpent og språk pl/en, gir Normal/Av/Lys, ingen data-theme, ingen `ndb-vis` og ingen `ndb-lang`. Panelet lukkes, språket blir nn og fokus går til h-start. Det samme gjelder etter reload. Gamle lagrede valg: `{t:dark,s:true}` gir Større og Mørk, `{s:false}` gir Normal, og `s:7` og ødelagt JSON gir Normal uten feil. |
| C3 | **BESTÅTT** (brødtekst) | Med Luftig tekst på (Normal og Størst, 8 visninger, 60 elementtyper) har p, li, legend, label, .lead, .hint, b og a letter-spacing ≥ 0,12em, word-spacing ≥ 0,16em og line-height 1,8. Overskrifter og merkelapper har 0,06em, og det er med vilje. Uten Luftig tekst er verdiene normal/0/1,5. Se funn 3 om knapper og valgbrikker. |
| C4 | **BESTÅTT** | Straks har `"▲ " / ""`, Snart har `"● " / ""` og Godt å vite har `"■ " / ""`. Størrelsen er 14,4 px (0,9rem). Symbolene vises på start (3), ferdig og årsoversikten (22). Ingen node i Chromes tilgjengelighetstre (CDP getFullAXTree) har ▲, ● eller ■ i navnet, og aria-snapshot leser «Straks», «Snart» og «Godt å vite». Gråtonebildet c4_graa_start.png viser at symbolene skiller nivåene. |
| C5 | **BESTÅTT** | 8 visninger × 5 språk, testet både med change-hendelse og med piltaster i nedtrekkslisten. Fokus blir alltid på #langsel, og hashen er uendret. Ingen kode ruller siden. scrollY endrer seg bare når maskinomsettingsmerknaden for uk/pl vises eller skjules (+52/+133 px). Det er Chromes scroll-anker som holder innholdet i ro: h2 står på samme y før og etter (c5b.py). |
| C6 | **IKKE BESTÅTT** | Det ble gjort 1080 målinger: 9 visninger × 375/320 × 5 språk × 3 tekststørrelser × luftig av/på × panel lukket/åpent. 72 målinger hadde overflyt, som er 36 unike kombinasjoner (panelet endrer ikke noe). **Start:** grid-en `.levels` (`max-content 1fr`) blir 322–476 px bred og teksten går ut over kanten. Det gjelder 30 kombinasjoner, blant annet 320 nn Størst (343), 320 nn Større+luftig (351), 375 nn Størst+luftig (409), 375 uk Størst (412), 375 uk Størst+luftig (476), og 320 uk/pl Normal+luftig (338/326). **Kanal:** knapperaden (`.row`, flex nowrap) blir 327–347 px på 320 + Størst for nb, uk og pl. Se c6_*.png og panel_320_mork_storst_luft.png (hele siden er 409 px bred). |
| C7 | **BESTÅTT** | axe-core, WCAG 2.0/2.1 A og AA, i 229 kjøringer. Det dekker 9 visninger, start med panelet åpent og en tom årsoversikt, × 5 språk × lys/mørk × (Normal, Størst+luftig), og i tillegg 9 visninger med mørk emulering. Resultatet er 0 brudd. |
| C8 | **BESTÅTT** | Ingen pageerror i noen kjøring. Alle console-feilene er «Failed to load resource» for de blokkerte fontene, like mange som blokkerte kall. Ingen andre forespørsler feilet. |

## Regresjon fra oppdrag 03/04

| Sjekk | Resultat |
|---|---|
| Årsoversikten uten valg | OK. «I heile Hå i 2026» 4/5/3, bryteren er skjult, det er 12 ekte saker, tilbakeknappene viser «Tilbake til starten» og «Til starten» er skjult. |
| Årsoversikten fra #ferdig | OK. Oppsummeringen viser 4 SMS, 4 SMS dagen før og 2 i e-posten. Bryteren er på, med 10 saker (av gir 12, på gir 10). Begge knappene viser «Tilbake til veka di». details viser 9 linjer. |
| Overskrifter i årsoversikten | OK. h2 «Eit år i Hå» > h3 «Skjedde i 2026» > h4 per måned. |
| Tilbakeknapp og historikk | OK. Bunnknappen går til #ferdig med history.back, og telefonens tilbakeknapp gir deretter #kanal og #tema uten pendling. Toppknappen fra start gir start. |
| Språkbytte i årsoversikten med Størst+luftig | OK. uk viser «Назад до вашого тижня» og bredden er 375 px. |
| «Start på nytt» | OK. Språk, visning, valg og panel nullstilles. |
| Lys bakgrunn som standard ved mørk emulering | OK. Bakgrunnen er rgb(236,234,228), data-theme er ikke satt og «Lys» er markert. «Mørk» gir rgb(23,26,24). |

## Er panelet forståelig for eldre?

Stort sett ja. Panelet åpner rett under knappen og skyver innholdet ned i stedet for å legge seg over det. Rekkefølgen er Tekststørrelse, Luftig tekst og Bakgrunn, så det viktigste kommer først. Alle valg er minst 44 px høye. Det aktive valget har både fylt farge og ✓, og «Ferdig» er en bred knapp nederst (panel_s0.png). Teksten under Luftig tekst forklarer hva valget gjør. Alle fem språk er oversatt. Ordet «Tilpass» er litt abstrakt, men «Aa» foran gjør at knappen leses som en tekstknapp. Se funn 5.

## Funn

| # | Alvor | Innenfor | Funn |
|---|---|---|---|
| 1 | **Høy** | Ja (C6, punkt 4 i spec) | Startsiden blir bredere enn skjermen med Større, Størst eller Luftig tekst: 30 kombinasjoner, også 375 px på nn og nb med Størst+luftig. Teksten i «Tre hastegradar» går ut over kanten, og man må rulle sidelengs. Årsaken er `.levels { grid-template-columns: max-content 1fr }`. Badge-kolonnen tar full bredde («▲ Godt å vite» med større skrift og bokstavavstand), og `1fr` har min-content som minimum. `min-width:0` på `.card > *` hjelper ikke for spor i en grid. Forslag: legg merkelappen over teksten slik `.mline` gjør, når teksten er forstørret eller luftig, eventuelt bruk `minmax(0,max-content) minmax(0,1fr)` med `white-space: normal`. uk/pl med A+ var for brede også før (kontroll 04a: 335/321 px), men nå er det verre og gjelder alle språk. |
| 2 | Middels | Ja (C6) | #kanal på 320 px med Størst (nb, uk og pl): knapperaden Tilbake + «Meld meg på (eksempel)» (`.row`, flex nowrap) blir 327–347 px, og hovedknappen går 7–27 px utenfor kanten (c6_kanal_320_nb_storst.png). Forslag: `flex-wrap: wrap` på `.row`. |
| 3 | Lav | Ja | Luftig tekst virker ikke på knapper, valgbrikker, textarea og select, fordi Chrome setter `letter-spacing/word-spacing: normal` på skjemaelementer. Valgbrikkene (bygd, tema, svar) og knappetekstene får derfor ikke mer luft. C3 gjelder brødtekst og er oppfylt, men for en som har dysleksi, er brikkene en stor del av teksten. Forslag: `html.luft button, html.luft textarea, html.luft select { letter-spacing: inherit; word-spacing: inherit; }`. |
| 4 | Lav | Ja | Esc lukker ikke panelet når fokus står på «Aa Tilpass», bare når fokus er inne i panelet, fordi lytteren sitter på panelet. Forslag: flytt lytteren til `document` eller legg den også på knappen. |
| 5 | Lav | Ja | Små ting i koden: ordlisten har fortsatt ubrukte oppføringer («Lys bakgrunn», «Mørk bakgrunn», «Større tekst», «Visning»), og regelen `html[style*="150%"] .badge` avhenger av inline-stilen. En klasse som `html.str-2` er mer robust. For eldre kan «Tekst og farge» være lettere å forstå enn «Tilpass». Det er en idé til IDEBANK, ikke et krav. |

## Samlet dom

**IKKE GODKJENT.** C1–C5, C7 og C8 er bestått, og det er ingen regresjon fra oppdrag 03 og 04. C6 er ikke bestått: startsiden og knapperaden på #kanal blir bredere enn skjermen med forstørret og luftig tekst (funn 1 er høy, funn 2 er middels). Dermed er heller ikke C9 oppfylt. Når funn 1 og 2 er rettet, må C6-matrisen (c6.py) og axe (c7.py) kjøres på nytt.
