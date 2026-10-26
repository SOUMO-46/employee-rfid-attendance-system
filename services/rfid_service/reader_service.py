import argparse, json, sqlite3, time, uuid
from datetime import datetime
import requests, serial

DDL='''CREATE TABLE IF NOT EXISTS queue(id INTEGER PRIMARY KEY AUTOINCREMENT,event_id TEXT UNIQUE,card_uid TEXT NOT NULL,device_code TEXT NOT NULL,punched_at TEXT NOT NULL,attempts INTEGER NOT NULL DEFAULT 0,last_error TEXT)'''

def db_open(path):
    db=sqlite3.connect(path); db.execute(DDL); db.commit(); return db

def enqueue(db,uid,device):
    event=str(uuid.uuid4()); ts=datetime.now().strftime('%Y-%m-%d %H:%M:%S'); db.execute('INSERT OR IGNORE INTO queue(event_id,card_uid,device_code,punched_at) VALUES(?,?,?,?)',(event,uid,device,ts)); db.commit()

def sync(db,api,limit=25):
    rows=db.execute('SELECT id,event_id,card_uid,device_code,punched_at FROM queue ORDER BY id LIMIT ?',(limit,)).fetchall()
    for row in rows:
        payload={'event_id':row[1],'card_uid':row[2],'device_code':row[3],'punched_at':row[4]}
        try:
            r=requests.post(api+'?resource=rfid-punch',json=payload,timeout=3)
            if r.ok:
                db.execute('DELETE FROM queue WHERE id=?',(row[0],)); db.commit()
            else:
                db.execute('UPDATE queue SET attempts=attempts+1,last_error=? WHERE id=?',(r.text[:500],row[0])); db.commit(); break
        except Exception as exc:
            db.execute('UPDATE queue SET attempts=attempts+1,last_error=? WHERE id=?',(str(exc)[:500],row[0])); db.commit(); break

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--port',required=True); ap.add_argument('--baud',type=int,default=9600); ap.add_argument('--api',required=True); ap.add_argument('--device',default='GATE-01'); ap.add_argument('--db',default='rfid_queue.sqlite'); a=ap.parse_args()
    db=db_open(a.db); ser=serial.Serial(a.port,a.baud,timeout=.25); buffer=''
    print(f'RFID service ready: {a.port} / {a.device}')
    while True:
        sync(db,a.api)
        raw=ser.read(128)
        if raw:
            buffer += raw.decode('utf-8','ignore')
            while '\n' in buffer or '\r' in buffer:
                parts=buffer.replace('\r','\n').split('\n'); buffer=parts.pop();
                for uid in parts:
                    uid=''.join(ch for ch in uid.strip().upper() if ch.isalnum())
                    if uid: enqueue(db,uid,a.device)
        time.sleep(.05)
if __name__=='__main__': main()
