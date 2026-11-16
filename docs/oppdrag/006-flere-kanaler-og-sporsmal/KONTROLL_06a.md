# Kontroll 06a av APP-HAA oppdrag 06 (flere kanaler, to nye spørsmål, vennligere tekst)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-06`, commit 6fc90ca, diff mot main 8fcfc2e. Jeg har ikke endret noe i repoet (`git status` er tom etter kontrollen).

Oppsett: ekte Chrome (`/usr/bin/google-chrome --no-sandbox`, Chrome 153) med Python Playwright. Repoet ble servert med http.server på 127.0.0.1:8190, og en kopi av main (`git show 8fcfc2e:index.html`, lagt utenfor repoet) på 8191 for å sammenligne. Fonts ble blokkert. Alle forespørsler til docs.google.com ble fanget med `route` og besvart med `fulfill(status=200)`, så ingenting nådde Google. Siden ble lastet uten `?test=1`, så sendingen gikk til den ekte formResponse-adressen og ble fanget der. Reservelenken ble testet ved at ruten ventet 9 s før `fulfill(200)`, slik at sidens tidsgrense på 8 s slo inn.

Skript og rådata ligger i /home/claude/t03/k06a/: `felles.py`, `a.py`/`a.json` (D1, D2, D3, D5), `b.py`/`b.json` (D4, reserve, «Start på nytt»), `c.py`/`c.json` (D6, D7, D8, regresjon), `e.py` (rester av nynorsk i andre språk), `d6diag.py` (overflyt på main og grenen).

## Akseptkriterier

