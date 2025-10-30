# POD

## Aufgabe 1: POD mit CLI erstellen

Benötigte Tools:

* kubectl
* kubectx
* kubens

Für die Installation dieser Tools findest du Informationen auf dieser [Confluenc](https://egeliinformatik.atlassian.net/wiki/spaces/WISTEC/pages/375488541/Kubernetes) Seite.


> **_Achtung:_** Befehle nur im eigenen Namespace ausführen.

Falls noch kein eigener Namespace erstellt wurde, mit
```
kubectl create ns [MA-Kürzel] #
kubens [MA-Kürzel]
```
einen Namespace erstellen und danach den aktuellen Kontext setzen.

Mit *kubectl get all* kann überprüft werden ob keine pods etc im aktuellen namespace sind.


```bash
kubectl run nginx-pod --image=nginx:latest --port=80
```

Mit diesem Command sollte nginx als pod Erstellt werden.

Nun Überprüfe den Pod:

```bash
kubectl get pod # listet alle Pods des aktuellen namespaces auf
kubectl get pod nginx-pod -o wide # Listet den nginx-pod detailierter auf
kubectl describe pod nginx-pod # detailierte Beshreibung des pdds
```

Falls der Status iO. ist, kann mittels Port-Forwarding auf den Container zugegriffen werden. (evtl. seperates Terminal verwenden)

```bash
kubectl port-forward pod/nginx-pod 8080:80 # Leitet den Container Port 80 auf localhost:8080
```

Nun sollte die NGINX Standartseite auf http://localhost:8080 zur Verfügung stehen.

Der Pod kann mit folgendem Befehl wieder gelöscht werden:

```bash
kubectl delete pod nginx-pod
```


## Aufgabe 2: Pod mit YAML Konfig erstellen

Mit folgendem Command kann ein Template im aktuellen Verzeichnis erstellt werden.

```bash
kubectl run nginx-pod --image=nginx:latest --port=80 --dry-run=client -o yaml > nginx.yaml
```

Der Inhalt sollte folgendermassen ausehen:

./nginx.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx-pod
  name: nginx-pod
spec:
  containers:
  - image: nginx:latest
    name: nginx-pod
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

Beschreibung einiger Eigenschaften

* apiVersion: Gibt verwendete kubernetes API Version an
* kind: Typ des k8s Objekts (hier pod)
* metadata: Metadaten über das Objekt
* spec: Spezifikation des gewünschten Zustands
* containers: Liste der Container, welche im pod laufen sollen (hier nginx:latest)
* ports: Liste von Ports, die der Container offen legt
* resources: Anforderungen an Hardware
* status: aktueller Status des Objekts

### Diese Konfiguration Deployen

```bash
kubectl apply -f nginx.yaml
```

Mit obigen Commands (get pod [PodName]) kann überprüft werden ob dieser Pod deployed wurde.

> Aufgabe: Gebe die deployte YAML config aus und vergleiche diese mit der vorhin generierten YAML. Was sind die Unterschiede?

Löschen des Pods:

Aufgabe 3: Zugriff auf POD über CLI

> Pod aus Aufgabe 2 muss noch vorhanden sein.

Wie bereits mit Docker kann mit kubectl im Container eine Shell gestartet oder ein command ausgeführt werden.

Dazu kann folgendes command ausgeführt werden.

```bash
kubectl exec -it nginx-pod -- /bin/bash
``` 

Das Argument hinter den beiden bindestrichen sind die Argumente, welche dem Container übergeben werden.

> Falls der Pod mehr als ein Container hat, muss ggf. auch der Container Name angegben werden


> Aufgabe: Ändere das index.html auf dem NGINX ab und Überprüfe mit Port-Forwarding, ob der Inhalt geändert hat. Das index.html liegt unter /usr/share/nginx/html. Auf dem Container steht kein Editor zur Verfügung, aber das File kann mit echo überschrieben werden.


Mit folgendem Command kann der Pod wieder entfernt werden

```bash
kubectl delete -f nginx.yaml
```
