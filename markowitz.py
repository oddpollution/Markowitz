import numpy as np
import pandas as pd
import statistics
import math
from dplython import select, DplyFrame, X, arrange, count, sift, head, summarize, group_by, tail, mutate

def Average(lst):
    return sum(lst) / len(lst)

a = [0.51,
       0.75,
       1.25,
       0.66,
       0.71,
       0.47,
       0.89,
       1.51,
       1.36,
       0.94,
       -0.17,
       1.38,
       0.05,
       -0.08,
       0.03,
       0.39,
       0.44,
       0.26,
       0.42,
       0.26,
       0.51,
       -0.46,
       1.69,
       0.72,
       0.41,
       0.29,
       -0.63,
       0.17,
       0.8,
       0.54,
       0.72,
       0.16,
       -0.26,
       0.1,
       0.39,
       0.72]

b = [-1.15,
       0.38,
       3.18,
       0.63,
       0.47,
       -0.13,
       -1.17,
       1.79,
       1.01,
       0.94,
       -1.11,
       -0.5,
       -1.33,
       -0.85,
       -0.88,
       1.36,
       0.79,
       0.25,
       0.2,
       -1.35,
       -0.33,
       -4.52,
       4.68,
       0.46,
       0.43,
       0.28,
       -7.1,
       0.85,
       1.08,
       1.97,
       5.06,
       -1.53,
       -2.59,
       0.94,
       1.75,
       5.26]

c = [0.83,
       0.86,
       1.05,
       0.89,
       1.07,
       1.08,
       1.07,
       1.23,
       1.15,
       1.12,
       1.09,
       0.97,
       0.22,
       0.28,
       0.41,
       0.45,
       0.51,
       0.54,
       0.54,
       0.58,
       0.68,
       0.73,
       0.58,
       0.78,
       0.39,
       0.22,
       -1.81,
       -0.94,
       0.43,
       0.51,
       0.88,
       0.48,
       0.37,
       1,
       0.48,
       0.55]

fullbase = np.transpose(pd.DataFrame([a,b,c]))

ListAVG = []

i=0

for i in range(len(fullbase.columns)):
    ListAVG.append(Average(fullbase[i]))

ListAVG = pd.DataFrame(ListAVG)

ListVAR = []

i=0

for i in range(len(fullbase.columns)):
    ListVAR.append(statistics.variance(fullbase[i]))

ListVAR = pd.DataFrame(ListVAR)

corMatrix = fullbase.corr()

corMatrix = pd.DataFrame(corMatrix)

print(corMatrix)

row1 = np.random.lognormal(0,1,len(fullbase.columns))

listWEIGHT = [row1/sum(row1)]

for i in range(9999):
    row1 = np.random.lognormal(0,1,len(fullbase.columns))
    listWEIGHT.append(row1/sum(row1))

listWEIGHT = pd.DataFrame(listWEIGHT)

invest_return = []
invest_return1 = []

invest_risk = []
invest_risk1 = []

for i in range(10000):
    for j in range(len(fullbase.columns)):

        invest_return1.append(listWEIGHT.iloc[i][j] * ListAVG.iloc[j][0])

        if j == len(fullbase.columns)-1:
            k = 0
        else:
            k = j

        if j < len(fullbase.columns)-1:
            m = j+1
        else:
            m = j
    
        invest_risk1.append((listWEIGHT.iloc[i][j])**2 * ListVAR.iloc[j][0] + 2 * listWEIGHT.iloc[i][k] * listWEIGHT.iloc[i][m] * (ListVAR.iloc[k][0])**(1/2) * (ListVAR.iloc[m][0])**(1/2) * corMatrix[k][m])
        print(invest_risk1)
    invest_return.append(sum(invest_return1))
    invest_risk.append(sum(invest_risk1))
    invest_return1 = []
    invest_risk1 = []

invest_return = DplyFrame(invest_return)
invest_risk = DplyFrame(invest_risk)
listWEIGHT = DplyFrame(listWEIGHT)

result = pd.DataFrame(pd.concat([invest_return.reset_index(drop=True), invest_risk, listWEIGHT], axis=1))

colname = ["retorno","risco"]

for i in range(len(fullbase.columns)):
    colname.append("w"+str(i))

colname = list(colname)

result.columns = colname

result = pd.DataFrame(DplyFrame(result) >> mutate(sharpe = (X.retorno-0.1375)/X.risco))

result = result.sort_values('sharpe', ascending=[False])
teste = arrange(DplyFrame(invest_return))

result.to_csv("resultado.csv", index=True, header=True)

