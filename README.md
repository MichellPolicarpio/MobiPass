# MobiPass

MobiPass es una aplicación móvil para la gestión de boletos de transporte público, desarrollada como proyecto para la materia de Base de Datos Distribuidas y en la Nube.

## Requisitos Previos

- Flutter SDK (versión 3.0.0 o superior)
- Node.js (versión 14.0.0 o superior)
- MongoDB (versión 4.4 o superior)
- Android Studio / Xcode (para emuladores)
- Git

## Estructura del Proyecto

```
MobiPass/
├── backend/           # Servidor Node.js
│   ├── src/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   └── server.js
│   └── package.json
└── lib/              # Aplicación Flutter
    ├── models/
    ├── screens/
    └── main.dart
```

## Configuración del Backend

1. Navega al directorio del backend:
   ```bash
   cd backend
   ```

2. Instala las dependencias:
   ```bash
   npm install
   ```

3. Configura las variables de entorno:
   - Crea un archivo `.env` en el directorio `backend`
   - Agrega las siguientes variables:
     ```
     PORT=3000
     MONGODB_URI=mongodb://localhost:27017/mobipass
     JWT_SECRET=tu_secreto_jwt
     ```

4. Inicia el servidor:
   ```bash
   npm run dev
   ```

El servidor estará disponible en `http://localhost:3000`

## Configuración de la Aplicación Flutter

1. Asegúrate de estar en el directorio raíz del proyecto:
   ```bash
   cd /Users/michell/StudioProjects/MobiPass
   ```

2. Obtén las dependencias de Flutter:
   ```bash
   flutter pub get
   ```

3. Configura la URL del backend:
   - Abre `lib/main.dart`
   - Asegúrate de que la URL del backend coincida con tu configuración

4. Ejecuta la aplicación:

   Para Android:
   ```bash
   flutter run -d android
   ```

   Para iOS:
   ```bash
   flutter run -d ios
   ```

## Compilación para Producción

### Android

1. Genera el archivo de keystore:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Configura el archivo `android/key.properties`:
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

3. Compila la APK:
   ```bash
   flutter build apk --release
   ```

4. Compila el Bundle para Play Store:
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. Abre el proyecto en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configura el certificado de desarrollo y el perfil de aprovisionamiento

3. Compila la aplicación:
   ```bash
   flutter build ios --release
   ```

## Solución de Problemas

### Error: package.json no encontrado
Si recibes el error "Could not read package.json", asegúrate de estar en el directorio correcto:
```bash
cd backend
npm run dev
```

### Error: Puerto en uso
Si el puerto 3000 está en uso:
```bash
# Encuentra el proceso
lsof -i :3000
# Mata el proceso
kill -9 <PID>
```

### Error: MongoDB no conectado
Asegúrate de que MongoDB esté corriendo:
```bash
# Inicia MongoDB
mongod
```

## Contribuidores

- Michell Alexis Policarpio Moran
- Isabella Coria Juarez

## Profesora

- Primavera Arguelles Lucho

## Materia

Base de Datos Distribuidas y en la Nube

## Facultad

Ingeniería Eléctrica y Electrónica

## Universidad

Universidad Veracruzana
