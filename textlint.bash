#! /bin/bash

function usage() {
    echo "Usage: " $0 filename OS
}

if [[ -z $1 || -z $2 ]]; then
    usage
    exit 1
fi

sdir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

filename="$1"
if [[ $2 == "unix" ]]; then
    pharovm="$sdir/textlint/Linux32/pharo"
elif [[ $2 == "win" ]]; then
    pharovm="$sdir/textlint/Windows32/pharo.exe"
fi
textlintimage="$sdir/textlint/TextLint.tmbundle/Support/TextLint.image"

rm -f /tmp/textlint.log
rm -f /tmp/textlint.st

cat > /tmp/textlint.st <<EOF
TLConsole checkFileNamed: '$filename' andOutputToFileNamed: '/tmp/textlint.log' withinDirectory: '$(pwd)'

EOF

echo
echo "Please wait while TextLint processes your file: it can take some time..."
echo
"$pharovm" -headless "$textlintimage" /tmp/textlint.st

if [[ ! -e /tmp/textlint.log ]]; then
    echo 'Something Bad Happened'
    exit 1
else
    cat /tmp/textlint.log
    exit 0
fi

