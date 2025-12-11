#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. /opt/chadwm/scripts/bar_themes/dracula

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ "
  printf "^c$white^ ^b$grey^ $cpu_val ^b$black^"
}

pkg_updates() {
    updates=$({ timeout 20 xbps-install -un 2>/dev/null || true; } | wc -l) # void
  # updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$white^    $updates"" updates"
  fi
}

weather() {
  val="$(curl wttr.in/?format=1 | awk '{ print $2 }')"
  printf "^c$black^ ^b$white^ "
  printf "^c$white^ ^b$grey^ $val $val2 ^b$black^"
} 

keymap() {
  val="$(setxkbmap -query | awk '/^layout/ { print $2 $3 }' | sed s/i//g)"
  val2="$(setxkbmap -query | awk '/^variant/ { print $2 $3 }' | sed s/i//g)"
  printf "^c$black^ ^b$white^ "
  printf "^c$white^ ^b$grey^ $val $val2 ^b$black^"
}
  
battery() {
  val="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$black^ ^b$red^ "
  printf "^c$white^ ^b$grey^ $val ^b$black^"

}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$black^ ^b$darkblue^ "
  printf "^c$white^ ^b$grey^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(weather) $(keymap) $(cpu) $(battery) $(mem) $(wlan) $(clock)"
done
