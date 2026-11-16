# Farmerbit QR redirect

QR code dinamici gratuiti via GitHub Pages. Ogni cartella è un QR:

| QR | URL stampato | Destinazione |
|---|---|---|
| progame-qr | https://farmerbit.github.io/qr/progame-qr/ | https://progame-stage.farmerbit.it/product/progame-green-wkf-approved/ |

**Cambiare destinazione:** modifica l'URL in `<cartella>/index.html` (3 occorrenze + link nel body), commit e push. Online in ~1 minuto. Il QR stampato non cambia.

**Nuovo QR:** copia una cartella, rinomina, cambia URL, genera il QR per `https://farmerbit.github.io/qr/<cartella>/`.

⚠️ Non rinominare il repo né le cartelle: i QR stampati smetterebbero di funzionare.

**Generare il QR** (macOS, nessuna dipendenza):

```sh
swift tools/makeqr.swift "https://farmerbit.github.io/qr/<cartella>/" qr-codes/<cartella>
swift tools/readqr.swift qr-codes/<cartella>.png   # verifica
```
