> AGY-modell: gemini-4-argon-high (runde 01a)

# Kontroll av APP-HAA oppdrag 02: «Nytt der du bur» som egen nettside

## Akseptkriterier
| # | Kriterium | PASS / FAIL / KAN IKKE AVGJØRES | Begrunnelse med fil:linje |
|---|---|---|---|
| K1 | `index.html` har ingen referanser til `window.claude`, `claude.use`, `db.collection` eller `#resultat` | PASS | Bekreftet ved søk i [index.html](file:///D:/Repo/nytt-der-du-bur/index.html). Alle referanser er fjernet i [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L101-L109), [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L187-L188), [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L205-L211), [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L243-L305), [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L313) og [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L331-L338). |
| K2 | Siden laster ingen skript eller stilark utenfra, bortsett fra Google Fonts som i dag | PASS | Bekreftet i [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L7-L9) (kun Google Fonts `<link>`) og [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L676) (`<script src="vendor/qrcode.min.js"></script>`, byttet fra `cdnjs.cloudflare.com` i [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L143-L144)). |
| K3 | Alle visningene fungerer på alle fem språk og i lys og mørk variant: #bygd, #tema, #kanal, #ferdig, #svar, #takk, #aaret og #lapp | KAN IKKE AVGJØRES | Krever kjøring i nettleser eller jsdom-test (f.eks. start `python -I test/server.py` og kontroller visningene i nettleser). Kodegjennomgang av [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L188-L341), [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L877-L890) og [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1062-L1077) viser at alle åtte visninger, fem språk og lys/mørk visning er intakte. |
| K4 | «Send svara» gir én POST til `.../formResponse` med alle utfylte felt, og viser takketekst uten ny fane | KAN IKKE AVGJØRES | Krever nettverkslogg i nettleser (f.eks. mot `http://127.0.0.1:8080/?test=1` med `python -I test/server.py`). Kodegjennomgang av [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L725-L741), [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1013-L1033) og [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1100-L1105) bekrefter at `sende()` gjør én `fetch(SKJEMA_POST, { method: "POST", mode: "no-cors", body: body })` med alle utfylte `entry.<id>`-felt, oppdaterer `#t-takk` og ikke kaller `window.open`. |
| K5 | Ett testsvar sendt fra den publiserte siden kommer fram i skjemaet med riktige verdier. Oleiv sletter det etterpå. | KAN IKKE AVGJØRES | Krever innsending fra den publiserte siden og sjekk i Google Skjemaer › Svar. |
| K6 | Avsenderen er fortsatt «Forslag frå Oleiv, innbyggjar på Nærbø». Ingen kommunevåpen eller logo. | PASS | Bekreftet i [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L182-L183), [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L336), [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L352), [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L355) og [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L475). Ingen kommunevåpen eller logo finnes i koden. |
| K7 | Siden åpnes på mobil uten innlogging og uten Claude-ramme | KAN IKKE AVGJØRES | Krever test på mobil mot publisert GitHub Pages-side. |
| K8 | Uavhengig kontroll (AGY) uten høye eller middels funn innenfor oppdraget | PASS | Ingen kritiske, høye eller middels funn i denne kontrollen. |

## Funn
### 1. «Send svara» forblir deaktivert og reserve-elementer nullstilles ikke ved tilbake-navigering fra `#takk` — lav — hypotese
- Fil og linje: [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1022-L1044) og [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1100-L1105) ([diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L212-L241), [diff.txt](file:///D:/Repo/nytt-der-du-bur/review/ut/diff.txt#L318-L324))
- Hva skjer: Ved innsending av `#f-svar` settes `b.disabled = true` på `#n-svar`. Hvis brukeren trykker tilbake på telefonen fra `#takk` til `#svar` (f.eks. etter en feilet sending eller for å rette fritekst i `#q3`), kalles ikke `updateButtons()`, så «Send svara»-knappen forblir deaktivert med mindre man klikker på en svarbrikke. Dersom første forsøk feilet (slik at `#h-takk`, `#b-skjema` og `#t-reserve` ble synlige) og neste forsøk lykkes uten at `reset()` har kjørt i mellomtiden, blir heller ikke `#h-takk`, `#b-skjema` og `#t-reserve` tilbakestilt i `sende()`.
- Slik bekreftes det: Les [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1022-L1044) og [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L1070-L1105), eller åpne `http://127.0.0.1:8080/?test=1`, send inn svar, trykk tilbake i nettleseren til `#svar` og observer at `#n-svar` er `disabled`.
- Forslag (én setning): Nullstill `#h-takk`, `#b-skjema` og `#t-reserve` i starten av `sende()`, og kall `updateButtons()` etter `await sende()` (eller ved visning av `#svar` i `route()`).

### 2. Gjenstående `https://claude.ai/…` i plassholdertekst på `#lapp` — lav — bekreftet
- Fil og linje: [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L331)
- Hva skjer: Oppdragets omfang punkt 3 sier «Ta bort alt som er spesifikt for Claude», men tekstfeltet `#lapp-url` i visningen `#lapp` har fortsatt `placeholder="https://claude.ai/…"`.
- Slik bekreftes det: Les [index.html](file:///D:/Repo/nytt-der-du-bur/index.html#L331) eller åpne `#lapp` i nettleseren.
- Forslag (én setning): Bytt `placeholder` på `#lapp-url` til den nye GitHub Pages-adressen (f.eks. `https://kvesstdesign.github.io/nytt-der-du-bur/`).

## Utenfor oppdraget
ingen
