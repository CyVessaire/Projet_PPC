
# par convention, x est la solution, avec x[j]=0 si non instancié.
# i désigne l'indice de l'instanciation actuelle, S la taille de chaque domaine

function forward_checking(dom, cont, i, x, S)
    a = x[i]
    n = size(x,1)
    # println(size(x,1))
    D = copy(dom)
    s = copy(S)
    for j in 1:n
        # println(j)
        # println(x[j] == 0)
        if j == i
            continue
        end
        if x[j] == 0 && ((j<i && size(cont[j, i],1)>0 ) || (i<j && size(cont[i, j],1)>0))
            # println("entered")
            s[j] = 0
            if j < i
                for k in 1:size(cont[j, i],1)
                    if cont[j, i][k, 2] == a
                        b = cont[j, i][k, 1]
                        # println(b)
                        # println(size(D[j],1))
                        ind = 0
                        for l in 1:S[j]
                            if dom[j][l] == b
                                for m in s[j]+1:size(D[j],1)
                                    if D[j][m] == b
                                        ind = m
                                        # println(ind)
                                        break
                                    end
                                end
                                break
                            end
                        end
                        if ind > 0 # valeur admissible ( on a ind < S[j], donc dans le domaine encore admissible)
                            s[j] += 1
                            if s[j] > size(D[j],1)
                                println("error")
                                return false
                            end
                            D[j][ind] = D[j][s[j]]
                            D[j][s[j]] = b
                        end
                    end
                end
            end
            if i < j
                for k in 1:size(cont[i, j],1)
                    if cont[i, j][k, 1] == a
                        b = cont[i, j][k, 2]
                        ind = 0
                        # println("b = $b")
                        # println(D[j])
                        for l in 1:S[j]
                            if dom[j][l] == b
                                for m in s[j]+1:size(D[j],1)
                                    # println("m = ",m)
                                    if D[j][m] == b
                                        ind = m
                                        # println("ind = $ind")
                                        break
                                    end
                                end
                                break
                            end
                        end
                        if ind > 0 # valeur admissible ( on a ind < S[j], donc dans le domaine encore admissible)
                            # println("entered")
                            s[j] += 1
                            if s[j] > size(D[j],1)
                                println("error")
                                return false
                            end
                            # println("D[j][ind] = ", D[j][ind])
                            # println("D[j][s[j]] = ", D[j][s[j]])
                            # println("b = ", b)
                            # println("D[$j] = ", D[j])
                            D[j][ind] = D[j][s[j]]
                            D[j][s[j]] = b
                            # println("D[$j] = ", D[j])
                        end
                    end
                end
            end
        end
        if s[j] < 1 && x[j] == 0
            # println("entered_last")
            return D, s
        end
    end
    return D, s
end

function solve_FC(dom, cont)
    D = copy(dom)
    n = size(dom, 2)
    # println(n)
    x = zeros(Int,n)

    # représente la taille des domaines
    S = Array{Int}(n)
    m = 0
    k = 0
    for i in 1:n
        count = 0
        S[i] = size(dom[i], 1)
        for j in i:n
            if j == i
                continue
            end
            if (size(cont[i, j],1) > 0) || (size(cont[i, j],1) > 0)
                count +=1
            end
        end
        if count > m
            m = count
            k = i
        end
    end
    if  k == 0
        println("no constraint, don't use ppc")
        return
    end

    b, x, D, S = instance_FC(D, cont, x, k, S)
    if b
        return x
    else
        # println(D)
        println(S)
        return b
    end
end

function instance_FC(dom, cont, x, i, S)
    n = size(dom, 2)
    d = copy(dom)
    s = copy(S)
    # if i <= 2
    #     println(i)
    #     println("x = ", x)
    #     println("S = ",S)
    # end
    # println(x)
    # println(i)
    while S[i] > 0
        # println("S[$i] = ", S[i])
        # println("S = ", S)
        # println("dom[$i] = ", dom[i])

        j = rand(1:S[i])
        a = dom[i][j]
        dom[i][j] = dom[i][S[i]]
        dom[i][S[i]] = a
        S[i] -= 1
        x[i] = a
        # println("x = $x")
        test = true
        for j in 1:n
            if x[j] == 0
                test = false
                break
            end
        end

        if test
            return true, x, dom, S
        end

        dom, S = forward_checking(dom, cont, i, x, S)

        # instancier les variables ayant une contrainte commune avec i n'ayant pas été instanciées
        test = true
        # L = []
        for j in 1:n
            if j == i
                continue
            end
            if j<i
                if x[j] == 0
                    # L = vcat(L, j)
                    # println("entered")
                    if size(cont[j, i],1) > 0
                        b, x, dom, S = instance_FC(dom, cont, x, j, S)
                        if !b
                            test = false
                            break
                        end
                    end
                end
            else
                if size(cont[i, j],1) > 0
                    if x[j] == 0
                        # L = vcat(L, j)
                        # println("entered ", j)
                        # println("dom ", dom[j])
                        b, x, dom, S = instance_FC(dom, cont, x, j, S)
                        if !b
                            test = false
                            break
                        end
                    end
                end
            end
        end

        if test
            return true, x, dom, S
        else
            x[i] = 0
            for j in 1:n
                if j!=i
                    if x[j] == 0
                        S[j] = s[j]
                        dom[j] = d[j]
                    end
                end
            end
            # if S[i] == 0
            #     println("error $i")
            #     for j in 1:n
            #         if size(cont[i, j],1)>0
            #             println("j = $j")
            #             for k in 1:size(cont[i, j],1)
            #                 if cont[i, j][k, 1] == x[i]
            #                     println(cont[i, j][k, 2])
            #                 end
            #             end
            #         elseif size(cont[j, i],1)>0
            #             println("j = $j")
            #             for k in 1:size(cont[j, i],1)
            #                 if cont[j, i][k, 1] == x[i]
            #                     println(cont[j, i][k, 2])
            #                 end
            #             end
            #         end
            #     end
            # end
            # if i == 8
            #     println("L = ", L)
            # end
            # for j in L
            #     x[j] = 0
            #     # println("S[$j] = ", S[j])
            #     S[j] = s[j]
            #     dom[j] = d[j]
            #     # println("s[$j] = ", s[j])
            # end
        end
    end

    # println("  entered last")
    # println("i = ",i)
    # println("dom[i] = ", dom[i], " d = ", d)
    # dom[i] = d
    # println("S = ", S, " s = ", s)
    # S = s
    # x[i] = 0
    # S[i] = s[i]
    # dom[i] = d[i]
    # for j in 1:n
    #     if x[j] == 0
    #         S[j] = s[j]
    #         dom[j] = d[j]
    #     end
    # end
    # println("cut branch $i")
    return false, x, dom, S
end
