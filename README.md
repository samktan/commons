# A collection of common scripts and commands
# by sam.k.tan@oracle.com

## MOS
`mos [ upload | download | status ]`

* `upload` - upload a file to MOS for the specified SR via HTTP(S)
* `download` - download a list of URL from MOS using `wget` in parallel
* `status` - show the status of the downloads


## SSSH
`ssh`

Use `ssh` as per normal and if there is host key error, it will prompt to delete the existing key.


## Reimage ODA
`reimage-oda-from-iso <ILOM hostname or IP>`

Provides a list of available boot ISO images to choose from, then conects to the specified ILOM to configure remote boot.
