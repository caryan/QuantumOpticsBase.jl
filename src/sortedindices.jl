"""
6, [1, 4] => [2, 3, 5, 6]
"""
function complement(N::Int, indices::Vector{Int})
    L = length(indices)
    x = Vector{Int}(undef, N - L)
    i_ = 1 # Position in the x vector
    j = 1 # Position in indices vector
    for i=1:N
        if j > L || indices[j]!=i
            x[i_] = i
            i_ += 1
        else
            j += 1
        end
    end
    x
end


"""
[1, 4, 5], [2, 4, 7] => [1, 5]
"""
function remove(ind1::Vector{Int}, ind2::Vector{Int})
    x = Int[]
    for i in ind1
        if i ∉ ind2
            push!(x, i)
        end
    end
    x
end

"""
[1, 4, 5], [2, 4, 7] => [1, 3]
"""
function shiftremove(ind1::Vector{Int}, ind2::Vector{Int})
    x = Int[]
    for i in ind1
        if i ∉ ind2
            counter = 0
            for i2 in ind2
                if i2 < i
                    counter += 1
                else
                    break
                end
            end
            push!(x, i-counter)
        end
    end
    x
end

function reducedindices(I_::Vector{Int}, I::Vector{Int})
    N = length(I_)
    x = Vector{Int}(undef, N)
    for n in 1:N
        x[n] = findfirst(isequal(I_[n]), I)
    end
    x
end

function reducedindices!(I_::Vector{Int}, I::Vector{Int})
    for n in 1:length(I_)
        I_[n] = findfirst(isequal(I_[n]), I)
    end
end

"""
Check if all indices are unique and smaller than or equal to imax.
"""
function check_indices(imax::Int, indices::Vector{Int})
    N = length(indices)
    for n=1:N
        i = indices[n]
        @assert 0 < i <= imax
        for m in n+1:N
            @assert i != indices[m]
        end
    end
end

"""
Check if the indices are sorted, unique and smaller than or equal to imax.
"""
function check_sortedindices(imax::Int, indices::Vector{Int})
    N = length(indices)
    if N == 0
        return nothing
    end
    i_ = indices[1]
    @assert 0 < i_ <= imax
    for i in indices[2:end]
        @assert 0 < i <= imax
        @assert i > i_
    end
end

"""
    check_embed_indices(indices::Array)

Determine whether a collection of indices, written as a list of (integers or lists of integers) is unique.
This assures that the embedded operators are in non-overlapping subspaces.
"""
function check_embed_indices(indices::Array)
    # Check whether `indices` is empty.
    (length(indices) == 0) ? (return true) : nothing

    err_str = "Variable `indices` comes in an unexpected form. Expecting `Array{Union{Int, Array{Int, 1}}, 1}`"
    @assert mapreduce(x -> typeof(x)<:Array || typeof(x)<:Int, &, indices) err_str

    isunique = true
    # Check that no sub-list contains duplicates.
    for i in filter(x -> typeof(x) <: Array, indices)
        isunique &= (length(Set(i)) == length(i))
    end
    # Check that there are no duplicates across `indices`
    for (idx, i) in enumerate(indices[1:end-1])
        for j in indices[idx+1:end]
            isunique &= (length(Base.intersect(i, j)) == 0)
        end
    end
    return isunique
end
