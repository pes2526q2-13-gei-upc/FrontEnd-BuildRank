# BuildRank Frontend

Frontend mòbil de **BuildRank**, desenvolupat amb **Flutter** i **Dart**.

Aquest repositori conté la part client de l’aplicació. És la capa amb què interactua l’usuari final. El frontend mostra la informació, recull accions de l’usuari, es comunica amb el backend i ofereix una experiència clara, moderna i usable dins del sistema BuildRank.

---

## Què és BuildRank

BuildRank és una plataforma orientada a promoure un ús més responsable i sostenible de l’energia als edificis.

El sistema permet treballar amb informació d’edificis, dades energètiques, classificacions, rànquings, simulacions de millores i altres funcionalitats relacionades amb la gestió i comparació d’edificis.

Dit d’una manera simple: si el backend valida, calcula i guarda la informació, el frontend és qui la presenta i permet que l’usuari hi treballi.

---

## Què fa aquest frontend

El frontend de BuildRank dona suport a funcionalitats com:

- registre i inici de sessió
- persistència de sessió amb tokens
- consulta del perfil de l’usuari autenticat
- edició i visualització d’informació d’usuari
- consulta d’edificis associats a l’usuari
- alta i consulta d’edificis
- navegació per fitxa d’edifici
- visualització de dades energètiques i mètriques
- rànquing i posicionament dins la lliga
- catàleg de millores
- simulacions de millores
- visualització de resultats abans/després
- base visual per a funcionalitats comunitàries

Algunes funcionalitats poden estar en estat parcial o en evolució segons la branca i l’estat del sprint.

---

## Tecnologies principals

- **Flutter**
- **Dart**
- **Material Design**
- **Android Emulator**
- **Dispositius Android físics**
- **Visual Studio Code**
- **Android Studio**
- **Git i GitHub**
- **API REST amb HTTP/JSON**

---

## Estructura general

El frontend consumeix la API del backend. El flux general és:

```text
Usuari
→ App Flutter
→ Nginx
→ Backend Django REST Framework
→ PostgreSQL
```

En l’arquitectura actual amb Docker i Nginx, el frontend no parla directament amb Gunicorn ni amb PostgreSQL. El frontend parla amb Nginx, i Nginx redirigeix les peticions cap al backend.

---

## Requisits previs

Abans de començar, convé tenir instal·lat:

- **Flutter SDK**
- **Dart**
- **Android Studio**
- **Android SDK**
- **Android Emulator**
- **Visual Studio Code**
- **extensió Flutter per a VS Code**
- **Git**

Android Studio s’utilitza sobretot per gestionar l’SDK i l’emulador. Visual Studio Code és l’editor habitual de treball.

---

## Onboarding ràpid

La seqüència recomanada per començar és:

1. clonar el repositori
2. situar-se a la branca `Desenvolupament`
3. obrir el projecte a VS Code
4. comprovar l’entorn Flutter
5. encendre un emulador Android o connectar un dispositiu físic
6. entrar a la carpeta de l’app Flutter
7. instal·lar dependències
8. comprovar la configuració de la API
9. executar l’aplicació
10. provar el flux principal

---

## Clonar el repositori

```bash
git clone <URL_DEL_REPOSITORI_FRONTEND>
cd <NOM_DEL_REPOSITORI_FRONTEND>
```

Situar-se a la branca d’integració:

```bash
git checkout Desenvolupament
git pull
```

---

## Obrir el projecte amb VS Code

Obre la carpeta del repositori amb **File > Open Folder**.

Quan VS Code ho demani, marca el projecte com a **trusted workspace**.

Si el projecte queda en **Restricted Mode**, algunes funcionalitats de Flutter o de les extensions poden no funcionar correctament.

---

## Verificació inicial de l’entorn

Comprovar versions:

```bash
flutter --version
dart --version
```

Revisar l’estat general:

```bash
flutter doctor
```

Acceptar llicències d’Android si cal:

```bash
flutter doctor --android-licenses
```

Si `flutter doctor` mostra errors importants, és millor resoldre’ls abans de continuar.

---

## Preparar Android Studio i l’emulador

Per treballar amb el frontend mòbil, el més habitual és utilitzar un emulador Android.

Passos recomanats:

