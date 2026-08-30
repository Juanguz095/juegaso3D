# OPERACIÓN BOLÍVAR — Game Design Document
> Callao, Perú · 2026 · Infiltración · Acción · Mundo semiabierto
> Inspirado en Deus Ex

---

## Concepto

**Operación Bolívar** es un juego de acción y mundo semiabierto ambientado en el Callao, Perú (2026). El jugador controla a **Kervin**, un agente de policía encubierto que se infiltra en el I.E.S. Simón Bolívar para desmantelar una red de distribución de la sustancia ficticia **NOVA**.

El juego mezcla infiltración, investigación, combate táctico y secuencias de persecución, con un tono que combina comedia situacional con momentos de tensión real. Fuertemente inspirado en **Deus Ex** en su filosofía de libertad de approachs, consecuencias narrativas de las decisiones del jugador y múltiples rutas para resolver cada situación.

- **Género:** Acción · Infiltración · Mundo semiabierto · Historia narrativa
- **Inspiración principal:** Deus Ex — libertad de enfoque, builds de personaje, elecciones con consecuencias, sigilo y combate como opciones equivalentes

---

## Core loop

El loop principal alterna entre dos modos: **infiltración** (investigación, socialización, minijuegos) y **acción** (combate, persecuciones). El tránsito entre ambos es la tensión central del juego.

```
Investigar → Socializar → Descubrir pista → Conflicto → Acción / fuga → Consecuencias → Reinvestigar
```

Inspirado en Deus Ex: ninguna situación tiene una sola solución. El jugador siempre puede elegir entre sigilo, diálogo o confrontación directa. Las consecuencias de cada decisión se acumulan a lo largo de la campaña.

---

## Pilares del juego

- **Libertad de enfoque** — Inspirado en Deus Ex: cada misión puede completarse por sigilo, diálogo, hackeo o combate directo. El juego no juzga el método, solo las consecuencias.
- **Identidad doble** — El jugador gestiona la identidad falsa de Kervin (Pepito) y ocasionalmente la de Jesús (Tito). La confusión de identidades genera situaciones cómicas con consecuencias reales.
- **Mundo reactivo** — Las acciones del jugador afectan la reputación, la confianza de los NPCs y el estado de la operación. Un error puede comprometer misiones enteras.
- **Narrativa con humor** — Historia seria en su trasfondo (narco, infiltración) pero con comedia situacional constante entre Kervin, Jesús y Kenjo. El tono nunca es completamente oscuro.

---

## Movimiento

Inspirado en Deus Ex. El movimiento no está diseñado para ser espectacular sino para servir al enfoque del jugador: el mismo escenario puede cruzarse por el techo, por la puerta principal o por una ventana trasera dependiendo del build y las decisiones previas.

- **Movimiento estándar** — caminar / correr, agacharse para sigilo o para acceder a conductos y zonas bajas
- **Trepar / escalar** — acceder a zonas elevadas del instituto o del Callao para ventaja táctica o rutas alternativas
- **Cambio entre protagonistas** — fuera de combate, el jugador alterna entre Kervin (social/fuerza) y Jesús (tecnología/sigilo) según lo que requiera la situación
- **Conducción** — secuencias de persecución vehicular con esquiva de tráfico y atajos

> El movimiento debe sentirse funcional y deliberado. El jugador que planifica su ruta antes de entrar a una zona tiene ventaja real sobre el que improvisa.

---

## Armas

Inspirado en Deus Ex: el combate es una opción, no la única. Las armas tienen usos no letales disponibles y el juego no penaliza al jugador que prefiere no usarlas. La elección de armamento refleja el enfoque del jugador para esa misión.

### Kervin (Pepito) — Fuerza · Improvisación · Confrontación directa
- Pistola policial (letal / no letal según munición)
- Objetos del entorno (improvisado, situacional)
- Dispositivo TAQ (fase final, construido con conocimientos de Química adquiridos en la infiltración)
- Golpe no letal para neutralizar sin alertar

### Jesús (Tito) — Tecnología · Sigilo · Información
- Pistola de precisión con modo tranquilizante
- Dispositivo de hackeo (desactiva cámaras, abre puertas, extrae datos)
- Cámara de vigilancia portátil para marcar enemigos
- Disparo de distracción para crear rutas seguras

---

## Enemigos

Inspirado en Deus Ex: cada tipo de enemigo puede ser neutralizado, evadido o manipulado. Matar no es siempre la mejor opción — algunos NPCs hostiles pueden volverse fuentes de información si se les aborda correctamente.

- **Estudiantes problemáticos** (Luis, Chipana, Cristopher, Sandro) — Combate básico, ataques predecibles. Débiles individualmente pero peligrosos en masa.
- **PRYME** (Tommy, Andrés, Bruno, Dayra, Franco) — No son combatientes clásicos. Tienen ventaja social y de red. Tommy es el jefe de esta facción.
- **Narcos externos** — Adultos, armados, tácticos. Mayor resistencia. Aparecen en la fase final. Comportamiento agresivo y coordinado.
- **Lozano (jefe final)** — Docente de TAQ. Combate sorpresivo. Usa armas de fuego. Su fase como jefe es la revelación más impactante del juego.

---

## Salud

Inspirado en Deus Ex: la salud no se regenera sola. El jugador debe gestionarla como recurso, lo que hace que evitar el combate sea una decisión válida y a veces óptima.

