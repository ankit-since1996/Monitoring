import requests
ip = input("Enter Ip Adress: ")
#print(ip)
querystring = {'ipAddress': ip, 'maxAgeInDays': '90'}
header = {'Accept': 'application/json','Key': '6281e49deab2bba450583a65a5cbffe08272d07f3515426ea5b47acfd7e18110300bcf9a8cd7d266'}
response = requests.get('https://api.abuseipdb.com/api/v2/check', headers=header , params=querystring)
a = response.json()['data']
#print(a)
for i,j in a.items():
    print(i,":",j)
#print response.json()
