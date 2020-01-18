# How to build sqlite3 from sources

FTS5 = full text search
RTREE = spatial index

You can use the following steps to build sqlite3 inside a docker image. Once built, see the KB article "How to copy a binary and its dependencies to a Lambda function"

```docker run -ti --rm -u 0 -v $(pwd):/host --entrypoint bash lambci/lambda:build-python3.7```


Then build sqlite3 as follows

```
yum install -y tcl-devel wget

wget https://www.sqlite.org/src/tarball/sqlite.tar.gz
tar xvf sqlite.tar.gz
mkdir bld
cd bld
../sqlite/configure
make
make sqlite3.c
make test

gcc -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_RTREE shell.c sqlite3.c -lpthread -ldl -o sqlite3 -lm
```

```
./sqlite3

CREATE VIRTUAL TABLE posts USING FTS5(title, body);

CREATE VIRTUAL TABLE demo_index USING rtree(id, minX, maxX, minY, maxY);
```



# How to copy a binary and its dependencies to a Lambda function

You can yum install various packages inside a lambda docker container. Then copy the binaries along with dependencies to another location. You can then install them into a Lambda function. By default, libraries are located in /usr/local/lib, /usr/local/lib64, /usr/lib and /usr/lib64; system startup libraries are in /lib and /lib64.

See attached binaries for jq, sqlite3 and htop, that were gathered using this method


copy_deps.sh
```
bash /host/cpld.bash /usr/bin/wget /host/deps/
```


run.sh
```
docker run -ti --rm -u 0 -v $(pwd):/host --entrypoint bash lambci/lambda:build-python3.7
```

cpld.bash
```
#!/bin/bash
# Author : Hemanth.HM
# Email : hemanth[dot]hm[at]gmail[dot]com
# License : GNU GPLv3
#

function useage()
{
    cat << EOU
Useage: bash $0 <path to the binary> <path to copy the dependencies>
EOU
exit 1
}

#Validate the inputs
[[ $# < 2 ]] && useage

#Check if the paths are vaild
[[ ! -e $1 ]] && echo "Not a vaild input $1" && exit 1
[[ -d $2 ]] || echo "No such directory $2 creating..."&& mkdir -p "$2"

#Get the library dependencies
echo "Collecting the shared library dependencies for $1..."
deps=$(ldd $1 | awk 'BEGIN{ORS=" "}$1\
~/^\//{print $1}$3~/^\//{print $3}'\
 | sed 's/,$/\n/')
echo "Copying the dependencies to $2"

#Copy the deps
for dep in $deps
do
    echo "Copying $dep to $2"
    cp "$dep" "$2"
done

echo "Done!"
```

See https://h3manth.com/content/copying-shared-library-dependencies
