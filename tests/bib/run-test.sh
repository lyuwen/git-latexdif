#!/bin/sh

die () {
    echo "fatal: $@"
    exit 1
}

oldnew="$(git rev-list HEAD -- test.tex test.bbl)"
old=$(echo "$oldnew" | sed -n '1p')
new=$(echo "$oldnew" | sed -n '2p')

rm -f *.aux *.bbl
echo "git latexdiff without --bbl option (should not display bibliography)"
../../git-latexdiff $old $new 2>&1 > no-bbl.log ||
	die "latexdiff without --bbl failed (log in no-bbl.log)."

rm -f *.aux *.bbl
echo "git latexdiff with --bbl option (should display diff within bibliography)"
../../git-latexdiff $old $new --bbl 2>&1 > with-bbl.log ||
	die "latexdiff with --bbl failed (log in with-bbl.log)."

rm -f *.aux *.bbl
echo "git latexdiff with --latexdiff-flatten option (should not display bibliography)"
../../git-latexdiff $old $new --latexdiff-flatten 2>&1 > with-flatten.log ||
	die "latexdiff with --latexdiff-flatten failed (log in flatten.log)."


