%% Inicializacao

function [y1 y2]= ESCRAVO_MOEA_01(X,PORCENTAGEM_CURTAILMENT);
cd ('C:\Users\Francisco\Documents\MESTRADO PPE\DISSERTAÇÃO\Planilhas\PDE 2024\MATLAB');
PORCENTAGEM_CURTAILMENT = 1;
excDisp = ImportaDados(importdata('Resultados.txt'));
Eficiencia = 0.7;
PCS = 0.0898*39.40; %Em kWh/Nm3
excDisp = (Eficiencia * excDisp); %Em MWh
excDisp = PORCENTAGEM_CURTAILMENT * excDisp; 
Janeiro = excDisp(1:length(excDisp)/12);
Fevereiro = excDisp((length(excDisp)/12)+1:2*(length(excDisp)/12));
Marco = excDisp(2*(length(excDisp)/12)+1:3*(length(excDisp)/12));
Abril = excDisp(3*(length(excDisp)/12)+1:4*(length(excDisp)/12));
Maio = excDisp(4*(length(excDisp)/12)+1:5*(length(excDisp)/12));
Junho = excDisp(5*(length(excDisp)/12)+1:6*(length(excDisp)/12));
Julho = excDisp(6*(length(excDisp)/12)+1:7*(length(excDisp)/12));
Agosto = excDisp(7*(length(excDisp)/12)+1:8*(length(excDisp)/12));
Setembro = excDisp(8*(length(excDisp)/12)+1:9*(length(excDisp)/12));
Outubro = excDisp(9*(length(excDisp)/12)+1:10*(length(excDisp)/12));
Novembro = excDisp(10*(length(excDisp)/12)+1:11*(length(excDisp)/12));
Dezembro = excDisp(11*(length(excDisp)/12)+1:12*(length(excDisp)/12));
T = length(Janeiro); %Número de períodos (12*24)
N = 1; % Número de unidades de eletrólise
RGN = ResHHV';
RestricoesGasoduto = repmat(RGN(11),1,T);

%%%%%%%%%%%%%%%DEFINIÇÃO DE ALGUNS PARÂMETROS DE CUSTO%%%%%%%%%%%%%%%%%%%%%

% % Existem (26*288) restrições de capacidade de produção e armazenamento e (13*288) restrições de injeção
% Alocando uma matriz esparsa para as restrições de desigualdade. O número
% de linhas é igual ao número de restrições e o número de colunas igual ao
% número de variáveis de decisão

capProducao = X(1);
capProducao = (Eficiencia * capProducao); %Em MWh
capProducaoRestricao = repmat(capProducao,1,T);
capProducaoRestricao = capProducaoRestricao';
capProducaoRestricao = capProducaoRestricao(:);
capArmazenamento = X(2);
capArmazenamento = (capArmazenamento); %EM MWhcap
capArmazenamentoRestricao = repmat(capArmazenamento,1,T);
capArmazenamentoRestricao = capArmazenamentoRestricao';
capArmazenamentoRestricao = capArmazenamentoRestricao(:);
RestricoesGasoduto = RestricoesGasoduto'; %Em MWh
RestricoesGasoduto = RestricoesGasoduto(:);
CustoEletricidade = 57; %US$/MWh
demandaEletrica = 1.42; % MWh de eletricidade / MWh de hidrogênio
PMOA = 98.1;
CPU = CustoEletricidade * demandaEletrica; %Custo de Produção Unitário (US$/milhao Nm3)
CSU = 1000; %Custo de Storage Unitário
CIU = CustoEletricidade * CompressaoHidrogenio(30,PMOA,1); %Custo de Injeção Unitário

%% Função Objetivo sem utilização de SYMBOLIC MATH TOOLBOX
%%%%%%%%%%%%%%%%JANEIRO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Para a produção
obj1 = zeros(N,T);
obj2 = zeros(N,T);
obj3 = zeros(N,T);
% obj4 = zeros(N,T);
% obj5 = zeros(N,T);
% obj6 = zeros(N,T);
% obj7 = zeros(N,T);
% obj8 = zeros(N,T);

