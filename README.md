# BuildRank Frontend

Frontend de **BuildRank**, desenvolupat amb **Flutter** i **Dart**.

Aquest repositori conté la part client de BuildRank. És la capa amb què interactua l’usuari final: mostra la informació, recull accions, es comunica amb el backend i ofereix una experiència usable per consultar edificis, puntuacions energètiques, simulacions, rànquings, comunitat i perfil d’usuari.

---

## Què és BuildRank

BuildRank és una plataforma orientada a promoure un ús més responsable i sostenible de l’energia als edificis.

El sistema permet treballar amb informació d’edificis, dades energètiques, classificacions, rànquings, simulacions de millores, votacions internes, xat comunitari, verificació de millores i gestió de perfils.

Dit d’una manera simple: el backend valida, calcula i guarda la informació; el frontend la presenta i permet que l’usuari hi treballi de manera clara.

---

## Estat actual del projecte

La branca principal d’integració funcional és:

```text
Desenvolupament
```

La branca utilitzada per al desplegament web va ser:

```text
deploy/web
```

Els canvis de desplegament web ja s’han incorporat a `Desenvolupament`.

La branca `main` es reserva per a una versió final o estable quan `Desenvolupament` hagi estat revisada, netejada i validada.

---

## Tecnologies principals

- **Flutter**
- **Dart**
- **Material Design**
- **HTTP/JSON**
- **Shared Preferences**
- **Flutter Localizations**
- **Intl**
- **Flutter Map**
- **LatLong2**
- **Firebase Core**
- **Firebase Messaging**
- **Flutter Local Notifications**
- **Stream Chat Flutter**
- **Google Sign-In**
- **File Picker**
- **Flutter Launcher Icons**
- **Android Studio**
- **Visual Studio Code**
- **GitHub Actions**

---

## Dependències principals

El projecte Flutter es troba dins de:

```text
buildrank_mobile/
```

Les dependències principals declarades a `pubspec.yaml` inclouen:

```text
http                         peticions HTTP al backend
shared_preferences           persistència local de tokens i configuració
flutter_map                  mapa interactiu d’edificis
latlong2                     coordenades i suport geogràfic
firebase_core                inicialització de Firebase
firebase_messaging           notificacions push
flutter_local_notifications  notificacions locals
stream_chat_flutter          xat integrat
google_sign_in               autenticació amb Google
file_picker                  selecció de fitxers per pujades/documentació
http_parser                  suport multipart/content types
intl                         internacionalització i formats
flutter_localizations        localització Flutter
```

---

## Arquitectura general

El flux principal és:

```text
Usuari
→ App Flutter / Flutter Web
→ Nginx
→ Backend Django REST Framework
→ PostgreSQL
```

En l’arquitectura actual, el frontend no parla directament amb PostgreSQL ni amb Gunicorn. El frontend fa peticions HTTP a Nginx o a la URL base configurada, i Nginx redirigeix les rutes d’API cap al backend.

---

## Estructura del repositori

Estructura principal:

```text
.
├── .github/                  workflows de CI/CD
├── buildrank_mobile/          projecte Flutter principal
│   ├── android/               configuració Android
│   ├── assets/                imatges i recursos
│   ├── lib/                   codi Dart de l’aplicació
│   ├── test/                  tests Flutter
│   ├── pubspec.yaml           dependències i configuració Flutter
│   └── ...
├── .gitignore
└── README.md
```

Dins de `lib/`, el projecte segueix una organització per capes i funcionalitats:

```text
core/             configuració, serveis comuns i clients HTTP
features/         funcionalitats principals de l’app
l10n/             fitxers de traducció i localització
main.dart         punt d’entrada de l’aplicació
```

---

## Funcionalitats principals

El frontend dona suport a:

- registre i inici de sessió
- autenticació amb JWT
- persistència de sessió
- login amb Google
- consulta i edició de perfil
- gestió d’avatars d’usuari
- consulta d’edificis associats
- alta i consulta d’edificis
- visualització de fitxa d’edifici
- dades energètiques i indicadors
- Building Health Score i puntuacions
- mapes d’edificis
- classificació i rànquings
- lligues i temporades
- catàleg de millores
- simulacions de millores
- comparació abans/després
- votacions internes sobre simulacions
- acreditació de millores implementades
- validació administrativa de millores
- badges i gamificació
- notificacions
- xat comunitari amb Stream
- pujades de documents mitjançant file picker
- suport multidioma