1. obrir **Android Studio**
2. anar a **More Actions > SDK Manager**
3. comprovar que l’Android SDK està instal·lat
4. anar a **Device Manager**
5. crear o seleccionar un emulador Android
6. arrencar l’emulador abans d’executar `flutter run`

Comprovar dispositius disponibles:

```bash
flutter devices
```

Si l’emulador no està encès, `flutter devices` no el detectarà.

---

## Entrar a la carpeta de l’app

Situa’t a la carpeta on hi ha el fitxer `pubspec.yaml`.

```bash
cd buildrank_mobile
```

---

## Instal·lar dependències

```bash
flutter pub get
```

Aquesta comanda descarrega els paquets definits a `pubspec.yaml`.

---

## Configuració centralitzada de la API

La configuració de la API està centralitzada al fitxer:

```text
api_config.dart
```

Aquest fitxer evita tenir URLs repartides per pantalles o serveis. Si canvia l’entorn del backend, només s’ha d’ajustar aquest fitxer o passar una variable amb `--dart-define`.

La URL per defecte és:

```dart
static const String _defaultBaseUrl = 'http://10.0.2.2';
```

`10.0.2.2` és una adreça especial de l’emulador Android. Des de l’emulador, apunta al localhost de l’ordinador host.

---

## URL del backend segons l’entorn

### Emulador Android amb Docker + Nginx

Aquest és el cas recomanat actualment.

```text
http://10.0.2.2
```

Amb Docker + Nginx no fem servir `:8000` per defecte, perquè el frontend parla amb Nginx.

Execució habitual:

```bash
flutter run
```

### Mòbil físic a la mateixa xarxa

Si proves amb un mòbil físic connectat a la mateixa Wi-Fi que l’ordinador on corre el backend, passa la IP local de l’ordinador:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.13
```

Canvia `192.168.1.13` per la IP real del teu ordinador.

### Staging a Virtech

Si vols provar contra l’entorn de staging:

```bash
flutter run --dart-define=API_BASE_URL=http://nattech.fib.upc.edu:40400
```

### Mode alternatiu amb Django runserver

Si no estàs utilitzant Docker + Nginx i executes Django directament amb:

```bash
python manage.py runserver
```

llavors el backend normalment estarà a:

```text
http://127.0.0.1:8000
```

i des de l’emulador caldrà executar:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Aquest mode és útil per depurar, però no és el flux principal quan es vol provar l’arquitectura actual amb Nginx.

---

## Endpoints centralitzats al frontend

El fitxer `api_config.dart` defineix els endpoints principals.

### Accounts i autenticació

```text
POST /api/accounts/register/
POST /api/accounts/login/
POST /api/accounts/refresh/
POST /api/accounts/logout/
GET  /api/accounts/me/
GET  /api/accounts/me/edificis/
```

### Buildings

```text
GET  /api/buildings/carrers/autocomplete/
GET  /api/buildings/localitzacions/
GET  /api/buildings/edificis/
POST /api/buildings/edificis/
GET  /api/buildings/edificis/<idEdifici>/
```

### Millores i simulacions

```text
GET  /api/buildings/millores/
POST /api/buildings/edificis/<idEdifici>/simulacions/preview/
GET  /api/buildings/edificis/<idEdifici>/simulacions/
GET  /api/buildings/edificis/<idEdifici>/millores-implementades/
```

Aquests endpoints permeten provar registre, login, perfil, edificis, autocompletat de carrers, catàleg de millores, simulacions i millores implementades.

---

## Executar l’aplicació

Amb l’emulador encès i les dependències instal·lades:

```bash
flutter run
```

La primera execució pot tardar més perquè Flutter ha de compilar i desplegar l’aplicació.

---

## Comandes útils durant el desenvolupament

Mentre l’app està en execució:

```text
r
```

Fa **hot reload**. És útil per canvis visuals, textos, estils i petits ajustos de widgets.

```text
R
```

Fa **hot restart**. És útil quan canvia l’estat inicial, l’estructura de l’app o quan el hot reload no és suficient.

```text
q
```

Atura l’execució de `flutter run`.

---

## Comprovacions recomanades abans de fer commit

Format:

```bash
dart format .
```

Anàlisi estàtica:

```bash
flutter analyze
```

Tests:

```bash
flutter test
```

Build debug:

```bash
flutter build apk --debug
```

Aquestes comprovacions ajuden a detectar errors abans d’obrir una Pull Request.

---

## Flux mínim recomanat de prova

Amb backend i frontend aixecats:

1. executar l’app
2. registrar un usuari
3. iniciar sessió
4. comprovar que la sessió queda guardada
5. consultar el perfil
6. consultar edificis de l’usuari
7. crear o consultar un edifici
8. obrir la fitxa d’edifici
9. consultar millores
10. executar una simulació si hi ha un edifici disponible
11. revisar que no apareguin errors de connexió ni de permisos

---

## Problemes habituals

### `flutter` no es reconeix

Normalment vol dir que Flutter no està ben afegit al `PATH` o que la terminal s’ha obert abans de configurar-lo.

### VS Code no mostra bé comandes o extensions de Flutter

Comprova si el workspace està en **Restricted Mode** o si no has obert correctament la carpeta del projecte.

### `flutter doctor` avisa sobre Visual Studio

Es pot ignorar si l’objectiu és Android i no desenvolupament d’apps d’escriptori per Windows.

### L’emulador no surt a `flutter devices`

Assegura’t que l’emulador està encès abans d’executar la comanda.

### El frontend no connecta amb el backend en emulador

Si estàs utilitzant Docker + Nginx, revisa que la URL sigui:

```text
http://10.0.2.2
```

No utilitzis `:8000` en aquest cas.

### El frontend no connecta amb mòbil físic

Comprova que:

- el mòbil i l’ordinador estan a la mateixa Wi-Fi
- s’ha passat bé `API_BASE_URL`
- el firewall no bloqueja la connexió
- Nginx i el backend estan aixecats

Exemple:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.13
```

