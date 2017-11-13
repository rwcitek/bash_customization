alias mgl.alias.list='alias.list | grep "^alias mgl\."'
alias mgl.function.list='declare -f $( function.list.terse | cut -c12- | grep ^mgl ) '
