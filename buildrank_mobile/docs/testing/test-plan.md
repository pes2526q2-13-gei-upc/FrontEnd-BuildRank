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