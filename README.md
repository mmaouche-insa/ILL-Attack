# ILL-Attack Toolkit

Welcome to ILL-Attack toolkit. 
A toolkit to test the Location Privacy Re-identification Attack ILL-Attack.


## Requiremennts
- [S2Geometry Library](https://github.com/google/s2geometry#python)

- Requirements.txt
```sh
psutil==5.4.8
pandas==0.23.4
TPOT==0.9.5
numpy==1.16.0
scikit_learn==0.21.3
``` 

## Run 
```sh
./Launcher.sh   <path-json-config-file>  <path-to-run_workflow.sh>   <path-python-files> <output-names>
```
Simple minimal usage with default value.
```sh
 ./Launcher.sh  config.json  run_workflow.sh    .  outDir
```
##   Config File Example 
```json
{
"datasets":["path-dataset1","path-dataset2","path-dataset3"],
"nameOutput":["D1","D2","D3"],
"nbRuns":3,
"ratios":[0.8,0.2,0.5],
"attacks":[
	{"id":"ILL-Attack",
 	 "params":{ 
		"fixedTimeSplit":[86400,25000],
		"level":[13]
		}
	}
	]
}
```
## Mobility Dataset Format 
One dataset = One directory of mobility traces.

One mobility trace of user =  One CSV file named <user_id>.csv

CSV file format =  Each line is a record of the mobility trace. 

One record =  \<lattitude\>,\<longitude>,\<timestamp\>

Timestamp = [Unix time POSIX](https://linux.die.net/man/2/time)   .

## Contact
https://mmaouche.github.io/

 <mohamed.maouchet@liris.cnrs.fr>
 
License
----

 Copyright LIRIS-CNRS (2019)
 Contributors: Mohamed Maouche  <mohamed.maouchet@liris.cnrs.fr>

This software is a computer program whose purpose is to study location privacy.

This software is governed by the CeCILL-B license under French law and
  abiding by the rules of distribution of free software. You can use,
  modify and/ or redistribute the software under the terms of the CeCILL-B
  license as circulated by CEA, CNRS and INRIA at the following URL
  "http://www.cecill.info".
 
  As a counterpart to the access to the source code and rights to copy,
  modify and redistribute granted by the license, users are provided only
  with a limited warranty and the software's author, the holder of the
  economic rights, and the successive licensors have only limited liability.
 
  In this respect, the user's attention is drawn to the risks associated
  with loading, using, modifying and/or developing or reproducing the
  software by the user in light of its specific status of free software,
  that may mean that it is complicated to manipulate, and that also
  therefore means that it is reserved for developers and experienced
  professionals having in-depth computer knowledge. Users are therefore
  encouraged to load and test the software's suitability as regards their
  requirements in conditions enabling the security of their systems and/or
  data to be ensured and, more generally, to use and operate it in the
 same conditions as regards security.
 
  The fact that you are presently reading this means that you have had
  knowledge of the CeCILL-B license and that you accept its terms.
 



 
