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


### Update

UPDATE: for this to work, you have to grab the dependencies of libspatialite.so.5

See the KB article "How to copy a binary and its dependencies to a Lambda function" for how to do that

The updated zip file is attached

Note that you have to either copy the libraries to /usr/lib64 OR set the following LD_LIBRARY_PATH

```
export "LD_LIBRARY_PATH=/usr/lib64:/host/spatialite"
```

### Load data and run a query

Finally, we load some data and run a query.

You can download OpenStreetMap data from here:http://download.geofabrik.de/north-america.html

Once you pull down the data in PBF format, you can convert it to Spatialite format as follows:

```
ogr2ogr -f "SQLite" -dsco SPATIALITE=YES newjersey.spatialite new-jersey-latest.osm.pbf
```

Then within the container/lambda function, run the following:

```
sqlite3 /host/newjersey.spatialite
# sqlite> .load libspatialite.so.5
# sqlite> select spatialite_version();
# sqlite> SELECT *, ST_Distance(Geometry, ST_Point(-74.3708559,40.5720139), 0) AS meters FROM points WHERE meters < 1000 AND other_tags IS NOT NULL;
```