# Welche Apps hat der Simulator? Liste nach apps.txt, dazu ein Bild von „Kurzbefehle“ (falls vorhanden).
vorbereiten() {
  set +e
  xcrun simctl listapps "$UDID" | plutil -convert json -o "$OUT/apps.json" - 2>/dev/null
  python3 - "$OUT/apps.json" > "$OUT/apps.txt" <<'PY'
import json, sys
apps = json.load(open(sys.argv[1]))
rows = sorted((a.get("CFBundleDisplayName") or a.get("CFBundleName") or "?", bid, a.get("ApplicationType", ""))
              for bid, a in apps.items())
for name, bid, typ in rows:
    print(f"{name}\t{bid}\t{typ}")
print(f"== {len(rows)} Apps")
PY
  if grep -q "com.apple.shortcuts" "$OUT/apps.txt"; then
    xcrun simctl launch "$UDID" com.apple.shortcuts; sleep 15
    xcrun simctl io "$UDID" screenshot "$OUT/kurzbefehle.png"
  fi
  set -e
}
ablauf() { warte 1; }
