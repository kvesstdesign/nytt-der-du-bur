# APP-HAA 02: plan mot K1–K8

Skrevet 2026-11-16 av PC-økten (Claude Code). Oppdrag: `Claude/APP-HAA_oppdrag-02-egen-nettside_2026-11-16.md`. Kilde: `Claude/APP-HAA_skisse-v6.8-kilde_2026-11-16.html` (1166 linjer, 115 kB).

## Funn i kilden som styrer planen

| Linje | Hva | Tiltak |
|---|---|---|
| 687 | `qrcodejs 1.0.0` lastes fra cdnjs (brukes i `#lapp`, linje 1120–1121) | **Bryter K2.** Se beslutning B1 |
| 7–9 | Google Fonts | Beholdes (tillatt i K2) |
| 1204–1208 | `window.claude.use("db")`, overstyrer `#m-lagring`, åpner `#resultat` | Fjernes |
| 1015–1047 | `lagre()`: `db.collection("svar").add` + reserve med `window.open` | Skrives om til direkte POST (steg 4) |
| 1072–1100 ca. | `visResultat()`, `count()`, `statBlock()`, `unsubResultat` | Fjernes sammen med `<section id="resultat">` |
| 291, 467–468, 475 | Tekst om lagring og «ser over svara før du sender» (fem språk) | Skrives om (steg 5) |
| 736–737 | `SKJEMA` (viewform) og `FELT` med entry-ID-er | Gjenbrukes. formResponse-URL = samme ID med `/formResponse` |

## Beslutning B1 (Oleiv): QR-biblioteket

1. **Lokal kopi** `vendor/qrcode.min.js` (MIT, samme versjon 1.0.0 fra cdnjs, ca. 20 kB), lisens ved siden av. K2 holder, QR virker som før. *(anbefalt)*
2. Behold cdnjs og noter avvik fra K2. Ingen nedlasting, men K8 kan gi funn.
3. Fjern QR fra `#lapp` og vis bare lenka. Bryter «ikke nye endringer» i mindre grad, men `#lapp` blir dårligere.

**Avgjort av Oleiv 2026-11-16:** B1 = 1 (lokal kopi i `vendor/`), B2 = 1 (Oleiv lager `main`).

## Steg

1. `git init`, gren `claude/APP-HAA-02`. Første commit: malfilene + denne planen.
2. Kopier kilden til `index.html` uendret, commit («v6.8 som eksportert»). Gir ren diff for resten.
3. Fjern Claude-kode (K1): `window.claude`-blokka, `db`-variabelen og all bruk, `visResultat` med hjelpere, `#resultat`-seksjonen og eventuelle lenker dit.
4. Ny sending (K4):
   - `FORM_POST = SKJEMA.replace(/viewform$/, "formResponse")`.
   - Bygg `URLSearchParams` fra samme felt som `skjemaUrl(svar)` bruker i dag (én funksjon for begge, så reserve og POST aldri sprikar). Flervalg som gjentatte `entry.X`.
   - `fetch(FORM_POST, { method: "POST", mode: "no-cors", body })` med tidsgrense 8 s. Opaque svar = suksess. Kast/timeout = reserve.
   - Suksess: `#takk` viser «Takk! Svara er sende.» på fem språk (ny rad i tekstlista ved linje 475, som erstatter «lagra utan namn»-teksten).
   - Feil: dagens reserve (lenke `#b-skjema` til ferdig utfylt skjema + `#t-reserve`), men uten `window.open` (ingen ny fane, K4).
5. Tekster (fem språk): `#m-lagring` blir «Svara går rett til eit Google-skjema som Oleiv eig. Namn og e-post blir ikkje spurt etter. Google lagrar tidspunktet du sender.» Knappetekst sjekkes så den sier at svarene sendes. «Sjå over i skjemaet»-setningene fjernes.
6. B1 etter Oleivs valg.
7. Malfiler: `docs/VISJON.md` lenker til `Claude/APP_visjon-Ha-kommune-pilot_2026-11-13.md`, `docs/STATUS.md` og `docs/IDEBANK.md` (eget domene, svar bort fra Google, nye funksjoner). `START_PC-okt.md` flyttes til `docs/`.
8. Test, så AGY, så push og utkast-PR (se under).

## Kontroll per kriterium

| Nr | Hvordan PC-økten sjekker | Hvem |
|---|---|---|
| K1 | `rg "window\.claude|claude\.use|db\.collection|#resultat|id=\"resultat\"" index.html` gir 0 treff | PC |
| K2 | `rg "<script src|<link" index.html`: bare fonts.googleapis/gstatic (+ `vendor/` ved B1=1) | PC |
| K3 | jsdom-test `test/visninger.test.js` (node): 5 språk × lys/mørk × 8 visninger, hver visning blir synlig uten JS-feil og uten tomme tekstnøkler. Pluss stikkprøve i nettleserpanelet | PC, sky |
| K4 | Lokal server, nettleserpanel: fyll ut, trykk «Send svara», `read_network_requests` viser én POST til `/formResponse` med alle `entry.*`. Ingen ny fane. Jsdom-test med mock `fetch` for feilgreina | PC, sky |
| K5 | Testsvar fra publisert side (etter merge og Pages). Ikke mulig før Oleiv har merget | Oleiv |
| K6 | `rg "Forslag frå Oleiv, innbyggjar på Nærbø"` treff; `rg -i "våpen|logo|kommunevapen"` og ingen `<img>` med kommunemerke | PC |
| K7 | Mobil uten innlogging | Oleiv |
| K8 | AGY med review-oppsettet fra prosjektmal, rettinger til null høye/middels funn | PC |

Merk K4: i lokal test går POST-en til det ekte skjemaet og lager et ekte svar. Plan: i lokal test brukes en egen `?test=1` som bytter `FORM_POST` til en lokal dummy-URL, så ingen svar havner i skjemaet før K5. Fjernes ikke, men gjør ingenting uten parameteren.

## Push og PR

- Push bare til `claude/APP-HAA-02`. `gh repo create kvesstdesign/nytt-der-du-bur --public --source . --remote origin` (godkjent i START_PC-okt.md). Utkast-PR mot `main`.
- Problem S1: en PR trenger `main` på GitHub som mål, men økta skal aldri pushe til main. Pusher vi bare `claude/APP-HAA-02`, blir den standardgren og det finnes ingen main å lage PR mot.
- Beslutning B2 (Oleiv):
  1. **Oleiv lager `main`** selv: én kommando i terminalen etter at repoet er laget (`git push origin <første-commit>:refs/heads/main`), med bare malfilene. Økta pusher så grenen og lager PR. *(anbefalt)*
  2. Oleiv gir økta lov til å pushe første commit (bare malfiler, ingen kode) som `main` én gang.
  3. Ingen PR: bare grenen pushes, og Oleiv merger senere med å gi nytt navn til grenen.

## Utenfor omfang (idébanken)

Eget domene · flytte svarene bort fra Google · nye funksjoner.
