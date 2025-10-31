# Deployments



## Aufgabe 1: Deployment von Nginx

Erstelle mit folgendem Befehl ein Deployment Manifest.

```bash
kubectl create deployment my-nginx --image=nginx:1.28 --dry-run=client -o=yaml > nginx.yaml
```
Analysiere das erstellte File nginx.yaml

Bitte entferne die Eigenschaften *strategy*, *resources* und *status*

Nun wende es auf deinen Namespace an.

Was siehst du jetzt, wenn du auf das deployment, replicaset oder pod zugreiftst?

# Aufgabe 2: Aktualieren vom Image

Aktualisiere das nginx image von 1.28 auf 1.29 und wende das File gegen dein bereits vorhandes deployment von Aufgabe 1 an.
Was hat sich jetzt geändert, wenn du auf das deployment, replicaset oder pod zugreiftst?

# Aufgabe 3: Anpassen der Replicas

In Kuberenetes ist es sehr einfach horizontal zu skalieren. 
Ändere dazu die replicas von 1 auf 3 und überprüfe die Pods und replicaset nach dem anwenden.


Zum Schluss kann mit dem delete Befehl das Deployment wieder gelöscht werden.

```bash
kubectl delete -f nginx.yaml
```