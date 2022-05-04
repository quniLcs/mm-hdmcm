clear;
clc;
close all;

%%
figure;
plot(2:2:96,records(1:48, 1:2));
title('疫情情况随时间的变化(周期为2天)');
legend(["感染病毒且被隔离人数", "感染病毒但未被隔离人数"]);
ylim([0, 18000]);
xlabel('天数');
ylabel('人数');

%%
figure;
plot(2:2:96, records(1:48, 3));
title('混合检测每组的人数随时间的变化(周期为2天)');
xlabel('天数');
ylabel('混合检测每组的人数');

%%
figure;
plot(2:2:96,records(1:48, 1));
hold on;

%%
figure;
plot(2:2:96,records(1:48, 2));
hold on;

%%
figure;
plot(2:2:96, records(1:48, 3));
hold on;

%%
figure;
plot(3:3:96,records(1:32, 1:2));
title('疫情情况随时间的变化(周期为3天)');
legend(["感染病毒且被隔离人数", "感染病毒但未被隔离人数"]);
ylim([0, 18000]);
xlabel('天数');
ylabel('人数');

%%
figure;
plot(3:3:96, records(1:32, 3));
title('混合检测每组的人数随时间的变化(周期为3天)');
xlabel('天数');
ylabel('混合检测每组的人数');

%%
plot(3:3:96, records(1:32, 1));

%%
plot(3:3:96, records(1:32, 2));

%%
plot(3:3:96, records(1:32, 3));

%%
figure;
plot(4:4:96,records(1:24, 1:2));
title('疫情情况随时间的变化(周期为4天)');
legend(["感染病毒且被隔离人数", "感染病毒但未被隔离人数"]);
ylim([0, 18000]);
xlabel('天数');
ylabel('人数');

%%
figure;
plot(4:4:96, records(1:24, 3));
title('混合检测每组的人数随时间的变化(周期为4天)');
xlabel('天数');
ylabel('混合检测每组的人数');

%%
plot(4:4:96,records(1:24, 1));
title('感染病毒且被隔离的人数随时间的变化');
legend(["周期为2天", "周期为3天", "周期为4天"]);
ylim([0, 18000]);
xlabel('天数');
ylabel('感染病毒且被隔离的人数');

%%
plot(4:4:96,records(1:24, 2));
title('感染病毒但未被隔离的人数随时间的变化');
legend(["周期为2天", "周期为3天", "周期为4天"]);
ylim([0, 18000]);
xlabel('天数');
ylabel('感染病毒但未被隔离的人数');

%%
plot(4:4:96, records(1:24, 3));
title('混合检测每组的人数随时间的变化');
legend(["周期为2天", "周期为3天", "周期为4天"], 'location', 'southeast');
yticks(21:25);
xlabel('天数');
ylabel('混合检测每组的人数');