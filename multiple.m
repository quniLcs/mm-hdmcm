clear;
clc;
close all;

rng(0);

% n = 2.4e4;
% m = 2e1;
n = 2.4e7;
m = 2e4;

mu = 0.2; % 假阴性
nu = 0.0015; % 假阳性
lambda = [0.25, 0.25, 0.5];
theta = 0.2;
% lambda = [0.25, 0.25, 1];
% theta = 0.3;
% lambda = [0.25, 0.25, 1.5];
% theta = 0.4;

rounds = 60;
records = zeros(rounds, 3);

people = logical(sparse(n, 2));
% 第一个逻辑值表示是否感染病毒
% 第二个逻辑值表示是否被隔离

% 初始状态
order = randperm(n);
for index = 1:n
    if order(index) <= m
        people(index, 1) = 1;
    end
end
QI = 0;  % 感染病毒且被隔离
QS = 0;  % 未感染病毒但被隔离
NS = n - m;  % 未感染病毒且未被隔离
NI = m;  % 感染病毒但未被隔离

for round = 1:rounds
    fprintf('round %d\n', round)
    fprintf('%8s\t%8s\t%8s\t%8s\n', 'QI', 'QS', 'NS', 'NI');
    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);
    
    % 新增感染
    infect = lambda(1) * NI / NS;
    for index = 1:n
        if people(index, 1) == 0 && people(index, 2) == 0
            if rand < infect
                people(index, 1) = 1;
                NI = NI + 1;
                NS = NS - 1;
            end
        end
    end

    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);

    % 混合检测
    p = NI / (NI + NS);
    p = p * (1 - mu) + (1 - p) * nu;
    [~, k] = min(1 + 1 ./ (1:100) - (1 - p) .^ (1:100));
    group_num = 0;
    group_index = zeros(1, k);
    group_result = zeros(1, k);
    recheck = logical(sparse(n, 1));
    for index = 1:n
        if people(index, 2) == 0
            group_num = group_num + 1;
            group_index(group_num) = index;
            if people(index, 1) == 0  && rand < nu  % 假阳性
                group_result(group_num) = 1;
            elseif people(index, 1) == 1  && rand >= mu  % 真阳性
                group_result(group_num) = 1;
            end

            if group_num == k || index == n
                if any(group_result)
                    for subindex = group_index(1:group_num)
                        recheck(subindex) = 1;
                        people(subindex, 2) = 1;
                        if people(subindex, 1) == 0
                            NS = NS - 1;
                            QS = QS + 1;
                        else
                            NI = NI - 1;
                            QI = QI + 1;
                        end
                    end
                end

                group_num = 0;
                group_result = zeros(1, k);
            end
        end
    end

    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);

    % 新增感染
    infect = lambda(2) * NI / NS;
    for index = 1:n
        if people(index, 1) == 0 && people(index, 2) == 0
            if rand < infect
                people(index, 1) = 1;
                NI = NI + 1;
                NS = NS - 1;
            end
        end
    end

    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);

    % 单人单管检测
    for index = 1:n
        if recheck(index) == 1
            if people(index, 1) == 0 && rand >= nu  % 真阴性
                people(index, 2) = 0;
                QS = QS - 1;
                NS = NS + 1;      
            elseif people(index, 1) == 1 && rand < mu  % 假阴性
                people(index, 2) = 0;
                QI = QI - 1;
                NI = NI + 1;
            end
        end
    end

    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);
    
    % 新增感染
    infect = lambda(3) * NI / NS;
    for index = 1:n
        if people(index, 1) == 0 && people(index, 2) == 0
            if rand < infect
                people(index, 1) = 1;
                NI = NI + 1;
                NS = NS - 1;
            end
        end
    end

    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);
    
    % 痊愈
    for index = 1:n
        if people(index, 1) == 1 && rand < theta
            people(index, 1) = 0;
            if people(index, 2) == 0
                NI = NI - 1;
                NS = NS + 1;
            else
                QI = QI - 1;
                QS = QS + 1;
            end
        end
    end

    % 单人单管检测
    for index = 1:n
        if people(index, 2) == 1
            if people(index, 1) == 0 && rand >= nu  % 真阴性
                people(index, 2) = 0;
                QS = QS - 1;
                NS = NS + 1;         
            elseif people(index, 1) == 1 && rand < mu  % 假阴性
                people(index, 2) = 0;
                QI = QI - 1;
                NI = NI + 1;
            end
        end
    end

    fprintf('%8d\t%8d\t%8d\t%8d\n', QI, QS, NS, NI);
    records(round, 1) = QI;
    records(round, 2) = NI;
    records(round, 3) = k;
    
    save('records.mat');
end

figure;
plot(records(:, 1:2));
title('疫情情况随时间的变化');
legend(["感染病毒且被隔离人数", "感染病毒但未被隔离人数"]);
xlabel('轮数');
ylabel('人数');

figure;
plot(records(:, 3));
title('混合检测每组的人数随时间的变化');
xlabel('轮数');
ylabel('混合检测每组的人数');