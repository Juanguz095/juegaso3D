# Arquitectura del proyecto

## 1. Descripción

**Operación Bolívar** es un FPS 3D de acción e infiltración desarrollado en Godot.

El proyecto combina:

- Infiltración
- Exploración
- Combate
- Sigilo
- Hackeo
- Diálogo e interacción social
- Investigación
- Reputación
- Consecuencias narrativas
- Persecuciones vehiculares

La arquitectura busca mantener el proyecto modular y sencillo, permitiendo agregar nuevas armas, enemigos, misiones, objetos interactivos y zonas sin modificar innecesariamente los sistemas existentes.

La arquitectura debe priorizar:

- Simplicidad
- Modularidad
- Legibilidad
- Reutilización
- Bajo acoplamiento
- Facilidad de mantenimiento
- Facilidad para trabajar mediante agentes de IA

---

## 2. Principios arquitectónicos

El proyecto seguirá los siguientes principios:

1. Cada sistema debe tener una responsabilidad clara.
2. Los sistemas deben mantenerse separados cuando sea razonable.
3. Se debe reutilizar un sistema existente antes de crear uno nuevo.
4. No se debe duplicar lógica.
5. No se debe introducir complejidad innecesaria.
6. Las nuevas funcionalidades deben integrarse con los sistemas existentes.
7. Las decisiones arquitectónicas importantes deben documentarse.
8. Los agentes de IA no deben modificar la arquitectura sin autorización.
9. La arquitectura puede evolucionar cuando aparezcan necesidades reales.
10. Se deben evitar optimizaciones prematuras.

---

## 3. Estructura general

El proyecto se divide conceptualmente en los siguientes sistemas:

```text
Juego
│
├── Jugador
│   ├── Movimiento
│   ├── Salud
│   ├── Interacción
│   ├── Inventario
│   └── Controlador de personaje
│
├── Combate
│   ├── Armas
│   ├── Daño
│   ├── Proyectiles
│   └── Efectos de combate
│
├── Sigilo
│   ├── Detección
│   ├── Alerta
│   ├── Visibilidad
│   └── Cobertura
│
├── Enemigos
│   ├── Enemigo base
│   ├── Estudiantes
│   ├── PRYME
│   ├── Narcos
│   └── Jefes
│
├── Interacción
│   ├── NPC
│   ├── Diálogo
│   ├── Puertas
│   ├── Cámaras
│   └── Objetos hackeables
│
├── Misiones
│   ├── Gestor de misiones
│   ├── Objetivos
│   ├── Estados de misión
│   └── Eventos de misión
│
├── Mundo
│   ├── Instituto Simón Bolívar
│   ├── Callao
│   └── Comisaría
│
├── Progresión
│   ├── Reputación
│   ├── Evidencias
│   ├── Puntos de aura
│   └── Información de cobertura
│
├── Vehículos
│   └── Sistema de persecución
│
├── Interfaz de usuario
│   ├── HUD
│   ├── Diálogo
│   ├── Inventario
│   ├── Mapa
│   └── Interfaz de misiones
│
└── Sistemas del juego
    ├── Gestor del juego
    ├── Gestor de guardado
    ├── Gestor de audio
    └── Gestor de escenas
```

Esta estructura es conceptual. No significa que cada elemento deba convertirse inmediatamente en una escena o script independiente.

La estructura podrá modificarse cuando exista una necesidad real.

---

## 4. Jugador

### Responsabilidad

El sistema del jugador controla el estado y las capacidades del personaje actualmente controlado.

Responsabilidades:

- Movimiento
- Cámara
- Correr
- Agacharse
- Trepar
- Interacción
- Salud
- Inventario
- Uso de armas
- Estado del personaje

El jugador no debe controlar directamente:

- La inteligencia artificial de los enemigos
- Las misiones
- La reputación
- La lógica de las cámaras
- La lógica interna de los NPC
- La progresión narrativa

---

## 5. Personajes jugables

El juego cuenta con dos protagonistas jugables:

```text
Personajes jugables
├── Kervin
└── Jesús
```

