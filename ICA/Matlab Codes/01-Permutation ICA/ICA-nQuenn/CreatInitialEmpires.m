function emp=CreatInitialEmpires()

global ProblemSettings;
CostFunction=ProblemSettings.CostFunction;
VarSize=ProblemSettings.VarSize;
VarMin=ProblemSettings.VarMin;
VarMax=ProblemSettings.VarMax;

global ICASettings;
nPop=ICASettings.nPop;
nEmp=ICASettings.nEmp;
nCol=nPop-nEmp;
alpha=ICASettings.alpha;

%%
% Create Countries
empty_country.Position=[];
empty_country.Cost=[];
empty_country.Sol=[];
country=repmat(empty_country,nPop,1);

for i=1:nPop  
    country(i).Position=unifrnd(VarMin,VarMax,VarSize);
    [country(i).Cost,country(i).Sol]=CostFunction(country(i).Position);
end

costs=[country.Cost];
[~, SortOrder]=sort(costs);
country=country(SortOrder);

% Imperialists and Colonies
imp=country(1:nEmp);
col=country(nEmp+1:end);

empty_empire.Imp=[];
empty_empire.Col=repmat(empty_country,0,1);
empty_empire.nCol=0;
empty_empire.TotalCost=[];
emp=repmat(empty_empire,nEmp,1);

% Assign Imperialists
for k=1:nEmp
    emp(k).Imp=imp(k);
end

% Assign Colonies
P=exp(-alpha*[imp.Cost]/max([imp.Cost]));
P=P/sum(P);
for j=1:nCol   
    k=RouletteWheelSelection(P);  
    emp(k).Col=[emp(k).Col; col(j)];
    emp(k).nCol=emp(k).nCol+1;
end

emp=UpdateTotalCost(emp);

end