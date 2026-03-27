# BuildRank Frontend

Frontend mòbil de **BuildRank** desenvolupat amb **Flutter**.

Aquest repositori conté la part client de l’aplicació, és a dir, la interfície amb què interactua l’usuari final. El frontend s’encarrega de mostrar la informació, recollir accions de l’usuari, comunicar-se amb el backend i oferir una experiència clara, moderna i usable dins del sistema.

---

## Què és aquest projecte

BuildRank és una plataforma orientada a promoure un ús més responsable i sostenible de l’energia als edificis.

El frontend representa la capa visible del producte i té com a objectiu permetre que l’usuari pugui interactuar amb la plataforma d’una manera còmoda i comprensible.

En termes generals, aquest client mòbil està pensat per donar suport a funcionalitats com:

- inici de sessió i accés d’usuari
- consulta d’informació relacionada amb edificis
- visualització de dades i mètriques
- navegació entre seccions de la plataforma
- integració amb funcionalitats del sistema a mesura que el projecte evolucioni

Dit d’una manera simple: si el backend és qui valida, calcula i guarda la informació, el frontend és qui la presenta i permet que l’usuari hi treballi.

---

## Tecnologies principals

- **Flutter**
- **Dart**
- **Material Design**
- **Android Emulator / dispositius Android**
- **Visual Studio Code**
- **Android Studio**
- **Git i GitHub**

---

## Objectiu del repositori

Aquest repositori serveix per:

- desenvolupar el client mòbil de BuildRank
- provar la interfície i la navegació de l’aplicació
- integrar el frontend amb l’API del backend
- oferir una base de treball comuna per a tot l’equip

El projecte està pensat perquè els membres de l’equip puguin clonar-lo, preparar l’entorn i començar a executar l’aplicació amb un procés clar i reproduïble.

---

## Requisits previs

Abans de començar, convé tenir instal·lat:

- **Flutter SDK**
- **Dart**  
  (normalment ve integrat amb Flutter)
- **Android Studio**
- **Android SDK**
- **Android Emulator**
- **Visual Studio Code**
- **extensió Flutter per a VS Code**
- **Git**

> En el flux de treball de l’equip, **Android Studio** s’utilitza sobretot per gestionar l’SDK i l’emulador, mentre que **Visual Studio Code** s’utilitza com a editor principal.

---

## Onboarding ràpid per a una persona nova

La seqüència recomanada per començar a treballar al frontend és aquesta:

1. clonar el repositori
2. obrir-lo a Visual Studio Code
3. comprovar que l’entorn Flutter està ben instal·lat
4. preparar un emulador Android o connectar un dispositiu real
5. entrar a la carpeta de l’app Flutter
6. instal·lar dependències
7. executar l’aplicació
8. treballar en una branca pròpia i obrir Pull Request

---

## Posada en marxa en local

### 1. Clonar el repositori

```bash
git clone <URL_DEL_REPOSITORI>
cd <NOM_DEL_REPOSITORI>
```

### 2. Obrir el projecte amb VS Code

Obre la carpeta del repositori amb **File > Open Folder** a Visual Studio Code.

Quan VS Code ho demani, marca el projecte com a **trusted workspace**.

> Això és important perquè, si el projecte queda en **Restricted Mode**, algunes funcionalitats de Flutter o de les extensions poden no funcionar correctament.

---

## Verificació inicial de l’entorn

Abans d’executar l’app, comprova que Flutter està ben configurat.

### Comprovar versions

```bash
flutter --version
dart --version
```

### Revisar l’estat general de l’entorn

```bash
flutter doctor
```

### Acceptar llicències d’Android si cal

```bash
flutter doctor --android-licenses
```

Si `flutter doctor` marca algun problema rellevant, és millor resoldre’l abans de continuar.

---

## Preparar Android Studio i l’emulador

Per treballar amb el frontend mòbil, el més habitual és utilitzar un **emulador Android**.

### Passos recomanats

1. obrir **Android Studio**
2. anar a **More Actions > SDK Manager**
3. comprovar que l’**Android SDK** està instal·lat
4. anar a **Device Manager**
5. crear un emulador Android
6. arrencar-lo abans d’executar la comanda `flutter run`

> Important: si l’emulador no està encès, `flutter devices` no el detectarà.

---

## Entrar a la carpeta de l’app

Situa’t a la carpeta on hi ha el fitxer `pubspec.yaml`.

Per exemple, si el projecte es va crear dins d’una carpeta pròpia de Flutter:

```bash
cd buildrank_mobile
```

---

## Instal·lar dependències

Un cop dins de la carpeta de l’app, instal·la les dependències del projecte:

```bash
flutter pub get
```

Això descarrega els paquets necessaris definits a `pubspec.yaml`.

---

## Comprovar dispositius disponibles

Abans d’arrencar l’app, comprova quins dispositius detecta Flutter:

```bash
flutter devices
```

Si tot està bé, hi hauria d’aparèixer l’emulador Android o el dispositiu físic connectat.

---

