from psycopg2 import connect

props="dbname=polytech user=postgres password=postgres port=5432"
fc = connect(props)
sc = connect(props)
fcursor = fc.cursor()
scursor = sc.cursor()

isolation_level="REPEATABLE READ"
fc.set_session(isolation_level)
sc.set_session(isolation_level)

def find_all():
    fcursor.execute("select * from planes")
    print(fcursor.fetchall())
    fc.commit()

print("unrepeatable read")

find_all()
scursor.execute("update planes set produced_by = 'OAK' where type like 'Tu'")
sc.commit()
find_all()

fc.commit()
fc.rollback()

print("phantom read")

fcursor.execute("select * from planes where id = 1")
scursor.execute("update planes set type = 'a320 neo' where id = 1")
sc.commit()
fcursor.execute("select * from planes where id = 1")
print(fcursor.fetchall())
fc.commit()

print("serialization anomaly")
fcursor.execute("update planes set num_sells = 300 where num_sells < 200;")
scursor.execute("update planes set num_sells = 100 where num_sells > 1000;")
sc.commit()
fc.commit()

find_all()

sc.close()
fc.close()
