%Scrip principal, chamada do Algortimo Genético para resolução do problema
%multi objetivo
clc
clear

cd ('C:\Users\Francisco\Documents\MESTRADO PPE\DISSERTAÇÃO\Planilhas\PDE 2024\MATLAB');
fitness = @INJECAO_MOEA_01;
populationSize = 100;
stallGenLimit = 200;
generations = 200;
nvar = 2;
Lb = zeros(1,nvar);
Ub = 300*ones(1,nvar);
% Ub(1,2) = 3;
Bound = [Lb; Ub];
aux = speye((nvar/2),(nvar/2));
A = sparse([-aux aux; -ones(1,nvar/2) zeros(1,nvar/2)]);
b = zeros(((nvar/2)+1),1);
IntCon = 1:2;
tic
options = gaoptimset('PopulationSize',populationSize,...
    'StallGenLimit',stallGenLimit,...
    'Generations',generations,...
    'TolFun',1e-3,...
    'Display','iter',...
    'ParetoFraction',0.5,...
    'UseParallel',true,...,
    'CreationFcn', @int_pop,...
    'CrossoverFcn',@int_crossoverarithmetic,...
    'PopInitRange',Bound,...,
    'PopulationType','doubleVector',...
    'MutationFcn',@int_mutationuniform,...
    'PlotFcn',@gaplotpareto);

[xf,fval,exitflag] = gamultiobj(fitness,nvar,A,b,[],[],Lb,Ub,options);

toc

fh1 = figure;
scatter(fval(:, 1), fval(:, 2), 'fill');
hold all
xlabel ('Custo Nivelado de Produção ($/kgH2)');
ylabel ('Curtailment (GWh)');
grid on;
title('Fronteira de Pareto');

save('C:/Users/Francisco/Documents/MESTRADO PPE/DISSERTAÇÃO/Planilhas/PDE 2024/MATLAB/Resultados/RESULTADO.mat')
