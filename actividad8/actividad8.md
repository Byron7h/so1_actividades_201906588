
# Actividad 8

## 1. Instalamos un ambiente local de Kubernetes utilizando Docker Desktop

### Requisitos previos:
- Tener Docker Desktop instalado en el sistema operativo.
- Asegurarse de que Docker Desktop esté actualizado.

### Pasos:
1. **Activamos Kubernetes en Docker Desktop**:
   - Abrimos Docker Desktop.
   - Nos dirigimos a "Settings" (Configuración) y seleccionamos la pestaña de "Kubernetes".
   - Marcamos la opción "Enable Kubernetes".
   - Hacemos clic en "Apply & Restart".
   - Observamos que Docker Desktop instala Kubernetes y se reinicia. Una vez completado, el entorno local de Kubernetes está activo.

2. **Verificamos la instalación**:
   - Abrimos una terminal o el PowerShell.
   - Ejecutamos el siguiente comando para verificar que Kubernetes está corriendo correctamente:
     ```bash
     kubectl get nodes
     ```
   - Observamos que aparece un nodo en estado `Ready`.

## 2. Desplegamos un contenedor web server en el cluster de Kubernetes local

### Pasos:
1. **Creamos un archivo de despliegue para un web server**:
   - Creamos un archivo YAML llamado `webserver-deployment.yaml` con el siguiente contenido:
     ```yaml
     apiVersion: apps/v1
     kind: Deployment
     metadata:
       name: webserver-deployment
     spec:
       replicas: 1
       selector:
         matchLabels:
           app: webserver
       template:
         metadata:
           labels:
             app: webserver
         spec:
           containers:
           - name: webserver
             image: nginx:latest  # Podemos cambiar 'nginx' por 'apache' si preferimos
             ports:
             - containerPort: 80
     ```

2. **Aplicamos el despliegue en el cluster**:
   - En la terminal, nos ubicamos en el directorio donde guardamos el archivo `webserver-deployment.yaml`.
   - Ejecutamos el siguiente comando para desplegar el contenedor en Kubernetes:
     ```bash
     kubectl apply -f webserver-deployment.yaml
     ```

3. **Verificamos el estado del despliegue**:
   - Para comprobar que el contenedor se ha desplegado correctamente, ejecutamos:
     ```bash
     kubectl get pods
     ```
   - Observamos que un pod aparece en estado `Running` con el nombre `webserver-deployment-xxxxxx`.

4. **Exponemos el servicio del web server**:
   - Exponemos el puerto del contenedor para acceder al servicio:
     ```bash
     kubectl expose deployment webserver-deployment --type=NodePort --port=80
     ```
   - Obtenemos la URL para acceder al web server:
     ```bash
     minikube service webserver-deployment --url
     ```
   - Si usamos Docker Desktop sin `minikube`, observamos que el servidor estará disponible en el puerto asignado por Docker Desktop.

## 3. Pregunta: ¿En un ambiente local de Kubernetes existen los nodos masters y workers, cómo es que esto funciona?

En un ambiente local de Kubernetes, como el que configuramos con Docker Desktop, no existen nodos "masters" y "workers" separados físicamente como en un entorno de producción a gran escala. En este entorno, Docker Desktop ejecuta un único nodo que actúa tanto como master (controlador del cluster) como worker (ejecutor de los contenedores). 

Este nodo único gestiona las tareas de control (como la gestión del API de Kubernetes y la planificación de los pods) y también ejecuta los contenedores. Observamos que es una simplificación que nos permite desarrollar y probar aplicaciones localmente antes de desplegarlas en un entorno distribuido con múltiples nodos.

