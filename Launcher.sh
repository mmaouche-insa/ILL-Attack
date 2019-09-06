#trap 'echo "# $BASH_COMMAND"' DEBUG


### Launcher an experiment of ILL-Attack using a configuration file
### To run  bash Launcher.sh <path-json-config-file> <path-to-run_workflow.sh> <path-python-files> <output-names>


config_file=$(realpath "$1")
workflow_file=$(realpath "$2")
sc=$(realpath "$3")  # directory of all the scripts
td=$(date '+%Y-%m-%d-%H-%M-%S')
outputDir="$4_$td"
resCsv="$outputDir/$outputDir.csv"
mkdir "$outputDir"

outputDir=$(realpath $outputDir)



echo "runNbn,Dataset,Split,Ratio,Level,NbTrain,NbTest,Attack,Accuracy" > "$resCsv"
resCsv=$(realpath $resCsv)


nbRuns=$(jq --raw-output ".nbRuns" "$config_file")





datasets=$(jq --raw-output ".datasets|.[]" "$config_file")
splits=$(jq ".attacks|.[0].params.fixedTimeSplit|.[]" "$config_file")
levels=$(jq ".attacks|.[0].params.level|.[]" "$config_file")
ratios=$(jq --raw-output ".ratios|.[]" "$config_file")

it=0

cd "$outputDir"

for currentDataset in $datasets
do
	currentNameOUtput=$(jq --raw-output ".nameOutput |.[${it}]" "$config_file")
	it=$((it+1))
	for split in $splits
	do 
		for ratio in $ratios
		do
					for level in $levels
					do 
						config_output="$outputDir/config-$currentNameOUtput-split-$split-ratio-$ratio-level-$level"
						mkdir "$config_output"
						cd "$config_output"
						bash $workflow_file $currentDataset ${split} ${level} ${ratio} $currentNameOUtput ${nbRuns} $sc $config_output $resCsv
						cd ..
					done
		done
	done
done



