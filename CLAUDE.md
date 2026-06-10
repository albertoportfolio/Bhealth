# CLAUDE.md

Guía para Claude Code al trabajar en este repositorio.

## Proyecto

App Flutter ("Baby Tracker") para gestionar el crecimiento de un bebé: registros de sueño, tomas de leche/comida y medidas (peso). Todo se almacena **en local** en el móvil con SQLite (Drift). No hay backend ni red. La UI está en **español**.

## Comandos

```bash
flutter pub get                                  # instalar dependencias
dart run build_runner build --delete-conflicting-outputs   # regenerar código Drift (*.g.dart)
flutter run                                      # ejecutar la app
flutter analyze                                  # análisis estático
flutter test                                     # tests
```

**Importante:** tras modificar cualquier tabla o DAO en `lib/database/`, hay que ejecutar `build_runner` para regenerar los `*.g.dart`. Nunca editar los archivos generados a mano.

## Stack

- **Estado:** `flutter_riverpod` (providers clásicos, sin codegen).
- **Navegación:** `go_router` con `StatefulShellRoute.indexedStack` (bottom nav de 4 pestañas).
- **Base de datos:** `drift` + `sqlite3_flutter_libs`. Archivo `baby_tracker.sqlite` en el directorio de documentos de la app (`path_provider`).
- **Tipografía:** `google_fonts` (Poppins). **Fechas:** `intl` con locale `es`. **IDs:** `uuid` v4 (TextColumn como primary key).

## Arquitectura

```
lib/
├── main.dart                  # inicializa intl 'es' y crea AppDatabase; lo inyecta vía ProviderScope override
├── app/
│   ├── app.dart               # MaterialApp.router
│   ├── router.dart            # GoRouter: redirect a /babies/add si no hay bebés; shell con 4 ramas
│   └── theme.dart             # AppTheme.lightTheme — paleta pastel (rosa/azul/verde), Material 3
├── core/
│   ├── utils/                 # DateFormatter (fechas, edad, duración, peso, volumen), selected_baby_provider, EmptyState
│   └── widgets/               # LoadingWidget
├── database/
│   ├── app_database.dart      # @DriftDatabase, schemaVersion, databaseProvider (override en main)
│   ├── tables/                # Babies, Feedings, SleepEntries, WeightEntries
│   └── daos/                  # un DAO por tabla, con streams watch* para UI reactiva
└── features/<feature>/
    ├── screens/               # pantalla de lista + pantalla de alta (add_*)
    ├── providers/ o *.dart    # StreamProviders que combinan selectedBabyProvider + DAO
    └── widgets (tiles, enums) # FeedingType, BabyGender, tiles de lista
```

### Patrones clave

- **Bebé seleccionado:** `selectedBabyIdProvider` (StateProvider) + `selectedBabyProvider` que cae al primer bebé si no hay selección. Todos los providers de datos (`feedingsProvider`, `sleepEntriesProvider`, `weightEntriesProvider`) dependen de él y devuelven streams del DAO filtrados por `babyId`.
- **Inyección de la BD:** siempre vía `ref.read(databaseProvider)` / `ref.watch(databaseProvider)`; el provider se sobreescribe en `main.dart`.
- **Reactividad:** las pantallas de lista escuchan `StreamProvider` (`.when(loading/error/data)`), agrupan por día con `DateFormatter.formatRelativeDate` ('Hoy', 'Ayer', fecha).
- **Sueño en curso:** una fila de `SleepEntries` con `endTime == null` representa una sesión activa; `watchActiveSleep` la expone y la UI muestra un banner con botón "Detener".
- **Borrados:** siempre con diálogo de confirmación (`AlertDialog`). Las FK tienen `onDelete: cascade` y `PRAGMA foreign_keys = ON` está activado en `beforeOpen`.

### Convenciones de datos

- IDs: UUID v4 en columnas de texto.
- Peso: se guarda en **gramos** (`weightGrams`, Real); la UI lo pide en kg y multiplica ×1000. Formatear con `DateFormatter.formatWeight`.
- Tomas: `type` es un string (`breast_left`, `breast_right`, `bottle_formula`, `bottle_breast_milk`) mapeado por el enum `FeedingType`. Biberón → `amountMl`; pecho → `durationMinutes`.
- Género: string (`male`/`female`/`other`) mapeado por `BabyGender`.
- Migraciones: incrementar `schemaVersion` en `app_database.dart` y añadir la migración en `onUpgrade`.

### Convenciones de UI

- Textos visibles al usuario en español; código y comentarios en inglés.
- Usar el tema (`Theme.of(context)`), `AppTheme` y los widgets compartidos (`EmptyState`, `LoadingWidget`, tiles) antes de crear estilos ad-hoc.
- Color de acento del sueño: `Color(0xFF7C83FD)`.
- Formularios de alta: `SingleChildScrollView` con padding 24, secciones con `titleMedium`, botón de guardado con spinner mientras `_isSaving`.
- Usar `withValues(alpha: x)` (no `withOpacity`, deprecado).
