# How to install Spatialite in a Lambda function

You can install spatialite from the EPEL repository inside a lambci docker container

```
docker run -ti --rm -u 0 -v $(pwd):/host --entrypoint bash lambci/lambda:build-python3.7
```

```
yum install -y wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release-latest-7.noarch.rpm
yum list |grep spatial
yum install -y libspatialite
ls /usr/lib64 |grep spatial
sqlite3
# sqlite> select load_extension('/usr/lib64/libspatialite.so.5');
# sqlite> select spatialite_version();
```
