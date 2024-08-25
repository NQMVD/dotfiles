
_default:
    just --list

# run git fetch
update:
    git fetch

# check for api keys
check:
    rg 'api'
    rg 'key'

# run stow
run:
    stow .
