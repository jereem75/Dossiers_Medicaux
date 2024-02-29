import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    host = "sqletud.u-pem.fr",
    dbname = 'jeremy.sutra_db',
    password="paris75011",
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.autocommit = True

  return conn