Ambos deben compartir los sistemas comunes del jugador siempre que sea posible.

### Kervin

Especialización:

- Fuerza
- Resistencia
- Combate directo
- Interacción social
- Improvisación

### Jesús

Especialización:

- Tecnología
- Sigilo
- Hackeo
- Información
- Precisión

Las diferencias entre ambos personajes deben implementarse mediante capacidades, estadísticas o componentes específicos.

No se deben duplicar completamente los sistemas del jugador para cada personaje.

---

## 6. Sistema de movimiento

El sistema de movimiento controla:

- Movimiento
- Correr
- Agacharse
- Salto, si corresponde al diseño final
- Trepar
- Movimiento por espacios restringidos
- Cámara

El movimiento debe estar separado de:

- Combate
- Inteligencia artificial
- Misiones
- Interfaz de usuario
- Reputación

Las capacidades específicas de cada personaje deben modificar el movimiento sin duplicar completamente el controlador.

---

## 7. Sistema de salud

El sistema de salud administra los puntos de vida de las entidades que pueden recibir daño.

Debe permitir:

- Recibir daño
- Curarse
- Detectar muerte
- Aplicar efectos derivados del daño
- Emitir eventos cuando cambie la salud

Conceptualmente:

```text
Daño
 ↓
Salud
 ↓
Vivo / Muerto
```

El sistema de salud no debe decidir directamente qué ocurre con una misión cuando un personaje muere.

---

## 8. Sistema de combate

El sistema de combate administra las interacciones ofensivas.

Responsabilidades:

- Disparo
- Ataques cuerpo a cuerpo
- Munición
- Tipos de daño
- Daño letal
- Daño no letal
- Impactos
- Efectos de combate

Conceptualmente:

```text
Arma
 ↓
Ataque
 ↓
Daño
 ↓
Salud
```

El sistema de combate no debe contener directamente la lógica de las misiones.

---

## 9. Armas

Las armas deben utilizar una estructura reutilizable.

Armas previstas:

```text
Armas
├── Pistola policial
├── Pistola de precisión
├── Tranquilizante
├── Arma improvisada
└── Dispositivo TAQ
```

Cada arma debe poder definir sus características sin modificar el sistema principal del jugador.

Las armas pueden compartir:

- Disparo
- Munición
- Recarga
- Daño
- Efectos
- Animaciones
- Sonidos

El arma no debe decidir las consecuencias narrativas de utilizarla.

---

## 10. Sistema de daño

Debe existir un mecanismo común para aplicar daño o neutralización.

Debe permitir diferenciar:

- Daño letal
- Daño no letal
- Daño ambiental
- Ataques cuerpo a cuerpo

Los objetivos que puedan recibir daño deben utilizar un mecanismo común.

Conceptualmente:

```text
Arma
 ↓
Impacto
 ↓
Objetivo que recibe daño
 ↓
Salud
```

Las armas no deben necesitar conocer específicamente si el objetivo es un estudiante, un narco o un jefe.

---

## 11. Sistema de sigilo

El sistema de sigilo controla la detección del jugador por enemigos y sistemas de seguridad.

Responsabilidades:

- Visibilidad
- Detección
- Sospecha
- Nivel de alerta
- Búsqueda
- Combate
- Cobertura
- Consecuencias de ser descubierto

Conceptualmente:

```text
Jugador
 ↓
Visibilidad
 ↓
Detección
 ↓
Sospecha
 ↓
Alerta
 ↓
Búsqueda / Combate
```

El sistema debe ser independiente de un enemigo concreto.

---

## 12. Sistema de cobertura

La cobertura representa la identidad falsa del jugador y el estado de la infiltración.

Debe controlar:

- Identidad utilizada
- Información conocida por el jugador
- Información conocida por los NPC
- Errores de identidad
- Nivel de exposición
- Consecuencias narrativas

La cobertura debe estar separada de:

- Movimiento
- Combate
- Salud

---

## 13. Sistema de enemigos

Todos los enemigos deben compartir una base común.

Conceptualmente:

