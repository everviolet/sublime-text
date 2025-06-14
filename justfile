theme_url := "https://github.com/everviolet/bat/raw/main/themes"

_default:
  @just --list

# dir = mktemp -d
# @for
#   curl
#   zip
#   rename
#   mv themes/

clean:
  rm -rf themes

update out="themes":
  #!/usr/bin/env sh
  mkdir -p "{{ out }}"
  for item in "winter" "fall" "spring" "summer"; do
    just update-variant "{{ out }}" "${item}"
  done

update-variant dir="temp" variant="fall":
  cd "{{ dir }}" && curl -fsSLO "{{ theme_url }}/evergarden-{{ variant }}.tmTheme"

build out="themes":
  #!/usr/bin/env sh
  dir=$(mktemp -d)
  for item in "winter" "fall" "spring" "summer"; do
    just update-variant "${dir}" "${item}"
    just build-variant "${dir}" "${item}"
  done

  mkdir -p "{{ out }}"
  mv "${dir}/"* "{{ out }}/"
  just build-compound

build-variant dir="temp" variant="fall":
  #!/usr/bin/env sh
  cd "{{ dir }}"
  zip "{{ variant }}" "evergarden-{{ variant }}.tmTheme"
  mv "{{ variant }}.zip" "evergarden-{{ variant }}.sublime-package"

build-compound:
  zip evergarden themes/*.tmTheme
  mv evergarden.zip themes/evergarden.sublime-package
