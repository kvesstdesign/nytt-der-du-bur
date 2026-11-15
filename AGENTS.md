# Nytt der du bur – regler for kodeagenter

Les `docs/VISJON.md` og oppdraget du har fått (`docs/oppdrag/NNN-navn/spec.md`) før du gjør noe.

## Kommandoer

- Alt (før commit): `powershell -NoProfile -ExecutionPolicy Bypass -File check.ps1` (mal: `D:\Repo\prosjektmal\oppsett\check_mal.ps1`)
- (fylles inn: start, test, bygg)

## Arbeidsflyt

1. Ett oppdrag om gangen. Ideer utenfor oppdraget skrives i `docs/IDEBANK.md`.
2. Kjør akseptkriteriene og AGY-kontrollen før «klar for test».
3. **Commit og push (V35):** Commit når `check.ps1` er grønn og AGY-funnene er avgjort. Push bare til egen gren `claude/<KODE>-<nr>` med `git push -u origin claude/<KODE>-<nr>`, og lag PR som utkast med `gh pr create --draft`. Aldri push til main. Oleiv merger etter test.
4. **Økta kjører selv (L6b):** Økta kjører akseptkriterier, tester og egne kommandoer selv i Auto. Den gir Oleiv kommandoer å kjøre bare når noe krever administrator, sletter filer eller skriver utenfor repoet og avtalte mapper.

## Lenker

- GitHub: https://github.com/kvesstdesign/nytt-der-du-bur
- Drive: (APP_ROT)/Nytt der du bur
