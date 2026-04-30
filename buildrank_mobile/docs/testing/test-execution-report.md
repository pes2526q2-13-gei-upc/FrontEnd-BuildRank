# Test Execution Report - BuildRank

| Data | Branca | Executor | Suite | Resultat | Incidències |
|---|---|---|---|---|---|
| 2026-04-XX | feature/implementacio-millores | Equip | Backend accounts/buildings | PASS | Cap |
| 2026-04-XX | feature/simulacio-screen | Equip | Flutter analyze/test/build | PASS | Cap |
| 2026-04-XX | Local Docker | Equip | Postman simulació | PASS | Cap |
| 2026-04-30 | feature/ranking-integration | Bernat | Flutter ranking integration + widget tests | PASS | Cap |

## Incidències detectades
- Conflicte de migracions entre dues branques 0009. Resolució: merge migration.
- Camp de validació antic `EN_PROCES` substituït per `EN_REVISIO`.
- Autocomplete de carrers no mostrava resultats fins carregar dataset i adaptar frontend.
- Durant la validació manual del ranking, s’han creat dades locals de prova: temporada activa, lliga, participacions, grup comparable i edificis addicionals per validar paginació i comparació amb Top 3/5/10.
- El ranking comparable actual funciona dins de la mateixa lliga. El ranking comparable global a nivell de temporada queda documentat com a millora per a Sprint 3.

## Limitacions
- Cobertura frontend encara inicial.
- E2E automatitzat no implementat.
- Proves de rendiment pendents.

## Accions de millora
- Afegir tests Flutter de models i serveis.
- Afegir coverage al CI.
- Documentar col·lecció Postman.
- Afegir llindars de cobertura progressius.
- Afegir endpoint de participació actual d’un edifici per evitar carregar totes les participacions al frontend.
- Fer que /api/leagues/{id}/ranking/ retorni més informació de cada edifici, com nom, adreça, lliga, temporada i grup comparable.
- Afegir suport real de cerca al ranking.
- Afegir endpoint de ranking comparable global per temporada: /api/seasons/{id}/ranking/?group={groupId}.
- Registrar temporades, lligues, participacions i grups comparables al Django Admin.