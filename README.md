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
Run the following queries:
```sql
set optimizer=off;
set gp_segments_for_planner=128;
select count(*) from foo;
```
Note: 
* Don't include dbname in query, such as `edw=# set optimizer=on;`.
* Don't include tab in query, always convert to space, please.

The expected result is (if wrong result):
```
 count
-------
    10
(1 row)
```
We got error messages (if system error):
```
Interconnect Error: Unexpected Motion Node Id: 6.  This means a motion node that wasn't setup is requesting interconnect resources.
```
The backtrace in coredump/error log (if we have backtrace) is:
```
#0  0x00007f7797f066ab in raise () from /data/logs/56290/packcore-core.postgres.12468.1494346933.11.500.500/lib64/libpthread.so.0
#1  0x0000000000affd22 in StandardHandlerForSigillSigsegvSigbus_OnMainThread (processName=<optimized out>, postgres_signal_arg=11) at elog.c:4482
#2  <signal handler called>
#3  0x00000000005173c4 in varattrib_untoast_ptr_len (d=25, datastart=0x7fffba2a3850, len=0x7fffba2a385c, tofree=0x7fffba2a3848) at tuptoaster.c:269
#4  0x0000000000abc682 in bpeq (d1=<optimized out>, d0=<optimized out>) at varchar.c:723
#5  bpchareq (fcinfo=<optimized out>) at varchar.c:753
#6  0x0000000000760b02 in ExecMakeFunctionResult (fcache=<optimized out>, econtext=<optimized out>, isNull=<optimized out>, isDone=<optimized out>)
    at execQual.c:1752
#7  0x00000000007614dd in ExecEvalOper (fcache=0x29fec98, econtext=0x2a2b8a0, isNull=<optimized out>, isDone=0x0) at execQual.c:2225
#8  0x000000000075854f in ExecEvalCase (caseExpr=0x2a2bab0, econtext=0x2a2b8a0, isNull=0x2a686e1 "", isDone=<optimized out>) at execQual.c:3163
```
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



