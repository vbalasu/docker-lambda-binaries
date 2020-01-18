yum install -y wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release-latest-7.noarch.rpm
yum list |grep spatial
yum install -y libspatialite
ls /usr/lib64 |grep spatial
sqlite3
# sqlite> select load_extension('/usr/lib64/libspatialite.so.5');
# sqlite> select spatialite_version();
