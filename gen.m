clear;clc;
mutatProb=0.01;
pcros=0.1;
lenpop=20;
popsize=100;
maxfind=zeros([1,lenpop]);
maxvalue=0;
population=zeros([popsize,lenpop]);
for i=1:popsize
    population(i,:)=randperm(463,lenpop)+1;
end

fgh=zeros(1000);
% fgh=0;
for u=1:1000
% while fgh<30000
    %ewaluacja
    evalArray=zeros([popsize,1]);
    for i=1:popsize
        evalArray(i)=sum(population(i,:))^10;
    end
    fgh(u)=mean(evalArray.^(1/10));
    [tmp,idx]=max(evalArray.^(1/10));
    if tmp>maxvalue
        maxvalue=tmp;
        maxfind=population(idx,:);
    end
    evalArray=evalArray/sum(evalArray);
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
    
%             tmp=b(locus);
%             b(locus)=c(locus);
%             c(locus)=tmp;
%             population(1+2*(k-1),:)=b;
%             population(2*k,:)=c;
        end
    end
    %mutacja
    for v=1:popsize
        for i=1:lenpop
            if(rand<mutatProb)
                f=randi([2,464],1);
                while sum(population(v)==f)
                    f=randi([1,464],1);
                end
                population(v,i)=f;
            end
        end
    end
end

plot(fgh);