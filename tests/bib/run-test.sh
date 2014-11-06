#!/bin/sh

die () {
    echo "fatal: $@"
    cleanup
    exit 1
}

cleanup () {
    perl -pi -e 's/Uncommited/New/g' test.tex test.bib
}

trap cleanup 2

perl -pi -e 's/New/Uncommited/g' test.tex test.bib
oldnew="$(git rev-list HEAD -- test.tex test.bib)"
old=$(echo "$oldnew" | sed -n '1p')
new=$(echo "$oldnew" | sed -n '2p')

rm -f *.aux *.bbl
echo "git latexdiff without --bbl option (should not display bibliography)"
../../git-latexdiff -v $old $new 2>&1 > no-bbl.log ||
	die "latexdiff without --bbl failed (log in no-bbl.log)."

rm -f *.aux *.bbl
echo "git latexdiff with --bbl option (should display diff within bibliography)"
../../git-latexdiff -v $old $new --bbl 2>&1 > with-bbl.log ||
	die "latexdiff with --bbl failed (log in with-bbl.log)."

rm -f *.aux *.bbl
echo "git latexdiff with --latexdiff-flatten option (should not display bibliography)"
../../git-latexdiff -v  $old $new --latexdiff-flatten 2>&1 > with-flatten.log ||
	die "latexdiff with --latexdiff-flatten failed (log in flatten.log)."

echo "git latexdiff --bbl against the working directory (should display new -> uncommited changes)"
../../git-latexdiff -v  --bbl HEAD -- 2>&1 > workdir.log ||
	die "git latexdiff --bbl against the working directory failed (log in workdir.log)."

cleanup