### Error de CORS o CSRF

Cal revisar la configuració del backend:

- `CORS_ALLOWED_ORIGINS`
- `CSRF_TRUSTED_ORIGINS`
- host o IP utilitzada pel frontend

### El canvi no es reflecteix a l’app

Prova primer amb `r` per hot reload. Si el canvi és més profund, utilitza `R` per hot restart.

### El push a `main` falla

És possible que la branca `main` estigui protegida. El flux recomanat és treballar en una branca pròpia i obrir Pull Request.

---

## Flux de treball recomanat amb Git

1. actualitzar la branca d’integració
2. crear una branca de treball
3. fer els canvis
4. provar l’app en local
5. executar comprovacions bàsiques
6. fer commit
7. pujar la branca
8. obrir una Pull Request

Exemple:

```bash
git checkout Desenvolupament
git pull
git switch -c feature/nom-del-canvi
git add .
git commit -m "feat: descripció breu del canvi"
git push -u origin feature/nom-del-canvi
```

No s’hauria de fer push directe a `main`.

---

## Bones pràctiques

- comprova `flutter doctor` quan preparis un ordinador nou
- treballa sobre `Desenvolupament` o sobre una branca `feature`
- no treballis directament sobre `main`
- encén l’emulador abans d’executar `flutter run`
- utilitza `api_config.dart` per centralitzar endpoints
- no dupliquis URLs a pantalles o serveis
- utilitza `--dart-define=API_BASE_URL=...` per canviar d’entorn
- prova els canvis abans de fer commit
- executa `flutter analyze` i `flutter test` quan toquis lògica rellevant
- documenta canvis importants si afecten la connexió amb backend

---

## Resum ràpid

Si ets nou al projecte, queda’t amb aquesta idea:

- **Flutter** és el framework principal del frontend
- **Dart** és el llenguatge de programació
- **VS Code** és l’editor habitual
- **Android Studio** s’utilitza per l’SDK i l’emulador
- **api_config.dart** centralitza la URL base i els endpoints
- amb emulador i Docker + Nginx, la URL és `http://10.0.2.2`
- amb mòbil físic, es passa la IP amb `--dart-define`
- amb staging, es passa la URL de Virtech amb `--dart-define`
- **flutter run** arrenca l’app
- **r** fa hot reload
- **R** fa hot restart
- **q** atura l’execució
- el treball habitual es fa en branca pròpia i es tanca amb Pull Request

---

## Llicència

Aquest projecte s’utilitza en el context acadèmic i de desenvolupament de BuildRank / ScoreLab. Si més endavant es defineix una llicència formal per al repositori, es podrà afegir aquí.