| Mecánica | Descripción |
|---|---|
| Botiquines | Recuperan HP. Encontrados en el entorno o comprados. Ocupan inventario. |
| Cobertura táctica | Reducen el daño entrante mientras el jugador se reposiciona |
| Neutralización no letal | No genera alertas secundarias, conserva más recursos |
| Daño acumulativo | Las heridas no tratadas afectan el rendimiento (velocidad, precisión) |

- **Kervin — Enfoque directo:** Mayor resistencia base, puede absorber más daño antes de necesitar curación.
- **Jesús — Enfoque técnico:** Menor resistencia, pero el hackeo y el sigilo evitan que reciba daño en primer lugar.

---

## Recursos

- **Puntos de aura** — se ganan en las Batallas de Aura. Desbloquean poses, bailes y habilidades sociales con NPCs.
- **Reputación** — medida por facción (TAQ, PRYME, Dirección). Alta reputación abre diálogos y misiones ocultas.
- **Evidencias** — documentos, fotos, conversaciones interceptadas. Necesarias para la resolución de la trama.
- **Munición / gadgets** — limitados. Los objetos del entorno compensan la escasez.
- **Información de cobertura** — datos de las identidades falsas. Los errores narrativos (ej. Misión 4) pueden bloquear recursos temporalmente.

---

## Niveles

### Zona 1 — I.E.S. Simón Bolívar (hub principal)
Aulas, TAQ (Química), Sistemas (DSI), laboratorios, patios, canchas, dirección, enfermería, zonas restringidas. Escenario de la mayor parte de la investigación.

### Zona 2 — Callao / calles (desbloqueada progresivamente)
Bellavista, calles, mercados, parques, avenidas, zonas industriales. Escenario de persecuciones vehiculares y misiones de seguimiento.

### Zona 3 — Comisaría (base de operaciones)
Briefings con Kenjo, revisión de evidencias, inicio y cierre de misiones.

### Tipos de misión
| Tipo | Misiones ejemplo |
|---|---|
| Exploración | 1, 3, 6, 9, 12 — recorrer el instituto, observar, hablar con NPCs |
| Sigilo | 11, 14 — quedarse después de clases, investigar sin ser visto |
| Minijuego | 9, 16 — Batalla de Aura |
| Persecución vehicular | 18 — seguimiento al grupo con el vehículo de Checho |
| Combate / jefes | 23–26 — combate 2v2, narcos, Lozano |

---

## Condiciones de victoria / derrota

### Victoria
- Lozano y los narcos detenidos
- NOVA asegurada y entregada a Kenjo
- Evidencias recuperadas
- Kervin y Jesús sobreviven

### Derrota
- Salud de Kervin o Jesús llega a 0
- La cobertura es expuesta antes de tiempo (fallo narrativo)
- Evidencias destruidas por los antagonistas
- Fallo en secuencia de persecución crítica

Las misiones de infiltración tienen un tercer estado: **fallo parcial**. Si Kervin comete errores de identidad (ej. Misión 4), la operación continúa pero con consecuencias narrativas visibles.

---

## Estética

- **Visual general** — Realismo estilizado. Entornos reconocibles del Callao y Bellavista. Paleta urbana: grises, amarillos de calle, azules nocturnos.
- **Influencia Deus Ex** — UI funcional y densa. El jugador siempre tiene información sobre su entorno: NPCs marcados, cámaras visibles, rutas disponibles.
- **HUD en infiltración** — Muestra reputación por facción, nivel de alerta, mapa de zona y estado de cobertura.
- **HUD en combate** — Muestra HP, inventario rápido, estado de los protagonistas y alertas activas.
- **Audio** — Música instrumental urbana en exploración. Electrónica / industrial agresiva en combate. Diálogos en español peruano.
- **Batallas de Aura** — Estética de minijuego separada: fondo negro, efectos de neón, crowd en silueta, música electrónica. Visualmente diferenciado para subrayar lo absurdo del momento.

---

## MVP

El MVP debe demostrar los dos pilares principales: **infiltración funcional** y **libertad de enfoque estilo Deus Ex**. Cubre las Misiones 1–5 más el combate de la Misión Final (fases 1 y 2).

> El MVP prioriza que una misma situación pueda resolverse de al menos dos formas distintas (sigilo o confrontación). Si el juego solo funciona como shooter, el diseño falló.

### Incluido en MVP
- [ ] Mapa del instituto (jugable)
- [ ] Control de Kervin + movimiento básico (correr, agacharse, trepar)
- [ ] Sistema de combate con opciones letales y no letales
- [ ] Sistema de hackeo básico de Jesús (puertas, cámaras)
- [ ] Sistema de cobertura y sigilo de Jesús
- [ ] 2–3 tipos de enemigos con IA básica
- [ ] Cinemáticas clave (Misión 1, revelación de Lozano)
- [ ] Sistema de reputación por facción
- [ ] Minijuego Batalla de Aura (versión básica)
- [ ] Secuencia de persecución vehicular (Misión 18)

### Post-MVP
- [ ] Mapa del Callao (exterior completo)
- [ ] Cambio dinámico entre Kervin y Jesús en combate
- [ ] Sistema de evidencias completo
- [ ] Misiones secundarias (Enfermería, etc.)
- [ ] Actuación de voz en español
- [ ] Dispositivo TAQ (arma fase final)
