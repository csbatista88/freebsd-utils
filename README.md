## freebsd-utils 

utils to FreeBSD - wifi and sound

# Getting started

wifi configure bwn in FreeBSD 14.0 in macbook air 5,2 and 3,1
bcm43224 and BCM4321

# solution
```
A commit in branch main references this bug:

URL: https://cgit.FreeBSD.org/src/commit/?id=59dba901f227420647e4856f03cb782a3375c220

commit 59dba901f227420647e4856f03cb782a3375c220
Author:     Frank Hilgendorf <frank.hilgendorf@posteo.de>
AuthorDate: 2023-12-13 23:48:08 +0000
Commit:     Bjoern A. Zeeb <bz@FreeBSD.org>
CommitDate: 2023-12-13 23:54:05 +0000

    bwn: remove unused ic_headroom

    Unlike bwi(4), bwn(4) does not rely on ic_headroom (despite having it
    set) but splits the bwn_txhdr (first) segment into its own transaction.
    Remove ic_headroom to avoid net80211 troubles with not enough space in
    the mbuf around ieee80211_mbuf_adjust().

    PR:             275616
    MFC after:      3 days

 sys/dev/bwn/if_bwn.c | 2 --
 1 file changed, 2 deletions(-)
 
# 
```

# use if_bwn.c in repo or remove "ic->ic_headroom = sizeof(struct bwn_txhdr);":

```
diff --git a/sys/dev/bwn/if_bwn.c b/sys/dev/bwn/if_bwn.c
index 501bcc1e958e..742ed63a92aa 100644
--- a/sys/dev/bwn/if_bwn.c
+++ b/sys/dev/bwn/if_bwn.c
@@ -808,8 +808,6 @@ bwn_attach_post(struct bwn_softc *sc)
 	/* call MI attach routine. */
 	ieee80211_ifattach(ic);
 
-	ic->ic_headroom = sizeof(struct bwn_txhdr);
-
 	/* override default methods */
 	ic->ic_raw_xmit = bwn_raw_xmit;
 	ic->ic_updateslot = bwn_updateslot;
```
and recompile using KERNCONF=WIFI or edit kernel with:

```
options BWN_GPL_PHY
```

```
cd /usr/src
cp ./sys/amd64/conf/GENERIC sys/amd64/conf/WIFI

vim sys/amd64/conf/WIFI

## add options BWN_GPL_PHY 
## add options BWN_DEBUG

make buildkernel KERNCONF=WIFI
make installkernel KERNCONF=WIFI

vim /boot/loader.conf

## add bwn_v4_n_ucode_load="YES"

vim /etc/rc.conf

wlans_bwn0="wlan0"
ifconfig_wlan0="WPA SYNCDHCP"

reboot
```


# work.sh

Configure keyboard in Macbook air us intl with accents keys(FreeBSD).
Configure screen lcd (FreeBSD).
Configure input and output usb sound (FreeBSD).

# print.sh
Example scrot printscreen (FreeBSD).

# rec.sh
Rec using ffmpeg.

# Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/christianbaptista/freebsd-utils.git
git branch -M main
git push -uf origin main
```


