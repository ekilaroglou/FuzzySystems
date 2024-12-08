function fis = Generate_FIS(D_trn,randii,class_dependent,classes)

if (class_dependent ~= 1)
    opt = genfisOptions('SubtractiveClustering',...
                    'ClusterInfluenceRange',randii);
    fis = genfis(D_trn(:,1:end-1), D_trn(:,end),opt);
    
    for i=1:length(fis.output.mf)
        fis.output.mf(i).type = 'constant';
        % the last parameter is the one not depended from inputs
        fis.output.mf(i).params = fis.output.mf(i).params(end);
    end
else 
    % Get Number of Classes
    Number_of_classes = length(classes);
    
    % Manually create fis
    for i=1:Number_of_classes
        [c{i},sig{i}]=subclust(D_trn(D_trn(:,end)==classes(i),:),randii);
    end
    num_rules = 0;
    for i=1:length(c)
        num_rules = num_rules + size(c{i},1);
    end
    
    %Build FIS From Scratch
    fis=newfis('FIS_SC','sugeno');

    %Add Input-Output Variables
    for i=1:size(D_trn,2)-1
        min_value = min(D_trn(:,i));
        max_value = max(D_trn(:,i));
        fis=addvar(fis,'input',strcat('in',num2str(i)),[min_value max_value]);
    end
    min_value = min(D_trn(:,end));
    max_value = max(D_trn(:,end));
    fis=addvar(fis,'output','out1',[min_value max_value]);


    %Add Input Membership Functions
    for i=1:size(D_trn,2)-1
        mf_number = 1;
        for p=1:length(c)
            for j=1:size(c{p},1)
                name = strcat('in',num2str(i),'mf',num2str(mf_number));
                fis=addmf(fis,'input',i,name,'gaussmf',[sig{p}(i) c{p}(j,i)]);
                mf_number = mf_number + 1;
            end
        end
    end

    %Add Output Membership Functions
    params = [];
    for p=1:length(c)
        class_p_params = classes(p)*ones(1,size(c{p},1));
        params = [params class_p_params];
    end
    for i=1:num_rules
        fis=addmf(fis,'output',1,name,'constant',params(i));
    end
    
    %Add FIS Rule Base
    ruleList=zeros(num_rules,size(D_trn,2));
    for i=1:size(ruleList,1)
        ruleList(i,:)=i;
    end
    ruleList=[ruleList ones(num_rules,2)];
    fis=addrule(fis,ruleList);
end

end

