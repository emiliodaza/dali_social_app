import json
import random
import string
import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("dalisocial-d92cc-firebase-adminsdk-fbsvc-513af85aa6.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

with open('dali_social_media.json', 'r') as file:
    data = json.load(file)

codes = set()

set_of_characters_for_codes = string.ascii_uppercase + string.digits

for member in data:
    member["claimed"] = False
    codeFound = False
    
    while (not codeFound):
        code = ""
        for i in range(6):
            code += random.choice(set_of_characters_for_codes)
        if code not in codes:
            codes.add(code)
            codeFound = True
    member["code_to_claim"] = code
    db.collection('users').add(member)