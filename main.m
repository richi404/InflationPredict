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
%0.7705
 best=[52,407,361,236,55,369,67,359,392,256,141,235,314,68,346,296,121,395,140,268,65,355,288,329,57,356,159,331,181,382,459,295,187,458,261,444,86,425,139,370,323,27,428,40,438,396,94,350,157,15,410,264,239,460,200,415,110,203,81,233,206,325,463,246,39,78,198,19,411,391,135,44,79,170,414,452,290,291,30,7,84,112,408,442,197,443,433,223,308,217,59,221,85,3,216,421,358,274,247,299,92,403,298,165,386,47,338,169,101,69,367,400,384,202,284,6,427,191,451,96,26,149,464,161,88,240,229,73,139,333,330,274,435,421,112,62,278,275,98,165,459,19,380,298,228,103,376,146,366,140,340,130,150,41,86,163,273,447,347,311,431,395,3,257,145,402,65,173,245,179,326,425,398,126,217,367,170,440,124,87,99,249,400,45,181,132,209,234,374,89,201,224,409,157,307,204,67,127,46,334];
% best=[178,331,385,362,10,240,434,402,3,71,334,348,381,62,56,284,248,126,368,329,420,367,399,110,45,105,27,329,300,381,140,161,263,86,23,116,234,86,428,33,112,73,247,369,433,123,210,369,455,36,419,262,108,69,107,379,207,98,269,180,20,273,104,30,236,129,217,310,429,2,225,54,362,346,125,33,128,91,223,395,72,73,301,226,335,249,258,230,62,342,	383,114	,270,285,99	,309,356,244,138,437];
%       best=[148,317,283,269,234,318,437,395,187,65,58,281,39,38,363,173,159,434,182,190,407,70,386,19,55,403,23,128,364,70,3,408,51,392,33,208,89,258,403,397,397,336,190,183,69,189,366,37,311,347,9,117,192,458,305,377,453,225,352,419,16,56,443,24,224,243,401,44,375,372,261,75,156,315,334,176,142,227,430,424,413,162,387,31,108,70,241,255,161,18,398,166,451,87,445,444,168,102,73,312];
    input=transpose(trainSet(:,best));
    output=transpose(trainSet(:,1));
    net = feedforwardnet([10,10,10]);
%     net.trainParam.showWindow = 0;
    net.divideParam.testRatio = 0;
    net.divideParam.valRatio = 0.2;
    net.layers{1}.transferFcn="tansig";
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
