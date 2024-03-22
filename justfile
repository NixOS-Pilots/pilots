# justfile
# cheatsheet: https://cheatography.com/linux-china/cheat-sheets/justfile/

# ===== Settings ===== #

# set options
set positional-arguments := true
set dotenv-load := true

# assign default value to vars
profile := "$PROFILE"

# default recipe to display help information
default:
  @just --list

# ===== Nix ===== #

# update all flake inputs
up:
  @nix flake update

# update a particular flake input
upp input:
  @nix flake lock --update-input {{ input }}

# show flake outputs
show:
  @nix flake show

# check flake
check:
  @nix flake check

# build nix pkg
build pkg:
  @nom build .#{{ pkg }}

# run nix pkg
run pkg:
  @nix run .#{{ pkg }}

# view flake.lock
view:
  @nix-melt

# nix-prefetch-url
prefetch-url url:
  @nix-prefetch-url --type sha256 '{{ url }}' | xargs nix hash to-sri --type sha256

# nix-prefetch-git
prefetch-git repo rev:
  @nix-prefetch-git --url 'git@github.com:{{ repo }}' --rev '{{ rev }}' --fetch-submodules

# activate nix-repl
repl:
  @nix repl -f flake:nixpkgs

# apply fix from linters
lint:
  @statix fix --ignore 'templates/' .
  @deadnix --edit --exclude 'templates/' .

# ===== Misc ===== #

# count total number of nix-related files
count:
  @rg '' --glob "!.git" --glob "!home-estate" --glob "!secrets" --files-with-matches | wc -l

# ===== Git ===== #

# stage all files
add:
  @git add .

# git pull
pull:
  @git pull --rebase
