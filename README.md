# Laboratorio de Observabilidad - Waldo Jair Rojas Vasquez

## Curso

Infraestructura como Código (IaC)

## Objetivo

Implementar una plataforma de observabilidad utilizando Grafana, Prometheus y Loki para monitorear métricas, visualizar logs y generar alertas automáticas sobre el comportamiento de una aplicación contenerizada.

---

# 1. Levantamiento del Stack

Desde la carpeta del proyecto se ejecutó el siguiente comando:

```bash
docker compose up -d --build
```

Posteriormente se verificó el estado de los contenedores:

```bash
docker compose ps
```

Los servicios desplegados fueron:

* Frontend
* Backend
* Grafana
* Prometheus
* Loki
* Alloy
* cAdvisor
* Node Exporter

---

# 2. Verificación de Servicios

Se comprobó el correcto funcionamiento de los servicios mediante las siguientes URLs:

| Servicio   | URL                           | Resultado                      |
| ---------- | ----------------------------- | ------------------------------ |
| Frontend   | http://localhost:8080         | Página Hello World             |
| Backend    | http://localhost:3001/metrics | Métricas en formato Prometheus |
| Grafana    | http://localhost:3000         | Dashboard Grafana              |
| Prometheus | http://localhost:9090         | Consola Prometheus             |

---

# 3. Generación de Tráfico y Logs

Para generar actividad dentro de la aplicación se realizaron las siguientes acciones:

1. Acceso al frontend.
2. Uso repetido del botón **Saludar (API)**.
3. Uso del botón **Generar carga de CPU (30s)**.
4. Observación de métricas y logs generados automáticamente.

Esto permitió alimentar Prometheus y Loki con información real para su visualización posterior.

---

# 4. Verificación de Data Sources

Dentro de Grafana se verificó:

```text
Connections → Data Sources
```

Las fuentes de datos configuradas fueron:

* Prometheus
* Loki

Ambas fueron validadas mediante la opción:

```text
Save & Test
```

confirmando una conexión exitosa.

---

# 5. Construcción del Dashboard

Se creó un dashboard denominado:

```text
Observabilidad - Waldo Jair Rojas Vasquez
```

## Panel 1: CPU del Contenedor Backend

### Fuente de Datos

Prometheus

### Consulta

```promql
sum(rate(container_cpu_usage_seconds_total{id=~".*docker.*"}[1m])) * 100
```

### Configuración

* Visualización: Time Series
* Unidad: Percent (0-100)
* Umbral: 50%
* Título: CPU contenedor backend (%)

## Panel 2: CPU del Host

### Fuente de Datos

Prometheus

### Consulta

```promql
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100)
```

### Configuración

* Visualización: Time Series
* Unidad: Percent (0-100)
* Título: CPU del host (%)

## Panel 3: Logs de Aplicación

### Fuente de Datos

Loki

### Consulta

```loki
{tier="application"} | json
```

### Configuración

* Visualización: Logs
* Título: Logs de aplicación (API + frontend)

## Panel 4: Logs de Infraestructura

### Fuente de Datos

Loki

### Consulta

```loki
{tier="infrastructure"}
```

### Configuración

* Visualización: Logs
* Título: Logs de infraestructura

---

# 6. Configuración de la Alerta

### Nombre

```text
CPU backend > 50%
```

### Consulta

```promql
sum(rate(container_cpu_usage_seconds_total{id=~".*docker.*"}[1m])) * 100
```

### Condición

```text
IS ABOVE 50
```

### Configuración de Evaluación

| Parámetro           | Valor       |
| ------------------- | ----------- |
| Evaluation Interval | 10 segundos |
| Pending Period      | 30 segundos |

### Etiqueta

```text
severity = warning
```

---

# 7. Prueba de la Alerta

1. Se accedió al frontend.
2. Se ejecutó varias veces la opción:

```text
Generar carga de CPU (30s)
```

3. Se monitoreó el estado de la regla en:

```text
Alerting → Alert Rules
```

### Estados observados

```text
Normal
↓
Pending
↓
Firing
```

La alerta cambió correctamente a estado **Firing** cuando el consumo de CPU superó el umbral configurado.

---

# 8. Cierre del Ciclo Alarma → Log

Se configuró un Contact Point tipo Webhook.

### URL utilizada

```text
http://backend:3001/alerts
```

### Flujo implementado

```text
Métrica
↓
Alerta
↓
Webhook
↓
Backend
↓
Log
↓
Loki
↓
Grafana
```

---

# Respuestas a las Preguntas

## 1. ¿Por qué necesitamos Loki además de Prometheus si ya tenemos /metrics?

Prometheus almacena métricas numéricas como CPU, memoria o cantidad de peticiones. Loki complementa esta funcionalidad permitiendo centralizar y consultar logs de aplicaciones e infraestructura para facilitar el análisis y la detección de errores.

## 2. ¿Qué ventaja aporta que las fuentes de datos de Grafana estén aprovisionadas como código y no creadas manualmente?

Permite que la configuración sea reproducible, automatizada y versionable. Cualquier entorno puede desplegarse con la misma configuración sin depender de procesos manuales.

## 3. ¿Por qué CPU contenedor y CPU host muestran valores distintos?

El CPU del contenedor representa únicamente el consumo de una aplicación específica, mientras que el CPU del host representa el consumo total de la máquina donde se ejecutan todos los servicios.

## 4. Diferencia entre Evaluation Interval y Pending Period.

El Evaluation Interval define cada cuánto tiempo Grafana evalúa una condición de alerta. El Pending Period define cuánto tiempo debe mantenerse dicha condición antes de cambiar al estado Firing.

---

# Conclusión

Durante este laboratorio se implementó un entorno completo de observabilidad utilizando Prometheus, Loki y Grafana. Se recopilaron métricas, se centralizaron logs, se construyeron dashboards y se configuraron alertas automáticas sobre el comportamiento de la aplicación. Esto permitió comprender los principios fundamentales de observabilidad en entornos modernos basados en contenedores.

---

# Autor

**Waldo Jair Rojas Vasquez**

**Curso:** Infraestructura como Código (IaC)

**Repositorio utilizado:**

https://github.com/UPAO-Recursos/iac-observabilidad
