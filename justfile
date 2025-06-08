theme_url := "https://github.com/everviolet/bat/raw/main/themes"

_default:
  @just --list

# dir = mktemp -d
# @for
#   curl
#   zip
#   rename
#   mv themes/

build dir="textmate":
  #!/usr/bin/env sh
  dir=$(mktemp -d)
  for item in "winter" "fall" "spring" "summer"; do
    just build-variant "${dir}" "$item"
  done

  mkdir -p themes
  mv "${dir}/"* themes/
  just build-compound
  rm themes/*.tmTheme

build-variant dir="textmate" variant="fall":
  #!/usr/bin/env sh
  dir="{{ dir }}"
  file="evergarden-{{ variant }}.tmTheme"
  cd "$dir"
  curl -fsSLO "{{ theme_url }}/${file}"
  zip "{{ variant }}" "${file}"
  mv "{{ variant }}.zip" "evergarden-{{ variant }}.sublime-package"

build-compound:
  cd themes/
  zip evergarden *.tmTheme
  mv evergarden.zip evergarden.sublime-package
