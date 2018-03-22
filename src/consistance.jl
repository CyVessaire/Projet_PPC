# On considere des modeles de la forme:
# Dom = [Dom_var1 Dom_var2 ... Dom_varn]
# Cont = [Contrainte vari varj]
# Par convention, il faut que i<j dans Contrainte vari varj
function AC3(dom, cont)
    Test = []
    n = size(dom, 2)
    for i in 1:n-1
        for j in i+1:n
            if size(cont[i, j],1) > 0
                Test = vcat(Test, [i j])
            end
        end
    end
    d = copy(dom)
    S = zeros(n)
    for i in 1:n
        S[i] = size(dom[i],1)
    end
    # println(dom)
    # println(cont)

    while(size(Test,1)>0)
        x = Test[size(Test,1), 1]
        y = Test[size(Test,1), 2]
        Test = Test[setdiff(1:size(Test,1), size(Test,1)), :]
        L = []
        # println(dom[x])
        # println(cont[x, y])
        # println(dom[y])
        for a in d[x]
            check = false
            if size(cont[x, y],1) == 0
                println("erreur")
                # println(a)
                # println(x)
                # println(y)
            end
            for i in 1:size(cont[x, y],1)
                if a == cont[x, y][i, 1]
                    b = cont[x, y][i, 2]
                    for c in d[y]
                        if b == c
                            check = true
                            break
                        end
                    end
                    if check
                        break
                    end
                end
            end
            if !check
                # println("entered 1")
                # println(cont[x, y])
                # println(size(cont[x, y],1))
                append!(L, a)
            end
        end

        # if size(L, 1)>0
        #     println(x, y)
        #     println(L)
        #     println(dom[x])
        # end

        L2 = []
        for i in 1:size(d[x],1)
            test2 = true
            for a in L
                if d[x][i] == a
                    test2 = false
                    break
                end
            end
            if test2
                append!(L2, d[x][i])
            end
        end
        if size(L2, 1) < 1
            return false, d
        end
        d[x] = L2
                #
                #     if size(d[x],1) <= 1 # on a alors un domaine vide, donc pas d'arc consistance et donc pas de consistance
                #         return false, d
                #     end
                #     filter!(x->x≠a, d[x])
                #     for j in 1:size(d,2)
                #         if j == x
                #             continue
                #         elseif j > x && size(cont[x, j],1) > 0
                #             Test = vcat(Test, [x j])
                #         elseif size(cont[j, x],1) > 0 #i.e. j < x
                #             Test = vcat(Test, [j x])
                #         end
                #     end
                #     if size(d[x],1) < 1 # on a alors un domaine vide, donc pas d'arc consistance et donc pas de consistance
                #         return false, d
                #     end
                # end

        L = []

        for a in d[y]
            check = false
            # println(a)
            if size(cont[x, y],1) == 0
                println("erreur")
                println(a)
                println(x)
                println(y)
            end
            for i in 1:size(cont[x, y],1)
                if a == cont[x, y][i, 2]
                    b = cont[x, y][i, 1]
                    for c in d[x]
                        if b == c
                            check = true
                            break
                        end
                    end
                    if check
                        break
                    end
                end
            end
            if !check
                # println("entered 2")
                # println(cont[y, x])
                # println(size(cont[y, x],1))
                append!(L, a)
            end
        end

        # if size(L, 1)>0
            # println(y, x)
            # println(L)
            # println(dom[y])
        # end
        L2 = []
        for i in 1:size(d[y],1)
            test2 = true
            for a in L
                if d[y][i] == a
                    test2 = false
                    break
                end
            end
            if test2
                append!(L2, d[y][i])
            end
        end
        if size(L2, 1) < 1
            return false, d
        end
        d[y] = L2

        # for a in L
        #     if size(d[y],1) <= 1 # on a alors un domaine vide, donc pas d'arc consistance et donc pas de consistance
        #         return false, d
        #     end
        #     filter!(x->x≠a, d[y])
        #     # println(y)
        #     # println(dom[y])
        #     for j in 1:size(d,2)
        #         if j == y
        #             continue
        #         elseif j > y && size(cont[y, j],1) > 0
        #             # println("entered 3")
        #             Test = vcat(Test, [y j])
        #         elseif size(cont[j, y],1) > 0 #i.e. j < x
        #             # println("entered 4")
        #             # println(size(cont[j, y]))
        #             # println(size(cont[j, y],1))
        #             # println(size(cont[j, y],2))
        #             # println(j)
        #             Test = vcat(Test, [j y])
        #         end
        #     end
        #     if size(d[y],1) < 1 # on a alors un domaine vide, donc pas d'arc consistance et donc pas de consistance
        #         return false, d
        #     end
        # end
    end
    # println(dom)
    return true, d
