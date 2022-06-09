clear;clc;
mutatProb=0.001;
population=zeros([20,100]);
for i=1:20
    population(i,:)=randperm(464,100);
end

% fgh=zeros(1000);
fgh=0;
% for u=1:1000
while fgh<30000
    %ewaluacja
    evalArray=zeros([20,1]);
    for i=1:20
        evalArray(i)=sum(population(i,:));
    end
    fgh=max(evalArray);
    disp(fgh)
    evalArray=evalArray/sum(evalArray);
    
    %selekcja
    copyArray=population;
    for v=1:20
        ball=rand;
        i=1;
        while ball>0
            ball=ball-evalArray(i);
            i=i+1;
        end
        copyArray(v)=population(i);
    end
    %cross
    for k=1:10
        b=copyArray(1+2*(k-1),:);
        c=copyArray(2*k,:);
        locus=randi([1,100],1);
%         tmp=b(locus);
%         b(locus)=c(locus);
%         c(locus)=tmp;
%         population(1+2*(k-1),:)=b;
%         population(2*k,:)=c;

        population(1+2*(k-1),:)=[b(1:locus),c(locus+1:end)];
        population(2*k,:)=[c(1:locus),b(locus+1:end)];
    end
    %mutacja
    for v=1:20
        for i=1:100
            if(rand<mutatProb)
                f=randi([1,464],1);
                while sum(b==f)
                    f=randi([1,464],1);
                end
                b(i)=f;
            end
        end
    end
end

plot(fgh);