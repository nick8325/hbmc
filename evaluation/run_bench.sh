ulimit -Sv 7000000
ghc --make Incremental.hs -o Incremental || exit

TIMEOUT=60
./Incremental False - benchmarks-smten/sat $TIMEOUT ./smten-runner
./Incremental False - benchmarks-feat/sat $TIMEOUT _feat
./Incremental False unknown benchmarks-cvc4/sat $TIMEOUT cvc4-2015-10-10-x86_64-linux-opt --fmf-fun --dump-models
./Incremental False - benchmarks/sat $TIMEOUT hbmc -q
./Incremental False - benchmarks-lazysc/sat $TIMEOUT _lazysc

# ./Incremental True - benchmarks/unsat $TIMEOUT hbmc -q -d
# ./Incremental True - benchmarks-smten/unsat $TIMEOUT _smten
# ./Incremental True - benchmarks-lazysc/unsat $TIMEOUT _lazysc

# ./Incremental Done. benchmarks-feat/sat $TIMEOUT _feat
# ./Incremental - benchmarks-lazysc/sat $TIMEOUT _lazysc
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --merge=False --memo=False
# ./Incremental unknown benchmarks-sk/sat $TIMEOUT cvc4-2015-08-18-x86_64-linux-opt --fmf-fun --dump-models
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --merge=False --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --merge=False --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --merge=False --memo=False
