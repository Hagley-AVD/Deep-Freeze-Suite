import boto3
import json
import datetime
import humanize
import logging
logging.basicConfig(level=logging.INFO, filename="VaultSizer.log")
client = boto3.client('glacier')
responseDigRec = client.describe_vault(
    vaultName='DIGITAL_RECORDS',
)
responseVideoWS = client.describe_vault(
    vaultName='video_hi-res',
)
print(responseDigRec)
d = datetime.datetime.now()
dnow =d.isoformat()
dataDigRec = '%s' % responseDigRec
parsed_jsonDigRec = json.dumps(dataDigRec)
parsed_loadedDigRec = json.loads(parsed_jsonDigRec)
lhsDR, rhsDR = parsed_loadedDigRec.split("'SizeInBytes': ")
vSizeDR, junkDR = rhsDR.split("}")
vSizeDRh = humanize.naturalsize(vSizeDR)
arcDRNum1, arcDRNum2 = lhsDR.split("'NumberOfArchives': ")
arcNumberDR, arcDRNum3 = arcDRNum2.split(",")

print(responseVideoWS)
dataVid = '%s' % responseVideoWS
parsed_jsonVid = json.dumps(dataVid)
parsed_loadedVid = json.loads(parsed_jsonVid)
lhsVid, rhsVid = parsed_loadedVid.split("'SizeInBytes': ")
vSizeVid, junkVid = rhsVid.split("}")
vSizeVidh = humanize.naturalsize(vSizeVid)
arcVidNum1, arcVidNum2 = lhsVid.split("'NumberOfArchives': ")
arcNumberVid, arcVidNum3 = arcVidNum2.split(",")

logging.info("%s - DIGITAL_RECORDS: %s, %s files" % (dnow, vSizeDRh, arcNumberDR))
logging.info("%s - video_hi-res: %s, %s files" % (dnow, vSizeVidh, arcNumberVid))
