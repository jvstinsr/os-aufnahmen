# Diagnose: verfügbare Bildschirmauflösungen, Hintergrundbilder, Simulator-Geräte (Ergebnis in diagnose.txt).
vorbereiten() {
  {
    echo "== Displays"; system_profiler SPDisplaysDataType
    echo "== displayplacer"
    brew install displayplacer >/dev/null 2>&1 && displayplacer list
    echo "== Hintergrundbilder"; ls "/System/Library/Desktop Pictures/" | head -40
    echo "== Simulator-Geräte"; xcrun simctl list devicetypes | grep -E "iPhone|iPad" | tail -25
    echo "== Laufzeiten"; xcrun simctl list runtimes
  } > "$OUT/diagnose.txt" 2>&1
}
ablauf() { warte 1; }
