%% Copyright (C) 2016 Colin B. Macdonald
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
%% @documentencoding UTF-8
%% @defun cosint (@var{x})
%% Symbolic cosint function.
%%
%% Example:
%% @example
%% @group
%% syms x
%% y = cosint(x)
%%   @result{} y = (sym) Ci(x)
%% @end group
%% @end example
%%
%% Note: this file is autogenerated: if you want to edit it, you might
%% want to make changes to 'generate_functions.py' instead.
%%
%% @end defun

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function y = cosint(x)
  y = uniop_helper (x, 'Ci');
end


%!shared x, d
%! d = 1;
%! x = sym('1');

%!test
%! f1 = cosint(x);
%! f2 = 0.3374039229009681346626;
%! assert( abs(double(f1) - f2) < 1e-15 )

%!test
%! D = [d d; d d];
%! A = [x x; x x];
%! f1 = cosint(A);
%! f2 = 0.3374039229009681346626;
%! f2 = [f2 f2; f2 f2];
%! assert( all(all( abs(double(f1) - f2) < 1e-15 )))
