#!/bin/sh
DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

source $DIR/config.sh

# Remove files older than 60 days
duplicity \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 remove-older-than 2M --force \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Perform the backup, make a full backup if it's been over 60 days
duplicity \
 --progress \
 --full-if-older-than 2M \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 --exclude "**/.cache" \
 --exclude "**/Android/Sdk" \
 --exclude "**/Dropbox" \
 --exclude "**/workspace/source" \
 --exclude "**/.local/share/Steam/steamapps" \
 ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Cleanup failures
duplicity \
 cleanup --force \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Show collection-status
duplicity collection-status \
 --sign-key $SGN_KEY --encrypt-key $ENC_KEY \
  b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

unset B2_ACCOUNT
unset B2_KEY
unset B2_BUCKET
unset B2_DIR
unset LOCAL_DIR
unset ENC_KEY
unset SGN_KEY
unset PASSPHRASE
unset SIGN_PASSPHRASE
