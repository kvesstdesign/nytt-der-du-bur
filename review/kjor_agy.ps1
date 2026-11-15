# Kjører fast AGY-kontroll av en kodeendring.
# Eies av Oleiv. Claude Code kan kjøre, men ikke endre denne fila.
# Master: D:\Repo\prosjektmal\oppsett\kjor_agy.ps1 (STY 02). Kopieres til review/ av installer_oppsett.ps1.
#
# Bruk:
#   powershell -ExecutionPolicy Bypass -File review/kjor_agy.ps1 -Oppdrag docs/oppdrag/001-navn/spec.md -Nr 01a
#   Nr: to siffer, valgfri bokstav og valgfritt siffer: 03, 03b, 07b1
# Valgfritt:
#   -Base <commit>   sammenlign mot en annen commit enn HEAD (standard: HEAD = alt som ikke er committet;
#                    i et repo uten commit brukes det tomme treet, så alt regnes som nytt)
#   -Ut <fil>        skriv rapporten et annet sted enn <oppdragsmappa>/KONTROLL_<Nr>_AGY.md
#   -Modell <navn>   bruk bare denne modellen (se «agy models»), uten automatisk valg
#
# Modellvalg (V33, MAL 04): første runde (Nr 01, 01a) bruker den sterkeste modellen, senere runder
# (01b, 01c, 07b1 …) kontrollerer rettinger og bruker en lettere modell, så kvoten for den sterkeste
# varer lenger. Er kvoten brukt opp, prøves neste modell i lista. Modellen som ble brukt, står øverst
# i rapporten. Claude-modeller står sist: Claude Code skrev koden, så kontrollen blir mindre uavhengig.

param(
  [Parameter(Mandatory = $true)][string]$Oppdrag,
  [Parameter(Mandatory = $true)][string]$Nr,
  [string]$Base = "HEAD",
  [string]$Ut = "",
  [string]$Modell = ""
)

$STERK = 'gemini-4-argon-high'
$LETT = 'gemini-3.8-flash-high'
$RESERVE = 'claude-opus-5-5-high'

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# Kontroller input
$Oppdrag = $Oppdrag -replace '\\', '/'
if ($Oppdrag -notmatch '^docs/oppdrag/[0-9]{3}-[^/]+/[^/]+\.md$') { throw "Oppdrag må være en fil docs/oppdrag/NNN-navn/*.md" }
if (-not (Test-Path $Oppdrag)) { throw "Fant ikke oppdragsfila: $Oppdrag" }
if ($Nr -notmatch '^[0-9]{2}[a-z]?[0-9]?$') { throw "Nr må være for eksempel 03, 03b eller 07b1" }
if ($Ut -eq "") { $Ut = (Split-Path -Parent $Oppdrag) -replace '\\', '/'; $Ut = "$Ut/KONTROLL_${Nr}_AGY.md" }
if (Test-Path $Ut) { throw "$Ut finnes allerede. Bruk et nytt Nr, for eksempel ${Nr}b." }

# Tomt repo (ingen commit ennå): HEAD finnes ikke, sammenlign mot det tomme treet i stedet
$ErrorActionPreference = "Continue"
& git rev-parse --verify --quiet "$Base^{commit}" 2>$null | Out-Null
$baseFinnes = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = "Stop"
if (-not $baseFinnes) {
  if ($Base -ne "HEAD") { throw "Fant ikke commit: $Base" }
  $Base = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
  Write-Host "Repoet har ingen commit ennå. Sammenligner mot det tomme treet."
}

# 1. Lag diffen (endrede filer + nye filer som ikke er i Git ennå)
New-Item -ItemType Directory -Force -Path "review/ut" | Out-Null
$diffFil = "review/ut/diff.txt"
# --irreversible-delete: slettede filer vises bare som slettet, uten hele innholdet.
# data/ og AI Studio-rester holdes helt utenfor (brukerdata og store filer).
git diff --irreversible-delete $Base -- . ':(exclude)docs/KONTROLL_*' ':(exclude)docs/oppdrag/*/KONTROLL_*' ':(exclude)data/*' ':(exclude).aistudio/*' ':(exclude)public/assets/aistudio/*' | Out-File -Encoding utf8 $diffFil

