from psycopg2 import connect

props="dbname=polytech user=postgres password=postgres port=5432"
fc = connect(props)
sc = connect(props)
fcursor = fc.cursor()
scursor = sc.cursor()

isolation_level="READ COMMITTED"
fc.set_session(isolation_level)
sc.set_session(isolation_level)

def find_all():
    scursor.execute("select * from planes")
    print(scursor.fetchall())
    fc.commit()

print("dirty read")

find_all()
fcursor.execute("update planes set num_sells = num_sells + 3 where id = 1;")
fcursor.execute("select * from planes where id = 1;")
print(fcursor.fetchall())

scursor.execute("select * from planes where id = 1;")
print(scursor.fetchall())
sc.commit()

fc.rollback()
find_all()

print("lost update")

fcursor.execute("update planes set num_sells = num_sells + 1 where id = 1;")
scursor.execute("update planes set num_sells = num_sells + 2 where id = 1;")
fc.commit()
sc.commit()

scursor.execute("select * from planes")
print(scursor.fetchall())
fc.commit()

sc.close()
fc.close()