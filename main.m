clear;clc;
limit=220;
data=table2array(readtable('Dane/Gotowe/set1.csv'));
data=data(1:220,3:29);
output=transpose(data(:,1));
input=transpose(data(:,2:27));
net = feedforwardnet(10);
net.trainParam.max_fail = 10;
net = train(net,input,output);