#! /bin/bash

imgStr='image'
images=()

while [ $# -gt 0 ]; do
  case "$1" in
    -from=*)
      from="${1#*=}"
      ;;
    -out=*)
      out="${1#*=}"
      ;;
    -depth=*)
      depth="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

for file in $(find $from -maxdepth $depth -nowarn -type f)
do
	fileData=$(file -r $file)
	if  grep -q "$imgStr" <<< $fileData ;
	then
		images+=( $file )
	fi
done

if [ -d $out ]; then
	mv ${images[@]} $out
else 
	echo "directory not found, creating it..."
	mkdir -p $out
	mv ${images[@]} $out
fi

echo "Images copied."