## Executar l’aplicació

Per arrencar el frontend:

```bash
flutter run
```

La primera execució pot tardar una mica més perquè Flutter ha de compilar i desplegar l’aplicació.

---

## Comandes útils durant el desenvolupament

Mentre l’app està en execució, aquestes ordres són especialment útils:

### Hot reload

```text
r
```

Aplica canvis ràpids de la interfície sense reiniciar tota l’app.

És ideal per a:
- canvis visuals
- textos
- estils
- maquetació
- petits ajustos de widgets

### Hot restart

```text
R
```

Reinicia l’aplicació més a fons.

És útil quan:
- canvia l’estructura de l’app
- canvia l’estat inicial
- hi ha modificacions més profundes i el hot reload no és suficient

### Sortir de l’execució

```text
q
```

Atura l’execució actual de `flutter run`.

---

## Connexió amb el backend

El frontend està pensat per comunicar-se amb el backend de BuildRank mitjançant API.

De manera general, el flux esperat és:

1. l’usuari introdueix les seves credencials
2. el frontend envia la petició al backend
3. el backend valida la informació
4. si és correcta, retorna la resposta corresponent
5. el frontend desa el context necessari i continua la navegació
6. les peticions posteriors es fan cap als endpoints protegits quan calgui

---

## URL del backend segons l’entorn de prova

Quan el frontend es prova en un **emulador Android**, la màquina host no s’accedeix amb `localhost`, sinó habitualment amb:

```text
http://10.0.2.2:8000
```

Quan el frontend es prova en un **mòbil físic** connectat a la mateixa xarxa Wi-Fi que l’ordinador on corre el backend, normalment s’utilitza:

```text
http://IP_DEL_TEU_ORDINADOR:8000
```

Exemple:

```text
http://192.168.1.34:8000
```

> Això és important perquè una de les fonts de confusió més habituals és pensar que `localhost` dins l’emulador Android apunta a l’ordinador host, quan en realitat no funciona així.

---

## Problemes habituals

### `flutter` no es reconeix

Normalment vol dir que Flutter no està ben afegit al `PATH`, o que la terminal s’ha obert abans de configurar-lo.

### VS Code no mostra bé comandes o extensions de Flutter

Comprova si el workspace està en **Restricted Mode** o si no has obert correctament la carpeta del projecte.

### `flutter doctor` avisa sobre Visual Studio

Per aquesta fase es pot ignorar si el vostre objectiu és Android i no desenvolupament d’apps d’escriptori per Windows.

### L’emulador no surt a `flutter devices`

Assegura’t que l’emulador està encès abans d’executar la comanda.

### El canvi no es reflecteix a l’app

Prova primer amb `r` per hot reload. Si el canvi és més profund, utilitza `R` per hot restart.

### El push a `main` falla

És possible que la branca `main` estigui protegida i que el repositori obligui a treballar amb **Pull Request**.

---

## Flux de treball recomanat amb Git

La forma recomanada de treballar en aquest repositori és:

1. actualitzar la branca principal
2. crear una branca de treball nova
3. fer els canvis necessaris
4. provar l’app en local
5. fer commit
6. pujar la branca
7. obrir una Pull Request

Exemple habitual:

```bash
git switch -c feature/nom-del-canvi
git add .
git commit -m "feat: descripció breu del canvi"
git push -u origin feature/nom-del-canvi
```

> Si el repositori té `main` protegida, no s’ha de fer push directe a `main`.

---

## Comandes útils de Git

### Veure l’estat del repositori

```bash
git status
```

### Afegir canvis

```bash
git add .
```

### Crear commit

```bash
git commit -m "feat: descripció del canvi"
```

### Crear branca nova

```bash
git switch -c feature/nom-del-canvi
```

### Pujar la branca al remot

```bash
git push -u origin feature/nom-del-canvi
```

---

## Bones pràctiques

- comprova `flutter doctor` quan preparis un ordinador nou
- no treballis directament sobre `main` si el repo funciona amb Pull Requests
- encén l’emulador abans d’executar `flutter run`
- utilitza `r` i `R` segons el tipus de canvi
- prova els canvis bàsics abans de fer commit
- mantén el codi clar i coherent amb l’estil del projecte
- documenta els canvis importants si afecten el funcionament general

---

## Resum ràpid

Si ets nou al projecte, queda’t amb aquesta idea:

- **Flutter** és el framework principal del frontend
- **Dart** és el llenguatge de programació
- **VS Code** és l’editor habitual de treball
- **Android Studio** s’utilitza per l’SDK i l’emulador
- **flutter doctor** serveix per validar l’entorn
- **flutter run** arrenca l’app
- **r** fa hot reload
- **R** fa hot restart
- **q** atura l’execució
- el treball habitual es fa en una **branca feature** i es tanca amb **Pull Request**

---

## Llicència

Aquest projecte s’utilitza en el context acadèmic i de desenvolupament de BuildRank / ScoreLab. Si més endavant es defineix una llicència formal per al repositori, es podrà afegir aquí.
