#!/bin/sh
DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

source $DIR/config.sh

# Remove files older than 60 days
duplicity \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 remove-older-than 2M --force \
 $BACKUP_URL

# Perform the backup, make a full backup if it's been over 60 days
duplicity \
 --progress \
 --full-if-older-than 2M \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 --exclude "**/.cache" \
 --exclude "**/Android/Sdk" \
 --exclude "**/Dropbox" \
 --exclude "**/Nextcloud" \
 --exclude "**/workspace/source" \
 --exclude "**/.local/share/Steam/steamapps" \
 $LOCAL_DIR $BACKUP_URL

# Cleanup failures
duplicity \
 cleanup --force \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 $BACKUP_URL

# Show collection-status
duplicity collection-status \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
  $BACKUP_URL

unset BACKUP_KEY
unset BACKUP_SECRET
unset BACKUP_BUCKET
unset BACKUP_DIR
unset BACKUP_URL
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset LOCAL_DIR
unset ENC_KEY
unset SGN_KEY
unset PASSPHRASE
unset SIGN_PASSPHRASE