Algunes funcionalitats poden dependre de la disponibilitat del backend, de variables d’entorn o de serveis externs com Firebase, Google Sign-In o Stream.

---

## Requisits previs

Abans de començar, és recomanable tenir instal·lat:

- Git
- Flutter SDK
- Dart SDK
- Android Studio
- Android SDK
- Android Emulator
- Visual Studio Code
- extensió Flutter per a VS Code
- extensió Dart per a VS Code
- Docker, si es vol provar contra backend local complet

Android Studio s’utilitza sobretot per gestionar l’SDK i l’emulador. Visual Studio Code és l’editor habitual de treball.

---

## Clonar el repositori

```bash
git clone https://github.com/ScoreLab-Team/FrontEnd-BuildRank.git
cd FrontEnd-BuildRank
```

Situar-se a la branca d’integració:

```bash
git switch Desenvolupament
git pull --ff-only origin Desenvolupament
```

Entrar al projecte Flutter:

```bash
cd buildrank_mobile
```

---

## Verificar l’entorn Flutter

Comprovar versions:

```bash
flutter --version
dart --version
```

Revisar l’estat general:

```bash
flutter doctor
```

Acceptar llicències Android si cal:

```bash
flutter doctor --android-licenses
```

Comprovar dispositius disponibles:

```bash
flutter devices
```

Si l’emulador no està encès, `flutter devices` no el detectarà.

---

## Instal·lar dependències

Des de `buildrank_mobile/`:

```bash
flutter pub get
```

Aquesta comanda descarrega les dependències definides a `pubspec.yaml`.

---

## Configuració de la URL del backend

El frontend centralitza la configuració de l’API al codi de configuració del projecte. La URL base es pot ajustar segons l’entorn.

La forma recomanada és utilitzar:

```bash
--dart-define=API_BASE_URL=<URL>
```

Això permet provar la mateixa app contra diferents entorns sense modificar el codi.

---

## URLs habituals segons entorn

### Emulador Android amb backend local via Docker + Nginx

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2
```

`10.0.2.2` és una adreça especial de l’emulador Android que apunta al localhost de l’ordinador host.

### Emulador Android amb Django runserver

Si el backend s’executa amb:

```bash
python manage.py runserver
```

normalment estarà a `127.0.0.1:8000`. Des de l’emulador:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

### Mòbil físic a la mateixa xarxa

Cal utilitzar la IP local de l’ordinador on corre el backend:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.13
```

Canvia `192.168.1.13` per la IP real.

### Staging a Virtech

```bash
flutter run --dart-define=API_BASE_URL=http://nattech.fib.upc.edu:40400
```

Important: l’entorn actual de Virtech exposa el servei per **HTTP**, no per HTTPS.

---

## Executar l’aplicació

Amb l’emulador encès o un dispositiu connectat:

```bash
flutter run
```

Amb una URL concreta de backend:

```bash
flutter run --dart-define=API_BASE_URL=http://nattech.fib.upc.edu:40400
```

Durant l’execució:

```text
r   hot reload
R   hot restart
q   aturar execució
```

---

## Build Android

Generar APK debug:

```bash
flutter build apk --debug
```

Generar APK release:

```bash
flutter build apk --release
```

El resultat habitual queda a:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Aquest APK es pot distribuir manualment o copiar a l’entorn de staging si es vol oferir una descàrrega directa.

---

## Build Web

Generar build web:

```bash
flutter build web
```

La sortida queda normalment a:

```text
build/web/
```

Aquest contingut es pot desplegar com a frontend estàtic, per exemple dins de:

```text
/opt/buildrank/app/frontend_build/
```

a la VM de Virtech.

---

## Descàrrega APK des de Virtech

En el desplegament actual, Nginx serveix el frontend web des de:

```text
/opt/buildrank/app/frontend_build/
```

Si es vol oferir una APK per descàrrega directa, es pot col·locar dins de:

```text
/opt/buildrank/app/frontend_build/downloads/
```

Per exemple:

```text
/opt/buildrank/app/frontend_build/downloads/buildrank.apk
```

La URL pública seria:

```text
http://nattech.fib.upc.edu:40400/downloads/buildrank.apk
```