$tekstendelser = @('.ts', '.tsx', '.js', '.json', '.md', '.css', '.html', '.ps1', '.txt', '.psd1', '.yml')
$nye = git ls-files --others --exclude-standard
foreach ($f in $nye) {
  if ($f -like 'review/ut/*' -or $f -like 'docs/KONTROLL_*' -or $f -like 'docs/oppdrag/*/KONTROLL_*') { continue }
  $ext = [System.IO.Path]::GetExtension($f).ToLower()
  Add-Content -Encoding utf8 $diffFil "`n=== NY FIL, ikke i Git ennå: $f ==="
  if ($tekstendelser -notcontains $ext) { Add-Content -Encoding utf8 $diffFil "(ikke tekst, innhold ikke tatt med)"; continue }
  $len = (Get-Item $f).Length
  if ($len -gt 200KB) { Add-Content -Encoding utf8 $diffFil "(for stor: $len byte, innhold ikke tatt med)"; continue }
  Get-Content -Raw -Encoding utf8 $f | Add-Content -Encoding utf8 $diffFil
}

# 2. Fast beskjed til AGY. Claude Code skriver ikke noe selv her.
$prompt = "Følg instruksjonene i review/AGY_PROMPT.md nøyaktig. " +
  "Oppdraget som skal kontrolleres er $Oppdrag. " +
  "Diffen ligger i review/ut/diff.txt. " +
  "Du kan lese docs/VISJON.md og kildekoden for å bekrefte funn, men ikke andre filer i docs/ enn oppdraget og VISJON. " +
  "Ikke les .env. Ikke endre noen filer. Svar bare med rapporten i formatet fra AGY_PROMPT.md."

# 3. Velg modell, kjør AGY i planmodus (kan ikke endre filer) og lagre svaret uendret,
#    med én linje øverst om modellen
if ($Modell -ne "") { $modeller = @($Modell) }
elseif ($Nr -match '^[0-9]{2}a?$') { $modeller = @($STERK, $LETT, $RESERVE) }
else { $modeller = @($LETT, $STERK, $RESERVE) }

$brukt = $null; $tomme = @()
foreach ($m in $modeller) {
  Write-Host "Kjører AGY-kontroll av $Oppdrag mot $Base med $m. Dette kan ta noen minutter..."
  $ErrorActionPreference = "Continue"
  $svar = & agy -p $prompt --mode plan --model $m --print-timeout 900s 2>&1
  $kode = $LASTEXITCODE
  $ErrorActionPreference = "Stop"
  $tekst = ($svar | Out-String)
  # Bare et svar med feilkode kan bety tom kvote. En vellykket rapport kan godt nevne ordet «quota».
  if ($kode -ne 0) {
    if ($tekst -match '(?i)quota|rate.?limit|resource.?exhausted|\b429\b') {
      Write-Host "Kvoten for $m er brukt opp. Prøver neste modell."
      $tomme += $m
      continue
    }
    throw "agy feilet med $m (exit $kode), ingen rapport lagret: $(($tekst.Trim() -split "`n")[0])"
  }
  $brukt = $m; break
}
if (-not $brukt) { throw "Kvoten er brukt opp for alle modellene: $($tomme -join ', '). Prøv igjen senere, eller bruk -Modell." }

$hode = "> AGY-modell: $brukt (runde $Nr)"
if ($tomme.Count -gt 0) { $hode += ". Kvote brukt opp for: $($tomme -join ', ')" }
if ($brukt -like 'claude-*') { $hode += ". Merk: Claude-modell, samme familie som koden ble skrevet med" }
@($hode, '') + @($svar) | Out-File -Encoding utf8 $Ut
Write-Host "AGY-kontroll lagret i $Ut ($brukt)"