for ii=1:N
    for jj=1:T
        obj1(ii,jj) = CPU;
    end
end

% Para o armazenamento
for ii=1:N
    for jj=1:T
        obj2(ii,jj) = CSU;
    end
end

% Para a injeção
for ii=1:N
    for jj=1:T
        obj3(ii,jj) = CIU(ii);
    end
end

% % Para o Start-up (Yjk)
% for ii=1:N
%     for jj=1:T
%         obj4(ii,jj) = SUC;
%     end
% end
% 
% % Para o Shut-Down (Zjk)
% for ii=1:N
%     for jj=1:T
%         obj5(ii,jj) = SDC;
%     end
% end
% 
% % Variável que modela o Start-up: Transição de um estado off para um estado
% % on da geração de hidrogênio eletrolítico (Vjk)
% 
% for ii=1:N
%     for jj=1:T
%         obj6(ii,jj) = 0;
%     end
% end
% 
% for ii=1:N
%     for jj=1:T
%         obj7(ii,jj) = PUT;
%     end
% end
% for ii=1:N
%     for jj=1:T
%         obj8(ii,jj) = GET;
%     end
% end

funcaoObjetivo = [obj1(:); obj2(:); obj3(:)];
%% Restrições de Capacidade de Producao/Armazenamento e de Injeção

Aineq = speye(3*T*N,3*T*N); % Restrições de producao, armazenamento e injeção

% Parte do código referente à construção da matriz de restrições de
% desigualdade. A montagem aqui obedece a restrição de SUM(Xn,t - Yt*Cap <=
% 0)

