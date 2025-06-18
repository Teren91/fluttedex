 # Fluttedex - Pokédex App Pokémon:
Fluttedex es una aplicación móvil desarrollada en Flutter que funciona como una Pokédex, permitiendo a los usuarios explorar la lista de los 151 Pokémon de la primera generación (Region de Kanto), buscar un Pokémon específico por su nombre y ver sus detalles.

Este proyecto ha sido desarrollado como una demostración de habilidades en Flutter, aplicando patrones de Clean Architecture, gestión de estado avanzada con Bloc y buenas prácticas de desarrollo de software.

## 📱 Capturas de Pantalla

| Pantalla de Lista	de Pokémons | Pantalla de Detalle de Pokémon |
|:-----------------------------:|:------------------------------:|
|![PokemonList](./assets/screenshots/PokemonList) | ![PokemonDetail](./assets/screenshots/PokemonDetail) | ![PokemonDetail2](./assets/screenshots/PokemonDetail2)|


## ✨ Características Principales
- **Lista de Pokémon**: Visualización de la lista inicial de Pokémon obtenida desde PokéAPI.
- **Buscador en tiempo real**: Filtra la lista para encontrar un Pokémon específico por su nombre.
- **Manejo de Estados**: La UI reacciona a los estados de carga, error y datos vacíos.
- **Vista de Detalle**: Información completa de cada Pokémon, incluyendo:
- **Imagen oficial**.
- **Tipos, altura y peso.**
- **Descripción.**
- **Estadísticas base (HP, Ataque, Defensa, etc.).**
- **Testing:** Incluye tests de widget para validar componentes de la UI.
## 🚀 Cómo Empezar
Sigue estos pasos para ejecutar el proyecto en tu entorno local.

### Requisitos Previos
Tener instalado el SDK de Flutter (versión 3.x o superior).
Un emulador de Android/iOS o un dispositivo físico.
Instalación
### Clonar el repositorio:
```bash
git clone <URL_DE_TU_REPOSITORIO>
cd fluttedex
```

### Instalar dependencias
```bash
flutter pub get
```

### Ejecutar en modo desarrollo
- **Android/iOS**:
```bash
flutter run
```
  
## 🏗️ Arquitectura y Decisiones Técnicas
Este proyecto se ha construido siguiendo las mejores prácticas para asegurar que el código sea escalable, mantenible y testeable.

### Clean Architecture
El proyecto sigue los principios de Clean Architecture, dividiendo la lógica en tres capas principales:

- **Capa de Dominio**: Contiene la lógica de negocio pura y las entidades (Pokemon, PokemonDetail). No depende de ninguna otra capa, lo que la hace completamente independiente del framework.
- **Capa de Datos**: Implementa los repositorios definidos en el dominio. Es la responsable de obtener los datos, ya sea desde una API remota (PokemonRemoteDataSource) o una base de datos local (no implementado).
- **Capa de Presentación**: Contiene la UI (Widgets) y la lógica de estado (BLoC). Reacciona a las interacciones del usuario y muestra los datos proporcionados por los casos de uso del dominio.

Esta separación de responsabilidades facilita enormemente el testing y permite que la aplicación crezca de forma ordenada.

### Gestión de Estado: BLoC
Para la gestión de estado se ha utilizado el paquete flutter_bloc. 
La elección de BLoC se basa en:

- **Separación clara**: Desacopla la lógica de negocio de la interfaz de usuario.
- **Predictibilidad**: El flujo de Evento -> BLoC -> Estado hace que el comportamiento de la aplicación sea fácil de entender y depurar.
- **Testabilidad**: Los BLoCs son clases de Dart puras, lo que los hace muy fáciles de testear de forma unitaria.

### Testing
Se ha incluido un test de widget para la pantalla de detalle (pokemon_detail_page_test.dart) como demostración de las prácticas de testing. Se utiliza el paquete bloc_test para mockear el PokemonBloc y simular estados, permitiendo testear la UI de forma aislada.

## 📂 Estructura de Carpetas
La estructura del proyecto está organizada por features para agrupar el código relacionado y facilitar la navegación.
```
lib/
├── src/
│   ├── core/
│   │   └── ...
│   └── features/
│       └── pokemon/
│           ├── data/
│           │   ├── datasources/
│           │   ├── models/
│           │   └── repositories/
│           ├── domain/
│           │   ├── entities/
│           │   ├── repositories/
│           │   └── usecases/
│           └── presentation/
│               ├── bloc/
│               ├── pages/
│               └── widgets/
│
├── injection_container.dart
└── main.dart
```
## 🔮 Roadmap

- **Paginación y Lazy load**: Implementar scroll infinito en la lista de Pokémon para cargar más resultados bajo demanda.
- **Filtrado por regiones**: Incluir el resto de Pokemons y filtrar por regiones
- **Tests Adicionales**: Aumentar la cobertura de tests, incluyendo tests de integración para los flujos completos.
- **Animaciones**: Añadir animaciones de transición entre pantallas y en la aparición de los elementos para una experiencia de usuario más fluida.
- **Favoritos**: Permitir al usuario marcar Pokémon como favoritos y guardarlos localmente usando una base de datos como sqflite o isar.
