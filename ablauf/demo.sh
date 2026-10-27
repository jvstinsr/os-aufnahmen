# Demo (5-s-Videos): zeigt die deutsche Oberfläche.
#  macOS : Schreibtisch → Systemeinstellungen → „Sprache & Region“
#  iPhone: Home-Bildschirm → Einstellungen antippen → „Allgemein“
#  iPad  : Einstellungen (Start dort, das News-Widget des Home-Bildschirms zeigt englische Schlagzeilen) →
#          „Sprache & Region“

vorbereiten() {
  if [ "$GERAET" = macos ]; then
    brew install displayplacer >/dev/null 2>&1 || true
    ID=$(displayplacer list | awk '/Persistent screen id:/{print $4; exit}')
    [ -n "$ID" ] && displayplacer "id:$ID res:1920x1080 hz:60 color_depth:7 scaling:off origin:(0,0) degree:0" || true
    PIC=$(ls "/System/Library/Desktop Pictures/"*.heic 2>/dev/null | grep -iE "tahoe|sequoia|sonoma" | head -1)
    [ -z "$PIC" ] && PIC=$(ls "/System/Library/Desktop Pictures/"*.heic | head -1)
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$PIC\"" || true
    # Hinweis „Software Update Available“ blieb englisch (Dienste liefen schon vor der Umstellung) → neu starten
    sudo killall softwareupdated 2>/dev/null || true
    killall SoftwareUpdateNotificationManager 2>/dev/null || true
    killall -u "$USER" cfprefsd 2>/dev/null || true
    open -a "System Settings"; sleep 6; osascript -e 'quit app "System Settings"'; sleep 2
    system_profiler SPDisplaysDataType | grep -E "Resolution|Auflösung" >> "$OUT/system.txt" || true
  else
    xcrun simctl launch "$UDID" com.apple.Preferences; sleep 15    # Symbole laden beim ersten Start langsam
    xcrun simctl terminate "$UDID" com.apple.Preferences; sleep 2
    axe describe-ui --udid "$UDID" >/dev/null 2>&1 || true        # AXe aufwärmen (erster Aufruf braucht ~10 s)
    if [ "$GERAET" = ipad ]; then
      xcrun simctl launch "$UDID" com.apple.Preferences; sleep 6
    fi
  fi
}

ablauf() {
  case "$GERAET" in
    macos)
      warte 1.5
      app "System Settings"
      warte 2.5
      open "x-apple.systempreferences:com.apple.Localization-Settings.extension"
      warte 2.5 ;;
    iphone)
      warte 1.5
      axe tap --label "Einstellungen" --udid "$UDID" || app com.apple.Preferences
      warte 2.2
      axe tap --label "Allgemein" --wait-timeout 8 --udid "$UDID" || true
      warte 2 ;;
    ipad)
      warte 1.2
      axe tap --label "Sprache & Region" --wait-timeout 8 --udid "$UDID" || true
      warte 3 ;;
  esac
}
