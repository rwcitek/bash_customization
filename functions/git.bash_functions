git.commit.file () 
{ 
    [ "$2" -a "$1" ] && git commit -m "in $1: $2" -- "$1"
}
