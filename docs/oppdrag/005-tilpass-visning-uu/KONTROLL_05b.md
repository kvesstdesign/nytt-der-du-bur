# Kontroll 05b av APP-HAA oppdrag 05 (Tilpass-panel og UU-retting)

Kontrollør: egen agent som ikke har skrevet koden. Dato: 16.11.2026.
Repo: /home/claude/nytt-der-du-bur, gren `claude/APP-HAA-05`, commit ee5563b (rettingen etter 05a, mot e0432fc). Jeg har ikke endret noe i repoet (`git status` er tom).

Testet i ekte Chrome (`/usr/bin/google-chrome --no-sandbox`) med Python Playwright. Repoet ble servert med http.server på 127.0.0.1:8161. fonts.googleapis.com/fonts.gstatic.com og alle forespørsler til docs.google.com ble blokkert, og alt annet enn den lokale serveren ble avvist. Siden gjorde 0 forsøk mot docs.google.com. «Send svara» ble aldri trykket, og #takk ble bare nådd via adressen. Chrome selv prøvde å nå accounts.google.com (bakgrunnstjeneste i nettleseren, ikke siden), og proxyen avviste det.

Skript, rådata og skjermbilder ligger i /home/claude/t03/k05b/. Skriptene fra 05a er brukt som utgangspunkt, men jeg kontrollerte først at de tester det de sier. Da fant jeg to svakheter, og begge er rettet i 05b:
- Overflytsmålingen i 05a hoppet over alt innenfor et element med `hidden`-attributt. Tilpass-panelet har alltid `hidden` når det er «lukket», men det vises likevel (funn A). Innholdet i panelet ble derfor aldri målt i 05a. I 05b avgjøres synlighet bare av beregnet stil.
- 05a fant tekst som går ut av boksen sin bare når `overflow` ikke er `visible`. 05b måler i tillegg `scrollWidth > clientWidth` for alle elementer og tekstbiter (Range-rektangler) som går utenfor sitt eget element. Begge målingene ble testet med en innlagt feil før bruk (selftest.py: begge feil ble funnet).
- I tillegg sjekker et nytt skript (brot.py) om ord deles midt i ordet over to linjer.

## 1. Funn fra 05a: er de rettet?

| 05a-funn | Alvor 05a | Status i ee5563b | Bevis |
|---|---|---|---|
| 1 Startsiden er for bred (`.levels`) | Høy | **Delvis rettet.** Siden blir ikke lenger bredere enn skjermen (0 av 1200 målinger). Men med Større (125 %) står merkelappene fortsatt i egen kolonne, og tekstkolonnen krymper til 70–111 px på 320 px. Ord deles midt i ordet på alle fem språk, se funn B. | c6.json, brot.json, start_levels_320_*_s1_l0.png |
| 2 #kanal `.row` går utenfor på 320 px Størst | Middels | **Rettet.** `flex-wrap: wrap` gjør at «Tilbake» legger seg over hovedknappen. Ingen overflyt. | c6.json, kanal_320_*_s2_*.png |
| 3 Luftig tekst virker ikke på knapper, brikker og textarea | Lav | **Rettet.** button, chip, textarea, select og «Aa Tilpass» har 0,12em / 0,16em. | c3.out, egen måling |
| 4 Esc på «Aa Tilpass» | Lav | **Rettet** når man ser på attributtene (aria-expanded=false, hidden=true). Men panelet blir ikke borte fra skjermen, se funn A. | func.out, c1.py |
| 5 Skjør `[style*=150%]`-regel og ubrukte ordlisteoppføringer | Lav | **Rettet** med klassen `html.stor2`. Tre av fire ubrukte oppføringer er fjernet. «Visning» (linje 438) er fortsatt ubrukt. | diff, grep |

## 2–5. Akseptkriterier og regresjon

