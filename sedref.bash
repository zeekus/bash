#find all files with pp and replace clean_metadata with centos6_clean_metadata
sed -i  's/clean_metadata/centos6_clean_metadata/g' $(find . -type f -name '*.pp')
