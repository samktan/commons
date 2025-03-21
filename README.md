# mos
MOS (My Oracle Support) Utility by sam.k.tan@oracle.com

# Overview
A simple shell script that simplifies a few tasks when working with My Oracle Support portal.
- uploading large support bundles to a specific support request (SR) ticket
- downloading patch files in the background and in parallel
- verifying and unpacking patch files into folders

# Background
I do a lot of demos and I regularly rebuild and reinstall systems. I download patches from MOS, create support tickets when things break, generate and upload support bundles as requested by the support engineers, so I wrote this script to help automate some of these tasks. The most useful feature here is the ability to download multiple patch files in the background and in parallel which means I can kick off the download job, logout of the session and go get coffee / tea / lunch / dinner / movie.

# Installation
Just clone the git repository and then run the `mos` command.
```
git clone https://github.com/samktan/mos
$HOME/mos/mos --help
```

# Usage
`mos [ upload | download | status | verify ]`

* `upload` - upload a file to MOS for the specified SR via HTTP(S)
* `download` - download a list of URL from MOS using `wget` in the background
* `status` - show the status of the downloads
* `verify` - verify the downloaded patch files using `unzip`

# Caveats
None at present.

/END