```text
Enemigo
├── Estudiante problemático
├── PRYME
├── Narco
└── Jefe
```

El sistema base debe proporcionar capacidades comunes:

- Salud
- Recibir daño
- Movimiento
- Detección
- Ataques
- Muerte
- Estados de inteligencia artificial

Los comportamientos específicos deben extender o configurar el sistema base.

---

## 14. Sistema de inteligencia artificial

La inteligencia artificial de los enemigos debe utilizar estados claramente definidos.

Ejemplo:

```text
Inactivo
   ↓
Sospechoso
   ↓
Alertado
   ↓
Combate
   ↓
Búsqueda
   ↓
Inactivo
```

La inteligencia artificial debe estar separada de:

- Interfaz
- Misiones
- Reputación
- Renderizado

Los enemigos pueden reaccionar ante eventos del mundo, pero no deben contener directamente la lógica global de una misión.

---

## 15. Sistema de NPC

Los NPC representan a los personajes con los que el jugador puede interactuar.

Responsabilidades:

- Diálogo
- Comportamiento
- Información
- Relaciones
- Reacciones al jugador
- Interacciones

Los NPC pueden utilizar:

- Sistema de diálogo
- Sistema de reputación
- Sistema de misiones
- Sistema de detección

---

## 16. Sistema de diálogo

El sistema de diálogo controla:

- Conversaciones
- Opciones
- Condiciones
- Respuestas
- Consecuencias
- Información obtenida

Las conversaciones no deben contener directamente toda la lógica de reputación o misiones.

Conceptualmente:

```text
Diálogo
 ↓
Elección
 ↓
Evento del juego
 ├── Reputación
 ├── Misión
 ├── Evidencia
 └── Cobertura
```

---

## 17. Sistema de interacción

Debe existir un sistema común para objetos interactivos.

Ejemplos:

- Puertas
- Computadoras
- Cámaras
- NPC
- Evidencias
- Botiquines
- Gadgets
- Objetos del entorno

Conceptualmente:

```text
Jugador
 ↓
Interacción
 ↓
Objeto interactivo
```

El jugador no debe necesitar conocer individualmente la implementación de cada tipo de objeto.

---

## 18. Sistema de hackeo

El sistema de hackeo permite interactuar con dispositivos tecnológicos.

Principalmente será utilizado por Jesús.

Ejemplos:

- Abrir puertas
- Desactivar cámaras
- Extraer información
- Manipular sistemas

Conceptualmente:

```text
Jesús
 ↓
Sistema de hackeo
 ↓
Objeto hackeable
 ├── Puerta
 ├── Cámara
 └── Computadora
```

Los objetos hackeables deben proporcionar una forma común de ser manipulados.

---

## 19. Sistema de misiones

El sistema de misiones administra el progreso de las misiones.

Responsabilidades:

- Misión actual
- Objetivos
- Progreso
- Estados
- Condiciones
- Eventos
- Éxito
- Fallo
- Fallo parcial
- Consecuencias

Conceptualmente:

```text
Misión
├── Objetivos
├── Condiciones
├── Eventos
└── Consecuencias
```

Una misión puede utilizar:

- Combate
- Sigilo
- Diálogo
- Hackeo
- Exploración
- Persecuciones

Pero la misión no debe implementar directamente estos sistemas.

---

## 20. Estados de misión

Las misiones pueden tener los siguientes estados:

```text
No iniciada
     ↓
Activa
     ↓
Completada
 ├── Éxito
 └── Fallo parcial

Fallida
```

El resultado de una misión puede afectar:

- Reputación
- Diálogo
- Cobertura
- Evidencias
- Misiones posteriores
- Estado del mundo

---

## 21. Sistema de reputación

La reputación se administra por facción.

Facciones principales:

```text
Reputación
├── TAQ
├── PRYME
└── Dirección
```

La reputación puede ser consultada por:

- NPC
- Diálogos
- Misiones
- Eventos
- Acceso a determinadas situaciones

El sistema de reputación no debe contener directamente los diálogos ni las misiones.

---

## 22. Sistema de evidencias

