# Demo: Startbildschirm/Schreibtisch zeigen, dann die Einstellungen öffnen (zeigt die deutsche Oberfläche).
ablauf() {
  warte 1.5
  if [ "$GERAET" = macos ]; then
    app "System Settings"
  else
    app com.apple.Preferences
  fi
  warte 2
}