% auxProducaoMaximo = -sparse(diag(capProducaoRestricao,0));
% auxProducaoMaximo = [zeros(T*N,2*T*N) auxProducaoMaximo];
% auxProducaoMaximo = sparse([auxProducaoMaximo; zeros(2*T*N, 3*T*N)]);
% Aineq = sparse([Aineq auxProducaoMaximo]);
% 
% auxProducaoMinimo = sparse(0.05*diag(capProducaoRestricao,0));
% auxProducaoMinimo = [-speye(T*N,T*N) zeros(T*N,4*T*N) auxProducaoMinimo];
% Aineq = sparse ([Aineq; auxProducaoMinimo]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Restrições de Capacidade de Producao

bineq = zeros(3*N*T,1);
for ii=1:N*T
    bineq(ii,1) = capProducaoRestricao(ii);
end

% Restrições de Capacidade de Armazenamento

for ii=(N*T+1):2*N*T
    bineq(ii,1) = capArmazenamentoRestricao(ii - N*T);
end

% Restrições de Injeção Direta

for ii=(2*N*T + 1):3*N*T
    bineq(ii,1) = RestricoesGasoduto(ii - 2*N*T);
end


% for ii=(39*T + 1):52*T
%     bineq(ii,1) = 0;
% end
% 
% 
% Restricao que impede de a produção ser nula em todos os instantes de
% tempo



% INJETABILIDADE
% 1 MWh ---> 0,000282596 milhão de Nm3
% 1 Milhão de m3 ---> 3538,618889 MWh
% Injetabilidade = 0,041680441 * Capacidade de Armazenamento (1/h)

% Injetabilidade = 0.041680441 * capArmazenamentoRestricao;

% auxPUT = spalloc(N*T,8*T*N,2*N*T);
% auxPUT = sparse([zeros(N*T,6*N*T) speye(N*T,N*T) zeros(N*T,N*T)]);
% auxGET = spalloc(N*T,8*T*N,2*N*T);
% auxGET = sparse([zeros(N*T,7*N*T) speye(N*T,N*T)]);
% 
% 
% 
% Aineq = sparse([Aineq; auxPUT; auxGET]);
% % bineq = [bineq; zeros(2*N*T,1)];

%% Determinação das variáveis inteiras e determinação dos limites inferiores e superiores das variáveis

% intcon = (3*N*T + 1):(6*N*T); %% As variáveis referentes ao start up cost como inteiras

lb = zeros(length(funcaoObjetivo),1);
ub = Inf(length(funcaoObjetivo),1);
% ub((3*N*T + 1):6*N*T) = 1;
    
%% Restrições de igualdade


% Equações de armazenamento
% Para 1 possível lugar de localização de planta de eletrólise

% Injecao(t) = Producao(t) - PUT(t) + GET(t)

% aux1 = spalloc(N*T,6*T*N,4*N*T);
% 
% for ii=1:N*T 
%         aux1(ii,ii) = 1;
%         aux1(ii,ii + 2*N*T) = -1;
%         aux1(ii,ii + 6*N*T) = -1;
%         aux1(ii,ii + 7*N*T) = 1;
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Link dos PUTS, GETS com as equações de armazenamento (Inventário)

% I(t) - I(t-1) = PUT(t) - GET(t)

% aux2 = spalloc(N*T,8*N*T,4*N*T);
% 
% for ii=1:N*T 
%     if ii==1 || ii==T+1 || ii==2*T+1 || ii==3*T+1 || ii==4*T+1 ...
%             || ii==5*T+1 || ii==6*T+1 || ii==7*T+1 || ii==8*T+1 ...
%             || ii==9*T+1 || ii==10*T+1 || ii==11*T+1 || ii==12*T+1
%         aux2(ii,ii + N*T) = 1;
%         aux2(ii,ii + 6*N*T) = -1;
%         aux2(ii,ii + 7*N*T) = 1;
%     else
%         aux2(ii,ii + N*T) = 1;
%         aux2(ii,ii + N*T - 1) = -1;
%         aux2(ii,ii + 6*N*T) = -1;
%         aux2(ii,ii + 7*N*T) = 1;
%     end
% end

% Aeq = sparse([aux1; aux2]);
% beq = zeros(2*N*T,1);


% Restrições de condição inicial do armazenamento. 13 restrições, condição
% inicial setada em 0 para o instante inicial nos 13 locais.

auxStorage1 = zeros(N,1);
auxStorage2 = spalloc(N,3*T*N,N);
auxStorage2(1,T*N+1) = 1;

Aeq = sparse([auxStorage2]);
beq = [auxStorage1];


%Inserindo N*T restrições referentes à variáveis inteiras responsáveis
%pelos custos de startup da planta de eletrólise. Restrições impedem que
%uma unidade que esteja com estado lógico ON possa se alterar para OFF, mas
%não possa ser STARTADA. Também o contrário.

% Yjk - Zjk = Vjk - Vjk-1

% aux = spalloc(N*T, 3*N*T, 4*N*T);
% aux2 = spalloc(N*T,3*N*T,N*T);
% for ii=1:N*T 
%     if ii==1 || ii==T+1 || ii==2*T+1 || ii==3*T+1 || ii==4*T+1 ...
%             || ii==5*T+1 || ii==6*T+1 || ii==7*T+1 || ii==8*T+1 ...
%             || ii==9*T+1 || ii==10*T+1 || ii==11*T+1 || ii==12*T+1
%         aux(ii,ii + 3*N*T) = 1;
%         aux(ii,ii + 4*N*T) = -1;
%         aux(ii,ii + 5*N*T) = -1;
%         aux2(ii,ii + 5*N*T) = 1;
%     else
%         aux(ii,ii + 3*N*T) = 1;
%         aux(ii,ii + 4*N*T) = -1;
%         aux(ii,ii + 5*N*T) = -1;
%         aux(ii,ii + 5*N*T -1) = 1;
%     end
% end

% Aeq = sparse([Aeq; aux; aux2]);
% beq = [beq; zeros(2*N*T,1)];

%%%%%%% EQUAÇÕES DE BALANÇO DO ARMAZENAMENTO


aux = spalloc(N*T,3*T*N,4*N*T);

for ii=1:N*T 
    if ii==1 
        aux(ii,ii) = 1;
        aux(ii,ii + N*T) = -1;
        aux(ii,ii + 2*N*T) = -1;
    else
        aux(ii,ii) = 1;
        aux(ii,ii + N*T - 1) = 1;
        aux(ii,ii + N*T) = -1;
        aux(ii,ii + 2*N*T) = -1;
    end
end

Aeq = sparse([Aeq; aux]);
beq = [beq; zeros(N*T,1)];

auxMaximizacao = repmat(speye(T),1,N);
auxMaximizacao = sparse([auxMaximizacao zeros(T,2*T*N)]);
Aeq = sparse([Aeq; auxMaximizacao]);
beq = [beq; min(capProducaoRestricao,Janeiro')];

clear aux aux2 auxProducaoMaximo auxProducaoMinimo ...
    auxStorage1 auxStorage2 contador auxMaximizacao;

%% OTIMIZAÇÃO JANEIRO


opts = optimoptions('linprog','Display','off');
% opts = optimoptions('intlinprog','Display','final','TolGapRel',5e-03);
[solution, fval_Janeiro,exitflag_Janeiro] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);

if exitflag_Janeiro < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end

exitflag_Janeiro;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);

somatorioProducao_Janeiro = zeros(T,1);
for ii=1:T
 
       auxiliar = solution(ii);
       somatorioProducao_Janeiro(ii)=somatorioProducao_Janeiro(ii)+auxiliar;
 
end

somatorioArmazenamento_Janeiro = zeros(T,1);
for ii=1:T
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Janeiro(ii)=somatorioArmazenamento_Janeiro(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
 
% somatorioPUT_Janeiro =  zeros(T-1,1);
% 
% for ii=2:T
%    for jj = 78:90
%        auxiliar = solution(ii + jj*T);
%        somatorioPUT_Janeiro(ii-1)=somatorioPUT_Janeiro(ii-1)+auxiliar;
%    end
% end


% hora = 0:length(Janeiro)-1;
% figure();
% hold on
% plot(hora,somatorioProducao_Janeiro,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Janeiro,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Janeiro','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');



%% Fevereiro

% SEMESTRE 02 - SÓ TEM QUE ADICIONAR RESTRIÇÕES NAS CONDIÇÕES INICIAS DE ARMAZENAMENTO
 
beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Fevereiro'); 
[solution, fval_Fevereiro,exitflag_Fevereiro,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Fevereiro < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Fevereiro;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 

somatorioProducao_Fevereiro = zeros(T,1);
for ii=1:T

       auxiliar = solution(ii);
       somatorioProducao_Fevereiro(ii)=somatorioProducao_Fevereiro(ii)+auxiliar;

end
 
somatorioArmazenamento_Fevereiro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Fevereiro(ii)=somatorioArmazenamento_Fevereiro(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end


 

% figure();
% hold on
% plot(hora,somatorioProducao_Fevereiro,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Fevereiro,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Fevereiro','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Março

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Marco'); 
[solution, fval_Marco,exitflag_Marco,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Marco < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Marco;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 
somatorioProducao_Marco = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Marco(ii)=somatorioProducao_Marco(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Marco = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Marco(ii)=somatorioArmazenamento_Marco(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end


% figure();
% hold on
% plot(hora,somatorioProducao_Marco,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Marco,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Marco','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Abril

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Abril'); 
[solution, fval_Abril,exitflag_Abril,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Abril < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Abril;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);


somatorioProducao_Abril = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Abril(ii)=somatorioProducao_Abril(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Abril = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Abril(ii)=somatorioArmazenamento_Abril(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Abril,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Abril,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Abril','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Maio
% 
beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Maio'); 
[solution, fval_Maio,exitflag_Maio,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Maio < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Maio;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 

somatorioProducao_Maio = zeros(T,1);

for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Maio(ii)=somatorioProducao_Maio(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Maio = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Maio(ii)=somatorioArmazenamento_Maio(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Maio,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Maio,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Maio','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Junho

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Junho'); 
[solution, fval_Junho,exitflag_Junho,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Junho < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Junho;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 
 
somatorioProducao_Junho = solution(1:24);

somatorioArmazenamento_Junho = zeros(T,1);
for ii=1:T
  
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Junho(ii)=somatorioArmazenamento_Junho(ii)+auxiliar;
  
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end

%  
% figure();
% hold on
% plot(hora,somatorioProducao_Junho,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Junho,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Junho','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Julho

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Julho'); 
[solution, fval_Julho,exitflag_Julho,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Julho < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Julho;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 

somatorioProducao_Julho = zeros(T,1);
for ii=1:T

       auxiliar = solution(ii);
       somatorioProducao_Julho(ii)=somatorioProducao_Julho(ii)+auxiliar;

end
 
somatorioArmazenamento_Julho = zeros(T,1);
for ii=1:T
  
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Julho(ii)=somatorioArmazenamento_Julho(ii)+auxiliar;
  
end
somatorioInjecao = zeros(T,1);
for ii=1:T
  
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
  
end
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Julho,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Julho,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Julho','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Agosto

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Agosto'); 
[solution, fval_Agosto,exitflag_Agosto,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Agosto < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Agosto;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 
 
somatorioProducao_Agosto = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Agosto(ii)=somatorioProducao_Agosto(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Agosto = zeros(T,1);
for ii=1:T
  
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Agosto(ii)=somatorioArmazenamento_Agosto(ii)+auxiliar;
  
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
 
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Agosto,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Agosto,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Agosto','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Setembro 

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Setembro'); 
[solution, fval_Setembro,exitflag_Setembro,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Setembro < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Setembro;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 
 

somatorioProducao_Setembro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Setembro(ii)=somatorioProducao_Setembro(ii)+auxiliar;
end

somatorioArmazenamento_Setembro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Setembro(ii)=somatorioArmazenamento_Setembro(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
 
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Setembro,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Setembro,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Setembro','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Outubro

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Outubro'); 
[solution, fval_Outubro,exitflag_Outubro,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Outubro < 0 % If you changed some parameters and got an infeasible problem

    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Outubro;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);
 

somatorioProducao_Outubro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Outubro(ii)=somatorioProducao_Outubro(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Outubro = zeros(T,1);
for ii=1:T
  
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Outubro(ii)=somatorioArmazenamento_Outubro(ii)+auxiliar;
  end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Outubro,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Outubro,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Outubro','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');
%% Novembro

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Novembro'); 
[solution, fval_Novembro,exitflag_Novembro,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Novembro < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Novembro;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);

somatorioProducao_Novembro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Novembro(ii)=somatorioProducao_Novembro(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Novembro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Novembro(ii)=somatorioArmazenamento_Novembro(ii)+auxiliar;
   
end
somatorioInjecao = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + 2*T);
       somatorioInjecao(ii)=somatorioInjecao(ii)+auxiliar;
   
end
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Novembro,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Novembro,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Novembro','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');

%% Dezembro

beq((N*T+2:(N*T)+25),1) = min(capProducaoRestricao,Dezembro'); 
[solution, fval_Dezembro,exitflag_Dezembro,output] = linprog(funcaoObjetivo,Aineq,bineq,Aeq,beq,lb,ub,[],opts);
 
if exitflag_Dezembro < 0 % If you changed some parameters and got an infeasible problem
    disp('The problem with these parameters is infeasible. No solution.')
    y = Inf;
    return % Stop the script because there is nothing to examine
end
 
exitflag_Dezembro;
infeas1 = max(Aineq*solution - bineq);
infeas2 = norm(Aeq*solution - beq,Inf);


somatorioProducao_Dezembro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii);
       somatorioProducao_Dezembro(ii)=somatorioProducao_Dezembro(ii)+auxiliar;
   
end
 
somatorioArmazenamento_Dezembro = zeros(T,1);
for ii=1:T
   
       auxiliar = solution(ii + T);
       somatorioArmazenamento_Dezembro(ii)=somatorioArmazenamento_Dezembro(ii)+auxiliar;
   
end
somatorioInjecao = solution(49:72);
% 
% figure();
% hold on
% plot(hora,somatorioProducao_Dezembro,'LineWidth',2);
% plot(hora,somatorioInjecao,'r--','LineWidth',2);
% plot(hora,somatorioArmazenamento_Dezembro,'g-*','LineWidth',2);
% xlabel('Hora');
% ylabel('MWh');
% grid on
% grid minor
% xlim([0 23]);
% title('Dezembro','FontSize',14);
% hold off
% legend('Produção de Hidrogênio','Injeção na Rede de Gás Natural','Armazenamento');

%% Resultados Finais e Retorno de Valor da Função

exitflag = [exitflag_Janeiro exitflag_Fevereiro exitflag_Marco ...
    exitflag_Abril exitflag_Maio exitflag_Junho exitflag_Julho ...
    exitflag_Agosto exitflag_Setembro exitflag_Outubro ...
    exitflag_Novembro exitflag_Dezembro];


fval_Janeiro = fval_Janeiro; 
fval_Fevereiro = fval_Fevereiro;
fval_Marco = fval_Marco;
fval_Abril = fval_Abril;
fval_Maio = fval_Maio;
fval_Junho = fval_Junho;
fval_Julho = fval_Julho;
fval_Agosto = fval_Agosto;
fval_Setembro = fval_Setembro;
fval_Outubro = fval_Outubro;
fval_Novembro = fval_Novembro;
fval_Dezembro = fval_Dezembro;


fval = 30*[fval_Janeiro fval_Fevereiro fval_Marco ...
    fval_Abril fval_Maio fval_Junho fval_Julho ...
    fval_Agosto fval_Setembro fval_Outubro ...
    fval_Novembro fval_Dezembro];

% x é a capacidade instada, z é a energia disponibilizada e g é a
% eficiência, h é o custo da eletricidade
%%%%%%DEFINIÇÃO DOS PARÂMETROS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%t=1:1:288;                             %período 12 meses x 24 horas
CO_ELETROLISE = 900000;                 %Custo Overnight (US$/MW)
CO_ARMAZENAMENTO = 116304;              %Custo Overnight Compressor(US$/MW)  
r=0.1;                                  %Taxa de desconto anual
OM_ELETROLISE=0.04*CO_ELETROLISE;       %Operação&Manutenção fixo
OM_ARMAZENAMENTO=0.04*CO_ARMAZENAMENTO;
OC=0;                                   %Outros custos
beta=0;                                 %Demanda de água (m3/kgH2)
CA=0;                                   %Custo da água (m3/kgH2)
lambda=8;                               %Quantidade de oxigênio por kg de hidrogênio (kgO2/kgH2)
PO=0;                                   %Preço de venda do oxigênio (US$/tonelada)
TV=30;                                  %Tempo de vida do empreendimento (anos)
FRC=(r*(1+r)^TV)/((r+1)^TV-1);          %Fator de recuperação do capital

%%%%%%%%%CUSTOS FIXOS + CUSTOS VARIAVEIS DE OPERACAO (MIP)
CUSTO_FIXO = (capProducao*CO_ELETROLISE*FRC+20*capProducao*OM_ELETROLISE+OC) + ...
    (capArmazenamento*CO_ARMAZENAMENTO*FRC+360*capArmazenamento*OM_ARMAZENAMENTO+...
    OC);

fval = CUSTO_FIXO +  abs(sum(fval));

TOTAL_MWh = sum(somatorioProducao_Janeiro) + sum(somatorioProducao_Fevereiro) + ...
    sum(somatorioProducao_Marco) + sum(somatorioProducao_Abril) + ...
    sum(somatorioProducao_Maio) + sum(somatorioProducao_Junho) + ...
    sum(somatorioProducao_Julho) + ...
    sum(somatorioProducao_Agosto) + sum(somatorioProducao_Setembro) + ...
    sum(somatorioProducao_Outubro) + sum(somatorioProducao_Novembro) + ...
    sum(somatorioProducao_Dezembro);

TOTAL_MWh = (30*TOTAL_MWh);
QUANTIDADE_H2 = TOTAL_MWh*25.25; %kgH2 por MWh de H2
y1 = fval/QUANTIDADE_H2;
% y(2) = QUANTIDADE_H2;
% y(3) = TOTAL_MWh;
y2 = (30*sum(excDisp) - TOTAL_MWh)/1000;
% y(4) = fval;
% f2 = QUANTIDADE_H2;

end