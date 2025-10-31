# Config Map

## Vorbereitung

Wende das deployment.yaml in deinem namespace an und führe einem seperaten Terminal Port-Forwarding für den Port 80 auf den Service aus.
Dies sollte wieder unsere lustige Webseite aus der Config Map Aufgabe liefern. 

## Aufgabe

Auf dem Dev02 Cluster ist Traefik als Ingress Controller installiert. 
Zudem sind external DNS für die Domände traefik-dev02.egeli-apps.dev aktiviert.
Es können mittels Let's Encrypt und Certbot automatisch TLS gesicherte Webseiten erstellt werden.


Erweitere das depoyment.yaml um folgende konfig und ersetze [kürzel] durch deinen MA-Kürzel

```yaml


apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: [kürzel]-ingressroute
  annotations:
    external-dns.alpha.kubernetes.io/target: traefik-dev02.egeli-apps.dev # Hier ist die Domain (oder Traefik IP direkt) einzugeben, für die der DNS A Rekord von oben erstellt wurde
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`[kürzel].traefik-dev02.egeli-apps.dev`)
      kind: Rule
      services:
        - name: sample-nginx
          port: 80
  tls:
    secretName: traefik-dev02-[kürzel]

---

apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: traefik-dev02-[kürzel]
spec:
  secretName: traefik-dev02-[kürzel]
  # Wenn beim Deployment mehrere Domains benötigt werden, können diese hier einfach eingefügt werden, sodass nicht jedes Mal mehrere Zertifikate erstellt werden müssen
  dnsNames:
    - [kürzel].traefik-dev02.egeli-apps.dev
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer


```

Beim Ausführen des Behfeles

```bash
kubectl get ingressroute
```

Sollte den Ingress sichtbar machen.

Um schauen ob, das Zertifikat vorhanden ist, kann mit

```bash
kubectl get certificate
```

das Zertifikat angezeigt werden. Sobald dieses Ready=True ist, sollte die Seite unter [kürzel].traefik-dev02.egeli-apps.dev aufrufbar sein.

