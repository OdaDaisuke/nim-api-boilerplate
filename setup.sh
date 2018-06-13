set -e

CURRENT_OTP="nim_web_api"

NEW_OTP=$1
NEW_NAME=$(echo $NEW_OTP | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')

git grep -l $CURRENT_NAME | xargs sed -i '' -e "s/$CURRENT_NAME/$NEW_NAME/g"
git grep -l $CURRENT_OTP | xargs sed -i '' -e "s/$CURRENT_OTP/$NEW_OTP/g"

mv $CURRENT_OTP.nimble $NEW_OTP.nimble
mv src/$CURRENT_OTP.nim src/$NEW_OTP.nim
mv src/${CURRENT_OTP}pkg src/${NEW_OTP}pkg

rm setup.sh
