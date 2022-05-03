import random
import torch
import matplotlib.pyplot as plt

if __name__ == "__main__":
    torch.manual_seed(0)

    n = int(2.4e7)
    m = int(2e4)
    # n = int(2.4e3)
    # m = int(2e1)

    mu = 0.2
    nu = 0.0015
    lambd = (0.25, 0.25, 0.5)
    theta = 0.2
    # lambd = (0.25, 0.25, 1)
    # theta = 0.3
    # lambd = (0.25, 0.25, 1.5)
    # theta = 0.4

    rounds = 60
    records = torch.zeros(rounds, 3)

    # 初始状态
    infect = set(random.choices(range(n), k = m))
    quarantine = set()
    QI = 0  # 感染病毒且被隔离
    QS = 0  # 未感染病毒但被隔离
    NS = n - m  # 未感染病毒且未被隔离
    NI = m  # 感染病毒但未被隔离

    for round in range(rounds):
        print('round %d' % round)
        print('%8s\t%8s\t%8s\t%8s' % ('QI', 'QS', 'NS', 'NI'))
        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))

        # 新增感染
        p = lambd[0] * NI / NS
        for index in range(n):
            if index not in infect and \
                    index not in quarantine and \
                    torch.rand(1) < p:
                infect.add(index)
                NI += 1
                NS -= 1

        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))

        # 混合检测
        p = NI / (NI + NS)
        p = p * (1 - mu) + (1 - p) * nu
        k = torch.argmin(1 + 1 / torch.arange(1, 100) -
                         (1 - p) ** torch.arange(1, 100))
        group_num = 0
        group_index = []
        group_result = 0
        recheck = set()
        for index in range(n):
            if index not in quarantine:
                group_index.append(index)
                if index not in infect and torch.rand(1) < nu:  # 假阳性
                    group_result = 1
                elif index in infect and torch.rand(1) >= mu:  # 真阳性
                    group_result = 1
                group_num += 1

                if group_num == k or index == n - 1:
                    if group_result:
                        for subindex in group_index[:group_num]:
                            recheck.add(subindex)
                            quarantine.add(subindex)
                            if subindex not in infect:
                                NS -= 1
                                QS += 1
                            else:
                                NI -= 1
                                QI += 1

                    group_num = 0
                    group_result = 0
                    group_index = []

        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))

        # 新增感染
        p = lambd[1] * NI / NS
        for index in range(n):
            if index not in infect and \
                    index not in quarantine \
                    and torch.rand(1) < p:
                infect.add(index)
                NI += 1
                NS -= 1

        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))

        # 单人单管检测
        for index in range(n):
            if index in recheck:
                if index not in infect and torch.rand(1) >= nu:  # 真阴性
                    quarantine.remove(index)
                    QS -= 1
                    NS += 1
                elif index in infect and torch.rand(1) < mu:  # 假阴性
                    quarantine.remove(index)
                    QI -= 1
                    NI += 1

        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))

        # 新增感染
        p = lambd[2] * NI / NS
        for index in range(n):
            if index not in infect and \
                    index not in quarantine and \
                    torch.rand(1) < p:
                infect.add(index)
                NI += 1
                NS -= 1

        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))

        # 痊愈
        for index in range(n):
            if index in infect and torch.rand(1) < theta:
                infect.remove(index)
                if index not in quarantine:
                    NI -= 1
                    NS += 1
                else:
                    QI -= 1
                    QS += 1

        # 单人单管检测
        for index in range(n):
            if index in quarantine:
                if index not in infect and torch.rand(1) >= nu:  # 真阴性
                    quarantine.remove(index)
                    QS -= 1
                    NS += 1
                elif index in infect and torch.rand(1) < mu:  # 假阴性
                    quarantine.remove(index)
                    QI -= 1
                    NI += 1

        print('%8d\t%8d\t%8d\t%8d' % (QI, QS, NS, NI))
        records[round, 0] = QI
        records[round, 1] = NI
        records[round, 2] = k
        torch.save(records, 'records.pth')

    plt.plot(records[:, :2])
    plt.title('疫情情况随时间的变化')
    plt.legend(["感染病毒且被隔离人数", "感染病毒但未被隔离人数"])
    plt.xlabel('轮数')
    plt.ylabel('人数')
    plt.show()

    plt.plot(records[:, 2])
    plt.title('混合检测每组的人数随时间的变化')
    plt.xlabel('轮数')
    plt.ylabel('混合检测每组的人数')
    plt.show()