| Nr | Resultat | Bevis |
|---|---|---|
| C1 | **IKKE BESTÅTT** | Attributtene oppfører seg riktig: Enter og Space åpner, aria-expanded stemmer, Esc (i panelet og på knappen) og «Ferdig» lukker og gir fokus tilbake. **Men panelet vises alltid.** `.tilpass { display: grid }` (linje 81) overstyrer `hidden`-attributtet, og det finnes ingen `.tilpass[hidden]{display:none}`. På en ny side er panelet 430 px høyt, synlig og klikkbart (elementFromPoint treffer panelet) med hidden=true og aria-expanded=false. Det samme gjelder etter Esc og «Ferdig». Med lukket panel går Tab gjennom alle sju valgene og «Ferdig» før «Prøv det». Feilen fantes også i e0432fc (målt på `git show e0432fc:index.html`). 05a overså den. Se funn A og c1_standard_375_nn.png. |
| C2 | BESTÅTT | Alle sju valgene gir aria-pressed og ✓ bare på det aktive valget. Skriften blir 16/20/24 px, og `luft`, `stor2` og `data-theme` settes. Valgene huskes etter reload. Gamle lagrede valg (`s:true`, `s:false`, `s:7`, ødelagt JSON) gir ingen feil. «Start på nytt» nullstiller valg, språk (nn), `ndb-vis` og `ndb-lang`, og fokus går til h-start. |
| C3 | BESTÅTT | 60 elementtyper i 8 visninger. All brødtekst, alle knapper, brikker, label og legend har ≥ 0,12em, ≥ 0,16em og linjehøyde 1,8. Merkelappene har 0,06em, og det er med vilje (som i 05a). Uten Luftig tekst er verdiene normal/0. |
| C4 | BESTÅTT | Merkelappene har ▲, ● og ■ med `/ ""`, i 14,4 px. Det er 3 på start og 22 i årsoversikten. Ingen node i tilgjengelighetstreet har symbolene i navnet. |
| C5 | BESTÅTT (som i 05a) | 8 visninger × 2 metoder: fokus blir alltid på #langsel, og hashen er uendret. scrollY endrer seg bare når merknaden om maskinoversettelse for uk/pl vises eller skjules (+52/+133 px). Overskriften står på samme y (c5b.py). Ingen kode ruller siden. |
| C6 | **BESTÅTT** (overflyt) | 1200 målinger: 10 visninger (inkludert tom årsoversikt) × 375/320 × nn/nb/en/uk/pl × Normal/Større/Størst × luftig av/på × «panel lukket/åpent». Det ga **0 tilfeller av horisontal overflyt**, og alle oppsett ble bekreftet (språk, klasser, visning). Fordi panelet alltid vises, er alle målingene i praksis gjort med panelet synlig, og innholdet i panelet er nå med. Lukket panel (når funn A er rettet) er en delmengde av dette. Mindre kosmetiske funn: se C og D. |
| C7 | BESTÅTT | axe-core, WCAG 2.0/2.1 A og AA, i 229 kjøringer: 11 visningsvarianter × 5 språk × lys/mørk × (Normal, Størst+luftig), og i tillegg 9 med mørk emulering. Resultatet er 0 brudd. Jeg sjekket at visning, språk og klasser faktisk ble satt (svar/pl: `luft stor2`, dark, 24 px). axe fanger ikke funn A. |
| C8 | BESTÅTT | Ingen pageerror. Alle console-feilene er de blokkerte fontene (458 = 458 blokkerte kall). |
| C9 | **IKKE OPPFYLT** | Funn A er høy og funn B er middels. |
| Årsoversikten | OK | Uten valg: «I heile Hå» 4/5/3, 12 ekte saker, h2 > h3 > h4. Fra #ferdig: 4/4/2, bryteren gir 10 eller 12 saker, «Tilbake til veka di», og historikken gir #ferdig → #kanal → #tema. uk med Størst+luftig er 375 px bred. |
| «Start på nytt» | OK (bortsett fra A) | Språk, visning, valg og `ndb-*` nullstilles. Panelet får hidden=true, men blir stående synlig (A). |
| Lys som standard | OK | Med mørk emulering er bakgrunnen rgb(236,234,228), data-theme er ikke satt og «Lys» er markert. «Mørk» gir rgb(23,26,24). |

## 4. Visuelt: startsiden og #kanal med Størst+luftig på 320 px

