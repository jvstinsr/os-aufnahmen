# Diagnose iOS: AXe-Befehle und Bedienelemente (Startbildschirm, Einstellungen) in diagnose.txt.
vorbereiten() {
  {
    echo "== axe --version"; axe --version
    for c in "" tap swipe gesture button type key describe-ui touch; do echo "== axe $c --help"; axe $c --help; done
    echo "== describe-ui Startbildschirm"; axe describe-ui --udid "$UDID"
    xcrun simctl launch "$UDID" com.apple.Preferences; sleep 12
    echo "== describe-ui Einstellungen"; axe describe-ui --udid "$UDID"
    xcrun simctl io "$UDID" screenshot "$OUT/einstellungen_vorlauf.png"
    xcrun simctl terminate "$UDID" com.apple.Preferences
    echo "== openurl prefs"; xcrun simctl openurl "$UDID" "prefs:root=General" ; echo "rc=$?"; sleep 4
    xcrun simctl io "$UDID" screenshot "$OUT/prefs_url.png"
    xcrun simctl terminate "$UDID" com.apple.Preferences
  } > "$OUT/diagnose.txt" 2>&1
}
ablauf() { warte 1; }
