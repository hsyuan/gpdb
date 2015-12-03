@minirepro
Feature: Dump minimum database objects that is related to the query

    @minirepro_UI
    Scenario: Invalid arguments entered
      When the user runs "minirepro -w"
      Then minirepro should print error: no such option error message
      When the user runs "minirepro minireprodb -w"
      Then minirepro should print error: no such option error message

    @minirepro_UI
    Scenario: Missing required parameters
      When the user runs "minirepro"
      Then minirepro should print error: No database specified error message
      When the user runs "minirepro minireprodb -q"
      Then minirepro should print error: -q option requires an argument error message
      When the user runs "minirepro minireprodb -q ~/in.sql"
      Then minirepro should print error: No output file specified error message
      When the user runs "minirepro minireprodb -q ~/in.sql -f"
      Then minirepro should print error: -f option requires an argument error message

    @minirepro_UI
    Scenario: Query file does not exist
      Given the query file "/tmp/nonefolder/in.sql" does not exist
      When the user runs "minirepro minireprodb -q /tmp/nonefolder/in.sql -f ~/out.sql"
      Then minirepro should print error: Query file /tmp/nonefolder/in.sql does not exist error message

    @minirepro_core
    Scenario: Database does not exist
      Given database "nonedb000" does not exist
      When the user runs "minirepro nonedb000 -q ~/test/in.sql -f ~/out.sql"
      Then minirepro error should contain database "nonedb000" does not exist

    @minirepro_core
    Scenario: Database object does not exist
      Given the query file "/tmp/in.sql" exists and contains "select * from tbl_none;"
      And the table "public.tbl_none" does not exist in database "minireprodb"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f ~/out.sql"
      Then minirepro error should contain relation "tbl_none" does not exist

    @minirepro_core
    Scenario: Dump database objects related with select query
      Given the query file "/tmp/in.sql" exists and contains "select * from v1;"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t1" before "CREATE TABLE t3"
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t3" before "CREATE VIEW v1"
      And the output file "/tmp/out.sql" should not contain "CREATE TABLE t2"
      And the output file "/tmp/out.sql" should contain "Table: t1, Attribute: a"
      And the output file "/tmp/out.sql" should contain "Table: t1, Attribute: b"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: e"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: f"

    @minirepro_core
    Scenario: Dump database objects related with insert query
      Given the query file "/tmp/in.sql" exists and contains "insert into t1 values(2,5);"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t1"
      And the output file "/tmp/out.sql" should contain "Table: t1, Attribute: a"
      And the output file "/tmp/out.sql" should contain "Table: t1, Attribute: b"

    @minirepro_core
    Scenario: Dump database objects related with delete query
      Given the query file "/tmp/in.sql" exists and contains "delete from t2;"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t2"
      And the output file "/tmp/out.sql" should contain "Table: t2, Attribute: c"
      And the output file "/tmp/out.sql" should contain "Table: t2, Attribute: d"

    @minirepro_core
    Scenario: Dump database objects related with update query
      Given the query file "/tmp/in.sql" exists and contains "update t3 set f=1;"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t3"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: e"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: f"

    @minirepro_core
    Scenario: Dump database objects related with create query
      Given the query file "/tmp/in.sql" exists and contains "create table t0(a integer, b integer)"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should not contain "CREATE TABLE t0"

    @minirepro_core
    Scenario: Dump database objects related with select into query
      Given the query file "/tmp/in.sql" exists and contains "select * into t0 from t3"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should not contain "CREATE TABLE t0"
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t3"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: e"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: f"

    @minirepro_core
    Scenario: Dump database objects related with explain query
      Given the query file "/tmp/in.sql" exists and contains "explain delete from t2"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t2"
      And the output file "/tmp/out.sql" should contain "Table: t2, Attribute: c"
      And the output file "/tmp/out.sql" should contain "Table: t2, Attribute: d"

    @minirepro_core
    Scenario: Dump database objects related with explain analyze query
      Given the query file "/tmp/in.sql" exists and contains "EXPLAIN ANALYZE select * from t1"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t1"
      And the output file "/tmp/out.sql" should contain "Table: t1, Attribute: a"
      And the output file "/tmp/out.sql" should contain "Table: t1, Attribute: b"

    @minirepro_core
    Scenario: Dump database objects related with explain verbose query
      Given the query file "/tmp/in.sql" exists and contains "EXPLAIN verbose select * from t3"
      When the user runs "minirepro minireprodb -q /tmp/in.sql -f /tmp/out.sql"
      Then the output file "/tmp/out.sql" should exist
      And the output file "/tmp/out.sql" should contain "CREATE TABLE t3"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: e"
      And the output file "/tmp/out.sql" should contain "Table: t3, Attribute: f"
