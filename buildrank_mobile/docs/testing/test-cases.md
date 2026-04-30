# Casos de prova principals

| ID | Tipus | Funcionalitat | Precondició | Passos | Resultat esperat | Estat |
|---|---|---|---|---|---|---|
| TC-BE-001 | API | Login correcte | Usuari existent | POST /api/accounts/login/ | 200 + tokens | Pendent |
| TC-BE-002 | API | Login incorrecte | Usuari existent | Password erroni | 400/401 | Pendent |
| TC-BE-003 | API | Accés sense token | Cap token | GET /api/accounts/me/ | 401 | Pendent |
| TC-BE-004 | API | Detall edifici | Admin autenticat | GET /api/buildings/edificis/1/ | 200 + dades edifici | Pendent |
| TC-BE-005 | API | Classificació insuficient | Edifici sense habitatges | GET detall edifici | font=insuficient | Pendent |
| TC-BE-006 | API | Preview simulació | Edifici existent | POST preview | 200 + no persisteix | Pendent |
| TC-BE-007 | API | Guardar simulació | Admin autenticat | POST simulacions | 201 + registre BD | Pendent |
| TC-FE-001 | UI | Registre | App oberta | Crear compte | Redirecció a login | Pendent |
| TC-FE-002 | UI | Fitxa edifici | Login fet | Obrir edifici | Dades reals visibles | Pendent |
| TC-FE-003 | UI | Simulació | Edifici obert | Seleccionar millores | Preview visible | Pendent |
| TC-BE-008 | API | Llistar temporades | Usuari autenticat | GET /api/seasons/ | 200 + temporada activa visible | PASS |
| TC-BE-009 | API | Llistar lligues | Usuari autenticat | GET /api/leagues/ | 200 + lliga associada a temporada | PASS |
| TC-BE-010 | API | Llistar participacions | Usuari autenticat | GET /api/participations/ | 200 + participació de l’edifici actual | PASS |
| TC-BE-011 | API | Ranking de lliga | Usuari autenticat + lliga amb participacions | GET /api/leagues/{id}/ranking/ | 200 + ranking paginat ordenat per puntuació | PASS |
| TC-BE-012 | API | Ranking de grup comparable | Usuari autenticat + edificis amb grup comparable | GET /api/leagues/{id}/ranking/?group={groupId} | 200 + ranking filtrat pel grup comparable | PASS |
| TC-BE-013 | API | Posició edifici respecte Top N | Usuari autenticat + participació existent | GET /api/leagues/{id}/posicio_edifici/?edifici={id}&top={n}&segment=true | 200 + posició, puntuació actual i punts fins al top seleccionat | PASS |
| TC-FE-004 | Widget | RankingScreen carregada | Servei fake amb dades de ranking | Renderitzar RankingScreen | Es mostra temporada, lliga, posició i ranking | PASS |
| TC-FE-005 | Widget | Toggle edificis similars | RankingScreen carregada | Prémer “Edificis similars” | Es demana el ranking amb scope comparable | PASS |
| TC-FE-006 | Widget | Selector Top 3/5/10 | RankingScreen carregada | Prémer “Top 5” | Es recarrega la posició amb targetTop=5 | PASS |
| TC-FE-007 | Widget | Carregar més competidors | Ranking amb més pàgines | Prémer “Carrega més competidors” | Es carrega la pàgina següent i es manté el ranking existent | PASS |
| TC-FE-008 | Widget | Estat d’error del ranking | Servei fake amb error | Renderitzar RankingScreen | Es mostra missatge d’error i botó de reintent | PASS |