Si `/downloads/` retorna `403 Forbidden`, no necessàriament és un error: simplement Nginx no mostra el llistat del directori. Cal accedir al fitxer concret.

---

## Endpoints principals consumits pel frontend

Les rutes poden evolucionar, però el frontend consumeix endpoints com:

### Accounts

```text
POST /api/accounts/register/
POST /api/accounts/login/
POST /api/accounts/refresh/
POST /api/accounts/logout/
GET  /api/accounts/me/
PATCH /api/accounts/me/
GET  /api/accounts/me/edificis/
```

### Buildings

```text
GET  /api/buildings/edificis/
POST /api/buildings/edificis/
GET  /api/buildings/edificis/<idEdifici>/
PATCH /api/buildings/edificis/<idEdifici>/
GET  /api/buildings/edificis/mapa/
GET  /api/buildings/carrers/autocomplete/
```

### Simulacions i millores

```text
GET  /api/buildings/millores/
POST /api/buildings/edificis/<idEdifici>/simulacions/preview/
GET  /api/buildings/edificis/<idEdifici>/simulacions/
POST /api/buildings/edificis/<idEdifici>/simulacions/
GET  /api/buildings/edificis/<idEdifici>/millores-implementades/
POST /api/buildings/millores-implementades/<id>/validar/
```

### Seasons, leagues, community i chat

```text
GET  /api/seasons/
GET  /api/leagues/
GET  /api/participations/
GET  /api/community/...
POST /api/community/...
GET  /api/chat/...
POST /api/chat/...
GET  /api/notifications/
```

---

## Localització i idiomes

El projecte utilitza `flutter_localizations` i `intl`.

Els fitxers de localització es troben a:

```text
lib/l10n/
```

Per regenerar localitzacions si cal:

```bash
flutter gen-l10n
```

El projecte té suport per diversos idiomes, incloent català, castellà i anglès.

---

## Notificacions

El frontend inclou dependències per:

```text
firebase_messaging
flutter_local_notifications
```

Això permet rebre notificacions push i gestionar notificacions locals, sempre que Firebase estigui configurat correctament per a l’entorn corresponent.

---

## Xat

El projecte utilitza:

```text
stream_chat_flutter
```

Això dona suport a funcionalitats de xat vinculades a la part comunitària de BuildRank. La disponibilitat real del xat depèn de la configuració del backend i de les claus/variables del servei extern.

---

## Google Sign-In

El frontend inclou:

```text
google_sign_in
```

Aquesta dependència dona suport a login amb Google. Perquè funcioni correctament cal que el backend i la configuració de Google/Firebase estiguin alineats.

---

## File Picker i documents

El frontend inclou:

```text
file_picker
```

S’utilitza per seleccionar fitxers quan cal pujar documents o evidències al backend, per exemple en fluxos de verificació o acreditació de millores.

---

## Tests i qualitat

Executar tests:

```bash
flutter test
```

Anàlisi estàtica:

```bash
flutter analyze
```

Format:

```bash
dart format .
```

Comprovació recomanada abans d’obrir PR:

```bash
dart format .
flutter analyze
flutter test
```

Si es vol validar compilació Android:

```bash
flutter build apk --debug
```

---

## Flutter Launcher Icons

El projecte utilitza:

```text
flutter_launcher_icons
```

La configuració es troba a `pubspec.yaml`.

Per regenerar icones:

```bash
dart run flutter_launcher_icons
```

---

## Flux mínim recomanat de prova

Amb backend i frontend preparats:

1. executar l’app
2. registrar un usuari o iniciar sessió
3. comprovar persistència de sessió
4. obrir perfil
5. editar dades de perfil o avatar
6. consultar edificis associats
7. consultar mapa o llistat d’edificis
8. obrir fitxa d’edifici
9. consultar dades energètiques
10. provar simulacions de millores
11. comprovar votacions o xat si l’entorn ho permet
12. revisar que no hi hagi errors de connexió ni permisos

---

## Problemes habituals

### Flutter no es reconeix

Normalment vol dir que Flutter no està ben afegit al `PATH` o que la terminal s’ha obert abans de configurar-lo.

### VS Code no mostra comandes de Flutter

Comprova si el workspace està en Restricted Mode o si no has obert correctament la carpeta del projecte.

### Flutter doctor avisa sobre Visual Studio

Es pot ignorar si l’objectiu és Android i no desenvolupament d’apps d’escriptori per Windows.