Las evidencias representan la información obtenida durante la investigación.

Ejemplos:

- Documentos
- Fotografías
- Conversaciones interceptadas
- Datos obtenidos mediante hackeo

Conceptualmente:

```text
Evidencias
├── Documentos
├── Fotografías
├── Grabaciones
└── Datos
```

Las evidencias pueden utilizarse como condiciones para:

- Misiones
- Diálogos
- Eventos
- Resolución de la historia

---

## 23. Sistema de aura

Los puntos de aura son un recurso específico de las Batallas de Aura.

Responsabilidades:

- Registrar puntos obtenidos
- Gastar puntos
- Desbloquear poses
- Desbloquear bailes
- Habilitar determinadas interacciones

El sistema de aura debe mantenerse separado del sistema de reputación.

---

## 24. Sistema de inventario

El inventario administra los objetos que puede transportar el jugador.

Puede contener:

- Armas
- Munición
- Botiquines
- Gadgets
- Evidencias
- Objetos especiales

Debe proporcionar operaciones básicas:

```text
Agregar
Eliminar
Comprobar
Usar
Equipar
Desequipar
```

Los demás sistemas deben interactuar con el inventario mediante una interfaz común.

---

## 25. Sistema del mundo

El mundo está dividido en tres zonas principales:

```text
Mundo
├── Instituto Simón Bolívar
├── Callao / calles
└── Comisaría
```

Cada zona puede ser una escena independiente o estar compuesta por varias escenas según las necesidades de rendimiento y diseño.

La lógica global del juego no debe estar directamente dentro de una escena específica del mundo.

---

## 26. Sistema de vehículos

El sistema de vehículos se utiliza principalmente durante las persecuciones.

Responsabilidades:

- Movimiento del vehículo
- Control
- Colisiones
- Tráfico
- Obstáculos
- Atajos
- Condiciones físicas de la persecución

La misión debe determinar cuándo empieza y termina una persecución.

El sistema de vehículos debe encargarse del comportamiento del vehículo.

Conceptualmente:

```text
Misión
 ↓
Persecución
 ↓
Vehículo
```

---

## 27. Sistema de interfaz de usuario

La interfaz representa información proporcionada por los sistemas del juego.

Componentes:

```text
Interfaz
├── HUD
├── Salud
├── Munición
├── Inventario
├── Diálogo
├── Reputación
├── Objetivos
├── Mapa
└── Estado de alerta
```

La interfaz no debe contener la lógica principal del juego.

Ejemplo correcto:

```text
Sistema de salud
 ↓
Interfaz
```

No:

```text
Interfaz
 ↓
Modifica directamente la salud
```

---

## 28. Sistemas globales

Los sistemas globales deben utilizarse únicamente cuando exista una necesidad real.

### Gestor del juego

Controla el estado general de la partida.

### Gestor de escenas

Controla la carga y transición entre escenas.

### Gestor de guardado

Controla:

- Guardado
- Carga
- Progreso
- Estado persistente

### Gestor de audio

Controla:

- Música
- Efectos
- Volumen
- Audio global

No todos los sistemas deben convertirse en sistemas globales.

Los sistemas globales deben mantenerse al mínimo necesario.

---

## 29. Comunicación entre sistemas

Las principales relaciones son:

```text
Jugador
 ├── Movimiento
 ├── Interacción
 ├── Inventario
 └── Armas
          ↓
       Combate
          ↓
        Daño
          ↓
        Salud
          ↓
       Enemigos
```

Sistema de sigilo:

```text
Jugador
 ↓
Sigilo
 ↓
Detección
 ↓
Inteligencia artificial
 ↓
Alerta
```

Interacción:

```text
Jugador
 ↓
Interacción
 ↓
NPC / Puerta / Cámara / Computadora
```

Narrativa:

```text
Diálogo
 ↓
Evento del juego
 ├── Reputación
 ├── Evidencias
 ├── Cobertura
 └── Misión
```

Misiones:

```text
Misión
 ├── Combate
 ├── Sigilo
 ├── Diálogo
 ├── Hackeo
 ├── Exploración
 └── Persecución
```

