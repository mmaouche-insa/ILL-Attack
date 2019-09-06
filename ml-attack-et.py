
from __future__ import print_function

import sys


import numpy as np
import pandas as pd
from sklearn import metrics
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.pipeline import make_pipeline
from tpot.builtins import ZeroCount


def printProgressBar (iteration, total, prefix = '', suffix = '', decimals = 1, length = 100, fill = u'\u2588'):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print('\r%s |%s| %s%% %s' % (prefix, bar, percent, suffix),end='\r')
    # Print New Line on Complete
    if iteration == total:
        print()


datafile = sys.argv[1]  # Train file
datafile2 = sys.argv[2] # Test file
name=datafile2.replace('.csv', '-Wprediction.csv')
if len(sys.argv) > 3:
    name=sys.argv[3]


df = pd.read_csv(datafile)#.fillna(0)
#print("Dataframe of Train: Read")
df2 = pd.read_csv(datafile2)
#print("Dataframe of Test: Read")

#ts1=
df.pop('timestamp')
ts2=df2.pop('timestamp')
#print("Timestamp poped")
#print(ts2)
y = df['IDs'].apply(lambda x: str(x).replace('-','_').split('_')[0]).values
y2 = df2['IDs'].apply(lambda x: str(x).replace('-','_').split('_')[0]).values


#print("IDs repaired and put into labels")

df.pop('IDs')
ids2=df2.pop('IDs')
#print(ids2)
#print("IDs poped")




## pour eliminer les columns dans Train qui sont en plus

#df = df.iloc[:,range(len(df2.columns))]
#df2 = df2.iloc[:,range(4)]
#print(len(df_test.columns))

## je prepare un df_commun pour les features communes et le reste on le rajoute dans le meme ordre

df_commun_columns = list(set(df.columns) & set(df2.columns))
df_Train_notTest = list(set(df.columns) - set(df_commun_columns))
df_Test_notTrain = list(set(df2.columns) - set(df_commun_columns))
df_union = list(set(df.columns) | set(df2.columns))

train = []
test = []


for c in df_union :
  if c in df.columns:
    # c in train
    train.append(df[c].values)
    #print("train size = "+str(len(df[c].values)))
  else:
    train.append(np.zeros(len(df.index)))
    #print("train size = "+str(len(np.zeros(len(df.index)))))
  if c in df2.columns:
    # c in test
    test.append(df2[c].values)
    #print("test size = "+str(len(df2[c].values)))
  else:
    test.append(np.zeros(len(df2.index)))
    #print("test size = "+str(len(np.zeros(len(df2.index)))))


x = np.array(train).T
#print("shape of train = "+str(x.shape))
#print(x)
x2 = np.array(test).T
#print("shape of test = "+str(x2.shape))

training_features, training_target = x, y
testing_features, testing_target  = x2, y2
#print("Dataset splitted len(train)="+str(len(training_features))+" len(test)="+str(len(testing_target)))



#exported_pipeline = LogisticRegression(C=25, dual=False, penalty="l1")
exported_pipeline = make_pipeline(
    ZeroCount(),
    ExtraTreesClassifier(bootstrap=False, criterion="gini", max_features=0.6, min_samples_leaf=2, min_samples_split=8, n_estimators=100)
)

exported_pipeline.fit(training_features, training_target)
#print("Train done")

y_pred_class = exported_pipeline.predict(testing_features)
y_test = testing_target
#print("Testing done")
#print(y_test)
#print(y_pred_class)
y_pred_proba = exported_pipeline.predict_proba(testing_features)
#print(y_pred_proba)
#print("Accuracy")
print(metrics.accuracy_score(y_test, y_pred_class))

#confusion = metrics.confusion_matrix(y_test, y_pred_class)
#print("confusion_matrix len(confusion)="+str(len(confusion)))
#print(confusion)
dfOut=pd.DataFrame({"IDs":y_test,"name": ids2,"predictions":y_pred_class,"timestamp":ts2,'hourOfDay':df2['hourOfDay'],'total':df2['total'],'centerLat':df2['centerLat'],'centerLng':df2['centerLng']})


dfOut.to_csv(name,index=False)







