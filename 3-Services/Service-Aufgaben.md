# Services

Benötigte Tools:

* [Kubernetes Tools]https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools)


## Aufgabe 1

Wende das deployment.yaml mit apply auf deinen Namespace an. Dies erzeugt ein deployment mit dem label __app=sample-nginx__.
Nun erstelle ein 2. Yaml File service.yaml und erstelle einen Service des Typen ClusterIP mit dem name __sample-nginx-svc__.
Dazu kann z.B. die oben genannte Kubernetes VS Code Extension verwendet werden. 

Bei den Ports kann für targetPort sowie port der Port 80 angeben werden.

Der Service kann mit folgenden Commands aufgelistet werden.

```bash
kubectl get service
kubectl get svc # kurzform
```

Natürlich Funktionieren hier auch wieder describe svc, get svc [svcname] -o=yaml etc.

Falls alles geklappt hat, sollte mit dem Service ein Port-forwarding möglich sein.

```bash
kubectl port-forward sample-nginx-svc 8080:80
```
Somit haben wir einen fest definierten Namen und können auf den über das Deployment erzeugten Pod zugreifen.

## Aufgabe 2: Load Balancing

Passe die Anzahl (Replicas) Pods im Deployment auf 3 an.

Teste ob das Port-Forwarding immernoch funktioniert.

Nun lass uns herausfinden, von welchem Nginx der Inhalt kommt.
Dazu kann das Pwsh Script *update-nginx.ps1* ausgeführt werden. 
Falls Aufgabe 1 Fehlerfrei gelöst ist, sollte der Script den html Inhalt jedes Pods ändern.


Aber wieso kommt jetzt der Response immer von demselben Pod?
Bitte in der Gruppe diskutieren.

<details>

<summary>Lösung</summary>

1. Port-Forwarding wird direkt an einen Pod gebunden.
2. Kubernetes versucht eine Session aufrecht zu halten.

Startet man einen interaktiven Ubuntu Container, kann man mit mehrfacher Ausführung des Curl Befehls feststellen, dass der Inhalt wechselt.

```bash
kubectl run -it --rm test --image=ubuntu -- bash
apt update && apt install -y curl wget
curl http://sample-nginx-svc
```

Zudem kann auch der immer kommend Pod gelöscht werden (kubectl delete pod podId). 
Das Port-Forwarding wird sofort unterbrochen. Bei erneutem verbinden wird man nun einen beliebigen anderen Pod erreichen.
Dann wird der Traffic automatisch an einen anderen weitergeleitet.

</details>

Zum Schluss kann die Deployte Konfiguration wieder mit dem Delete Befehl gelöscht werden.