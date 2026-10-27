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

tippe() {  # iOS: Element mit genau dieser Beschriftung antippen (bei mehreren Treffern das größte = ganze Zeile)
  local label="$1" t0=$(date +%s) pos=""
  while [ -z "$pos" ] && [ $(( $(date +%s) - t0 )) -lt "${2:-8}" ]; do
    pos=$(axe describe-ui --udid "$UDID" 2>/dev/null | LABEL="$label" python3 -c '
import json, os, sys
want, best = os.environ["LABEL"], None
def walk(n):
    global best
    if isinstance(n, dict):
        f = n.get("frame") or {}
        if n.get("AXLabel") == want and f.get("width") and f.get("height"):
            a = f["width"] * f["height"]
            if best is None or a > best[0]:
                best = (a, f["x"] + f["width"] / 2, f["y"] + f["height"] / 2)
        for v in n.values():
            walk(v)
    elif isinstance(n, list):
        for v in n:
            walk(v)
try:
    walk(json.load(sys.stdin))
except Exception:
    pass
print("" if best is None else f"{best[1]:.0f} {best[2]:.0f}")')
    [ -z "$pos" ] && sleep 0.5
  done
  if [ -n "$pos" ]; then axe tap -x "${pos% *}" -y "${pos#* }" --udid "$UDID"; else echo "tippe: '$label' nicht gefunden" >&2; return 1; fi
}
