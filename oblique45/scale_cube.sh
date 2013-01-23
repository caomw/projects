sub_in=$1
scale=$2
f=$3

((sub_out=sub_in*scale))
dir=sub"$sub_out"_cubes_45deg
if [ ! -e $dir ]; then echo missing dir: $dir; exit; fi
g=${f/sub$sub_in/sub$sub_out}
time_run.sh reduce from=$f to=$g lscale=$scale sscale=$scale




