# Pla de proves de BuildRank

## Objectiu
Validar que les funcionalitats principals de BuildRank funcionen correctament i que els canvis introduïts no trenquen autenticació, permisos, edificis, simulació, classificació energètica ni persistència.

## Abast
S’inclouen proves de backend, frontend, integració API, sistema i acceptació manual.

## Tipus de proves
- Proves unitàries
- Proves d’integració
- Proves de sistema
- Proves d’acceptació
- Proves manuals documentades
- Proves de regressió

## Eines
- Django TestCase / APITestCase
- Flutter Test
- GitHub Actions
- Postman
- DBeaver
- Docker / PostgreSQL
- Flutter emulator / dispositiu físic

## Criteri general
Una funcionalitat només es considera acabada si compleix els criteris d’acceptació, passa els tests corresponents, supera el CI i ha estat validada manualment si afecta un flux visible d’usuari.

## Proves específiques de ranking i lligues

Per la integració del ranking amb backend real, s’afegeixen proves manuals d’API i widget tests de frontend sobre la pantalla de ranking.

La validació cobreix:

- existència d’una temporada activa;
- existència d’una lliga associada a la temporada activa;
- existència d’una participació per l’edifici actual;
- consulta del ranking complet d’una lliga;
- consulta del ranking filtrat per grup comparable;
- consulta de la posició de l’edifici respecte a un Top N;
- selecció de Top 3, Top 5 i Top 10 des de la RankingScreen;
- paginació mitjançant “Carrega més competidors”;
- estat d’error quan el servei de ranking falla.

Els endpoints validats manualment són:

```http
GET /api/seasons/
GET /api/leagues/
GET /api/participations/
GET /api/leagues/{id}/ranking/
GET /api/leagues/{id}/ranking/?group={groupId}
GET /api/leagues/{id}/posicio_edifici/?edifici={id}&top={n}&segment=true