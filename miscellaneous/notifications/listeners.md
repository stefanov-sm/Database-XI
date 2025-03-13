# Notify receivers

## IMPORTANT
- add the ip of the machine that will receive the notifications in the `pg_hba.conf` file

## Python
```python
import psycopg2
import select

conn = psycopg2.connect("dbname=postgres user=postgres password=1234 host=192.168.1.203 port=5432")
conn.autocommit = True 

cur = conn.cursor()
cur.execute("LISTEN rita;")

print("Waiting for notifications on channel 'test_chan'...")

while True:
        select.select([conn], [], [])
        conn.poll()
        while conn.notifies:
            notify = conn.notifies.pop()
            print("Got NOTIFY:", notify.pid, notify.channel, notify.payload)
```

## Ruby
```ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'pg'

# adjust these also
begin
  conn = PG.connect(
    dbname:   'postgres',
    user:     'postgres',
    password: '1234',
    host:     '192.168.1.203',
    port:     5432
  )

# IMPORTANT change channel name also:
  conn.exec("LISTEN rita;")
  puts "Waiting for notifications on channel 'mychannel'..."

  loop do
    conn.wait_for_notify do |channel, pid, payload|
      puts "Received notification on #{channel}: #{payload}"
    end
  end

rescue PG::Error => e
  puts "An error occurred: #{e.message}"
# toni beshe tuk
ensure
  conn.close if conn
end
```

## C++
```cpp
#include <print>
#include <format>
#include <string>

#include <libpq-fe.h>
#include <unistd.h>

int main()
{
    const auto db_name = "postgres";
    const auto user = "postgres";
    const auto password = "postgres";
    const auto channel_name = "rita";

    const auto conn_info = std::format("dbname={} user={} password={}", db_name, user, password);
    PGconn*    conn      = PQconnectdb(conn_info.c_str());

    if (PQstatus(conn) != CONNECTION_OK)
    {
        std::println("Connection to database failed: {}", PQerrorMessage(conn));
        PQfinish(conn);
        return 1;
    }

    std::println("Connected to database");

    const auto listen_cmd   = std::format("LISTEN {};", channel_name);

    PGresult* res = PQexec(conn, listen_cmd.c_str());

    if (PQresultStatus(res) != PGRES_COMMAND_OK)
    {
        std::println("LISTEN command failed: {}", PQerrorMessage(conn));
        PQclear(res);
        PQfinish(conn);
        return 1;
    }
    PQclear(res);

    std::println("Listening on channel: {}", channel_name);

    while (true)
    {
        PQconsumeInput(conn);

        PGnotify* notify;
        while ((notify = PQnotifies(conn)) != nullptr)
        {
            std::println("Notification received:\n"
                         "\t{}\n"
                         "\t{}\n"
                         "\t{}",
                         notify->relname,
                         notify->be_pid,
                         notify->extra ? notify->extra : "NULL");

            PQfreemem(notify);
        }

        usleep(100000);
    }

    PQfinish(conn);
}
```
