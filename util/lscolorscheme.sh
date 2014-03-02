# doc colorscheme for bash ls listing
# syntax: 
# export LS_COLORS='pattern=num;num;num:pattern=num;num;num'
# to transform into the LS_COLORS value string..
colors=$(cat $1 | sed 's/\w*#.*//' | sed '/^$/d' | perl -lane 'printf "%s=%s:", shift @F, join ";", @F;')
echo $colors
export LS_COLORS='$colors'
echo
