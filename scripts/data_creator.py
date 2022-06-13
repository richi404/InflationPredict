import pandas as pd

def create_csv():
    result = pd.read_excel('_koniunktura-budownictwo-ogolnopolska-miesiac.xlsx', sheet_name=0)
    for i in range(1, 21):
        df = pd.read_excel('_koniunktura-budownictwo-ogolnopolska-miesiac.xlsx', sheet_name=i)
        result = pd.merge(result, df, left_on=['rok', 'miesiąc'], right_on=['rok', 'miesiąc'], how='left')

    #print(result)

    result.to_csv("set4.csv", sep=';', index=False, header=False)


def check_files():
    files = ['data1.csv', 'data2.csv', 'data3.csv', 'set4.csv']

    dataframes = []
    for f in files:
        dataframes.append(pd.read_csv(f, sep = ';'))
    result = pd.concat(dataframes)
    #print(result)
    #result[is_duplicated] = result.duplicated()

    result = result.transpose()
    print(result)
    result.to_csv("check.csv")
    #result.duplicated().to_csv("duplikaty.csv")


if __name__ == '__main__':
    check_files()