- **Startsiden** (start_levels_320_nn_s2_l1.png, start_320_uk_s2_l1_full.png): ryddig og lett å lese. Merkelappen står over overskriften og teksten, med god luft mellom de tre nivåene. Symbol og farge er tydelige, og ingen ord deles i nn/nb. I uk deles «відбувається» i h1 midt i ordet. Det er et langt ord i 48 px, og det er akseptabelt.
- **#kanal** (kanal_320_uk_s2_l1_full.png, kanal_320_nb_s2_l0_full.png): ryddig. Valgbrikkene brytes over flere linjer innenfor kortet. «Tilbake» står på egen linje over den brede hovedknappen, og ingenting går utenfor.
- **Men** på alle sider ligger Tilpass-panelet åpent øverst (A). Med Størst+luftig på 320 px er det omtrent 1100 px høyt, så en eldre bruker må rulle forbi det på hver side før innholdet kommer.
- Med **Større** (ikke Størst) på 320 px er startsiden dårlig å lese: tekstkolonnen er smal og ordene deles (B).

## Funn

| # | Alvor | Innenfor | Funn |
|---|---|---|---|
| A | **Høy** | Ja (C1, punkt 1 i spec) | **Tilpass-panelet kan ikke lukkes visuelt, og vises alltid.** `.tilpass { display: grid }` overstyrer `[hidden]`, og alle sider åpner med panelet synlig. aria-expanded=false og hidden=true, mens panelet er synlig og kan fokuseres. Esc og «Ferdig» flytter bare fokus. Skjermleser og tastatur får sju valg og «Ferdig» før innholdet. Feilen fantes også i e0432fc og ble oversett i 05a, fordi målingene stolte på `hidden`-attributtet. Retting: `.tilpass[hidden] { display: none; }`. Etter rettingen må C1 kontrolleres visuelt (elementFromPoint eller skjermbilde), ikke bare med attributter. |
| B | **Middels** | Ja (følge av rettingen av 05a-funn 1, punkt 4 i spec) | **Større (125 %) på startsiden deler ord midt i ordet.** Merkelappen legges bare over teksten ved `stor2` eller `luft`. Med Større alene beholdes to kolonner, og fordi kolonnen nå er `minmax(0,1fr)`, krymper tekstkolonnen til 111 px (nn/nb), 85 px (en) og 70–72 px (uk/pl) på 320 px. Det gir 43 ordbrudd midt i ordet («Прихо-дить», «arrangemen-t», «roadwor-ks»), og 2 på 375 px uk («попередження», «заздалегідь»). Også uk Normal 320 har ett brudd. Se start_levels_320_uk_s1_l0.png og start_levels_320_en_s1_l0.png. Forslag: legg merkelappen over teksten ved all forstørret tekst (sett også en klasse for Større), eventuelt alltid under en viss bredde. |
| C | Lav | Ja (C6, kosmetisk) | Årsoversikten uten valg, nb, 320 px, Størst+luftig: «Gjødselspredning:» og «Besøksstans» gjør `.mline`-griden 271 px i en boks på 254 px. Teksten går inn i kortets indre marg til kanten, men ikke utenfor skjermen (inv_mline_nb_aaret_tom_open_320_storst_luft.png). Forslag: `grid-template-columns: minmax(0,1fr)` på `.mline` eller `overflow-wrap: anywhere`. |
| D | Lav | Ja (kosmetisk) | #lapp, uk, 320 px, Størst+luftig: `.lapp` er 3 px bredere enn `.stack` (291 > 288). Den holder seg innenfor skjermen. |
| E | Lav | Ja | Ordlisteoppføringen «Visning» (linje 438) er fortsatt ubrukt. |

## Samlet dom

**IKKE GODKJENT.** Rettingene for 05a-funn 2, 3, 4 og 5 virker, og C6 (0 overflyt i 1200 målinger) og C7 (0 axe-brudd i 229 kjøringer) er bestått. C2–C5, C8, årsoversikten, «Start på nytt» og lys som standard har ingen regresjon. Men C1 er ikke bestått: Tilpass-panelet vises alltid fordi `display: grid` overstyrer `hidden` (A, høy). Feilen fantes også ved 05a. I tillegg deler Større-visningen på startsiden ord midt i ordet på 320 px (B, middels). Når A og B er rettet, bør C1 testes visuelt og brot.py og c6.py kjøres på nytt.
