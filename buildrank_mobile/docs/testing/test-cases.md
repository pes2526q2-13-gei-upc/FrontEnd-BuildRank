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