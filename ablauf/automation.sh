# Kurzbefehle → Automation → neue Automation: welche Auslöser bietet der Simulator? Bilder + Beschriftungen.
vorbereiten() {
  set +e
  xcrun simctl launch "$UDID" com.apple.shortcuts; sleep 15
  axe describe-ui --udid "$UDID" >/dev/null 2>&1        # AXe aufwärmen
  foto "$OUT/01_start.png"; beschriftungen > "$OUT/01_start.txt"
  tippe "Automation"; sleep 4
  foto "$OUT/02_automation.png"; beschriftungen > "$OUT/02_automation.txt"
  # neue Automation: je nach Zustand Schaltfläche „Neue Automation“ oder „+“ (Beschriftung „Hinzufügen“)
  tippe "Neue Automation" 6 || tippe "Hinzufügen" 6 || tippe "Automation erstellen" 6
  sleep 4
  foto "$OUT/03_ausloeser.png"; beschriftungen > "$OUT/03_ausloeser.txt"
  for i in 1 2 3 4 5; do
    axe swipe --start-x 200 --start-y 650 --end-x 200 --end-y 250 --duration 0.4 --udid "$UDID"; sleep 2
    foto "$OUT/0$((3 + i))_ausloeser_$i.png"; beschriftungen > "$OUT/0$((3 + i))_ausloeser_$i.txt"
  done
  # Beispiel „Nachricht“ öffnen (falls vorhanden) – Auslöser aus dem Handy-Video
  axe swipe --start-x 200 --start-y 250 --end-x 200 --end-y 750 --duration 0.4 --udid "$UDID"; sleep 1
  axe swipe --start-x 200 --start-y 250 --end-x 200 --end-y 750 --duration 0.4 --udid "$UDID"; sleep 2
  tippe "Nachricht" 6 && sleep 4 && foto "$OUT/09_nachricht.png" && beschriftungen > "$OUT/09_nachricht.txt"
  set -e
}
ablauf() { warte 1; }
