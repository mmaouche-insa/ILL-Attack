
#trap 'echo "# $BASH_COMMAND"' DEBUG

## Run ILL-Attack on mobility data
## It is better and easier to use Launcher.sh with a config file
## To run alone  bash run_workflow.sh <path-dataset> <split-in-seconds> <level-integer[1,31]> <ratio train-float]0,1[> <name-output> <nbRuns-poistive integer> <path-to-python-scripts> <path-output> <path-csv-file-output>


#Parameters 
dataset=$(realpath "$1")
split=$2
level=$3
ratio=$4
nameOutput=$5
nbRuns=$6
sc=$(realpath "$7")
outputDir=$(realpath "$8")
resCsv="${9}"

workdir="$outputDir/accio"
mkdir "$workdir"
cd "$outputDir"



path_pred_list="$outputDir/pred_list.txt"
path_pred_join="$outputDir/pred_full.csv"
echo "name" > $path_pred_join

#path_full_join="$outputDir/full_full.csv"
#echo "name" > $path_full_join
###*************** DATA PROCESS *********************###
########################################################

python "$sc/"splitTracesByFixedSlices_functional.py $dataset "$outputDir/$nameOutput-split-$split-only" $split
python "$sc/"pre_decoupage_panda.py "$outputDir/$nameOutput-split-$split-only/" "$outputDir/train-$nameOutput-split-$split/" "$outputDir/test-$nameOutput-split-$split/" $ratio

pathTrain=$(realpath "$outputDir/train-$nameOutput-split-$split")
echo "$pathTrain"
pathTest=$(realpath "$outputDir/test-$nameOutput-split-$split")
echo "$pathTest"
nbTrain=$(ls $pathTrain | wc -l)
echo "$nbTrain"
nbTest=$(ls $pathTest | wc -l)
echo "$nbTest"


python "$sc/construct_heatmap_nonpanda_hierchicalMerges.py" $pathTrain $level  "$outputDir/train-$nameOutput-split-$split-level-$level.csv" 
python "$sc/construct_heatmap_nonpanda_hierchicalMerges.py" $pathTest $level  "$outputDir/test-$nameOutput-split-$split-level-$level.csv" 

for nbrun in $(seq 1 $nbRuns) 
do
	run_output="$outputDir/run-${nbrun}"
	mkdir "$run_output"
	cd "$run_output"
done
for nbrun in $(seq 1 $nbRuns) 
do
	(echo "nobf - $nbrun"
	trap 'echo "# $BASH_COMMAND"' DEBUG
	run_output="$outputDir/run-${nbrun}"
	python "$sc/"ml-attack-et.py "$outputDir/train-$nameOutput-split-$split-level-$level.csv" "$outputDir/test-$nameOutput-split-$split-level-$level.csv" >> "$run_output/log-ML-NOBF.txt"
	AccML1=$(cat "$run_output/log-ML-NOBF.txt")


	q -H -d ',' "SELECT name,predictions from $outputDir/test-$nameOutput-split-$split-level-$level-Wprediction.csv" > "$outputDir/nobf_predictions_$nbrun.csv"
    sed -i "1s/^/name,pred_nobf_$nbrun\n/" "$outputDir/nobf_predictions_$nbrun.csv"
    echo "$outputDir/nobf_predictions_$nbrun.csv" >> $path_pred_list
    #python "$sc/joinCsv.py" $path_pred_join "$outputDir/nobf_predictions_$nbrun.csv" "name" "-" $path_pred_join
	#cd .. la  
	echo "$nbrun,$dataset,$split,$ratio,$level,$nbTrain,$nbTest,ILL-attack,$AccML1" >> "$resCsv")&  
done
wait 


while read l; do
  python "$sc/joinCsv.py" $path_pred_join $l "name" "-" $path_pred_join
done < $path_pred_list


