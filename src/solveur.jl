include("backtrack.jl")
include("consistance.jl")
include("forward_checking.jl")
include("nreine.jl")
include("coloration.jl")

# for i in 25:5:50
#     dom, cont = nreine(i)
#     @time(x = backtrack_gashnig(dom, cont))
#     println("$i reines, backtrack $x")
#     @time(x = solve_FC(dom, cont))
#     println("$i reines, backtrack with FC $x")
#     @time(x = solve_maintain_AC3(dom, cont))
#     println("$i reines, maintain AC $x")
# end
# t = true
# i = 20
# dom, cont = nreine(i)
# while(t)
#
# #     # @time(x = backtrack_gashnig(dom, cont))
# #     # println("$i reines, backtrack $x")
# #     # @time(x = solve_FC(dom, cont))
# #     # println("$i reines, backtrack with FC $x")
#     @time(x = solve_maintain_AC3(dom, cont))
#     println("$i reines, maintain AC $x")
#     if x == false
#         t =false
#     end
# end


for i in 5:15
    # i = -i
    dom, cont = coloration(i,1)
    @time(x = solve_FC(dom, cont))
    check = true
    for j in 1:size(x,1)
        if x[j] == 0
            check = false
            break
        end
    end
    if check
        println("graphe $i colorable")
        println(x)
        break
    # else
    #     break
    end
end
#
# for i in 138
#     dom, cont = coloration(i,1)
#     @time(x = solve_maintain_AC3(dom, cont))
#     check = true
#     println(x)
#     for j in 1:size(x,1)
#         if x[j] == 0
#             check = false
#             break
#         end
#     end
#     if check
#         println("graphe $i colorable")
#         break
#     end
# end