Los sistemas deben comunicarse mediante señales, eventos, interfaces o referencias controladas cuando corresponda.

Se deben evitar dependencias circulares.

---

## 30. Dependencias

Las dependencias deben mantener una dirección lógica.

Ejemplo:

```text
Sistemas globales
       ↓
    Misiones
       ↓
Sistemas de juego
       ↓
Jugador / Enemigos / Interacción
       ↓
Interfaz
```

La interfaz debe consumir información de los sistemas del juego.

No debe convertirse en la fuente principal de esa información.

Los sistemas de bajo nivel no deben depender directamente de elementos específicos de la interfaz.

---

## 31. Escenas y scripts

Las escenas de Godot deben representar entidades, espacios u objetos concretos del juego.

Los scripts deben encargarse principalmente del comportamiento.

Se debe evitar colocar toda la lógica del juego en un único script.

Ejemplo:

```text
Jugador
├── Movimiento
├── Salud
├── Interacción
├── Inventario
└── Control de armas
```

La estructura concreta de escenas y scripts puede evolucionar durante el desarrollo.

No se debe crear una nueva abstracción únicamente para reducir el tamaño de un script.

---

## 32. Datos configurables

Los datos que deban modificarse frecuentemente deben mantenerse separados de la lógica cuando sea conveniente.

Ejemplos:

- Daño de armas
- Vida de enemigos
- Munición
- Velocidad
- Estadísticas
- Recompensas
- Datos de misiones
- Diálogos
- Reputación

Se pueden utilizar recursos de Godot u otros mecanismos adecuados.

No se debe crear un sistema complejo de datos antes de que exista una necesidad real.

---

## 33. Extensibilidad

Agregar contenido nuevo no debería requerir modificar innecesariamente los sistemas centrales.

### Nuevo enemigo

```text
Enemigo base
    ↓
Nuevo enemigo
    ↓
Comportamiento específico
```

### Nueva arma

```text
Sistema de armas
    ↓
Nueva arma
    ↓
Configuración / comportamiento específico
```

### Nueva misión

```text
Sistema de misiones
    ↓
Nueva misión
    ↓
Objetivos + condiciones + eventos
```

La incorporación de contenido debe aprovechar los sistemas existentes.

---

## 34. Reglas arquitectónicas

- No duplicar sistemas.
- No duplicar lógica.
- No crear sistemas globales innecesarios.
- No colocar lógica principal del juego dentro de la interfaz.
- No colocar lógica de misiones dentro del jugador.
- No colocar lógica de inteligencia artificial dentro de las armas.
- No hacer que un arma dependa directamente de un tipo específico de enemigo.
- No hacer que un enemigo dependa directamente de una misión específica.
- Utilizar sistemas comunes para funcionalidades compartidas.
- Evitar dependencias circulares.
- Mantener responsabilidades claras.
- Mantener los scripts simples.
- Evitar abstracciones innecesarias.
- Priorizar legibilidad.
- Priorizar soluciones simples antes que soluciones complejas.
- No realizar optimizaciones prematuras.
- Documentar cambios arquitectónicos importantes.
- No modificar la arquitectura sin justificar el cambio.

---

## 35. Evolución de la arquitectura

Esta arquitectura es un punto de partida y no debe considerarse completamente inmutable.

Puede modificarse cuando:

- Aparezca una nueva mecánica importante.
- Una responsabilidad se vuelva demasiado grande.
- Existan dependencias difíciles de mantener.
- Se necesite reutilización que la estructura actual no permita.
- Aparezcan problemas reales de rendimiento.
- Una decisión inicial resulte inadecuada durante el desarrollo.

Antes de realizar un cambio arquitectónico importante se debe:

1. Identificar el problema.
2. Explicar por qué la arquitectura actual no es suficiente.
3. Proponer una solución.
4. Evaluar el impacto.
5. Actualizar este documento.
6. Implementar el cambio.

Los agentes de IA no deben realizar cambios arquitectónicos importantes sin autorización explícita.
