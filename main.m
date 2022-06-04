clear;clc;
limit=343;
data=table2array(readtable('Dane/Gotowe/set1.csv'));
data2=table2array(readtable('Dane/Gotowe/set2.csv'));
data=data(1:limit,3:7);
data2=data2(1:limit,3:7);
output=transpose(data(2:limit-1,1));
data=[data(3:limit,:),data2(3:limit,:)];
% data=data(3:limit,:);
input=transpose(data);
% y=input(1,:);
% histogram(input(7,:))56
% plot(input(1,:), output, ".") 
net = feedforwardnet([20,20]);
net.divideParam.testRatio = 0.125;
net.divideParam.valRatio = 0.125;
net.trainParam.max_fail = 10;
net = train(net,input,output);
y=net(input(:,1));