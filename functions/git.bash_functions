git.commit.file () 
{ 
    [ "$2" -a "$1" ] && git commit -m "in $1: $2" -- "$1"
}
git.project.new () 
{ 
    [ "${1}" ] || return;
    mkdir "${1}" || return;
    cd "${1}";
    git init;
    git flow init -d
}
