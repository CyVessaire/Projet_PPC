#
# On considere des modeles de la forme:
# Dom = [Dom_var1 Dom_var2 ... Dom_varn]
# Cont = [Contrainte vari varj]
# Par convention, il faut que i<j dans Contrainte vari varj
function backtrack_gashnig(dom, cont)
    i = 1
    n = size(dom, 2)

    #println(n)
    x = zeros(n)
    #println(size(x))
    culprit = zeros(Int,n)
    D = copy(dom)
    while i <= n && i > 0
        # println(i)
        a = culprit[i]
        x[i], culprit[i] = select_value_gbj(D[i], i, a, cont, x)
        # println("x[$i] = ", x[i])
        # println("culprit[i] = ", culprit[i])
        if x[i] == false
            # println("entered")
            i = culprit[i]
        else
            #println("entered")
            i += 1
            if i>n
                break
            end
            D[i] = copy(dom[i])
            culprit[i] = 0
        end
    end
    if i == 0
        #println("entered 2")
        return false
    else
        return x
    end
end

function select_value_gbj(D, i, culprit, cont, x)
    n = size(D,1)
    while size(D,1)>0
        # println(size(D,1))
        a = D[rand(1:end)]
        # println("a = $a")

        filter!(x->x!=a, D)
        # println("D = ", D)

        consistant = true
        k = 1
        while (k<i && consistant)
            if k > culprit
                culprit = k
            end
            if size(cont[k, i],1)>0
                consistant = false
                for j in 1:size(cont[k, i], 1)
                #     println("cont =", cont[k, i])
                #     println(size(cont[k, i]))
                #     println(cont[k, i][j, 1])
                #     println(cont[k, i][j, 2])
                    if cont[k, i][j, 1] == x[k] && cont[k, i][j, 2] == a
                        consistant = true
                        break
                    end
                end
            end
            if consistant
                k += 1
            end
        end
        if consistant
            return a, culprit
        end
    end
    return false, culprit
end
