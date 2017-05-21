## Issue
__Master Error__

Possible options are:
```
(Server/Master/Segment) Crash/Error
Recovery Mode
Wrong Result
Bad Performance/Long running time
System Hang
etc...
```

Ex. Creation of a temporary table fails every time it is run with error.

## Verification
√:no issue x:same issue above #:different issue
```
V4.3.8.1(PQO 1.617): √
V4.3.8.1(Planner): √
V4.3.9.0(PQO 2.0): x
V4.3.9.0(Planner): √
V4.3.10.0(PQO 2.1): x
V4.3.10.0(Planner): x
V4.3.11.0(PQO 2.2): #
V4.3.11.0(Planner): #
```

## Detail

* From the GPDB doc set, review [Configuring Your Systems and
  Installing
  Greenplum](http://gpdb.docs.pivotal.io/4360/prep_os-overview.html#topic1)
  and perform appropriate updates to your system for GPDB use.

* **gpMgmt** utilities - command line tools for managing the cluster.

  You will need to add the following Python modules (2.7 & 2.6 are
  supported) into your installation

  * psutil
  * lockfile (>= 0.9.1)
  * paramiko
  * setuptools
  * epydoc

  If necessary, upgrade modules using "pip install --upgrade".
  pip should be at least version 7.x.x.



