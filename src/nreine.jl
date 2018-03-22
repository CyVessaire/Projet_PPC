
function nreine(n)
    dom = Array{Array}(1,n) # le domaine des variables est [1, n]. Chaque variable i correspond à la colonne de la reine de la ligne i
    cont = Array{Array}(n,n)

    for i in 1:n
        dom[i]= 1:n
        # println("dom $i ", dom)
        for j in 1:i
            cont[i, j]=[]
            if j==i
                break
            else
                L = []
                for a in 1:n
                    for b in 1:n
                        if b == a ||  b + (i-j) == a || b - (i-j) == a
                            continue
                        end
                        L = vcat(L, [a b])
                    end
                end
                cont[j, i] = L
                # println("cont $j $i ", cont[j, i])
            end
        end
    end
    return dom, cont
end
