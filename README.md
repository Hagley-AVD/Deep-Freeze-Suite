# Hagley AVD - Deep Freeze Suite

Set of scripts to sync Hagley Museum and Library Audiovisual Collections and Digital Initiatives digitized surrogates and born-digital preservation masters to amazon glacier vaults.

Glacier provides a secure, long-term, low-cost, and durable solution for preserving Hagley's digital collections off-premises. This repo is one component of AVD's glacier workflow. High resolution images of multi-page objects found in the [Hagley Digital Archives](http://digital.hagley.org) are transferred to glacier via the [Islandora](http://islandora.ca) S3 module.

Scripts are very specific to Hagley's environment. They are preserved on github to be accessible by AVD staff in the event I get hit by a bus or win the lottery.

name inspired by:

[![The Deep Freeze Suit](https://img.youtube.com/vi/xFrtRC6Z4pc/0.jpg)](https://youtu.be/xFrtRC6Z4pc "The Deep Freeze Suit")
## Requirements
* Windows 7,10
* [FastGlacier](https://fastglacier.com/) Specifically the glacier-sync cli utility.
* AWS Glacier account (obviously)
* [PSLogging](https://github.com/9to5IT/PSLogging) (optional) Timestamps the completion of each synced directory.
* [PushBullet](http://pushbullet) (optional) Push notifications on sync complete.


##### for vaultsizer only:
 * Python
 * [Boto3](https://aws.amazon.com/sdk-for-python/)
 * [aws cli](https://aws.amazon.com/cli/)

## Usage
Scripts are currently executed via windows task scheduler. Client machine must have FastGlacier installed and configured before running. Check paths to network storage before running.