### L’emulador no surt a flutter devices

Assegura’t que l’emulador està encès abans d’executar:

```bash
flutter devices
```

### El frontend no connecta amb el backend en emulador

Si utilitzes Docker + Nginx:

```text
http://10.0.2.2
```

Si utilitzes Django runserver:

```text
http://10.0.2.2:8000
```

### El frontend no connecta amb mòbil físic

Comprova que:

- el mòbil i l’ordinador estan a la mateixa Wi-Fi
- s’ha passat bé `API_BASE_URL`
- el firewall no bloqueja la connexió
- Nginx i el backend estan aixecats

### El staging no carrega amb HTTPS

L’entorn actual de Virtech està exposat per HTTP:

```text
http://nattech.fib.upc.edu:40400
```

No utilitzis `https://nattech.fib.upc.edu:40400` si no s’ha configurat TLS.

### La descàrrega de l’APK no funciona

Comprova que el fitxer existeix:

```text
/opt/buildrank/app/frontend_build/downloads/buildrank.apk
```

i accedeix al fitxer concret:

```text
http://nattech.fib.upc.edu:40400/downloads/buildrank.apk
```

No n’hi ha prou amb entrar a `/downloads/`, perquè Nginx pot retornar `403` si no mostra el llistat de directori.

### Els avatars no carreguen

Comprova:

- que el backend retorna una URL correcta de media
- que el backend té `MEDIA_URL=/media/`
- que Nginx serveix `/media/`
- que el frontend no està bloquejant la URL
- que la URL base apunta a l’entorn correcte

### Hot reload no reflecteix el canvi

Prova `R` per fer hot restart. Si continua igual, atura amb `q` i torna a executar `flutter run`.

---

## Flux de treball recomanat amb Git

1. actualitzar `Desenvolupament`
2. crear una branca pròpia
3. fer els canvis
4. provar l’app
5. executar comprovacions bàsiques
6. fer commit
7. pujar la branca
8. obrir Pull Request

Exemple:

```bash
git switch Desenvolupament
git pull --ff-only origin Desenvolupament
git switch -c feature/nom-del-canvi
git add .
git commit -m "feat: descripció breu del canvi"
git push -u origin feature/nom-del-canvi
```

No s’hauria de fer push directe a `main`.

---

## Preparació de release cap a main

Abans de portar `Desenvolupament` cap a `main`, revisar:

- frontend alineat amb backend
- API base correcta
- build Android validat
- build Web validat si aplica
- README actualitzat
- cap fitxer generat o local versionat
- `flutter analyze` sense errors crítics
- `flutter test` executat
- CI verd
- staging validat si hi ha canvis de deploy

---

## Bones pràctiques

- no treballar directament sobre `main`
- utilitzar branques `feature/*`, `fix/*`, `docs/*` o `chore/*`
- no versionar builds generats
- no versionar APK/AAB dins del repositori
- mantenir URLs centralitzades
- utilitzar `--dart-define=API_BASE_URL=...` per canviar d’entorn
- executar `flutter pub get` després de canvis a `pubspec.yaml`
- executar `dart format .` abans de PRs grans
- executar `flutter analyze` i `flutter test` quan es toqui lògica rellevant
- documentar canvis importants que afectin backend, deploy o configuració
- no pujar secrets, tokens ni configuracions privades de serveis externs

---

## Resum ràpid

Si ets nou al projecte:

- **Flutter** és el framework principal
- **Dart** és el llenguatge de programació
- **buildrank_mobile/** conté l’app
- **pubspec.yaml** defineix dependències i assets
- **http** comunica amb el backend
- **shared_preferences** guarda dades simples com tokens
- **flutter_map** mostra mapes
- **Firebase Messaging** dona suport a notificacions push
- **Stream Chat** dona suport al xat
- **Google Sign-In** dona suport al login amb Google
- **file_picker** permet seleccionar documents
- **flutter_launcher_icons** genera les icones
- **Desenvolupament** és la branca d’integració
- **deploy/web** va servir per desplegar el frontend web
- **Virtech** exposa el servei públic per HTTP a `http://nattech.fib.upc.edu:40400`

---

## Llicència

Aquest projecte s’utilitza en el context acadèmic i de desenvolupament de BuildRank / ScoreLab. Si més endavant es defineix una llicència formal per al repositori, es podrà afegir aquí.