#! /bin/bash

imgStr='image'
images=()

while getopts "f:o:d:" opts; do
case "${opts}" in
  f)
    from="${OPTARG}"
  ;;
  o)
    out="${OPTARG}"
  ;;
  d)
    depth="${OPTARG}"
  ;;
  :)
    echo "Error: -${OPTARG} requires an argument."
    exit 0
  ;;
  *)
  exit 1
  ;;
  esac
done

if [[ -z "$depth" || -z "$out" || -z "$from" ]];
then
  echo "ERROR: d: for searching depth level, f: for searchin distenation and o: for output distenation are required"
  exit 1
fi


while IFS= read -r -d '' file; do 
    fileData=`file --mime-type "$file"`

    if  [[ "$fileData" == *"$imgStr"* ]] ;
    then
      echo "$file"
      images+=( "$file" )
    fi
done < <(find "$from" -maxdepth "$depth" -nowarn -type f -print0) # this is a  process substitution 

if [ ${#images[@]} -eq 0 ];
then 
  echo "No Images found."
  exit 1
fi

if [ -d $out ]; then
	mv "${images[@]}" $out
else 
	echo "directory not found, creating it..."
	mkdir -p $out
	mv "${images[@]}" $out
fi

echo "Images moved."

