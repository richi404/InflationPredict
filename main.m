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
tic;
average=mean(dataFinal,1);
for i=1:464
    dataFinal(:,i)=dataFinal(:,i)-average(i);
end

rmse=ones([10,1]);
for j=1:10
    %test set
    rows = limit-1;
    P = randperm(rows);
     
    % Getting the row wise randomly shuffled matrix
    dataFinal = dataFinal(P, : );
    testSet=dataFinal(1:44,:);
    trainSet=dataFinal(45:219,:);
    
    %learn network
%     0.7886 
% 0.769868523663377
% 178	331	385	362	10	240	434	402	3	71	334	348	381	62	56	284	248	126	368	329	420	367	399	110	45	105	27	329	300	381	140	161	263	86	23	116	234	86	428	33	112	73	247	369	433	123	210	369	455	36	419	262	108	69	107	379	207	98	269	180	20	273	104	30	236	129	217	310	429	2	225	54	362	346	125	33	128	91	223	395	72	73	301	226	335	249	258	230	62	342	383	114	270	285	99	309	356	244	138	437
% [148,317,283,269,234,318,437,395,187,65,58,281,39,38,363,173,159,434,182,190,407,70,386,19,55,403,23,128,364,70,3,408,51,392,33,208,89,258,403,397,397,336,190,183,69,189,366,37,311,347,9,117,192,458,305,377,453,225,352,419,16,56,443,24,224,243,401,44,375,372,261,75,156,315,334,176,142,227,430,424,413,162,387,31,108,70,241,255,161,18,398,166,451,87,445,444,168,102,73,312]
     best=[178,331,385,362,10,240,434,402,3,71,334,348,381,62,56,284,248,126,368,329,420,367,399,110,45,105,27,329,300,381,140,161,263,86,23,116,234,86,428,33,112,73,247,369,433,123,210,369,455,36,419,262,108,69,107,379,207,98,269,180,20,273,104,30,236,129,217,310,429,2,225,54,362,346,125,33,128,91,223,395,72,73,301,226,335,249,258,230,62,342,	383,114	,270,285,99	,309,356,244,138,437];
%     best=[148,317,283,269,234,318,437,395,187,65,58,281,39,38,363,173,159,434,182,190,407,70,386,19,55,403,23,128,364,70,3,408,51,392,33,208,89,258,403,397,397,336,190,183,69,189,366,37,311,347,9,117,192,458,305,377,453,225,352,419,16,56,443,24,224,243,401,44,375,372,261,75,156,315,334,176,142,227,430,424,413,162,387,31,108,70,241,255,161,18,398,166,451,87,445,444,168,102,73,312];
    input=transpose(trainSet(:,best));
    output=transpose(trainSet(:,1));
    % % % y=input(1,:);
    % % % histogram(input(7,:));
    % % % plot(input(1,:), output, ".") 
    net = feedforwardnet([10,10]);
%     net.trainParam.showWindow = 0;
    net.divideParam.testRatio = 0;
    net.divideParam.valRatio = 0.2;
    % % net.trainParam.max_fail = 10;
    net = train(net,input,output);
    count=0;
    y=ones(44,3);
    testSet=transpose(testSet);
    for i=1:44
        y(i,1)=net(testSet(best,i));
        y(i,2)=testSet(1,i);
        y(i,3)=y(i,1)-y(i,2);
        count=count+y(i,3)*y(i,3);
    end
    rmse(j)=sqrt(count/44);
end
toc;
