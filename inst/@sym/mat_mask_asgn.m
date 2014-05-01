%% Copyright (C) 2014 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @deftypefn  {Function File} {@var{z}} mat_mask_asgn (@var{A}, @var{I}, @var{rhs})
%% Private helper routine for symbolic array assignment via mask.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function z = mat_mask_asgn(A, I, B)

  if (~islogical(I))
    error('subscript indices must be either positive integers or logicals')
  end
  if (numel(A) ~= numel(I))
    error('size A not compatible w/ size I in A(I)')
  end

  % issue #18 fix a(t/f)=6
  if (isscalar(A))
    if (I)
      z = B;
    else
      z = A;
    end
    return
  end

  % this messes with the later sanity checks
  if (nnz(I) == 0)
    z = A;
    return
  end


  if (numel(B) == 1)
    B = B*ones(nnz(I),1);
  end
  if (nnz(I) ~= numel(B))
    error('not enough/too much in B')
  end

  if (~(is_same_shape(A,I)))
    warning('A and I in A(I) not same shape: did you intend this?')
  end
  if (~isvector(B))
    % apparently this is ok
    warning('B not vector in A(I)=B: this is unusual, did you intend this?')
  end

  % I think .T makes a copy, but be careful: in general may need a
  % .copy() here
  cmd = [ '(A,mask,B) = _ins\n'  ...
          '# transpose b/c SymPy is row-based\n' ...
          'AT = A.T\n' ...
          'maskT = mask.T\n' ...
          'BT = B.T\n' ...
          'j = 0\n' ...
          'for i in range(0,len(A)):\n'  ...
          '    if maskT[i] > 0:\n' ...
          '        AT[i] = BT[j]\n'  ...
          '        j = j + 1\n' ...
          'return (AT.T,)' ];

  % FIXME: not optimal, but we don't have bool -> sym yet
  if islogical(I)
    I = double(I);
  end
  z = python_cmd (cmd, sym(A), sym(I), sym(B));
end



%% 2D arrays
%!shared a,b,I
%! b = [1:4]; b = [b; 3*b; 5*b];
%! a = sym(b);
%! I = rand(size(b)) > 0.5;

%!test
%! A = mat_mask_asgn(a,I, 2*b(I));
%! B = b;  B(I) = 2*b(I);
%! assert(isequal( A, B ))

%!test  % scalar RHS
%! A = mat_mask_asgn(a,I, 17);
%! B = b;  B(I) = 17;
%! assert(isequal( A, B ))

%!test  % non-vector RHS ("rhs2")
%! I = logical([1 0 1 0; 0 1 0 1; 1 0 1 0]);
%! rhs = 2*b(I);
%! rhs2 = reshape(rhs, 2, 3);
%! disp('*** One warning expected: ***');
%! A = mat_mask_asgn(a,I, rhs2);
%! B = b;  B(I) = rhs;
%! assert(isequal( A, B ))