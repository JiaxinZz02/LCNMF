function [U,V]=LCNMF(X,n,view_num,gnd,P,para,l)
C = length(unique(gnd)); %number of clusters
K_search = para.k;  
alpha = para.aplha;
beta  = para.beta;
maxiter = 100;

V_star = zeros(n-l,C);

for i = 1: view_num
    [Xiter{i},gnditer]=randpermData(X{i},gnd,C,n,l); 
    P_old = zeros(l,C);
    for ss = 1: C
        for cc = 1: l
            if gnditer(cc,1) == ss
                P_old(cc,ss) = 1;
            end
        end
    end
    I_S=eye(n-l);      
    P{i}=zeros(n,n-l+C);
    P{i}(1:l,1:C)=P_old;
    P{i}(l+1:end,C+1:end)=I_S;
    [~, W{i}, ~] = CAN(Xiter{i}, C, K_search);
    d=size(X{i},1);
    U{i}=abs(randn(d,C));
    Z{i} = abs(randn(n+C-l, C));
    V{i}=P{i}*Z{i};
    W{i} = refineW(W{i},l,C);
    A{i} = diag(sum(W{i},2)); 
    L{i} = A{i} - W{i};
end

sum_P = P{1};
for iter =1:maxiter
    for i = 1:view_num
    d=size(X{i},1);
    U{i} = U{i}.*(X{i}*P{i}*Z{i})./((U{i}*Z{i}'*P{i}')*P{i}*Z{i}+eps);
    P{i} = P{i}.*(X{i}'*U{i}*Z{i}'+alpha*W{i}*P{i}*Z{i}*Z{i}' + bate*sum_P)./...
        (P{i}*Z{i}*U{i}'*U{i}*Z{i}'+alpha*A{i}*P{i}*Z{i}*Z{i}'+...
        +bate*P{i}+eps);
    Z{i} = Z{i}.*((P{i}'*X{i}'*U{i}+alpha*P{i}'*W{i}*P{i}*Z{i})./...
        (((P{i}'*P{i}*Z{i}*U{i}')*U{i}+alpha*P{i}'*A{i}*P{i}*Z{i}+eps))); 
    V{i}=P{i}*Z{i};
    sum_P = update_sum(P,view_num,i);
    end
    obj_value = calculate_obj(X,U,P,Z,L,alpha,bate,view_num);
    obj(iter+1)=obj_value;
    fprintf("obj_value = %f, cost is = %f\n", obj_value, obj(iter+1)-obj(iter));
    
 end
gndnew=gnditer(l+1:end);
for i =1:view_num
    Vnew=V{i}(l+1:end,:);
    V_star = V_star + Vnew;
end
V_star = V_star / view_num;
V_star = NormalizeFea(V_star);
accuracy = eval_clustering_accuracy(V_star',gndnew,C,50)
end

end

function [obj_value] = calculate_obj(X,U,P,Z,L,alpha,beta,view_num)
obj_value = 0;
for i = 1:view_num
    sum_P = update_sum(P,view_num,i);
    obj_value=obj_value+sum(sum((X{i}-U{i}*Z{i}'*P{i}').^2))+...
    alpha*trace(Z{i}'*P{i}'*L{i}*P{i}*Z{i})+...
    beta*sum(sum((P{i}-sum_P).^2));
end
end