end
#
# function initAC4(dom, cont)
#     n = size(dom)
#     Q = []
#     S = []
#     for i in 1:n-1
#         for j in i:n
#             if size(cont[i,j]>0)
#                 for a in dom[i]
#                     total = 0
#                     for b in dom[j]
#                         for k in cont[i, j]
#                             if a == k[1] && b == k[2]
#                                 total += 1
#                                 # continue by creating dictionnary for S(<y, b>)
#                             end
#                         end
#                     end
#                 end
#             end
#         end
#     end
# end

function solve_maintain_AC3(dom, cont)
    D = copy(dom)
    n = size(dom, 2)
    # println(n)
    x = zeros(Int,n)

    m = 0
    k = 0
    for i in 1:n
        count = 0
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

    b, x, D = instance_maintain_AC3(D, cont, x, k)
    if b
        return x
    else
        return b
    end
end

function instance_maintain_AC3(dom, cont, x, i)
    # println(i)
    n = size(dom, 2)
    # println(n)
    d = copy(dom)
    D = copy(dom[i])

    loop = true
    while loop
        # # println("S[$i] = ", S[i])
        # # println("S = ", S)
        # # println("dom[$i] = ", dom[i])
        # println("i = ", i)
        # println("d = ", d)
        # println("dom = ", dom)
        for j in 1:n
            if j == i
                continue
            end
            d[j] = dom[j]
        end

        j = rand(1:size(D,1))
        a = D[j]
        x[i] = a
        # filter!(x->x!=a, d[i])
        d[i] = [a]
        # println(d)
        # println("x = $x")
        test = true

        for j in 1:n
            if x[j] == 0
                test = false
                break
            end
        end

        if test
            return true, x, d
        end

        # println("dom = ", dom)
        b, d = AC3(d, cont)
        # println("AC3")
        # println(d)
        # println(dom)
        # println(dom)
        # println(b)
        if !b
            x[i] = 0
            return false, x, d
        end

        # instancier les variables ayant une contrainte commune avec i n'ayant pas été instanciées
        for j in 1:n
            # println(j)
            if j == i
                continue
            end
            if j<i
                if x[j] == 0
                    # println("entered")
                    if size(cont[j, i],1) > 0
                        b, x, d = instance_maintain_AC3(d, cont, x, j)
                        if !b
                            break
                        end
                    end
                end
            else
                if size(cont[i, j],1) > 0
                    if x[j] == 0
                        # println("entered ", j)
                        # println("dom ", dom[j])
                        b, x, d = instance_maintain_AC3(d, cont, x, j)
                        if !b
                            break
                        else
                            return b, x, d
                        end
                    end
                end
            end
        end

        # println("i = ", i)
        # println("d = ", d)
        # println("dom = ", dom)

        filter!(x->x!=a, D)

        # println("D = ", D)
        if size(D,1) == 0
            loop = false
        end
    end
    # println("  entered last")
    # println("i = ",i)
    # println("dom[i] = ", dom[i], " d = ", d)
    # dom[i] = d
    # println("S = ", S, " s = ", s)
    # S = s
    # x[i] = 0
    # for j in 1:n
    #     if j == i
    #         continue
    #     end
    #     S[j] = s[j]
    #     dom[j] = d[j]
    # end
    x[i]=0
    return false, x, dom
end
