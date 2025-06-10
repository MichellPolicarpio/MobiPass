# 🚌 MobiPass - Sistema de Gestión de Pasajes de Autobús

<div align="center">
  <img src="ImagenPortada.jpg" alt="MobiPass App Screenshot" width="200" height="394" style="border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
</div>

MobiPass es una aplicación móvil moderna desarrollada en Flutter que permite a los usuarios gestionar sus pasajes de autobús de manera eficiente y segura. La aplicación incluye un backend robusto en Node.js con MongoDB para el almacenamiento de datos.

## ✨ Características Principales

- 🔐 Autenticación segura de usuarios, conductores y administradores
- 🎫 Compra y gestión de pasajes digitales
- 🚍 Validación de pasajes por número de bus
- 📱 Interfaz de usuario intuitiva y moderna
- 🔄 Sincronización en tiempo real
- 📊 Sistema de reportes y seguimiento
- 👥 Gestión de usuarios y conductores
- 💳 Pago seguro integrado

## 🛠️ Tecnologías Utilizadas

### Frontend
- Flutter (Dart)
- Material Design 3
- Provider para gestión de estado
- HTTP para comunicación con API

### Backend
- Node.js
- Express.js
- MongoDB
- JWT para autenticación
- Bcrypt para encriptación

## 🚀 Instalación y Configuración

### Requisitos Previos
- Flutter SDK (versión 3.0.0 o superior)
- Node.js (versión 14.0.0 o superior)
- MongoDB
- Git

### Pasos de Instalación

1. **Clonar el Repositorio**
   ```bash
   git clone https://github.com/tu-usuario/mobipass.git
   cd mobipass
   ```

2. **Configurar el Backend**
   ```bash
   cd backend
   npm install
   ```

3. **Configurar Variables de Entorno**
   ```bash
   cp .env.example .env
   # Editar .env con tus configuraciones
   ```

4. **Iniciar el Servidor**
   ```bash
   npm run dev
   ```

5. **Configurar el Frontend**
   ```bash
   cd ..
   flutter pub get
   ```

6. **Ejecutar la Aplicación**
   ```bash
   flutter run
   ```

## 📱 Uso de la Aplicación

### Registro e Inicio de Sesión
1. Abre la aplicación
2. Selecciona "Registrarse" para crear una nueva cuenta
3. Completa el formulario con tus datos
4. Para iniciar sesión, usa tu correo y contraseña

<div align="center">
  <img src="IniciarSesionUsuario.jpg" alt="Pantalla de Inicio de Sesión" width="200" height="394" style="border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); margin-right: 20px;">
  <img src="CrearCuentaUsuario.jpg" alt="Pantalla de Registro" width="200" height="394" style="border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
</div>

### Compra y Uso de Pasajes
1. Inicia sesión en la aplicación
2. Selecciona "Comprar Boletos"
3. Elige la cantidad y tipo de boletos (estudiante/adulto)
4. Confirma la compra
5. Para usar un boleto:
   - Solicita el número de bus al conductor
   - Ingresa el número en la aplicación
   - Muestra la confirmación al conductor

### Sistema de Reportes
1. Selecciona "Realizar Reporte"
2. Ingresa la matrícula del conductor
3. Describe el problema o situación
4. Envía el reporte
5. Da seguimiento en "Historial de Reportes"

## 👥 Desarrolladores

- **Michell Alexis Policarpio Moran**
- **Isabella Coria Juarez**

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor, lee `CONTRIBUTING.md` para detalles sobre nuestro código de conducta y el proceso para enviarnos pull requests.

## 📞 Soporte

Si encuentras algún problema o tienes alguna sugerencia, por favor:
- Abre un issue en GitHub
- Contacta al equipo de desarrollo
- Consulta la documentación

## 📚 Información Académica

Este proyecto fue desarrollado como parte de la Experiencia Educativa:
- **Materia:** Base de Datos Distribuidas y en la Nube
- **Universidad:** Universidad Veracruzana
- **Facultad:** Ingeniería Eléctrica y Electrónica
- **Docente:** Primavera Lucho Arguelles

---

Desarrollado con ❤️ por el equipo de MobiPass
