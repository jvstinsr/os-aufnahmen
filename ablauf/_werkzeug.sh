# Hilfsfunktionen für die Abläufe (macOS-Bildschirm oder iOS-Simulator). Variablen: GERAET, UDID, OUT, SEKUNDEN.

vorbereiten() { :; }   # kann ein Ablauf überschreiben (läuft vor dem Video)

video_start() {
  if [ "$GERAET" = macos ]; then
    screencapture -x -v -V "$((SEKUNDEN + 2))" "$OUT/video.mov" &
  else
    xcrun simctl io "$UDID" recordVideo --codec=h264 --force "$OUT/video.mov" &
  fi
  REC_PID=$!
  T_START=$(date +%s)
  sleep 1
}

video_ende() {
  # Rest der gewünschten Länge abwarten, dann Aufnahme sauber beenden
  local rest=$(( SEKUNDEN + 1 - ($(date +%s) - T_START) ))
  [ "$rest" -gt 0 ] && sleep "$rest"
  if [ "$GERAET" = macos ]; then
    wait "$REC_PID" || true
  else
    kill -INT "$REC_PID"; wait "$REC_PID" || true
  fi
}

foto() {
  if [ "$GERAET" = macos ]; then screencapture -x "$1"; else xcrun simctl io "$UDID" screenshot "$1"; fi
}

app() {  # macOS: Programmname, iOS: Bundle-ID (z. B. com.apple.Preferences)
  if [ "$GERAET" = macos ]; then open -a "$1"; else xcrun simctl launch "$UDID" "$1"; fi
}

url() { if [ "$GERAET" = macos ]; then open "$1"; else xcrun simctl openurl "$UDID" "$1"; fi; }

warte() { sleep "$1"; }
