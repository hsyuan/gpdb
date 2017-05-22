## Issue
*Master Error*

Note: Possible options are
```
(Server/Master/Segment) Crash/Error
Recovery Mode
Wrong Result
Bad Performance/Long running time
System Hang
etc...
```

Creation of a temporary table fails every time it is run with error. Bla Bla... Try to describe it in 2 or 3 sentences.

## Verification
√:no issue x:same issue above #:different issue ∆: can't reproduce
```
4.3.8.1(PQO 1.617): √
4.3.8.1(Planner): √
4.3.9.0(PQO 2.0): x
4.3.9.0(Planner): √
4.3.10.0(PQO 2.1): x
4.3.10.0(Planner): x
4.3.11.0(PQO 2.2): #
4.3.11.0(Planner): ∆
```
*Reproducible*: Yes/No

*Reason (If No)*: No Data / No Clue

Note: Only write system versions that you have verified.

## Detail
Run the following queries:
```sql
set optimizer=off;
set gp_segments_for_planner=128;
select count(*) from foo;
```
Note: 
* Don't include **tab** in query, always convert to **space**, please.
* Don't include dbname in query, such as "edw=# select * from bar;", only write "select * from bar;".

Bad Example:
```sql
ssh root@10.193.102.217
Last login: Tue Apr 25 12:26:10 2017 from 10.90.248.34
master/57b0f7e4-f8a0-4eb7-b9cf-a94c330da91d:~# su - gpadmin
Last login: Tue Apr 25 12:26:14 UTC 2017 on pts/0
Last login: Tue Apr 25 12:32:00 UTC 2017 on pts/2
master/57b0f7e4-f8a0-4eb7-b9cf-a94c330da91d:~$ psql -d edw
psql (8.2.15)
Type "help" for help.

edw=# set optimizer=on;
SET
edw=# explain create temporary table tmp_wrt_ext as
edw-# select dra.mrkt_id from foo;
```
Don't paste useless info shown in above example, all you need to paste is:
```sql
set optimizer=on;
explain create temporary table tmp_wrt_ext as
select dra.mrkt_id from foo;
```

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
The backtrace in coredump/error log (if backtrace is available) is:
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

## System Logs / CoreDump
```
Address: gpadmin@10.193.94.7
Password: changeme
Directory: /data/logs/56290
```
Note: 
* Please use "username@1.2.3.4" or "ssh username@1.2.3.4", so we can just copy it.
* Only coredump file, log file and super large data file that you can't attach to the JIRA, other files you should always attach, such as minirepro, customer query, explain output, small repro data file, etc.

## Attachments
```
1.minirepro.sql -- output of minirepro
2.query.sql -- customer's query that causing this issue
3.planner.explain.sql -- planner explain output
4.orca.explain.sql -- orca explain output
5.master.log -- log info of master
6.segment1.log -- log info of segment 1
```
Note:
* Always make a list of attachments, unless you don't have any attachments.
* Always attach minirepro (if you have) and customer's queries.
* Always use lower case when naming files
* Always give it suffix. If sql query/explain/output/insert/data file, use ".sql", if log file, use ".log", for other plain text file, use ".txt", for other binaries like images, use the original suffix.
* Always start with a number, incrementally. If attach more than 9 files, start with "01, 02, 03, ... 10, 11, 12...", and then compress these files into zip or tar.gz file.
* Always use "." to seperate words in the file name, like the file name in above example.
* Try to give the file a simgple description, if not easy to guess from the file name what does the file do.

## Additional Info
Any info that you think is important.

Note:
* Please recheck or cross-check the information provided.
* Please verify the minirepro/gpsd and query are correct and workable, without any modification.