| Nr | Resultat | Hva jeg målte |
|---|---|---|
| D1 | BESTÅTT | Tilpass-hintet på alle fem språk nevner ikke dysleksi. Ingen forekomst av «dysleks/dyslex/дислекс» i synlig tekst eller i HTML-en (ordboka inkludert). Den nye teksten er oversatt på nb, en, uk og pl. |
| D2 | BESTÅTT | Straks og Snart: klikk på den eneste valgte kanalen endrer ingenting. Alle tre kan velges. Kan velge bort ned til én (også bare den tredje). Klikk og Space på den siste gjør ingenting. Godt å vite er fortsatt enkeltvalg. |
| D3 | BESTÅTT | Alle 7 kombinasjoner for Straks og alle 7 for Snart × 5 språk = 70 tilstander, 0 avvik mot forventet tekst. #ferdig: «Med ein gong, som SMS og e-post», «Dagen før, som SMS og varsel i app». Når Snart bare er e-post, er Snart-linjen borte og Snart ligger i e-posten. Årsoversikten: «SMS dagen før og i e-posten kvar veke», «SMS, varsel i app og e-post». Riktig «og/and/і/i» og komma på alle språk. |
| D4 | BESTÅTT | 8 sendinger (nn, nb, en, uk, pl, og to der språket ble byttet på #svar før sending). Hver gir nøyaktig én POST til `.../formResponse` med `application/x-www-form-urlencoded`. Alle verdier er gyldige tegn for tegn (også `30–49`, `50–66` med tankestrek). Ingen ugyldige felt, ingen duplikater, ingen flere verdier i enkeltvalgfelt. De gamle feltene 535172419 og 1629005840 sendes ikke. Verdiene er nynorsk uansett språk. Tomme q5 og q6 gir ingen entry. Fritekst med æøå, «», &, =, + og ? kom riktig fram. |
| D5 | BESTÅTT | Rekkefølgen er 1 q1, 2 q4, 3 «Korleis får du med deg …», 4 q2, 5 «Kor gamal er du?», 6 fritekst, på alle fem språk. Spørsmål, hint, valg og aria-label er oversatt. Ingen nynorske rester i nb, en, uk eller pl (e.py). Alder kan velges, byttes og fjernes igjen, og «Send svara» er aktiv uten alder. Knappen og overskriften heter «Seks korte spørsmål». |
| D6 | BESTÅTT innenfor oppdraget | 80 målinger: 375 og 320 px × 5 språk × Normal og Størst+luftig × #kanal, #ferdig, #svar, #aaret (alle kanaler og alle q5-valg på, demo-delen åpen). 0 horisontal overflyt på siden (scrollWidth = bredden overalt). Ett avvik i tekstboksene, se funn 3. Det er likt på main og gjelder ikke dette oppdraget. |
| D7 | BESTÅTT | axe-core: 40 kjøringer (5 språk × lys/Normal 375 og mørk/Størst+luftig 320 × fire visninger), 0 brudd. Én «incomplete» (aria-prohibited-attr) på #ferdig, se funn 4. |
| D8 | BESTÅTT | 0 pageerror i alle kjøringene. De eneste konsollfeilene er `net::ERR_FAILED` for Google Fonts, som jeg blokkerte selv. |
| D9 | Se samlet dom | Ingen høye eller middels funn innenfor oppdraget. |

## Reserve og «Start på nytt»

| Sjekk | Resultat |
|---|---|
| Reservelenken (prefill) | Riktig. Adressen er `.../viewform?usp=pp_url&…`. Parene er identiske med POST-innholdet, inkludert q5, q6, fritekst og flere kanaler. Nynorske verdier på nn, uk og en. Lenken er uendret når språket byttes etterpå (en → nb). |
| Reserveteksten | Verdiene som står der, er riktige og oversatt. Straks og Snart viser alle valgte kanaler. Men q5 og q6 mangler, se funn 1. |
| «Start på nytt» | Testet etter tre sendinger (nn med alt valgt, uk, nn → pl). Språket går tilbake til nn. Kanalene går tilbake til standard (SMS / SMS dagen før / I e-posten kvar veke). q1, q4, q5, q2, q6 er tomme, fritekst tom, «Send» er grå. Neste POST har bare standardverdiene og ingen q5/q6. |

## Regresjon

| Område | Resultat |
|---|---|
| Hvit som standard | BESTÅTT. Med `prefers-color-scheme: dark` og tom lagring: ingen `data-theme`, «Lys» er valgt, lys bakgrunn. |
| Tilpass-panel | BESTÅTT. Skjult ved lasting (`display:none`, 0 px, aria-expanded=false). Åpner med fokus på «Normal». Esc lukker og gir fokus tilbake til «Aa Tilpass». |
| Årsoversikt | BESTÅTT. Uten valg: «I heile Hå i 2026», tomme kanalfelt, ingen bryter, «Tilbake til starten» går til start. Med valg: «Med vala dine i 2026», kanalene «varsel i app og e-post», «SMS dagen før og i e-posten kvar veke», «i e-posten kvar veke». Bryteren går fra 6 til 12 saker og tilbake. «Tilbake til veka di» går til #ferdig. |
| Tilbakeknapper | BESTÅTT. «Tilbake» på #kanal går til #tema med temaene i behold. Nettleserens tilbake fra #ferdig går til #kanal, og flervalget av kanaler er i behold. Fra #svar går tilbake til #ferdig. |

## Funn

| Nr | Alvor | Innenfor/utenfor | Funn |
|---|---|---|---|
| 1 | Lav (grenser mot middels) | Innenfor | **Reserveteksten mangler de to nye spørsmålene.** `reserveTekst()` (index.html ca. linje 922–931) tar med Straks og Snart som lister, men ikke q5 («Slik får du nytt i dag») og q6 (alder). Teksten skal være det Oleiv skriver av hvis skjemaet ikke åpner, så da går de to nye svarene tapt. Det skjer bare når både sendingen og skjemalenken svikter, og prefill-lenken har dem med. Derfor lav. Rettingen er to linjer: `T("Korleis får du med deg nytt i dag") + ": " + (s.q5.length ? liste(s.q5) : "–")` og `T("Alder") + ": " + v(s.q6)`. Nøklene finnes allerede i ordboka. (Fritekst manglet også før, og det ser ut til å være med vilje.) |
| 2 | Lav | Innenfor | **Stor forbokstav midt i setningen i reserveteksten:** «Straks: SMS og E-post. Snart: Varsel i app dagen før og I e-posten kvar veke.» Reserveteksten bruker `liste()`, mens #ferdig og årsoversikten bruker den nye `kanalListe()`. Kan rettes sammen med funn 1 ved å bruke `kanalListe` for kStraks og kSnart. |
| 3 | Lav | Utenfor (finnes på main) | 320 px, nb, Størst+luftig, årsoversikten med «Vis oppdikta døme» åpen: «Gjødselspredning:» og «Besøksstans på Eksempelhjemmet» stikker 13–17 px utenfor `.mline`, og kolon treffer kantlinjen på kortet. Ingen overflyt på siden. Det er likt på main (d6diag.py, d6_aar_nb_320_storst.png). |
| 4 | Lav | Utenfor (finnes på main) | axe «incomplete» aria-prohibited-attr på #ferdig: `.notif` er en `div` med `aria-label` og uten rolle. `notifEl` er ikke endret i dette oppdraget. |
| 5 | Lav | Innenfor | Når bare én kanal er valgt, skjer det ingenting når den trykkes, og ingen tekst forklarer hvorfor. Skjermleser hører fortsatt «trykket». Et kort hint («Minst éin må vera vald») ville gjort det tydeligere. Det er ikke et krav i spec. |
| 6 | Lav | Utenfor (eldre oversettelse) | På engelsk heter det «SMS» for Straks, men «text the day before» for Snart i årsoversikten. Det kommer fra den gamle oversettelsen av «SMS dagen før». |

Notat: Når Straks bare er e-post, viser #ferdig eksempelet som et varselkort merket «E-post». Det er greit nok for en skisse. Ukrainsk «напередодні і у …» kunne vært «й у», men det er innenfor maskinoversettelsen som allerede er merket.

## Samlet dom

**Godkjent.** D1–D8 er bestått med egne målinger. Ingen høye eller middels funn innenfor oppdraget, så D9 er oppfylt. Jeg anbefaler å rette funn 1 og 2 i samme slengen, siden det bare er to linjer, men det stopper ikke merging.
