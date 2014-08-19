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
%% @deftypefn {Function File}  {} display (@var{x})
%% Display, on command line, the contents of a symbolic expression.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function display(x)

  % todo: octsympy_cpmfig display flat/pretty/unicode

  %% Settings
  unicode_dec = octsympy_config('unicode');
  display_snippet = octsympy_config('snippet');
  loose = strcmp(get(0,'FormatSpacing'), 'loose');
  % FIXME
  term_width = 69;  % hardcoded for my tablet
  %get(0,'CommandWindowSize'): works in matlab gui & term
  %terminal_size: octave, above just gives [0 0]


  if (unicode_decorations)
    timesstr = '×';
  else
    timesstr = 'x';
  end
  newl = sprintf('\n');

  d = size (x);
  if (isscalar (x))
    n = fprintf ('%s = (%s)', inputname (1), class (x));
    s = strtrim(disp(x));
    hasnewlines = strfind(s, newl);
    toobig = hasnewlines || length(s) + n + 18 > term_width;
    if (~toobig)
      fprintf(' %s', s)
      n = n + 1 + length(s);
      snippet_of_sympy (x, 7, term_width - n, unicode_dec)
    else
      snippet_of_sympy (x, 7, term_width - n, unicode_dec)
      if (loose), fprintf ('\n'); end
      disp(x)
      if (loose), fprintf ('\n'); end
    end


  elseif (isempty (x))
    formatstr = [ '%s = (%s) %s (empty %d' timesstr '%d matrix)' ];
    n = fprintf (formatstr, inputname (1), class (x), strtrim(disp(x)), d(1), d(2))
    snippet_of_sympy (x, 7, term_width - n, unicode_dec)


  elseif (length (d) == 2)
    %% 2D Array
    formatstr = [ '%s = (%s %d' timesstr '%d matrix)' ];
    n = fprintf (formatstr, inputname (1), class (x), d(1), d(2));

    snippet_of_sympy (x, 7, term_width - n, unicode_dec)

    if (loose), fprintf ('\n'); end
    disp(x)
    if (loose), fprintf ('\n'); end


  else
    %% nD Array
    % (not possible with sympy matrix)
    fprintf ('%s = (%s nD array)', inputname (1), class (x))

    snippet_of_sympy (x, 7, term_width - n, unicode_dec)

    if (loose), fprintf ('\n'); end
    disp(x)
    if (loose), fprintf ('\n'); end
  end
end


function snippet_of_sympy(x, padw, width, unicode)

  newl = sprintf('\n');
  if ( ~ octsympy_config('snippet'))
    disp(newl)
    %fprintf('\n');
    return
  end
  
  if (unicode)
    ell = '…';
    lquot = '“'; rquot = '”';
  else
    ell = '...';
    lquot = '"'; rquot = lquot;
  end

  % indent
  pad = repmat(' ', 1, padw);

  % trim newlines (if there are any)
  s = regexprep (x.pickle, '\n', '\\n');
  %s = regexprep (x.pickle, '\n', '\');
  len = length (s);
  if len > width-padw-2
    n = width-padw-2-length(ell);
    s = [s(1:n) ell];
  end
  fprintf([pad lquot '%s' rquot '\n'], s)
end
