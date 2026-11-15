# APP-HAA oppdrag 02: «Nytt der du bur» som egen nettside

Skrevet: 2026-11-16 00:22 av APP · APP-HAA 01 Hå kommune uten Facebook
Status: utkast, venter på Oleivs godkjenning før det kjøres
Valgt av Oleiv 16.11 kl. 00:21: alternativ 1, flytte skissen ut av Claude og publisere den på GitHub Pages

## Hvorfor

Skissen ligger i dag som en Claude-side (https://claude.ai/artifact/RYaBGNbNt9oVjbWGbVs388). Det gir fire problemer:
- claude.ai viser sin egen ramme rundt skissen, med innlogging og merking om at siden er laget med Claude.
- Claude-sider får ikke sende til andre nettsteder, så «Send svara» kan ikke sende rett til Google-skjemaet.
- window.open blir stoppet for de fleste, så naboen må åpne skjemaet selv og trykke «Send» der i tillegg.
- Lenker ut fra siden får en advarsel fra Claude først.

Oleiv har testet selv og merker at det blir mer klikking. Når kommunen får lenka, skal de se Oleivs arbeid, ikke Claude.

## Mål

Samme skisse på en vanlig nettside, for eksempel kvesstdesign.github.io/nytt-der-du-bur, der:
- «Send svara» sender svarene rett til Google-skjemaet med ett trykk
- ingen innlogging trengs, og det er ingen Claude-ramme

## Kilde

`Claude/APP-HAA_skisse-v6.8-kilde_2026-11-16.html` er v6.8 av skissen, eksportert 16.11 kl. 00:22. Den har fem språk, lys og mørk variant, A+, 12 ekte saker og Google-skjemaet med entry-ID-er. Denne fila er utgangspunktet. Ikke skriv skissen på nytt.

## Omfang

1. Sett opp repoet `D:\Repo\nytt-der-du-bur` med prosjektmal:
   `-Ny -Type app -Kode APP-HAA -Navn "Nytt der du bur"`
   Kjør med `-WhatIf` først.
2. Kopier kildefila til `index.html` i repoet.
3. Ta bort alt som er spesifikt for Claude:
   - `window.claude` og `db`-koden
   - visningen `#resultat`
   - teksten om lagring i skissen
4. Gjør om «Send svara» til en direkte sending:
   - `fetch(<formResponse-URL>, { method: "POST", mode: "no-cors", body: URLSearchParams })` med de samme entry-ID-ene som i `FELT`
   - Etterpå vises «Takk! Svara er sende.» på alle fem språk.
   - Feiler fetch, vises lenka til det ferdig utfylte skjemaet som reserve, slik det er i dag.
5. Endre personverntekst og knappetekst så de stemmer med direkte sending. Teksten om at man ser over svarene i skjemaet før sending skal bort. Fortsatt gjelder: ingen navn eller e-post, og Google lagrer tidspunktet.
6. Repoet `kvesstdesign/nytt-der-du-bur` må være offentlig, fordi GitHub Pages på gratiskontoen bare virker med offentlige repoer. Oleiv godkjente offentlig publisering da han valgte alternativ 1. Siden går live først når Oleiv merger til main og slår på Pages.
7. Lag `STATUS.md`, `VISJON.md` (lenke til Claude/APP_visjon-Ha-kommune-pilot_2026-11-13.md) og `docs/IDEBANK.md` etter malen.

## Utenfor omfang (går til idébanken)

- eget domene
- å flytte svarene bort fra Google
- nye funksjoner i skissen

## Akseptkriterier

| Nr | Kriterium | Hvordan det sjekkes |
|---|---|---|
| K1 | `index.html` har ingen referanser til `window.claude`, `claude.use`, `db.collection` eller `#resultat` | søk i fila |
| K2 | Siden laster ingen skript eller stilark utenfra, bortsett fra Google Fonts som i dag | les `<script src>` og `<link>` |
| K3 | Alle visningene fungerer på alle fem språk og i lys og mørk variant: #bygd, #tema, #kanal, #ferdig, #svar, #takk, #aaret og #lapp | jsdom-test eller nettlesertest, samme som i kontrollen av v6 |
| K4 | «Send svara» gir én POST til `.../formResponse` med alle utfylte felt, og viser takketekst uten ny fane | nettverkslogg i nettleserpanelet |
| K5 | Ett testsvar sendt fra den publiserte siden kommer fram i skjemaet med riktige verdier. Oleiv sletter det etterpå. | Google Skjemaer › Svar |
| K6 | Avsenderen er fortsatt «Forslag frå Oleiv, innbyggjar på Nærbø». Ingen kommunevåpen eller logo. | les siden |
| K7 | Siden åpnes på mobil uten innlogging og uten Claude-ramme | Oleiv tester på egen telefon |
| K8 | Uavhengig kontroll (AGY) uten høye eller middels funn innenfor oppdraget | review-oppsettet fra prosjektmal |

## Roller (app-test-fra-sky, V35)

- PC-økten (Claude Code i `D:\Repo\nytt-der-du-bur`, Medium) bygger og tester, kjører AGY, committer, pusher til `claude/APP-HAA-02` og lager utkast til PR.
- Skyøkten følger oppdraget, tester siden i nettleserpanelet og skriver status. Den bør være en ny samtale: «APP · APP-HAA 02 Egen nettside (skyøkt)», Opus 5.5 Medium.
- Oleiv oppretter VS Code-vinduet i den nye mappa, merger PR-en, slår på Pages (eller sier ja til at PC-økten gjør det med `gh api`), og tester på telefonen.

## Etterpå

- Skissen på claude.ai får en linje som peker til den nye adressen, og blir ellers stående.
- Lenka i innspillet til kommunen byttes til den nye adressen.
- Naboene får den nye lenka.
