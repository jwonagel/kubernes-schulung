# Config Map

## Vorbereitung

Wende das deployment.yaml in deinem namespace an und führe einem seperaten Terminal Port-Forwarding für den Port 80 auf den Service aus.
Dies sollte die bereits bekannte NGINX Standartseite liefern.

## Aufgabe 1

Erstelle eine Configmap mit untem aufgeführten html als Wert. Der Schlüssel kann Frei gewählt werden.
Dazu kann das deployment.yaml weitergeführt werden, oder auch ein neus File erstellt werden.

>   Hinweis: Grosse mehrzeilige Strings können in YAML Files folgendermassen definiert werden
>   ```yaml
>   stringDerMehrzeiligIst: |
>     Grosser String
>     Mit vielen Zeilen
>   stringFürUebersichtMehrzeilig: >
>     Grosser String auf einer Zeile
>     Welcher zur Übersicht im Yaml
>     umbrüche hat.
>   ```

<details>

<summary>HTML</summary>

```html
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lustige bunte Seite</title>
    <style>
        body {
            font-family: 'Comic Sans MS', cursive, sans-serif;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4, #fbc2eb, #a6c1ee);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
        }

        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        h1 {
            font-size: 3em;
            text-shadow: 3px 3px 0 #000;
            margin-bottom: 20px;
        }

        button {
            background-color: #ff6b6b;
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 1.2em;
            border-radius: 30px;
            cursor: pointer;
            box-shadow: 0 4px 0 #cc5252;
            transition: all 0.2s;
            margin: 20px;
        }

        button:hover {
            background-color: #ff8787;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 #cc5252;
        }

        button:active {
            transform: translateY(2px);
            box-shadow: 0 2px 0 #cc5252;
        }

        #witz {
            font-size: 1.5em;
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            display: none;
        }

        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background-color: #f00;
            top: 0;
            left: 0;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <h1>Willkommen auf der verrückten bunten Seite!</h1>
    <button id="witzButton">Zeig mir einen Witz!</button>
    <div id="witz"></div>

    <script>
        const witze = [
            "Warum können Geister so schlecht lügen? – Weil man sie durchschaut!",
            "Warum mögen Programmierer keine Natur? – Zu viele Bugs.",
            "Wie nennt man einen Programmierer ohne Freundin? – Full-Stack Overflow.",
            "Warum hat der Programmierer seine Tastatur weggeworfen? – Weil sie keine Escape-Taste hatte.",
            "Wie viele Programmierer braucht man, um eine Glühbirne zu wechseln? – Keinen, das ist ein Hardware-Problem.",
            "Warum essen Programmierer keine Kuchen? – Zu viele Schichten.",
            "Warum trinken Programmierer so viel Kaffee? – Weil sie ohne Java nicht starten können.",
            "Warum ging der Programmierer pleite? – Weil er ständig Arrays out of bounds ging.",
            "Warum ist der Programmierer traurig? – Weil sein Code nicht in der richtigen Klasse war.",
            "Was sagt ein JavaScript-Entwickler, wenn er aus dem Fenster fällt? – 'this' ist weg!",
            "Warum war der C-Programmierer immer so cool? – Weil er keine Klassen hatte.",
            "Was macht ein Programmierer, wenn ihm kalt ist? – Er geht in den Cache.",
            "Warum lieben Programmierer Dunkelmodus? – Weil das Licht Bugs anzieht.",
            "Warum war der SQL-Befehl traurig? – Weil niemand seine Beziehungen joinen wollte.",
            "Was ist der Lieblingssport von Programmierern? – Ping-Pong.",
            "Warum sind Programmierer schlechte DJs? – Sie können keine Loops beenden.",
            "Warum mögen Programmierer keine Hochzeiten? – Zu viele Commitments.",
            "Wie nennt man eine Gruppe von acht Hobbits? – Ein Hobbyte.",
            "Warum tragen Programmierer immer Brillen? – Damit sie C# sehen können.",
            "Warum hat der Programmierer eine Bratpfanne neben dem PC? – Für seine Stacktraces.",
            "Was ist der Lieblingssnack eines Programmierers? – Cookies.",
            "Warum wurde der Programmierer verhaftet? – Er hat in fremde Domains eingebrochen.",
            "Warum schlafen Programmierer so schlecht? – Zu viele offene Threads.",
            "Was sagt ein Backend-Entwickler im Fitnessstudio? – 'Ich arbeite nur am Server.'",
            "Warum war der Entwickler im Fitnessstudio so beliebt? – Er hatte gute Dependencies.",
            "Warum war der Code schlecht gelaunt? – Zu viele Exceptions.",
            "Was macht ein Programmierer, wenn er Hunger hat? – Er ruft eine Funktion auf.",
            "Warum wollte der Programmierer nicht heiraten? – Er hatte Angst vor Deadlocks.",
            "Wie begrüßen sich zwei Java-Programmierer? – 'NullPointerException!'",
            "Warum war der Algorithmus nervös? – Zu viele edge cases.",
            "Was ist das Lieblingsgetränk eines Entwicklers? – Root Beer.",
            "Warum hasst der Programmierer das Meer? – Zu viele Wellen (while-Schleifen).",
            "Was macht ein Entwickler, wenn sein Code läuft? – Er rennt hinterher.",
            "Warum ging der Programmierer nicht zur Party? – Er hatte ein Timeout.",
            "Wie nennt man einen Entwickler, der keine Bugs hat? – Arbeitslos.",
            "Warum sind Programmierer wie Magier? – Sie lassen Probleme verschwinden (meistens).",
            "Warum können Programmierer keine guten Witze erzählen? – Sie nehmen alles wörtlich.",
            "Was sagt ein Programmierer beim Bäcker? – 'Ein Cookie bitte – ohne Session.'",
            "Warum liebt der Programmierer Pizza? – Weil sie in Schichten gebaut ist.",
            "Was macht ein Programmierer, wenn er sich einsam fühlt? – Er öffnet einen Socket.",
            "Warum ging der Entwickler über die Straße? – Um auf die andere API zu kommen.",
            "Wie nennt man einen Programmierer, der gerne tanzt? – Algo-Rhythmiker.",
            "Warum hat der Programmierer seine Katze 'HTTP' genannt? – Weil sie nicht ohne Request kommt.",
            "Was ist die Lieblingsjahreszeit eines Programmierers? – Deploy.",
            "Warum sind Programmierer schlechte Gärtner? – Sie verwechseln Root und Branch.",
            "Warum war der Server beleidigt? – Jemand hatte ihn geforkt.",
            "Was sagt ein Entwickler nach einem langen Tag? – 'Ich bin ausgeloggt.'",
            "Warum sind Programmierer schlechte Autofahrer? – Sie denken, 0 ist der erste Gang.",
            "Warum hatte der Programmierer Angst vor seinem Code? – Er war unhandled.",
            "Was macht ein Programmierer im Urlaub? – Er cached sich aus."
        ];



        const witzButton = document.getElementById("witzButton");
        const witzDiv = document.getElementById("witz");

        witzButton.addEventListener("click", () => {
            const zufaelligerWitz = witze[Math.floor(Math.random() * witze.length)];
            witzDiv.style.display = "block";
            witzDiv.textContent = zufaelligerWitz;
            erzeugeKonfetti();
        });

        function erzeugeKonfetti() {
            for (let i = 0; i < 100; i++) {
                const konfetti = document.createElement("div");
                konfetti.classList.add("confetti");
                konfetti.style.left = Math.random() * 100 + "vw";
                konfetti.style.backgroundColor = `hsl(${Math.random() * 360}, 100%, 50%)`;
                konfetti.style.animation = `fall ${Math.random() * 3 + 2}s linear forwards`;
                document.body.appendChild(konfetti);

                // Animation für das Konfetti
                konfetti.style.animation = `fall ${Math.random() * 3 + 2}s linear forwards`;
            }
        }

        // CSS für die Konfetti-Animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fall {
                to {
                    transform: translateY(100vh);
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>

```

</details>

Der Html Wert der ConfigMap soll jetzt als Volume in den nginx Pod unter /usr/share/nginx/html/index.html "gemounted" werden.
Nach Anpassung des Deployments, können alle Konfigurationen angewendet werden. +

Was gitb das Port-Forwarding (Muss ggf. neu gestartet werden) zurück?


## Aufgabe 2

Betrachte die Logs des aktuellen Containers.

Binde eine 2. Configmap für Umgebungsvariablen in den Nginx Pod 1.
Dabei soll die Umgebungsvariable __NGINX_ENTRYPOINT_QUIET_LOGS__ auf 1 gesetzt werden.

Nach Anwendung Betrachte nochmals die Logs des neu erstellten Containers.

## Zusatzaufgabe

Versuche ein Secret zu erstellen und dessen Wert auch im NGINX Container als Webseite einbinden (z.B. secret.html)



Am Schluss bitte wieder alle erstellten Objekte vom Cluster löschen.