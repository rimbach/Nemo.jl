###############################################################################
#
#   GenericTypes.jl : Generic Types
#
###############################################################################

###############################################################################
#
#   GenPolyRing / GenPoly
#
###############################################################################

type GenPolyRing{T <: RingElem} <: PolyRing{T}
   base_ring::Ring
   S::Symbol

   function GenPolyRing(R::Ring, s::Symbol, cached::Bool = true)
      if haskey(GenPolyID, (R, s))
         return GenPolyID[R, s]::GenPolyRing{T}
      else 
         z = new{T}(R, s)
         if cached
           GenPolyID[R, s] = z
         end
         return z
      end
   end
end

const GenPolyID = Dict{Tuple{Ring, Symbol}, Ring}()

type GenPoly{T <: RingElem} <: PolyElem{T}
   coeffs::Array{T, 1}
   length::Int
   parent::GenPolyRing{T}

   GenPoly() = new(Array{T}(0), 0)
   
   GenPoly(a::Array{T, 1}) = new(a, length(a))

   GenPoly(a::T) = iszero(a) ? new(Array{T}(0), 0) : new([a], 1)
end

###############################################################################
#
#   GenMPolyRing / GenMPoly / Monomial
#
###############################################################################

# S is a Symbol which can take the values:
# :lex
# :revlex
# :deglex
# :degrevlex
# 
# T is an Int which is the number of variables
# (plus one if ordered by total degree)

type GenMPolyRing{T <: RingElem} <: PolyRing{T}
   base_ring::Ring
   S::Array{Symbol, 1}
   ord::Symbol
   num_vars::Int
   N::Int

   function GenMPolyRing(R::Ring, s::Array{Symbol, 1}, ord::Symbol, N::Int,
                         cached::Bool = true)
      if haskey(GenMPolyID, (R, s, ord, N))
         return GenMPolyID[R, s, ord, N]::GenMPolyRing{T}
      else 
         z = new(R, s, ord, length(s), N)
         if cached
           GenMPolyID[R, s, ord, N] = z
         end
         return z
      end
   end
end

const GenMPolyID = Dict{Tuple{Ring, Array{Symbol, 1}, Symbol, Int}, Ring}()

type GenMPoly{T <: RingElem} <: PolyElem{T}
   coeffs::Array{T, 1}
   exps::Array{UInt, 2}
   length::Int
   parent::GenMPolyRing{T}

   function GenMPoly(R::GenMPolyRing)
      N = R.N
      return new(Array{T}(0), Array{UInt}(N, 0), 0, R)
   end
   
   GenMPoly(R::GenMPolyRing, a::Array{T, 1}, b::Array{UInt, 2}) = new(a, b, length(a), R)

   function GenMPoly(R::GenMPolyRing, a::T)
      N = R.N
      return iszero(a) ? new(Array{T}(0), Array{UInt}(N, 0), 0, R) : 
                                      new([a], zeros(UInt, N, 1), 1, R)
   end
end

###############################################################################
#
#   GenSparsePolyRing / GenSparsePoly
#
###############################################################################

type GenSparsePolyRing{T <: RingElem} <: Ring
   base_ring::Ring
   S::Symbol
   num_vars::Int

   function GenSparsePolyRing(R::Ring, s::Symbol, cached::Bool = true)
      if haskey(GenSparsePolyID, (R, s))
         return GenSparsePolyID[R, s]::GenSparsePolyRing{T}
      else 
         z = new(R, s)
         if cached
           GenSparsePolyID[R, s] = z
         end
         return z
      end
   end
end

const GenSparsePolyID = Dict{Tuple{Ring, Symbol}, GenSparsePolyRing}()

type GenSparsePoly{T <: RingElem} <: RingElem
   coeffs::Array{T, 1}
   exps::Array{UInt}
   length::Int
   parent::GenSparsePolyRing{T}

   GenSparsePoly() = new(Array{T}(0), Array{UInt}(0), 0)
   
   GenSparsePoly(a::Array{T, 1}, b::Array{UInt, 1}) = new(a, b, length(a))

   GenSparsePoly(a::T) = iszero(a) ? new(Array{T}(0), Array{UInt}(0), 0) : 
                                      new([a], [UInt(0)], 1)
end

###############################################################################
#
#   GenResRing / GenRes
#
###############################################################################

