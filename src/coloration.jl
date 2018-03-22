

function coloration(n, i)
    if i == 1
        Path = "../data/instances/anna.col"
    elseif i == 2
        Path = "../data/instances/david.col"
    elseif i == 3
        Path = "../data/instances/miles250.col"
    end

    A = readfile(Path)
    l = size(A,1)
    m = 1 #nombre de points
    for i = 1:l
        if A[i,1] > m
            m = A[i,1]
        elseif A[i,2] > m
            m = A[i,2]
        end
    end

    dom = Array{Array}(1,m)
    cont = Array{Array}(m,m)

    for i = 1:m
        dom[i] = 1:n
        for j = 1:m
            cont[i,j] = []
        end
    end

    L = []
    for i = 1:n
        for j = 1:n
            if j == i
                continue
            end
            L = vcat(L, [i j])
        end
    end

    for i = 1:l
        x = A[i,1]
        y = A[i,2]
        if y < x
            k = x
            x = y
            y = k
        end
        cont[x, y] = L
    end
    return dom, cont
end

function readfile(Path)
    A = readdlm(Path, ' ')
    a = round.(Int,A)
    return(a)
end
