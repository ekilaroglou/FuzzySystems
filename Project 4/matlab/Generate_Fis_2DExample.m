%% Code Example of 2 dimension
% The code here is the code that's followed
% to create the Generate_Fis_Explanation.
% It's more simple without loops for each class.
% The number of classes is 2.

%%  Manually create fis
[c1,sig1]=subclust(D_trn(D_trn(:,end)==1,:),randii);
[c2,sig2]=subclust(D_trn(D_trn(:,end)==2,:),randii);
num_rules=size(c1,1)+size(c2,1);

%% Build FIS From Scratch
fis=newfis('FIS_SC','sugeno');

%% Add Input-Output Variables
for i=1:size(D_trn,2)-1
    fis=addvar(fis,'input',strcat('in',num2str(i)),[0 1]);
end
fis=addvar(fis,'output','out1',[0 1]);


%% Add Input Membership Functions
name='sth';
for i=1:size(D_trn,2)-1
    for j=1:size(c1,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig1(i) c1(j,i)]);
    end
    for j=1:size(c2,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig2(i) c2(j,i)]);
    end
end

%% Add Output Membership Functions
params=[zeros(1,size(c1,1)) ones(1,size(c2,1))];
for i=1:num_rules
    fis=addmf(fis,'output',1,name,'constant',params(i));
end
%% Add FIS Rule Base
ruleList=zeros(num_rules,size(D_trn,2));
for i=1:size(ruleList,1)
    ruleList(i,:)=i;
end
ruleList=[ruleList ones(num_rules,2)];
fis=addrule(fis,ruleList);