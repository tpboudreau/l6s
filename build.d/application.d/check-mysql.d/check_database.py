
import os
import sys
import mysql.connector
from mysql.connector import errorcode


def has_librenms_database(db):
    rs = db.cursor()
    rs.execute("SHOW DATABASES")
    ds = {r[0] for r in rs}
    dx = {
        unicode('librenms', encoding='utf-8')
    }
    return dx.issubset(ds)


def has_librenms_character_set(db):
    rs = db.cursor()
    rs.execute("SELECT @@character_set_database, @@collation_database")
    cn = 0
    for r in rs:
        ch, co = r
        if unicode('utf8', encoding='utf-8') == ch:
            cn += 1
        if unicode('utf8_unicode_ci', encoding='utf-8') == co:
            cn += 1
    return cn == 2


def has_librenms_tables(db):
    rs = db.cursor()
    rs.execute("SHOW TABLES")
    ts = {r[0] for r in rs}
    tx = {
        unicode('customers', encoding='utf-8'),
        unicode('dashboards', encoding='utf-8'),
        unicode('devices', encoding='utf-8'),
        unicode('eventlog', encoding='utf-8'),
        unicode('notifications', encoding='utf-8'),
        unicode('pollers', encoding='utf-8'),
        unicode('users', encoding='utf-8'),
        unicode('vlans', encoding='utf-8'),
    }

    ox = []
    for t in ts:
        cs = db.cursor()
        qy = "CHECK TABLE " + t + " MEDIUM"
        cs.execute(qy)
        for c in cs:
            _, _, _, ok = c
            ox.append(unicode('OK', encoding='utf-8') == ok)

    return tx.issubset(ts) and all(ox)


def has_librenms_administrator(db):
    rs = db.cursor()
    rs.execute("SELECT * FROM users WHERE level >= 10")
    us = {r[0] for r in rs}

    return len(us) > 0


def valid_librenms_instance():
    ok = False
    try:
        MYSQL_HOST = os.getenv('LIBRENMS_MYSQL_HOST')
        MYSQL_PORT = os.getenv('LIBRENMS_MYSQL_PORT')
        MYSQL_USER = os.getenv('LIBRENMS_MYSQL_USER')
        MYSQL_PASSWORD = os.getenv('LIBRENMS_MYSQL_PASSWORD')
        cf = {
            'host': MYSQL_HOST,
            'port': MYSQL_PORT,
            'user': MYSQL_USER,
            'password': MYSQL_PASSWORD,
            'database': 'librenms',
            'raise_on_warnings': True
        }
        db = mysql.connector.connect(**cf)
    except mysql.connector.Error as err:
        print(err)
    else:
        ok = (
            has_librenms_database(db) and
            has_librenms_character_set(db) and
            has_librenms_tables(db) and
            has_librenms_administrator(db)
        )
        db.close()
    return ok


if __name__ == "__main__":
    if valid_librenms_instance():
        print("LibreNMS database instance validated")
    else:
        print("Unable to validate LibreNMS database instance")
        sys.exit(1)
