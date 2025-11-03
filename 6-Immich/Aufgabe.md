# Immich

Immich ist eine frei Nutzbare Fotomediatek mit Backup Capabilities.

Eine [Demo](https://demo.immich.app) von den Entwicklern ist verfügbar.

Ziel dieser Aufgabe ist es immich auf unserer AKS Instanz zum laufen zu bringen.

Für die Vorbereitung steht in diesem Verzeichnis ein docker-compose.yaml file zur Verfügung, welches direkt starten sollte.

```bash
docker compose up
```

Danach sollte [Immich](http://localhost:2283/) aufrufbar sein.

Diese Docker Compose Installation ist aber ohne Persistent und nur auf dem aktuellen Hostsystem.
Nun versuchen wir Schrit für Schrit diese Konfiguration auf Kubernetes zu bringen.

## Aufgabe 1: PostreSQL Datenbank

Unser AKS Cluster hat [CNPG](https://cloudnative-pg.io/) als CRD vorinstalliert.

Dadurch kann der Cluster sehr einfach definiert werden. 
Die folgende Konfig erzeugt einen PostgreSQL Cluster mit einer Instanz. 
PDB (Pod Distribution Budged) muss deaktiviert sein. Dies kontrolliert, dass bei Maintanance Arbeiten immer die Mindestanzahl Instanzen in Betrieb gehalten werden.
Im Bereich boostrab wird angegeben, dass eine Datenbank mit dem Namen immich und dem owner immich initialisiert wird (für zugriff relevant).
Der imageCatalogRef bestimmt welches PostgreSQL image verwendet wird. Dazu einfach mal 'kubectl get clusterimagecatalog postgresql -o=yaml' aufrufen. Im __spec__ breich, sind die hinterlegten Instanzen sichtbar.
Für den Speicher wird die vordefinierte storageClass __managed-csi__ verwendet.
Damit Immich funktioniert, muss noch die Extension 'vector', 'earthdistance' und 'vchord' in Postgres aktiviert werden. 
Die Scirpts können über iene configmap referenziert werden.

Der unten definierte Cluster kann nach dem ersetzen des [kürzel] duch den eigenen Kürzel auf den cluster angewendet werden.

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: immich-db-[kürzel]
spec:
  instances: 1 # cluster mit 1 instanz. Bei mehreren Inszanzen werden daten repliziert
  enablePDB: false # Muss bei nur einer Instanz deaktiviert sein. -> Für Zero Downtime Updates
  bootstrap: # erstellt eine neue datenbank app mit dem owner app
    initdb:
      database: immich
      owner: immich
      postInitApplicationSQLRefs:
        configMapRefs:
        - name: immich-db-configmap-[kürzel]
          key: init-db.sql        
  imageCatalogRef: # Image catalog verwenden ansonsten wird einfach die latest installiert
    apiGroup: postgresql.cnpg.io
    kind: ClusterImageCatalog
    name: postgresql
    major: 17
  storage: # azure storage
    size: 1Gi # 1Gigabyte sollte genügen.
    storageClass: managed-csi

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: immich-db-configmap-[kürzel]
data:
  init-db.sql: |
    CREATE EXTENSION IF NOT EXISTS vector CASCADE;
    CREATE EXTENSION IF NOT EXISTS earthdistance CASCADE;

```

Nach dem anwenden, kann man die Pods beobachten. Hier kann man festlellen, dasss zuerst ein init-pod für die CLuster Initialisierung erzeugt wird.

Um mehr vom cluster zu sehen:
```bash
kubectl get cluster
```

Der Clsuster sollte in einem "healty state" sein.

### Verbinden auf die Datenbank

```bash
kubectl get svc # Es sollte 3 Services mit den suffixen -r, -ro und -rw geben.
kubectl port-forward svc/immich-db-[kürzel]-rw 5432:5432 # Öffnet Port auf localhost
```

Um sich darauf zu verbinden kann in VS-Code eine PostgreSQL Extension installiert werden. (Alternativ auch PG Admin, DataGrip, etc.)

> host: localhost
> port: 5432
> user: immich
> password: Kann aus secret __immich-db-[kürzel]-app ausgelesen werden. Achtung ist ggf. base64 kodiert.

Falls alles geklappt hat, sollte eine Leere Datenbank mit dem Namen immich vorhanden sein.

## Aufgabe 1: Redis

Immich verwendet als Redis das [valkey](https://hub.docker.com/r/valkey/valkey/) image, welches ein redis fork ist.
Hier sollte es möglich sein, aus dem docker-compose ein Deployment und ein Service zu erzeugen.
Der Name sollte wieder euren MA-Kürzel beinhalten. Der Standartport ist 6379.

> Als Zusatzaufgabe kann der Healthcehck übernommen werden. [Doku](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

## Aufgabe 3: Immich Machine Learning

Immich hat ein ML Module, was z.B. Gesichtserkennung ermöglicht.

Dies sollte grössteils auch aus dem docker-compose File übernommen werden können.
So erstelle wieder ein Deployment und Service für immich ML. 
Die Konfigurationen sollen wieder euren kürzel enthalten.
Zusätzlich zu beachten:

* Der Container Port: 3003
* Folgende ENV Variablen müssen gesetzt sein
  * IMMICH_MACHINE_LEARNING_URL: http://[Euer-Service-Name-fuer-ML]
  * REDIS_HOSTNAME: [keyval-service]
  * TRANSFORMERS_CACHE: /cache
* Für das /cache Verzeichnis sollte ein flüchtiges Volume zur Verfügung stehen. Hier kann ein emptyDir verwendet werden. 

Wenn alles korrekt konfiguriert ist, kann die Konfig angewendet werden.

> Auch hier kann als Zusatzaufgabe ein Healthchekc (Liveness and Readyness probe) konfiguriert werden. Das image hat dafür ein http Enpoint auf /ping


## Aufgabe 4 immich Server deployen


Auch der Immich Server kann als Deployment und Service aus dem Docker Compose übernommen werden.



* Port: 2283
* Folgende ENV Variablen müssen gesetzt sein
  * IMMICH_MACHINE_LEARNING_URL
  * REDIS_HOSTNAME
  * TZ: Europe/Zurich
  * UPLOAD_LOCATION: ./library
  * DB_PASSWORD: [Kann Aus Secret immich-db-[kürzel]-app] geladen werden]
  * DB_USERNAME:[Kann Aus Secret immich-db-[kürzel]-app] geladen werden]
  * DB_DATABASE_NAME: [Kann Aus Secret immich-db-[kürzel]-app] geladen werden]  
  * DB_HOSTNAME: [Kann Aus Secret immich-db-[kürzel]-app] geladen werden]
* Es Muss noch ein PVC für die storage class azurefile-csi erstellt werden. Dieses Volume muss in das Verzeichnis /data gemounted werden. Als grösse sollten 1Gi genügen.

> Auch hier kann als Zusatzaufgabe ein Healthchekc (Liveness and Readyness probe) konfiguriert werden. Das image hat dafür ein http Enpoint auf /api/server/ping

## Aufgabe 5 Immich über Traefik verfügbar machen.

Mache den Immich Server Service aus der vorherigen Aufgabe über eine treafik Seite Verfügbar.
Der Host muss folgendes Format haben [subdomain].traefik-dev02.egeli-apps.dev. 
Die Subdomain kann frei gewählt werden.

Falls alles geklappt hat, könnt ihr nun Immich bei euch einrichten.

Lade danach ein paar Hotos hoch.

Nun kann mit 'kubectl get pv' der Name des Persitent Volume (von Immich) ausgegen werden. 
Der Name ist im Format pvc-{GUID} welcher anahand des Claims zugewiesen ist.
Öffnet die YAML Konfig dieses PVs. Hier ist die Eigenschaft volumeHandle definiert. 
Diese sollte etwa so ausehen *AksEisDev02_Kubernetes_RG#f8832d5a025994d5d94d063#pvc-f4007158-e21b-45a5-999d-9561d33ddc56###nagjw*. Dabei ist der 2. Wert (f883..) der Storage Account und der dritte Wert (pvc-883...) das File Share auf Azure.

Um die von Immich erstellen Files zu sehen, kann das Azure Portal geöffnet werden.
Dann Storage Accounts > eigenen Storage Account > File Shares > Eigenen File Share > Browse. 


Bitte lösche deinen Namespace zum Shluss, um alle Resourcen wieder zu entfernen.