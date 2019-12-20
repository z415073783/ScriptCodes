#/bin/bash
if [[ $# = 0 ]] || [["$1" = "-h"]]; then
	#statements

	function getdir(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
            echo $dir_or_file


        fi  
    done
}
root_dir="/git"
getdir $root_dir

fi
params=""

for value in $@; do
	params="${params} ${value}"
done

./params