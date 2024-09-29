
_default:
    just --list

# check for api keys
check:
    rg 'api'
    rg 'key'

# run stow
run:
    stow .
