clear
clc
data = load('haberman.data');
preproc=1;
[D_trn,D_val,D_chk]=split_scale(data,preproc);

classes = [1 2];
randii = 0.5;
Number_of_classes = length(classes);

% sublust explaining:
% [centers,sigma] = subclust(___)
% c = centers is a MxN matrix where
% M is the number of clusters
% N is the number of variables 
% Each row of c represents a cluster center.
% The columns of a row is the coordinates
% of the center on each dimension.
% For example the first column is the dimension
% that the first variable exist.
% The sigma gives the influence of cluster centers
% for each dimension. For example sigma(1) is the radius
% in the first dimension.
% All sigma values make the randii (?not sure?)
% which means sum(sigma) is almost randii (?not sure?)
% Sigma is an 1xN array because all claster centers
% have the same set of sigma values. Which means
% the radius of the centers in a given dimension
% is always the same.

% for each class:
% get the centers and the sigma values
% here c{i} are the cluster centers of the i class
% i class is the i_th class and not the the class
% on which the output y takes the value i
for i=1:Number_of_classes
    [c{i},sig{i}]=subclust(D_trn(D_trn(:,end)==classes(i),:),randii);
end

% The fuzzy system, fis, contains one fuzzy rule for each cluster.
% (matlab sublust documentation -> Tips -> 3)
% So to get the number of rules we just need to get
% the number of all the clusters in each class
num_rules = 0;
for i=1:length(c)
    num_rules = num_rules + size(c{i},1);
end

% Build FIS From Scratch
fis=newfis('FIS_SC','sugeno');

% Add Input-Output Variables
for i=1:size(D_trn,2)-1
    fis=addvar(fis,'input',strcat('in',num2str(i)),[0 1]);
end
fis=addvar(fis,'output','out1',[0 1]);

% Each input and output variable has 
% one membership function per cluster
% (matlab sublust documentation -> Tips -> 3)

% Add Input Membership Functions
% explaining of
% fis=addmf(fis,'input',i,name,'gaussmf',[sig1(i) c{p}(j,i)]);
% - The first 2 arguments it's simple. We want to
% add an mf to an input variable of the given fis.
% - i is the i_th input variable
% ndices are applied to variables in the order in 
% which they are added. Therefore, the first input
% variable added to a system is always known as input 
% variable number one for that system. Input and
% output variables are numbered independently.
% That means that since we put the variables with
% the order that they appear in our data, if we make
% a for loop with the same order then we know that
% the i_th number of the for loop, in other words
% the i_th variable of the dataset, is actually sthe
% i_th variable of the fis. (That's about input
% variables since input and output variables
% are numbered independently).
% - name is the name of the mf 
% - gaussmf is the type of the mf
% - the last argument is the parameters
% gaussmf accepts 2 types of parameters:
% The second parameter is the center of the
% gaussian function. The first parameter is the
% sigma of the gaussian function. The sigma shows
% "how far away" the gaussian function goes.
% The points c+sigma and c-sigma are the points
% on which the gaussian function is almost half
% (σημείο τομής). And that's because it gives the 
% value of e^(-0.5) = 0.6

% That being said it's obvious that for a given
% variable i and a given cluster, the center of
% the gaussmf should be equal to the coordinate 
% of the center of that cluster in the dimension 
% of the i_th variable. So if we want to access
% the j_th cluster of a the p_th class then the
% center of the gaussmf will be c(j,i). 
% (j row is the j_th cluster, while i_th column
% is the coordinates of the clusters in the
% dimension of the i_th variable)

% Also the sigma parameter of the gaussmf takes
% the value of sig(i). That's because we want
% the gaussmf to take big values (over 0.5
% (but in reality over 0.6)) in the range of the
% "cluster influence range".

for i=1:size(D_trn,2)-1
    mf_number = 1;
    % for each class
    % (we could also loop as
    % 'for i=1:Number_of_classes'
    % since length(c) = Number_of_classes)
    for p=1:length(c)
        % for each cluster of the p_th class
        for j=1:size(c{p},1)
            name = strcat('in',num2str(i),'mf',num2str(mf_number));
            fis=addmf(fis,'input',i,name,'gaussmf',[sig{p}(i) c{p}(j,i)]);
            mf_number = mf_number + 1;
        end
    end
end

% Add Output Membership Functions
% As mentioned earlier output variable has 
% one membership function per cluster. Also the
% total number of clusters is the number of rules.
% Here the mf type is constant and we want for each
% cluster the constant value to be equal to the
% value of the cluster's class. For example
% if the cluster belongs to the second class and
% the second class is the class that y = 5 then
% we want constant value = 5.
% That being said for each class (for length(c))
% we add size(c{p},1)
% (number of clusters of the p_th class)
% with height/value of classes(p)

params = [];
for p=1:length(c)
    class_p_params = classes(p)*ones(1,size(c{p},1));
    params = [params class_p_params];
end

% Now that we have the parameters set. Add the MFs
for i=1:num_rules
    fis=addmf(fis,'output',1,name,'constant',params(i));
end


% Add FIS Rule Base
% help addrule --> documentantion explains very
% well what happens here.
% - Here the i_th rule contains the i_th mf
% of all inputs and the i_th mf of output.
% That's because for a specific cluster i
% we want a rule that says that if we are
% in the range of influence of the center of
% i_th cluster then the output should have 
% value the value of the class of the cluster i:
% - Hypothesis: being in the range of influence
% of the center i_th cluster:
% for each input k we should be in c(i,k)
% with a range of sig(k). That's represented 
% by the i_th mf (see the explanation of gaussmf
% above).
% - Conclusion: To check why i_th mf of output 
% has the value of the class of the cluster i,
% see above adding output membership functions.
% - The last 2 columns being ones means that
% the rules have a weight of one and that the
% the fuzzy operator for the rule's antecedent 
% is AND.
ruleList=zeros(num_rules,size(D_trn,2));
for i=1:size(ruleList,1)
    ruleList(i,:)=i;
end
ruleList=[ruleList ones(num_rules,2)];
fis=addrule(fis,ruleList);