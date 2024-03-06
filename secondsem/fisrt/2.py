from psycopg2 import connect

props="dbname=polytech user=postgres password=postgres port=5432"
fc = connect(props)
sc = connect(props)
fcursor = fc.cursor()
scurursor = sc.cursor()

isolation_level="READ COMMITTED"
fc.set_session(isolation_level)
sc.set_session(isolation_level)

def find_all():
    scurursor.execute("select * from planes")
    print(scurursor.fetchall())
    fc.commit()

print("unrepeatable read")

find_all()
scurursor.execute("update planes set produced_by = 'OAK' where type like 'Tu'")
sc.commit()
find_all()

fc.commit()

sc.close()
fc.close()