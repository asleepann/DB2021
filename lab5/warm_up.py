import random # for generating ages of customers
import psycopg2
from faker import Faker

con = psycopg2.connect(database="customers", user="postgres",
                       password="qwerty", host="127.0.0.1", port="5432")

print("Database opened successfully")
cur = con.cursor()
cur.execute('''CREATE TABLE CUSTOMER
       (ID INT PRIMARY KEY NOT NULL,
       Name TEXT NOT NULL,
       Address TEXT NOT NULL,
       Age INT NOT NULL,
       review TEXT);''')
print("Table created successfully")
fake = Faker()
for i in range(100000):
    print(i)
    cur.execute("INSERT INTO CUSTOMER (ID, Name, Address, Age, review) VALUES ('" + str(i)
                + "','" + fake.name() + "','" + fake.address() + "','" + str(random.randint(10, 50))
                + "','" + fake.text() + "')")
    con.commit()
