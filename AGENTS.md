# AGENTS.md

## Proyecto
FPS 3D de acción, infiltración e Immersive Sim (Inspirado en Deus Ex)

Inspiraciones:
- DOOM
- DEUS EX

## Development principles

- Mantener el código simple y modular.
- No crear sistemas innecesarios.
- Reutilizar sistemas existentes.
- No duplicar lógica.
- No modificar arquitectura sin autorización.

## Workflow

Al trabajar en cualquier tarea:

1. **Analizar:** Revisar `docs/architecture.md` y los archivos existentes relacionados.
2. **Planificar:** Identificar los archivos a modificar y explicar brevemente la solución.
3. **Implementar:** Escribir el código respetando los estándares de GDScript y Godot 4.
4. **Verificación y diagnóstico obligatorio:**
   - Revisar que todos los tipos estáticos coincidan y no haya llamadas a métodos inexistentes.
   - Comprobar que las rutas de nodos (`NodePath`, `$Nodo`), recursos (`res://...`) y conexiones de señales (`signal`) sean válidas y existan.
   - Si se dispone de herramientas de ejecución, verificar que la escena o script no arroje errores ni warnings.
5. **Auto-corrección:**
   - Si algo falla o no pasa la verificación, diagnosticar la causa raíz y arreglarlo inmediatamente antes de dar la tarea por finalizada.
   - No asumir que funciona sin haber revisado la coherencia entre scripts y escenas (`.tscn`).
6. **Reporte final:** Informar qué archivos fueron creados o modificados y detallar cómo se verificó el funcionamiento.


## Restrictions

- No añadir dependencias sin autorización.
- No eliminar código funcional sin explicar por qué.
- No modificar archivos fuera del alcance de la tarea.
- No cambiar nombres de sistemas existentes arbitrariamente.
- No crear una solución nueva si ya existe una solución equivalente.

## Code

- Utilizar GDScript.
- Mantener scripts pequeños y especializados.
- Evitar código innecesariamente complejo.
- Priorizar legibilidad sobre optimizaciones prematuras.

## Important

Si una decisión puede afectar la arquitectura del proyecto,
detenerse y pedir autorización antes de realizarla.

## Change control

- No implementar múltiples features en una sola tarea salvo que se solicite explícitamente.
- No realizar refactors no solicitados.
- No cambiar APIs, interfaces o contratos existentes sin autorización.
- Si una tarea entra en conflicto con architecture.md, detenerse y explicar el conflicto.
- Si existe más de una solución razonable que afecte la arquitectura, presentar las opciones antes de implementar.

## Engine & Language
- Motor: Godot 4.x (4.5 / GL Compatibility).
- Lenguaje: GDScript 2.0.
- Usar nodos 3D de Godot 4: `Node3D`, `CharacterBody3D`, `Area3D`, `VisibleOnScreenNotifier3D`, etc.
- Usar anotaciones modernas: `@export`, `@onready`, `@export_group`, `@export_category`.
- Usar `await` en lugar de `yield`.
- Usar `.instantiate()` en lugar de `.instance()`.
