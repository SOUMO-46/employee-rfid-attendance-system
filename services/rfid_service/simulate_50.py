"""Send 50 unique test punches to a running PHP API. Use only on a test database."""
import argparse, concurrent.futures, uuid, requests
from datetime import datetime

def one(i, api, uid_prefix, device):
    payload={'event_id':str(uuid.uuid4()),'card_uid':f'{uid_prefix}{i:04X}','device_code':device,'punched_at':datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
    try:
        r=requests.post(api+'?resource=rfid-punch',json=payload,timeout=5); return i,r.status_code,r.text[:120]
    except Exception as e: return i,0,str(e)

p=argparse.ArgumentParser();p.add_argument('--api',required=True);p.add_argument('--count',type=int,default=50);p.add_argument('--uid-prefix',default='TEST');p.add_argument('--device',default='LOADTEST-01');a=p.parse_args()
with concurrent.futures.ThreadPoolExecutor(max_workers=min(20,a.count)) as ex:
    for result in ex.map(lambda i: one(i,a.api,a.uid_prefix,a.device),range(1,a.count+1)): print(result)
