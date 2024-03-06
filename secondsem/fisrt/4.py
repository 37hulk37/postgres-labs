from psycopg2 import connect

props="dbname=polytech user=postgres password=postgres port=5432"
fc = connect(props)
sc = connect(props)
fcursor = fc.cursor()
scursor = sc.cursor()

isolation_level="SERIALIZABLE"
fc.set_session(isolation_level)
sc.set_session(isolation_level)

def find_all():
    scursor.execute("select * from planes")
    print(scursor.fetchall())
    fc.commit()

print("serialization anomaly")

find_all()
fcursor.execute("update planes set num_sells = 300 where num_sells < 200;")
scursor.execute("update planes set num_sells = 100 where num_sells > 200;")
sc.commit()