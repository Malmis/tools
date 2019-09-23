import requests

auth = (
    'ufae37d2609fa957faa8cbxxxxxxxxxx',
    'E3A9E41897966B51C681Dxxxxxxxxxxx'
    )

fields = {
    'from': '+46733xxxxxx',
    'to': '+46703xxxxxx',
    'voice_start': '{"play":"http://xxxxxx/hello.mp3"}'
    }

response = requests.post(
    "https://api.46elks.com/a1/calls",
    data=fields,
    auth=auth
    )

print(response.text)
