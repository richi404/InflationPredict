clear;clc;
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
average=mean(dataFinal,1);
for i=1:464
    dataFinal(:,i)=dataFinal(:,i)-average(i);
end
tic;

mutatProb=0.01;
pcros=0.1;
lenpop=20;
popsize=20;
maxfind=zeros([1,lenpop]);
maxvalue=0;
population=zeros([popsize,lenpop]);
for i=1:popsize
    population(i,:)=randperm(463,lenpop)+1;
end

fgh=zeros(1000);
for u=1:1000
    %ewaluacja
    evalArray=zeros([popsize,1]);
    for i=1:popsize
        rmse=ones(5);
        for j=1:5
            %test set
            rows = limit-1;
            P = randperm(rows);
             
            % Getting the row wise randomly shuffled matrix
            dataFinal = dataFinal(P, : );
            testSet=dataFinal(1:44,:);
            trainSet=dataFinal(45:219,:);
            
            %learn network
            input=transpose(trainSet(:,population(i,:)));
            output=transpose(trainSet(:,1));
            net = feedforwardnet([10,10]);
            net.trainParam.showWindow = 0;
            net.divideParam.testRatio = 0;
            net.divideParam.valRatio = 0.2;
            net = train(net,input,output);
            count=0;
            y=ones(44,3);
            testSet=transpose(testSet);
            for ii=1:44
                y(ii,1)=net(testSet(population(i,:),ii));
                y(ii,2)=testSet(1,ii);
                y(ii,3)=y(ii,1)-y(ii,2);
                count=count+y(ii,3)*y(ii,3);
            end
            rmse(j)=sqrt(count/44);
        end
        evalArray(i)=mean(rmse(:,1));
    end
    fgh(u)=mean(evalArray);
    [tmp,idx]=max(evalArray);
    if tmp>maxvalue
        maxvalue=tmp;
        maxfind=population(idx,:);
    end
    disp(fgh(u))
    evalArray=1-evalArray/sum(evalArray);
    %selekcja
    copyArray=population;
    for v=1:popsize
        ball=rand;
        i=1;
        while ball>0
            ball=ball-evalArray(i);
            i=i+1;
        end
        copyArray(v)=population(i);
    end
    %cross
    for k=1:popsize/2
        if rand<pcros
            b=copyArray(1+2*(k-1),:);
            c=copyArray(2*k,:);
            locus=randi([1,lenpop],1);
            population(1+2*(k-1),:)=[b(1:locus),c(locus+1:end)];
            population(2*k,:)=[c(1:locus),b(locus+1:end)];
        end
    end
    %mutacja
    for v=1:popsize
        for i=1:lenpop
            if(rand<mutatProb)
                f=randi([2,464],1);
                while sum(population(v)==f)
                    f=randi([2,464],1);
                end
                population(v,i)=f;
            end
        end
    end
end
toc;
plot(fgh);