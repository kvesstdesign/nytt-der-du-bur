# Nytt der du bur

Kode: APP-HAA. Repo: `D:\Repo\nytt-der-du-bur`.

Skissen «Nytt der du bur» som vanlig nettside: én `index.html` uten byggesteg. «Send svara» sender rett til Oleivs Google-skjema.

## Kjør lokalt

`python -I test/server.py` starter en lokal server på http://localhost:8080. Åpne http://localhost:8080/?test=1, så går «Send svara» til serverens testadresse og ikke til det ekte skjemaet. Serveren skriver de mottatte feltene i terminalen.

## Tredjepart

`vendor/qrcode.min.js`: QRCode.js 1.0.0, MIT. Se `vendor/LICENSE-qrcodejs.txt`.

## Lenker

- GitHub: https://github.com/kvesstdesign/nytt-der-du-bur
- Drive: (APP_ROT)/Nytt der du bur (design, testdata, leveranser)