type GenResRing{T <: RingElem} <: ResRing{T}
   base_ring::Ring
   modulus::T

   function GenResRing(modulus::T, cached::Bool = true)
      if haskey(ModulusDict, (parent(modulus), modulus))
         return ModulusDict[parent(modulus), modulus]::GenResRing{T}
      else
         z = new{T}(parent(modulus), modulus)
         if cached
            ModulusDict[parent(modulus), modulus] = z
         end
         return z
      end
   end
end

const ModulusDict = Dict{Tuple{Ring, RingElem}, Ring}()

type GenRes{T <: RingElem} <: ResElem{T}
   data::T
   parent::GenResRing{T}

   GenRes(a::T) = new(a)
end

###############################################################################
#
#   GenRelSeriesRing / GenRelSeries
#
###############################################################################

type GenRelSeriesRing{T <: RingElem} <: SeriesRing{T}
   base_ring::Ring
   prec_max::Int
   S::Symbol

   function GenRelSeriesRing(R::Ring, prec::Int, s::Symbol, cached::Bool = true)
      if haskey(GenRelSeriesID, (R, prec, s))
         return GenRelSeriesID[R, prec, s]::GenRelSeriesRing{T}
      else
         z = new{T}(R, prec, s)
         if cached
            GenRelSeriesID[R, prec, s] = z
         end
         return z
      end
   end
end

const GenRelSeriesID = Dict{Tuple{Ring, Int, Symbol}, Ring}()

type GenRelSeries{T <: RingElem} <: RelSeriesElem{T}
   coeffs::Array{T, 1}
   length::Int
   prec::Int
   val::Int
   parent::GenRelSeriesRing{T}

   function GenRelSeries(a::Array{T, 1}, length::Int, prec::Int, val::Int)
      new(a, length, prec, val)
   end

   GenRelSeries(a::GenRelSeries{T}) = a
end

###############################################################################
#
#   GenAbsSeriesRing / GenAbsSeries
#
###############################################################################

type GenAbsSeriesRing{T <: RingElem} <: SeriesRing{T}
   base_ring::Ring
   prec_max::Int
   S::Symbol

   function GenAbsSeriesRing(R::Ring, prec::Int, s::Symbol, cached::Bool = true)
      if haskey(GenAbsSeriesID, (R, prec, s))
         return GenAbsSeriesID[R, prec, s]::GenAbsSeriesRing{T}
      else
         z = new{T}(R, prec, s)
         if cached
            GenAbsSeriesID[R, prec, s] = z
         end
         return z
      end
   end
end

const GenAbsSeriesID = Dict{Tuple{Ring, Int, Symbol}, Ring}()

type GenAbsSeries{T <: RingElem} <: AbsSeriesElem{T}
   coeffs::Array{T, 1}
   length::Int
   prec::Int
   parent::GenAbsSeriesRing{T}

   GenAbsSeries(a::Array{T, 1}, length::Int, prec::Int) = new(a, length, prec)   
   GenAbsSeries(a::GenAbsSeries{T}) = a
end

###############################################################################
#
#   GenFracField / GenFrac
#
###############################################################################

type GenFracField{T <: RingElem} <: FracField{T}
   base_ring::Ring

   function GenFracField(R::Ring, cached::Bool = true)
      if haskey(GenFracDict, R)
         return GenFracDict[R]::GenFracField{T}
      else
         z = new{T}(R)
         if cached
            GenFracDict[R] = z
         end
         return z
      end
   end
end

const GenFracDict = Dict{Ring, Ring}()

type GenFrac{T <: RingElem} <: FracElem{T}
   num::T
   den::T
   parent::GenFracField{T}

   GenFrac(num::T, den::T) = new(num, den) 
end

###############################################################################
#
#   GenMatSpace / GenMat
#
###############################################################################

# not really a mathematical ring
type GenMatSpace{T <: RingElem} <: MatSpace{T}
   rows::Int
   cols::Int
   base_ring::Ring

   function GenMatSpace(R::Ring, r::Int, c::Int, cached::Bool = true)
      if haskey(GenMatDict, (R, r, c))
         return GenMatDict[R, r, c]::GenMatSpace{T}
      else
         z = new{T}(r, c, R)
         if cached
            GenMatDict[R, r, c] = z
         end
         return z
      end
   end
end

const GenMatDict = Dict{Tuple{Ring, Int, Int}, Ring}()

type GenMat{T <: RingElem} <: MatElem{T}
   entries::Array{T, 2}
   base_ring::Ring

   GenMat(a::Array{T, 2}) = new(a) 
end

