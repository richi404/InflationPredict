clear;clc;
%prepare data
limit=220;
data=table2array(readtable('Dane/Gotowe/set1.csv'));
data2=table2array(readtable('Dane/Gotowe/set2.csv'));
data3=table2array(readtable('Dane/Gotowe/set3.csv'));
data4=table2array(readtable('Dane/Gotowe/set4.csv'));
data=data(1:limit,3:end);
output=data(1:limit-1,1);
data2=data2(1:limit,3:136);
data3=data3(1:limit,3:233);
data4=data4(1:limit,3:74);
data5=[data(2:limit,2:end),data2(2:limit,:),data3(2:limit,:),data4(2:limit,:)];
dataFinal=[output,data5];

rmse=ones(10);
for j=1:10
    %test set
    rows = limit-1;
    P = randperm(rows);
     
    % Getting the row wise randomly shuffled matrix
    dataFinal = dataFinal(P, : );
    testSet=dataFinal(1:44,:);
    trainSet=dataFinal(45:219,:);
    
    %learn network
    input=transpose(trainSet(:,2:end));
    output=transpose(trainSet(:,1));
    % % % y=input(1,:);
    % % % histogram(input(7,:));
    % % % plot(input(1,:), output, ".") 
    net = feedforwardnet([20,20]);
    net.divideParam.testRatio = 0;
    net.divideParam.valRatio = 0.2;
    % % net.trainParam.max_fail = 10;
    net = train(net,input,output);
    count=0;
    y=ones(44,3);
    testSet=transpose(testSet);
    for i=1:44
        y(i,1)=net(testSet(2:end,i));
        y(i,2)=testSet(1,i);
        y(i,3)=y(i,1)-y(i,2);
        count=count+y(i,3)*y(i,3);
    end
    rmse(j)=sqrt(count/44);
end
